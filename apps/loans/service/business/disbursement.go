package business

import (
	"context"
	"strconv"
	"time"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	"buf.build/gen/go/antinvestor/operations/connectrpc/go/operations/v1/operationsv1connect"
	operationsv1 "buf.build/gen/go/antinvestor/operations/protocolbuffers/go/operations/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"
	moneyx "github.com/pitabwire/util/money"

	"github.com/antinvestor/service-fintech/apps/loans/service/events"
	"github.com/antinvestor/service-fintech/apps/loans/service/models"
	"github.com/antinvestor/service-fintech/apps/loans/service/repository"
)

type DisbursementBusiness interface {
	Create(ctx context.Context, req *loansv1.DisbursementCreateRequest) (*loansv1.DisbursementObject, error)
	Get(ctx context.Context, id string) (*loansv1.DisbursementObject, error)
	Search(
		ctx context.Context,
		req *loansv1.DisbursementSearchRequest,
		consumer func(ctx context.Context, batch []*loansv1.DisbursementObject) error,
	) error
}

type disbursementBusiness struct {
	eventsMan       fevents.Manager
	disbRepo        repository.DisbursementRepository
	loanAccountRepo repository.LoanAccountRepository
	laBusiness      LoanAccountBusiness
	operationsCli   operationsv1connect.OperationsServiceClient
}

func NewDisbursementBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	disbRepo repository.DisbursementRepository,
	loanAccountRepo repository.LoanAccountRepository,
	laBusiness LoanAccountBusiness,
	operationsCli operationsv1connect.OperationsServiceClient,
) DisbursementBusiness {
	return &disbursementBusiness{
		eventsMan:       eventsMan,
		disbRepo:        disbRepo,
		loanAccountRepo: loanAccountRepo,
		laBusiness:      laBusiness,
		operationsCli:   operationsCli,
	}
}

func (b *disbursementBusiness) Create(
	ctx context.Context,
	req *loansv1.DisbursementCreateRequest,
) (*loansv1.DisbursementObject, error) {
	logger := util.Log(ctx).WithField("method", "DisbursementBusiness.Create")

	loanAccountID := req.GetLoanAccountId()

	// Idempotency check
	if req.GetIdempotencyKey() != "" {
		existing, idErr := b.disbRepo.GetByIdempotencyKey(ctx, req.GetIdempotencyKey())
		if idErr == nil && existing != nil {
			return existing.ToAPI(), nil
		}
	}

	// Verify loan is in PENDING_DISBURSEMENT state
	la, err := b.loanAccountRepo.GetByID(ctx, loanAccountID)
	if err != nil {
		return nil, ErrLoanAccountNotFound
	}

	if loansv1.LoanStatus(la.Status) != loansv1.LoanStatus_LOAN_STATUS_PENDING_DISBURSEMENT {
		return nil, ErrLoanNotPendingDisbursement
	}

	// Create the disbursement record
	now := time.Now().UTC()
	disb := &models.Disbursement{
		LoanAccountID:      loanAccountID,
		Amount:             la.PrincipalAmount,
		CurrencyCode:       la.CurrencyCode,
		Status:             int32(loansv1.DisbursementStatus_DISBURSEMENT_STATUS_PROCESSING),
		Channel:            req.GetChannel(),
		RecipientReference: req.GetRecipientReference(),
		IdempotencyKey:     req.GetIdempotencyKey(),
		DisbursedAt:        &now,
	}
	disb.GenID(ctx)

	if err = b.eventsMan.Emit(ctx, events.DisbursementSaveEvent, disb); err != nil {
		logger.WithError(err).Error("could not emit disbursement save event")
		return nil, err
	}

	// Execute the disbursement transfer order via operations service
	if b.operationsCli != nil {
		toResp, toErr := b.operationsCli.TransferOrderExecute(ctx, connect.NewRequest(
			&operationsv1.TransferOrderExecuteRequest{
				Data: &operationsv1.TransferOrderObject{
					DebitAccountRef:  "loan_asset:" + loanAccountID,
					CreditAccountRef: la.PaymentAccountRef,
					Amount:           moneyx.FromSmallestUnit(la.CurrencyCode, la.PrincipalAmount, decimalPrecision),
					OrderType:        1, // disbursement
					Reference:        "disbursement:" + disb.GetID(),
					Description:      "Loan disbursement for " + loanAccountID,
					State:            commonv1.STATE_ACTIVE,
				},
			},
		))
		if toErr != nil {
			logger.WithError(toErr).Error("transfer order execution failed")
			disb.Status = int32(loansv1.DisbursementStatus_DISBURSEMENT_STATUS_FAILED)
			disb.FailureReason = toErr.Error()
			_ = b.eventsMan.Emit(ctx, events.DisbursementSaveEvent, disb)
			return disb.ToAPI(), nil
		}
		disb.LedgerTransactionID = toResp.Msg.GetData().GetId()
	}

	// Mark disbursement as completed
	disb.Status = int32(loansv1.DisbursementStatus_DISBURSEMENT_STATUS_COMPLETED)
	if err = b.eventsMan.Emit(ctx, events.DisbursementSaveEvent, disb); err != nil {
		logger.WithError(err).Error("could not update disbursement status")
	}

	// Transition loan to ACTIVE
	if _, transErr := b.laBusiness.TransitionStatus(
		ctx, loanAccountID,
		loansv1.LoanStatus_LOAN_STATUS_ACTIVE,
		"system", "disbursement completed",
	); transErr != nil {
		logger.WithError(transErr).Error("could not transition loan to active after disbursement")
	}

	return disb.ToAPI(), nil
}

func (b *disbursementBusiness) Get(ctx context.Context, id string) (*loansv1.DisbursementObject, error) {
	disb, err := b.disbRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrDisbursementNotFound
	}
	return disb.ToAPI(), nil
}

func (b *disbursementBusiness) Search(
	ctx context.Context,
	req *loansv1.DisbursementSearchRequest,
	consumer func(ctx context.Context, batch []*loansv1.DisbursementObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "DisbursementBusiness.Search")

	var searchOpts []data.SearchOption

	cursor := req.GetCursor()
	if cursor != nil {
		offset, offsetErr := strconv.Atoi(cursor.GetPage())
		if offsetErr != nil {
			offset = 0
		}
		searchOpts = append(searchOpts, data.WithSearchOffset(offset), data.WithSearchLimit(int(cursor.GetLimit())))
	}

	andQueryVal := map[string]any{}
	if req.GetLoanAccountId() != "" {
		andQueryVal["loan_account_id = ?"] = req.GetLoanAccountId()
	}
	if req.GetStatus() != loansv1.DisbursementStatus_DISBURSEMENT_STATUS_UNSPECIFIED {
		andQueryVal["status = ?"] = int32(req.GetStatus())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.disbRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search disbursements")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Disbursement) error {
		var apiResults []*loansv1.DisbursementObject
		for _, d := range res {
			apiResults = append(apiResults, d.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

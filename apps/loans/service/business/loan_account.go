package business

import (
	"context"
	"fmt"
	"strconv"
	"time"

	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	"buf.build/gen/go/antinvestor/origination/connectrpc/go/origination/v1/originationv1connect"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/loans/service/events"
	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
	"github.com/antinvestor/service-lender/pkg/calculation"
)

// validTransitions defines the allowed loan status transitions.
var validTransitions = map[loansv1.LoanStatus][]loansv1.LoanStatus{ //nolint:gochecknoglobals // state machine
	loansv1.LoanStatus_LOAN_STATUS_PENDING_DISBURSEMENT: {
		loansv1.LoanStatus_LOAN_STATUS_ACTIVE,
		loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED,
	},
	loansv1.LoanStatus_LOAN_STATUS_ACTIVE: {
		loansv1.LoanStatus_LOAN_STATUS_DELINQUENT,
		loansv1.LoanStatus_LOAN_STATUS_PAID_OFF,
		loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED,
	},
	loansv1.LoanStatus_LOAN_STATUS_DELINQUENT: {
		loansv1.LoanStatus_LOAN_STATUS_DEFAULT,
		loansv1.LoanStatus_LOAN_STATUS_ACTIVE,
		loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED,
	},
	loansv1.LoanStatus_LOAN_STATUS_DEFAULT: {
		loansv1.LoanStatus_LOAN_STATUS_WRITTEN_OFF,
		loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED,
	},
	loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED: {
		loansv1.LoanStatus_LOAN_STATUS_ACTIVE,
		loansv1.LoanStatus_LOAN_STATUS_DELINQUENT,
		loansv1.LoanStatus_LOAN_STATUS_PAID_OFF,
	},
	loansv1.LoanStatus_LOAN_STATUS_PAID_OFF: {
		loansv1.LoanStatus_LOAN_STATUS_CLOSED,
	},
	loansv1.LoanStatus_LOAN_STATUS_WRITTEN_OFF: {
		loansv1.LoanStatus_LOAN_STATUS_CLOSED,
	},
}

type LoanAccountBusiness interface {
	Create(ctx context.Context, applicationID string) (*loansv1.LoanAccountObject, error)
	Get(ctx context.Context, id string) (*loansv1.LoanAccountObject, error)
	Search(
		ctx context.Context,
		req *loansv1.LoanAccountSearchRequest,
		consumer func(ctx context.Context, batch []*loansv1.LoanAccountObject) error,
	) error
	GetBalance(ctx context.Context, loanAccountID string) (*loansv1.LoanBalanceObject, error)
	GetStatement(ctx context.Context, req *loansv1.LoanStatementRequest) (*loansv1.LoanStatementResponse, error)
	TransitionStatus(
		ctx context.Context,
		loanAccountID string,
		newStatus loansv1.LoanStatus,
		changedBy, reason string,
	) (*loansv1.LoanAccountObject, error)
}

type loanAccountBusiness struct {
	eventsMan        fevents.Manager
	loanProductRepo  repository.LoanProductRepository
	loanAccountRepo  repository.LoanAccountRepository
	loanBalanceRepo  repository.LoanBalanceRepository
	statusChangeRepo repository.LoanStatusChangeRepository
	repaymentRepo    repository.RepaymentRepository
	originationCli   originationv1connect.OriginationServiceClient
	scheduleBusiness RepaymentScheduleBusiness
}

func NewLoanAccountBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	loanProductRepo repository.LoanProductRepository,
	loanAccountRepo repository.LoanAccountRepository,
	loanBalanceRepo repository.LoanBalanceRepository,
	statusChangeRepo repository.LoanStatusChangeRepository,
	repaymentRepo repository.RepaymentRepository,
	originationCli originationv1connect.OriginationServiceClient,
	scheduleBusiness RepaymentScheduleBusiness,
) LoanAccountBusiness {
	return &loanAccountBusiness{
		eventsMan:        eventsMan,
		loanProductRepo:  loanProductRepo,
		loanAccountRepo:  loanAccountRepo,
		loanBalanceRepo:  loanBalanceRepo,
		statusChangeRepo: statusChangeRepo,
		repaymentRepo:    repaymentRepo,
		originationCli:   originationCli,
		scheduleBusiness: scheduleBusiness,
	}
}

func (b *loanAccountBusiness) Create(ctx context.Context, applicationID string) (*loansv1.LoanAccountObject, error) {
	logger := util.Log(ctx).WithField("method", "LoanAccountBusiness.Create")

	la := &models.LoanAccount{
		ApplicationID: applicationID,
		Status:        int32(loansv1.LoanStatus_LOAN_STATUS_PENDING_DISBURSEMENT),
	}

	// Fetch application details from origination service to populate the loan
	if b.originationCli == nil {
		return nil, ErrOriginationServiceUnavailable
	}

	var lp *models.LoanProduct
	{
		appResp, appErr := b.originationCli.ApplicationGet(ctx, connect.NewRequest(
			&originationv1.ApplicationGetRequest{Id: applicationID},
		))
		if appErr != nil {
			logger.WithError(appErr).Error("could not fetch application from origination service")
			return nil, ErrApplicationNotFound
		}

		app := appResp.Msg.GetData()
		la.ProductID = app.GetProductId()
		la.ClientID = app.GetClientId()
		la.AgentID = app.GetAgentId()
		la.BranchID = app.GetBranchId()
		la.BankID = app.GetBankId()
		la.CurrencyCode = app.GetCurrencyCode()
		la.PrincipalAmount = models.StringToMinorUnits(app.GetApprovedAmount())
		la.InterestRate = models.StringToBasisPoints(app.GetInterestRate())
		la.TermDays = app.GetApprovedTermDays()

		// Fetch product details for interest method and repayment frequency
		if app.GetProductId() != "" {
			prod, prodErr := b.loanProductRepo.GetByID(ctx, app.GetProductId())
			if prodErr == nil && prod != nil {
				lp = prod
				la.InterestMethod = prod.InterestMethod
				la.RepaymentFrequency = prod.RepaymentFrequency

				// Use product rate if application doesn't have one
				if la.InterestRate == 0 {
					la.InterestRate = prod.AnnualInterestRate
				}
				if la.CurrencyCode == "" {
					la.CurrencyCode = prod.CurrencyCode
				}
			} else {
				logger.WithError(prodErr).Warn("could not fetch loan product, using application data only")
			}
		}

		// Use requested amounts as fallback if approved amounts are zero
		if la.PrincipalAmount == 0 {
			la.PrincipalAmount = models.StringToMinorUnits(app.GetRequestedAmount())
		}
		if la.TermDays == 0 {
			la.TermDays = app.GetRequestedTermDays()
		}
	}

	if la.PrincipalAmount <= 0 {
		return nil, fmt.Errorf("loan principal amount must be positive, got %d", la.PrincipalAmount)
	}

	la.GenID(ctx)

	// Set disbursement date and first repayment date so the schedule can be generated.
	// For direct borrower products, disbursement happens immediately upon loan creation.
	now := time.Now().UTC()
	la.DisbursedAt = &now
	firstRepayment := now.AddDate(0, 0, computeFirstRepaymentDays(loansv1.RepaymentFrequency(la.RepaymentFrequency)))
	la.FirstRepaymentDate = &firstRepayment

	err := b.eventsMan.Emit(ctx, events.LoanAccountSaveEvent, la)
	if err != nil {
		logger.WithError(err).Error("could not emit loan account save event")
		return nil, err
	}

	// Compute total outstanding including interest and fees from product
	var totalInterest, totalFees int64
	if lp != nil {
		ppy := int64(
			calculation.PeriodsPerYear(frequencyToPeriodType(loansv1.RepaymentFrequency(la.RepaymentFrequency))),
		)
		numInstallments := computeInstallmentCount(la.TermDays, loansv1.RepaymentFrequency(la.RepaymentFrequency))
		if numInstallments <= 0 {
			numInstallments = 1
		}
		totalInterest = calculation.FlatRateInterest(la.PrincipalAmount, la.InterestRate, numInstallments, int32(ppy))
		totalFees = calculation.FlatRateInterest(
			la.PrincipalAmount,
			lp.InsuranceFeePercent+lp.ProcessingFeePercent,
			numInstallments,
			int32(ppy),
		)
	}

	// Create initial balance snapshot
	balance := &models.LoanBalance{
		LoanAccountID:        la.GetID(),
		CurrencyCode:         la.CurrencyCode,
		PrincipalOutstanding: la.PrincipalAmount,
		InterestAccrued:      totalInterest,
		FeesOutstanding:      totalFees,
		TotalOutstanding:     la.PrincipalAmount + totalInterest + totalFees,
		TotalDisbursed:       la.PrincipalAmount,
		LastCalculatedAt:     &now,
	}
	balance.GenID(ctx)

	err = b.eventsMan.Emit(ctx, events.LoanBalanceSaveEvent, balance)
	if err != nil {
		logger.WithError(err).Warn("could not emit loan balance save event")
	}

	// Auto-generate repayment schedule
	if b.scheduleBusiness != nil {
		if _, schedErr := b.scheduleBusiness.Generate(ctx, la.GetID()); schedErr != nil {
			logger.WithError(schedErr).Error("could not generate repayment schedule")
			// Non-fatal: loan is created but schedule needs manual generation
		}
	}

	return la.ToAPI(), nil
}

func (b *loanAccountBusiness) Get(ctx context.Context, id string) (*loansv1.LoanAccountObject, error) {
	la, err := b.loanAccountRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrLoanAccountNotFound
	}
	return la.ToAPI(), nil
}

func (b *loanAccountBusiness) Search(
	ctx context.Context,
	req *loansv1.LoanAccountSearchRequest,
	consumer func(ctx context.Context, batch []*loansv1.LoanAccountObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "LoanAccountBusiness.Search")

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
	if req.GetClientId() != "" {
		andQueryVal["client_id = ?"] = req.GetClientId()
	}
	if req.GetAgentId() != "" {
		andQueryVal["agent_id = ?"] = req.GetAgentId()
	}
	if req.GetBranchId() != "" {
		andQueryVal["branch_id = ?"] = req.GetBranchId()
	}
	if req.GetBankId() != "" {
		andQueryVal["bank_id = ?"] = req.GetBankId()
	}
	if req.GetStatus() != loansv1.LoanStatus_LOAN_STATUS_UNSPECIFIED {
		andQueryVal["status = ?"] = int32(req.GetStatus())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	if req.GetQuery() != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{"searchable @@ websearch_to_tsquery( 'english', ?) ": req.GetQuery()},
			),
		)
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.loanAccountRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search loan accounts")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.LoanAccount) error {
		var apiResults []*loansv1.LoanAccountObject
		for _, la := range res {
			apiResults = append(apiResults, la.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

func (b *loanAccountBusiness) GetBalance(
	ctx context.Context,
	loanAccountID string,
) (*loansv1.LoanBalanceObject, error) {
	balance, err := b.loanBalanceRepo.GetByLoanAccountID(ctx, loanAccountID)
	if err != nil {
		return nil, ErrBalanceNotFound
	}
	return balance.ToAPI(), nil
}

func (b *loanAccountBusiness) GetStatement(
	ctx context.Context,
	req *loansv1.LoanStatementRequest,
) (*loansv1.LoanStatementResponse, error) {
	logger := util.Log(ctx).WithField("method", "LoanAccountBusiness.GetStatement")

	la, err := b.loanAccountRepo.GetByID(ctx, req.GetLoanAccountId())
	if err != nil {
		return nil, ErrLoanAccountNotFound
	}

	balance, balErr := b.loanBalanceRepo.GetByLoanAccountID(ctx, req.GetLoanAccountId())
	if balErr != nil {
		logger.WithError(balErr).Warn("could not load balance for statement")
	}

	var balanceAPI *loansv1.LoanBalanceObject
	if balance != nil {
		balanceAPI = balance.ToAPI()
	}

	// Build statement entries from repayments
	var statementEntries []*loansv1.LoanStatementEntry

	fromDate := models.StringToTime(req.GetFromDate())
	toDate := models.StringToTime(req.GetToDate())

	// Add repayment entries
	repQuery := data.NewSearchQuery(
		data.WithSearchFiltersAndByValue(map[string]any{
			"loan_account_id = ?": req.GetLoanAccountId(),
		}),
	)
	repResults, repErr := b.repaymentRepo.Search(ctx, repQuery)
	if repErr == nil {
		_ = workerpoolConsumeStream(ctx, repResults, func(batch []*models.Repayment) error {
			for _, r := range batch {
				if r.ReceivedAt == nil {
					continue
				}
				if fromDate != nil && r.ReceivedAt.Before(*fromDate) {
					continue
				}
				if toDate != nil && r.ReceivedAt.After(*toDate) {
					continue
				}
				statementEntries = append(statementEntries, &loansv1.LoanStatementEntry{
					Date:        models.TimeToString(r.ReceivedAt),
					Description: "Repayment via " + r.Channel,
					Credit:      models.MinorUnitsToString(r.Amount),
					Reference:   r.PaymentReference,
				})
			}
			return nil
		})
	}

	return &loansv1.LoanStatementResponse{
		Loan:    la.ToAPI(),
		Balance: balanceAPI,
		Entries: statementEntries,
	}, nil
}

func (b *loanAccountBusiness) TransitionStatus(
	ctx context.Context,
	loanAccountID string,
	newStatus loansv1.LoanStatus,
	changedBy, reason string,
) (*loansv1.LoanAccountObject, error) {
	logger := util.Log(ctx).WithField("method", "LoanAccountBusiness.TransitionStatus")

	la, err := b.loanAccountRepo.GetByID(ctx, loanAccountID)
	if err != nil {
		return nil, ErrLoanAccountNotFound
	}

	currentStatus := loansv1.LoanStatus(la.Status)

	// Validate transition
	allowed, ok := validTransitions[currentStatus]
	if !ok {
		return nil, ErrInvalidStatusTransition
	}

	valid := false
	for _, s := range allowed {
		if s == newStatus {
			valid = true
			break
		}
	}
	if !valid {
		return nil, ErrInvalidStatusTransition.Extend(
			"cannot transition from " + currentStatus.String() + " to " + newStatus.String(),
		)
	}

	// Record status change
	now := time.Now().UTC()
	statusChange := &models.LoanStatusChange{
		LoanAccountID: la.GetID(),
		FromStatus:    la.Status,
		ToStatus:      int32(newStatus),
		ChangedBy:     changedBy,
		Reason:        reason,
		ChangedAt:     &now,
	}
	statusChange.GenID(ctx)

	err = b.eventsMan.Emit(ctx, events.LoanStatusChangeSaveEvent, statusChange)
	if err != nil {
		logger.WithError(err).Error("could not emit loan status change save event")
		return nil, err
	}

	// Update loan account status
	la.Status = int32(newStatus)
	err = b.eventsMan.Emit(ctx, events.LoanAccountSaveEvent, la)
	if err != nil {
		logger.WithError(err).Error("could not emit loan account save event")
		return nil, err
	}

	return la.ToAPI(), nil
}

// computeFirstRepaymentDays returns the number of days from disbursement
// to the first repayment date based on the repayment frequency.
func computeFirstRepaymentDays(freq loansv1.RepaymentFrequency) int {
	switch freq {
	case loansv1.RepaymentFrequency_REPAYMENT_FREQUENCY_WEEKLY:
		return 7
	case loansv1.RepaymentFrequency_REPAYMENT_FREQUENCY_BIWEEKLY:
		return 14
	case loansv1.RepaymentFrequency_REPAYMENT_FREQUENCY_MONTHLY:
		return 30
	default:
		return 7
	}
}

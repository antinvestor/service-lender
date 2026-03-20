package business

import (
	"context"
	"strconv"

	savingsv1 "buf.build/gen/go/antinvestor/savings/protocolbuffers/go/savings/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/savings/service/events"
	"github.com/antinvestor/service-lender/apps/savings/service/models"
	"github.com/antinvestor/service-lender/apps/savings/service/repository"
)

type DepositBusiness interface {
	Record(
		ctx context.Context,
		accountID, amount, paymentRef, channel, payerRef, idempotencyKey string,
	) (*savingsv1.DepositObject, error)
	Get(ctx context.Context, id string) (*savingsv1.DepositObject, error)
	Search(
		ctx context.Context,
		req *savingsv1.DepositSearchRequest,
		consumer func(ctx context.Context, batch []*savingsv1.DepositObject) error,
	) error
}

type depositBusiness struct {
	eventsMan fevents.Manager
	depRepo   repository.DepositRepository
	saRepo    repository.SavingsAccountRepository
}

func NewDepositBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	depRepo repository.DepositRepository,
	saRepo repository.SavingsAccountRepository,
) DepositBusiness {
	return &depositBusiness{
		eventsMan: eventsMan,
		depRepo:   depRepo,
		saRepo:    saRepo,
	}
}

func (b *depositBusiness) Record(
	ctx context.Context,
	accountID, amount, paymentRef, channel, payerRef, idempotencyKey string,
) (*savingsv1.DepositObject, error) {
	logger := util.Log(ctx).WithField("method", "DepositBusiness.Record")

	// Validate savings account exists and is not frozen/closed
	sa, err := b.saRepo.GetByID(ctx, accountID)
	if err != nil {
		return nil, ErrSavingsAccountNotFound
	}

	currentStatus := savingsv1.SavingsAccountStatus(sa.Status)
	if currentStatus == savingsv1.SavingsAccountStatus_SAVINGS_ACCOUNT_STATUS_FROZEN {
		return nil, ErrAccountFrozen
	}
	if currentStatus == savingsv1.SavingsAccountStatus_SAVINGS_ACCOUNT_STATUS_CLOSED {
		return nil, ErrAccountClosed
	}

	// Check idempotency key
	if idempotencyKey != "" {
		existing, idempErr := b.depRepo.GetByIdempotencyKey(ctx, idempotencyKey)
		if idempErr == nil && existing != nil {
			return existing.ToAPI(), nil
		}
	}

	dep := models.DepositFromAPI(ctx, &savingsv1.DepositObject{
		SavingsAccountId: accountID,
		Amount:           amount,
		CurrencyCode:     sa.CurrencyCode,
		PaymentReference: paymentRef,
		Channel:          channel,
		PayerReference:   payerRef,
		IdempotencyKey:   idempotencyKey,
	})
	dep.Status = int32(savingsv1.DepositStatus_DEPOSIT_STATUS_COMPLETED)

	err = b.eventsMan.Emit(ctx, events.DepositSaveEvent, dep)
	if err != nil {
		logger.WithError(err).Error("could not emit deposit save event")
		return nil, err
	}

	return dep.ToAPI(), nil
}

func (b *depositBusiness) Get(ctx context.Context, id string) (*savingsv1.DepositObject, error) {
	dep, err := b.depRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrDepositNotFound
	}
	return dep.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *depositBusiness) Search(
	ctx context.Context,
	req *savingsv1.DepositSearchRequest,
	consumer func(ctx context.Context, batch []*savingsv1.DepositObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "DepositBusiness.Search")

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
	if req.GetSavingsAccountId() != "" {
		andQueryVal["savings_account_id = ?"] = req.GetSavingsAccountId()
	}
	if req.GetStatus() != savingsv1.DepositStatus_DEPOSIT_STATUS_UNSPECIFIED {
		andQueryVal["status = ?"] = int32(req.GetStatus())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.depRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search deposits")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Deposit) error {
		var apiResults []*savingsv1.DepositObject
		for _, dep := range res {
			apiResults = append(apiResults, dep.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

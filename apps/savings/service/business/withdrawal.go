package business

import (
	"context"
	"strconv"

	savingsv1 "buf.build/gen/go/antinvestor/savings/protocolbuffers/go/savings/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/savings/service/events"
	"github.com/antinvestor/service-fintech/apps/savings/service/models"
	"github.com/antinvestor/service-fintech/apps/savings/service/repository"
)

type WithdrawalBusiness interface {
	Request(
		ctx context.Context,
		accountID, amount, channel, recipientRef, reason, idempotencyKey string,
	) (*savingsv1.WithdrawalObject, error)
	Approve(ctx context.Context, id string) (*savingsv1.WithdrawalObject, error)
	Get(ctx context.Context, id string) (*savingsv1.WithdrawalObject, error)
	Search(
		ctx context.Context,
		req *savingsv1.WithdrawalSearchRequest,
		consumer func(ctx context.Context, batch []*savingsv1.WithdrawalObject) error,
	) error
}

type withdrawalBusiness struct {
	eventsMan  fevents.Manager
	wdrRepo    repository.WithdrawalRepository
	saRepo     repository.SavingsAccountRepository
	saBusiness SavingsAccountBusiness
}

func NewWithdrawalBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	wdrRepo repository.WithdrawalRepository,
	saRepo repository.SavingsAccountRepository,
	saBusiness SavingsAccountBusiness,
) WithdrawalBusiness {
	return &withdrawalBusiness{
		eventsMan:  eventsMan,
		wdrRepo:    wdrRepo,
		saRepo:     saRepo,
		saBusiness: saBusiness,
	}
}

func (b *withdrawalBusiness) Request(
	ctx context.Context,
	accountID, amount, channel, recipientRef, reason, idempotencyKey string,
) (*savingsv1.WithdrawalObject, error) {
	logger := util.Log(ctx).WithField("method", "WithdrawalBusiness.Request")

	// Validate savings account exists and is active
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
		existing, idempErr := b.wdrRepo.GetByIdempotencyKey(ctx, idempotencyKey)
		if idempErr == nil && existing != nil {
			return existing.ToAPI(), nil
		}
	}

	// Validate sufficient balance
	if b.saBusiness != nil {
		balance, balErr := b.saBusiness.GetBalance(ctx, accountID)
		if balErr != nil {
			logger.WithError(balErr).Error("could not get balance for withdrawal validation")
			return nil, balErr
		}
		requestedAmount := models.StringToMinorUnits(amount)
		availableAmount, _ := models.MoneyToMinorUnits(balance.GetAvailableBalance())
		if requestedAmount > availableAmount {
			return nil, ErrInsufficientBalance
		}
	}

	wdr := models.WithdrawalFromAPI(ctx, &savingsv1.WithdrawalObject{
		SavingsAccountId:   accountID,
		Amount:             models.MinorUnitsToMoney(models.StringToMinorUnits(amount), sa.CurrencyCode),
		Channel:            channel,
		RecipientReference: recipientRef,
		Reason:             reason,
		IdempotencyKey:     idempotencyKey,
	})
	wdr.Status = int32(savingsv1.WithdrawalStatus_WITHDRAWAL_STATUS_PENDING)

	err = b.eventsMan.Emit(ctx, events.WithdrawalSaveEvent, wdr)
	if err != nil {
		logger.WithError(err).Error("could not emit withdrawal save event")
		return nil, err
	}

	return wdr.ToAPI(), nil
}

func (b *withdrawalBusiness) Approve(ctx context.Context, id string) (*savingsv1.WithdrawalObject, error) {
	logger := util.Log(ctx).WithField("method", "WithdrawalBusiness.Approve")

	wdr, err := b.wdrRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrWithdrawalNotFound
	}

	if wdr.Status != int32(savingsv1.WithdrawalStatus_WITHDRAWAL_STATUS_PENDING) {
		return nil, ErrInvalidStatusTransition
	}

	// Transition: PENDING → APPROVED → COMPLETED
	wdr.Status = int32(savingsv1.WithdrawalStatus_WITHDRAWAL_STATUS_APPROVED)

	err = b.eventsMan.Emit(ctx, events.WithdrawalSaveEvent, wdr)
	if err != nil {
		logger.WithError(err).Error("could not emit withdrawal approved event")
		return nil, err
	}

	wdr.Status = int32(savingsv1.WithdrawalStatus_WITHDRAWAL_STATUS_COMPLETED)

	err = b.eventsMan.Emit(ctx, events.WithdrawalSaveEvent, wdr)
	if err != nil {
		logger.WithError(err).Error("could not emit withdrawal completed event")
		return nil, err
	}

	return wdr.ToAPI(), nil
}

func (b *withdrawalBusiness) Get(ctx context.Context, id string) (*savingsv1.WithdrawalObject, error) {
	wdr, err := b.wdrRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrWithdrawalNotFound
	}
	return wdr.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *withdrawalBusiness) Search(
	ctx context.Context,
	req *savingsv1.WithdrawalSearchRequest,
	consumer func(ctx context.Context, batch []*savingsv1.WithdrawalObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "WithdrawalBusiness.Search")

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
	if req.GetStatus() != savingsv1.WithdrawalStatus_WITHDRAWAL_STATUS_UNSPECIFIED {
		andQueryVal["status = ?"] = int32(req.GetStatus())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.wdrRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search withdrawals")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Withdrawal) error {
		var apiResults []*savingsv1.WithdrawalObject
		for _, wdr := range res {
			apiResults = append(apiResults, wdr.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

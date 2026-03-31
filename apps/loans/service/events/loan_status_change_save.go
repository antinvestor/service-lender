package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
)

const LoanStatusChangeSaveEvent = "loan_status_change.save"

type LoanStatusChangeSave struct {
	loanStatusChangeRepo repository.LoanStatusChangeRepository
}

func NewLoanStatusChangeSave(
	_ context.Context,
	loanStatusChangeRepo repository.LoanStatusChangeRepository,
) *LoanStatusChangeSave {
	return &LoanStatusChangeSave{loanStatusChangeRepo: loanStatusChangeRepo}
}

func (e *LoanStatusChangeSave) Name() string     { return LoanStatusChangeSaveEvent }
func (e *LoanStatusChangeSave) PayloadType() any { return &models.LoanStatusChange{} }

func (e *LoanStatusChangeSave) Validate(_ context.Context, payload any) error {
	lsc, ok := payload.(*models.LoanStatusChange)
	if !ok {
		return errors.New("payload is not of type models.LoanStatusChange")
	}
	if lsc.GetID() == "" {
		return errors.New("loan status change ID should already have been set")
	}
	return nil
}

func (e *LoanStatusChangeSave) Execute(ctx context.Context, payload any) error {
	lsc, ok := payload.(*models.LoanStatusChange)
	if !ok {
		return errors.New("payload is not of type models.LoanStatusChange")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "loan_status_change_id": lsc.GetID()})
	defer logger.Release()

	existing, getErr := e.loanStatusChangeRepo.GetByID(ctx, lsc.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.loanStatusChangeRepo.Update(ctx, lsc); err != nil {
			logger.WithError(err).Error("could not update loan status change in db")
			return err
		}
		return nil
	}

	if err := e.loanStatusChangeRepo.Create(ctx, lsc); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create loan status change in db")
		return err
	}

	return nil
}

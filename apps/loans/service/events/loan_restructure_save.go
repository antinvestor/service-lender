package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
)

const LoanRestructureSaveEvent = "loan_restructure.save"

type LoanRestructureSave struct {
	loanRestructureRepo repository.LoanRestructureRepository
}

func NewLoanRestructureSave(
	_ context.Context,
	loanRestructureRepo repository.LoanRestructureRepository,
) *LoanRestructureSave {
	return &LoanRestructureSave{loanRestructureRepo: loanRestructureRepo}
}

func (e *LoanRestructureSave) Name() string     { return LoanRestructureSaveEvent }
func (e *LoanRestructureSave) PayloadType() any { return &models.LoanRestructure{} }

func (e *LoanRestructureSave) Validate(_ context.Context, payload any) error {
	lr, ok := payload.(*models.LoanRestructure)
	if !ok {
		return errors.New("payload is not of type models.LoanRestructure")
	}
	if lr.GetID() == "" {
		return errors.New("loan restructure ID should already have been set")
	}
	return nil
}

func (e *LoanRestructureSave) Execute(ctx context.Context, payload any) error {
	lr, ok := payload.(*models.LoanRestructure)
	if !ok {
		return errors.New("payload is not of type models.LoanRestructure")
	}

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("loan_restructure_id", lr.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	existing, getErr := e.loanRestructureRepo.GetByID(ctx, lr.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.loanRestructureRepo.Update(ctx, lr); err != nil {
			logger.WithError(err).Error("could not update loan restructure in db")
			return err
		}
		logger.Debug("event handler completed successfully")
		return nil
	}

	if err := e.loanRestructureRepo.Create(ctx, lr); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create loan restructure in db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}

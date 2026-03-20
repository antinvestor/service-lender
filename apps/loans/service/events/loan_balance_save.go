package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"
	"fmt"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
)

const LoanBalanceSaveEvent = "loan_balance.save"

type LoanBalanceSave struct {
	loanBalanceRepo repository.LoanBalanceRepository
}

func NewLoanBalanceSave(_ context.Context, loanBalanceRepo repository.LoanBalanceRepository) *LoanBalanceSave {
	return &LoanBalanceSave{loanBalanceRepo: loanBalanceRepo}
}

func (e *LoanBalanceSave) Name() string     { return LoanBalanceSaveEvent }
func (e *LoanBalanceSave) PayloadType() any { return &models.LoanBalance{} }

func (e *LoanBalanceSave) Validate(_ context.Context, payload any) error {
	lb, ok := payload.(*models.LoanBalance)
	if !ok {
		return errors.New("payload is not of type models.LoanBalance")
	}
	if lb.GetID() == "" {
		return errors.New("loan balance ID should already have been set")
	}
	return nil
}

func (e *LoanBalanceSave) Execute(ctx context.Context, payload any) error {
	lb, ok := payload.(*models.LoanBalance)
	if !ok {
		return errors.New("payload is not of type models.LoanBalance")
	}

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("loan_balance_id", lb.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	existing, getErr := e.loanBalanceRepo.GetByID(ctx, lb.GetID())
	if getErr == nil && existing != nil {
		rowsAffected, err := e.loanBalanceRepo.Update(ctx, lb)
		if err != nil {
			logger.WithError(err).Error("could not update loan balance in db")
			return err
		}
		if rowsAffected == 0 {
			return fmt.Errorf("optimistic lock conflict: loan balance %s was modified concurrently (version %d)", lb.GetID(), lb.GetVersion())
		}
		logger.Debug("event handler completed successfully")
		return nil
	}

	if err := e.loanBalanceRepo.Create(ctx, lb); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create loan balance in db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}

package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/loans/service/models"
	"github.com/antinvestor/service-fintech/apps/loans/service/repository"
)

const LoanRequestSaveEvent = "loan_request.save"

type LoanRequestSave struct {
	loanRequestRepo repository.LoanRequestRepository
}

func NewLoanRequestSave(_ context.Context, loanRequestRepo repository.LoanRequestRepository) *LoanRequestSave {
	return &LoanRequestSave{loanRequestRepo: loanRequestRepo}
}

func (e *LoanRequestSave) Name() string     { return LoanRequestSaveEvent }
func (e *LoanRequestSave) PayloadType() any { return &models.LoanRequest{} }

func (e *LoanRequestSave) Validate(_ context.Context, payload any) error {
	lr, ok := payload.(*models.LoanRequest)
	if !ok {
		return errors.New("payload is not of type models.LoanRequest")
	}
	if lr.GetID() == "" {
		return errors.New("loan request ID should already have been set")
	}
	return nil
}

func (e *LoanRequestSave) Execute(ctx context.Context, payload any) error {
	lr, ok := payload.(*models.LoanRequest)
	if !ok {
		return errors.New("payload is not of type models.LoanRequest")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "loan_request_id": lr.GetID()})
	defer logger.Release()

	existing, getErr := e.loanRequestRepo.GetByID(ctx, lr.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.loanRequestRepo.Update(ctx, lr); err != nil {
			logger.WithError(err).Error("could not update loan request in db")
			return err
		}
		return nil
	}

	if err := e.loanRequestRepo.Create(ctx, lr); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create loan request in db")
		return err
	}

	return nil
}

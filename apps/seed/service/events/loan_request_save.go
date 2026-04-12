package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/seed/service/models"
	"github.com/antinvestor/service-fintech/apps/seed/service/repository"
)

// LoanRequestSaveEvent persists a seed loan request snapshot. Loan
// requests evolve through submitted → approved → disbursed → completed,
// so the handler allows upserts (not strictly append-only) — the
// append-only invariant lives on the audit log which captures each
// state change descriptively.
const LoanRequestSaveEvent = "seed_loan_request.save"

type LoanRequestSave struct {
	repo repository.LoanRequestRepository
}

// NewLoanRequestSave wires a repository into a handler.
func NewLoanRequestSave(_ context.Context, repo repository.LoanRequestRepository) *LoanRequestSave {
	return &LoanRequestSave{repo: repo}
}

func (e *LoanRequestSave) Name() string     { return LoanRequestSaveEvent }
func (e *LoanRequestSave) PayloadType() any { return &models.LoanRequest{} }

func (e *LoanRequestSave) Validate(_ context.Context, payload any) error {
	lr, ok := payload.(*models.LoanRequest)
	if !ok {
		return errors.New("payload is not of type models.LoanRequest")
	}
	if lr.GetID() == "" {
		return errors.New("loan request id should already have been set")
	}
	if lr.ClientID == "" {
		return errors.New("loan request client id is required")
	}
	return nil
}

func (e *LoanRequestSave) Execute(ctx context.Context, payload any) error {
	lr, ok := payload.(*models.LoanRequest)
	if !ok {
		return errors.New("payload is not of type models.LoanRequest")
	}

	logger := util.Log(ctx).WithFields(map[string]any{
		"type":            e.Name(),
		"loan_request_id": lr.GetID(),
		"client_id":       lr.ClientID,
	})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, lr.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, lr); err != nil {
			logger.WithError(err).Error("could not update loan request")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, lr); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create loan request")
		return err
	}
	return nil
}

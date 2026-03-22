package events //nolint:dupl // similar patterns for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/apps/funding/service/repository"
)

const LoanWindowSaveEvent = "loan_window.save"

type loanWindowSave struct {
	repo repository.LoanWindowRepository
}

// NewLoanWindowSave creates a new loan window save event handler.
func NewLoanWindowSave(_ context.Context, repo repository.LoanWindowRepository) *loanWindowSave {
	return &loanWindowSave{repo: repo}
}

func (e *loanWindowSave) Name() string {
	return LoanWindowSaveEvent
}

func (e *loanWindowSave) PayloadType() any {
	return &models.LoanWindow{}
}

func (e *loanWindowSave) Validate(_ context.Context, payload any) error {
	lw, ok := payload.(*models.LoanWindow)
	if !ok {
		return errors.New("invalid payload type for loan_window.save")
	}
	if lw.GroupID == "" {
		return errors.New("group_id is required")
	}
	return nil
}

func (e *loanWindowSave) Execute(ctx context.Context, payload any) error {
	lw := payload.(*models.LoanWindow)
	log := util.Log(ctx)

	// Upsert: try to find existing, then create or update
	existing, err := e.repo.GetByID(ctx, lw.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("loan_window.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, lw)
		if err != nil {
			log.WithError(err).Error("loan_window.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, lw)
	if err != nil {
		log.WithError(err).Error("loan_window.save -- failed to create record")
		return err
	}
	return nil
}

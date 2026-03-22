package events //nolint:dupl // similar patterns for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/apps/funding/service/repository"
)

const LoanFundingSaveEvent = "loan_funding.save"

type loanFundingSave struct {
	repo repository.LoanFundingRepository
}

// NewLoanFundingSave creates a new loan funding save event handler.
func NewLoanFundingSave(_ context.Context, repo repository.LoanFundingRepository) *loanFundingSave {
	return &loanFundingSave{repo: repo}
}

func (e *loanFundingSave) Name() string {
	return LoanFundingSaveEvent
}

func (e *loanFundingSave) PayloadType() any {
	return &models.LoanFunding{}
}

func (e *loanFundingSave) Validate(_ context.Context, payload any) error {
	lf, ok := payload.(*models.LoanFunding)
	if !ok {
		return errors.New("invalid payload type for loan_funding.save")
	}
	if lf.LoanOfferID == "" {
		return errors.New("loan_offer_id is required")
	}
	return nil
}

func (e *loanFundingSave) Execute(ctx context.Context, payload any) error {
	lf := payload.(*models.LoanFunding)
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, lf.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("loan_funding.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, lf)
		if err != nil {
			log.WithError(err).Error("loan_funding.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, lf)
	if err != nil {
		log.WithError(err).Error("loan_funding.save -- failed to create record")
		return err
	}
	return nil
}

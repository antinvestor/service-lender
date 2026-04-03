package events //nolint:dupl // similar patterns for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/apps/funding/service/repository"
)

const LoanOfferSaveEvent = "loan_offer.save"

type loanOfferSave struct {
	repo repository.LoanOfferRepository
}

// NewLoanOfferSave creates a new loan offer save event handler.
func NewLoanOfferSave(_ context.Context, repo repository.LoanOfferRepository) *loanOfferSave {
	return &loanOfferSave{repo: repo}
}

func (e *loanOfferSave) Name() string {
	return LoanOfferSaveEvent
}

func (e *loanOfferSave) PayloadType() any {
	return &models.LoanOffer{}
}

func (e *loanOfferSave) Validate(_ context.Context, payload any) error {
	lo, ok := payload.(*models.LoanOffer)
	if !ok {
		return errors.New("invalid payload type for loan_offer.save")
	}
	if lo.MembershipID == "" {
		return errors.New("membership_id is required")
	}
	return nil
}

func (e *loanOfferSave) Execute(ctx context.Context, payload any) error {
	lo, ok := payload.(*models.LoanOffer)
	if !ok {
		return errors.New("invalid payload type for loan_offer.save")
	}
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, lo.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("loan_offer.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, lo)
		if err != nil {
			log.WithError(err).Error("loan_offer.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, lo)
	if err != nil {
		log.WithError(err).Error("loan_offer.save -- failed to create record")
		return err
	}
	return nil
}

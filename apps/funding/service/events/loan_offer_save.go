package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
	"github.com/antinvestor/service-fintech/apps/funding/service/repository"
)

const LoanOfferSaveEvent = "loan_offer.save"

// NewLoanOfferSave creates a new loan offer save event handler.
func NewLoanOfferSave(_ context.Context, repo repository.LoanOfferRepository) events.EventI {
	return &eventHandler[*models.LoanOffer]{
		name:    LoanOfferSaveEvent,
		factory: func() *models.LoanOffer { return &models.LoanOffer{} },
		validate: func(_ context.Context, lo *models.LoanOffer) error {
			if lo.MembershipID == "" {
				return errors.New("membership_id is required")
			}
			return nil
		},
		repo: repo,
	}
}

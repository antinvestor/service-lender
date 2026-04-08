package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
	"github.com/antinvestor/service-fintech/apps/funding/service/repository"
)

const InvestorAccountSaveEvent = "investor_account.save"

// NewInvestorAccountSave creates a new investor account save event handler.
func NewInvestorAccountSave(_ context.Context, repo repository.InvestorAccountRepository) events.EventI {
	return &eventHandler[*models.InvestorAccount]{
		name:    InvestorAccountSaveEvent,
		factory: func() *models.InvestorAccount { return &models.InvestorAccount{} },
		validate: func(_ context.Context, ia *models.InvestorAccount) error {
			if ia.InvestorID == "" {
				return errors.New("investor_id is required")
			}
			if ia.Currency == "" {
				return errors.New("currency is required")
			}
			return nil
		},
		repo: repo,
	}
}

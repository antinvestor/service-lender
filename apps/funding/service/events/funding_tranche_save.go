package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
	"github.com/antinvestor/service-fintech/apps/funding/service/repository"
)

const FundingTrancheSaveEvent = "funding_tranche.save"

// NewFundingTrancheSave creates a new funding tranche save event handler.
func NewFundingTrancheSave(_ context.Context, repo repository.FundingTrancheRepository) events.EventI {
	return &eventHandler[*models.FundingTranche]{
		name:    FundingTrancheSaveEvent,
		factory: func() *models.FundingTranche { return &models.FundingTranche{} },
		validate: func(_ context.Context, ft *models.FundingTranche) error {
			if ft.LoanFundingID == "" {
				return errors.New("loan_funding_id is required")
			}
			return nil
		},
		repo: repo,
	}
}

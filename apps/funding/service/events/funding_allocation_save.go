package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
	"github.com/antinvestor/service-fintech/apps/funding/service/repository"
)

const FundingAllocationSaveEvent = "funding_allocation.save"

// NewFundingAllocationSave creates a new funding allocation save event handler.
func NewFundingAllocationSave(_ context.Context, repo repository.FundingAllocationRepository) events.EventI {
	return &eventHandler[*models.FundingAllocation]{
		name:    FundingAllocationSaveEvent,
		factory: func() *models.FundingAllocation { return &models.FundingAllocation{} },
		validate: func(_ context.Context, fa *models.FundingAllocation) error {
			if fa.LoanFundingID == "" {
				return errors.New("loan_funding_id is required")
			}
			return nil
		},
		repo: repo,
	}
}

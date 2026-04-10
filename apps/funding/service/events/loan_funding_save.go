package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
	"github.com/antinvestor/service-fintech/apps/funding/service/repository"
)

const LoanFundingSaveEvent = "loan_funding.save"

// NewLoanFundingSave creates a new loan funding save event handler.
func NewLoanFundingSave(_ context.Context, repo repository.LoanFundingRepository) events.EventI {
	return &eventHandler[*models.LoanFunding]{
		name:    LoanFundingSaveEvent,
		factory: func() *models.LoanFunding { return &models.LoanFunding{} },
		validate: func(_ context.Context, lf *models.LoanFunding) error {
			if lf.LoanRequestID == "" {
				return errors.New("loan_request_id is required")
			}
			return nil
		},
		repo: repo,
	}
}

package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
	"github.com/antinvestor/service-fintech/apps/funding/service/repository"
)

const LoanWindowSaveEvent = "loan_window.save"

// NewLoanWindowSave creates a new loan window save event handler.
func NewLoanWindowSave(_ context.Context, repo repository.LoanWindowRepository) events.EventI {
	return &eventHandler[*models.LoanWindow]{
		name:    LoanWindowSaveEvent,
		factory: func() *models.LoanWindow { return &models.LoanWindow{} },
		validate: func(_ context.Context, lw *models.LoanWindow) error {
			if lw.GroupID == "" {
				return errors.New("group_id is required")
			}
			return nil
		},
		repo: repo,
	}
}

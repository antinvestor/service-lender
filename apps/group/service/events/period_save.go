package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/group/service/models"
	"github.com/antinvestor/service-fintech/apps/group/service/repository"
)

const PeriodSaveEvent = "period.save"

// NewPeriodSave creates a new period save event handler.
func NewPeriodSave(_ context.Context, repo repository.PeriodRepository) events.EventI {
	return &eventHandler[*models.Period]{
		name:    PeriodSaveEvent,
		factory: func() *models.Period { return &models.Period{} },
		validate: func(_ context.Context, period *models.Period) error {
			if period.GroupID == "" {
				return errors.New("period group ID is required")
			}
			return nil
		},
		repo: repo,
	}
}

package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
)

const TenureSaveEvent = "tenure.save"

// NewTenureSave creates a new tenure save event handler.
func NewTenureSave(_ context.Context, repo repository.TenureRepository) events.EventI {
	return &eventHandler[*models.Tenure]{
		name:    TenureSaveEvent,
		factory: func() *models.Tenure { return &models.Tenure{} },
		validate: func(_ context.Context, tenure *models.Tenure) error {
			if tenure.GroupID == "" {
				return errors.New("tenure group ID is required")
			}
			return nil
		},
		repo: repo,
	}
}

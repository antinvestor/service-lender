package events

import (
	"context"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/group/service/models"
	"github.com/antinvestor/service-fintech/apps/group/service/repository"
)

const InfractionSaveEvent = "infraction.save"

// NewInfractionSave creates a new infraction save event handler.
func NewInfractionSave(_ context.Context, repo repository.InfractionRepository) events.EventI {
	return &eventHandler[*models.Infraction]{
		name:    InfractionSaveEvent,
		factory: func() *models.Infraction { return &models.Infraction{} },
		validate: func(_ context.Context, _ *models.Infraction) error {
			return nil
		},
		repo: repo,
	}
}

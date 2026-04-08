package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/operations/service/models"
	"github.com/antinvestor/service-fintech/apps/operations/service/repository"
)

const AccountRefSaveEvent = "account_ref.save"

// NewAccountRefSave creates a new account ref save event handler.
func NewAccountRefSave(_ context.Context, repo repository.AccountRefRepository) events.EventI {
	return &eventHandler[*models.AccountRef]{
		name:    AccountRefSaveEvent,
		factory: func() *models.AccountRef { return &models.AccountRef{} },
		validate: func(_ context.Context, ar *models.AccountRef) error {
			if ar.OwnerID == "" {
				return errors.New("owner_id is required")
			}
			return nil
		},
		repo: repo,
	}
}

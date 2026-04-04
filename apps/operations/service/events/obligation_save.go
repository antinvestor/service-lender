package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
)

const ObligationSaveEvent = "obligation.save"

// NewObligationSave creates a new obligation save event handler.
func NewObligationSave(_ context.Context, repo repository.ObligationRepository) events.EventI {
	return &eventHandler[*models.Obligation]{
		name:    ObligationSaveEvent,
		factory: func() *models.Obligation { return &models.Obligation{} },
		validate: func(_ context.Context, ob *models.Obligation) error {
			if ob.MembershipID == "" {
				return errors.New("membership_id is required")
			}
			return nil
		},
		repo: repo,
	}
}

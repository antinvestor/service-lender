package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/group/service/models"
	"github.com/antinvestor/service-fintech/apps/group/service/repository"
)

const MembershipSaveEvent = "membership.save"

// NewMembershipSave creates a new membership save event handler.
func NewMembershipSave(_ context.Context, repo repository.MembershipRepository) events.EventI {
	return &eventHandler[*models.Membership]{
		name:    MembershipSaveEvent,
		factory: func() *models.Membership { return &models.Membership{} },
		validate: func(_ context.Context, membership *models.Membership) error {
			if membership.GroupID == "" {
				return errors.New("membership group ID is required")
			}
			return nil
		},
		repo: repo,
	}
}

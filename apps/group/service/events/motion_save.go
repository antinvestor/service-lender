package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
)

const MotionSaveEvent = "motion.save"

// NewMotionSave creates a new motion save event handler.
func NewMotionSave(_ context.Context, repo repository.MotionRepository) events.EventI {
	return &eventHandler[*models.Motion]{
		name:    MotionSaveEvent,
		factory: func() *models.Motion { return &models.Motion{} },
		validate: func(_ context.Context, motion *models.Motion) error {
			if motion.GroupID == "" {
				return errors.New("motion group ID is required")
			}
			return nil
		},
		repo: repo,
	}
}

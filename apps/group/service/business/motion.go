package business

import (
	"context"
	"errors"

	fevents "github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
)

type motionBusiness struct {
	eventsMan fevents.Manager
	motRepo   repository.MotionRepository
}

func NewMotionBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	motRepo repository.MotionRepository,
) MotionBusiness {
	return &motionBusiness{eventsMan: eventsMan, motRepo: motRepo}
}

func (b *motionBusiness) Create(ctx context.Context, motion *models.Motion) (*models.Motion, error) {
	return nil, errors.New("not implemented")
}

func (b *motionBusiness) Vote(ctx context.Context, motionID, membershipID string, choice int32) error {
	return errors.New("not implemented")
}

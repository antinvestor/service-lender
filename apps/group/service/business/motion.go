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

func (b *motionBusiness) Create(_ context.Context, _ *models.Motion) (*models.Motion, error) {
	return nil, errors.New("group motion operations are not yet available for this product")
}

func (b *motionBusiness) Vote(_ context.Context, _, _ string, _ int32) error {
	return errors.New("group motion operations are not yet available for this product")
}

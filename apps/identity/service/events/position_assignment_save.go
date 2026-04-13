package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

const PositionAssignmentSaveEvent = "position_assignment.save"

type PositionAssignmentSave struct {
	repo repository.PositionAssignmentRepository
}

func NewPositionAssignmentSave(
	_ context.Context,
	repo repository.PositionAssignmentRepository,
) *PositionAssignmentSave {
	return &PositionAssignmentSave{repo: repo}
}

func (e *PositionAssignmentSave) Name() string     { return PositionAssignmentSaveEvent }
func (e *PositionAssignmentSave) PayloadType() any { return &models.PositionAssignment{} }

func (e *PositionAssignmentSave) Validate(_ context.Context, payload any) error {
	m, ok := payload.(*models.PositionAssignment)
	if !ok {
		return errors.New("payload is not of expected type")
	}
	if m.GetID() == "" {
		return errors.New("ID should already have been set")
	}
	return nil
}

func (e *PositionAssignmentSave) Execute(ctx context.Context, payload any) error {
	m, ok := payload.(*models.PositionAssignment)
	if !ok {
		return errors.New("payload is not of expected type")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "id": m.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, m.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, m); err != nil {
			logger.WithError(err).Error("could not update in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, m); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create in db")
		return err
	}

	return nil
}

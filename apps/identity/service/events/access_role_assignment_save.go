package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

const AccessRoleAssignmentSaveEvent = "access_role_assignment.save"

type AccessRoleAssignmentSave struct {
	repo repository.AccessRoleAssignmentRepository
}

func NewAccessRoleAssignmentSave(
	_ context.Context,
	repo repository.AccessRoleAssignmentRepository,
) *AccessRoleAssignmentSave {
	return &AccessRoleAssignmentSave{repo: repo}
}

func (e *AccessRoleAssignmentSave) Name() string     { return AccessRoleAssignmentSaveEvent }
func (e *AccessRoleAssignmentSave) PayloadType() any { return &models.AccessRoleAssignment{} }

func (e *AccessRoleAssignmentSave) Validate(_ context.Context, payload any) error {
	m, ok := payload.(*models.AccessRoleAssignment)
	if !ok {
		return errors.New("payload is not of type models.AccessRoleAssignment")
	}
	if m.GetID() == "" {
		return errors.New("access role assignment ID should already have been set")
	}
	return nil
}

func (e *AccessRoleAssignmentSave) Execute(ctx context.Context, payload any) error {
	m, ok := payload.(*models.AccessRoleAssignment)
	if !ok {
		return errors.New("payload is not of type models.AccessRoleAssignment")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "assignment_id": m.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, m.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, m); err != nil {
			logger.WithError(err).Error("could not update access role assignment in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, m); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create access role assignment in db")
		return err
	}

	return nil
}

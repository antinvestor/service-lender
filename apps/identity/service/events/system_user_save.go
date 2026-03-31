package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

const SystemUserSaveEvent = "system_user.save"

type SystemUserSave struct {
	systemUserRepo repository.SystemUserRepository
}

func NewSystemUserSave(_ context.Context, systemUserRepo repository.SystemUserRepository) *SystemUserSave {
	return &SystemUserSave{systemUserRepo: systemUserRepo}
}

func (e *SystemUserSave) Name() string     { return SystemUserSaveEvent }
func (e *SystemUserSave) PayloadType() any { return &models.SystemUser{} }

func (e *SystemUserSave) Validate(_ context.Context, payload any) error {
	su, ok := payload.(*models.SystemUser)
	if !ok {
		return errors.New("payload is not of type models.SystemUser")
	}
	if su.GetID() == "" {
		return errors.New("system user ID should already have been set")
	}
	return nil
}

func (e *SystemUserSave) Execute(ctx context.Context, payload any) error {
	su, ok := payload.(*models.SystemUser)
	if !ok {
		return errors.New("payload is not of type models.SystemUser")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "system_user_id": su.GetID()})
	defer logger.Release()

	existing, getErr := e.systemUserRepo.GetByID(ctx, su.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.systemUserRepo.Update(ctx, su); err != nil {
			logger.WithError(err).Error("could not update system user in db")
			return err
		}
		return nil
	}

	if err := e.systemUserRepo.Create(ctx, su); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create system user in db")
		return err
	}

	return nil
}

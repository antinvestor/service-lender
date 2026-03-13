package events

import (
	"context"
	"errors"

	"github.com/antinvestor/service-ant-lender/apps/identity/service/models"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/repository"
	"github.com/pitabwire/util"
)

const SystemUserSaveEvent = "system_user.save"

type SystemUserSave struct {
	systemUserRepo repository.SystemUserRepository
}

func NewSystemUserSave(_ context.Context, systemUserRepo repository.SystemUserRepository) *SystemUserSave {
	return &SystemUserSave{systemUserRepo: systemUserRepo}
}

func (e *SystemUserSave) Name() string         { return SystemUserSaveEvent }
func (e *SystemUserSave) PayloadType() any     { return &models.SystemUser{} }

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
	su := payload.(*models.SystemUser)

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("system_user_id", su.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	err := e.systemUserRepo.Create(ctx, su)
	if err != nil {
		logger.WithError(err).Error("could not save system user to db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}

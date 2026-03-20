package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/origination/service/models"
	"github.com/antinvestor/service-lender/apps/origination/service/repository"
)

const VerificationTaskSaveEvent = "verification_task.save"

type VerificationTaskSave struct {
	repo repository.VerificationTaskRepository
}

func NewVerificationTaskSave(_ context.Context, repo repository.VerificationTaskRepository) *VerificationTaskSave {
	return &VerificationTaskSave{repo: repo}
}

func (e *VerificationTaskSave) Name() string     { return VerificationTaskSaveEvent }
func (e *VerificationTaskSave) PayloadType() any { return &models.VerificationTask{} }

func (e *VerificationTaskSave) Validate(_ context.Context, payload any) error {
	vt, ok := payload.(*models.VerificationTask)
	if !ok {
		return errors.New("payload is not of type models.VerificationTask")
	}
	if vt.GetID() == "" {
		return errors.New("verification task ID should already have been set")
	}
	return nil
}

func (e *VerificationTaskSave) Execute(ctx context.Context, payload any) error {
	vt, ok := payload.(*models.VerificationTask)
	if !ok {
		return errors.New("payload is not of type models.VerificationTask")
	}

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("verification_task_id", vt.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	existing, getErr := e.repo.GetByID(ctx, vt.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, vt); err != nil {
			logger.WithError(err).Error("could not update verification task in db")
			return err
		}
		logger.Debug("event handler completed successfully")
		return nil
	}

	if err := e.repo.Create(ctx, vt); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create verification task in db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}

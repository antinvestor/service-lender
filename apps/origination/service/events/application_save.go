package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
)

const ApplicationSaveEvent = "application.save"

type ApplicationSave struct {
	repo repository.ApplicationRepository
}

func NewApplicationSave(_ context.Context, repo repository.ApplicationRepository) *ApplicationSave {
	return &ApplicationSave{repo: repo}
}

func (e *ApplicationSave) Name() string     { return ApplicationSaveEvent }
func (e *ApplicationSave) PayloadType() any { return &models.Application{} }

func (e *ApplicationSave) Validate(_ context.Context, payload any) error {
	app, ok := payload.(*models.Application)
	if !ok {
		return errors.New("payload is not of type models.Application")
	}
	if app.GetID() == "" {
		return errors.New("application ID should already have been set")
	}
	return nil
}

func (e *ApplicationSave) Execute(ctx context.Context, payload any) error {
	app, ok := payload.(*models.Application)
	if !ok {
		return errors.New("payload is not of type models.Application")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "application_id": app.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, app.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, app); err != nil {
			logger.WithError(err).Error("could not update application in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, app); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create application in db")
		return err
	}

	return nil
}

package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/origination/service/models"
	"github.com/antinvestor/service-lender/apps/origination/service/repository"
)

const ApplicationStatusHistorySaveEvent = "application_status_history.save"

type ApplicationStatusHistorySave struct {
	repo repository.ApplicationStatusHistoryRepository
}

func NewApplicationStatusHistorySave(
	_ context.Context,
	repo repository.ApplicationStatusHistoryRepository,
) *ApplicationStatusHistorySave {
	return &ApplicationStatusHistorySave{repo: repo}
}

func (e *ApplicationStatusHistorySave) Name() string     { return ApplicationStatusHistorySaveEvent }
func (e *ApplicationStatusHistorySave) PayloadType() any { return &models.ApplicationStatusHistory{} }

func (e *ApplicationStatusHistorySave) Validate(_ context.Context, payload any) error {
	ash, ok := payload.(*models.ApplicationStatusHistory)
	if !ok {
		return errors.New("payload is not of type models.ApplicationStatusHistory")
	}
	if ash.GetID() == "" {
		return errors.New("application status history ID should already have been set")
	}
	return nil
}

func (e *ApplicationStatusHistorySave) Execute(ctx context.Context, payload any) error {
	ash, ok := payload.(*models.ApplicationStatusHistory)
	if !ok {
		return errors.New("payload is not of type models.ApplicationStatusHistory")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "application_status_history_id": ash.GetID()})
	defer logger.Release()

	if err := e.repo.Create(ctx, ash); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create application status history in db")
		return err
	}

	return nil
}

package events //nolint:dupl // similar patterns for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
)

const PeriodSaveEvent = "period.save"

type periodSave struct {
	repo repository.PeriodRepository
}

// NewPeriodSave creates a new period save event handler.
func NewPeriodSave(_ context.Context, repo repository.PeriodRepository) *periodSave {
	return &periodSave{repo: repo}
}

func (e *periodSave) Name() string {
	return PeriodSaveEvent
}

func (e *periodSave) PayloadType() any {
	return &models.Period{}
}

func (e *periodSave) Validate(_ context.Context, payload any) error {
	period, ok := payload.(*models.Period)
	if !ok {
		return errors.New("invalid payload type for period.save")
	}
	if period.GroupID == "" {
		return errors.New("period group ID is required")
	}
	return nil
}

func (e *periodSave) Execute(ctx context.Context, payload any) error {
	period := payload.(*models.Period)
	log := util.Log(ctx)

	if period.GetVersion() > 0 {
		_, err := e.repo.Update(ctx, period)
		if err != nil {
			log.WithError(err).Error("period.save -- could not update period")
			return err
		}
		return nil
	}

	err := e.repo.Create(ctx, period)
	if err != nil {
		if data.ErrorIsDuplicateKey(err) {
			log.WithError(err).Warn("period.save -- duplicate period, attempting update")
			existing, getErr := e.repo.GetByID(ctx, period.GetID())
			if getErr != nil {
				return getErr
			}
			period.Version = existing.Version
			_, err = e.repo.Update(ctx, period)
			if err != nil {
				log.WithError(err).Error("period.save -- could not update existing period")
				return err
			}
			return nil
		}
		log.WithError(err).Error("period.save -- could not create period")
		return err
	}

	return nil
}

var _ events.EventI = (*periodSave)(nil)

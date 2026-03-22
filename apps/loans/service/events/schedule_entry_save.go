package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
)

const ScheduleEntrySaveEvent = "schedule_entry.save"

type ScheduleEntrySave struct {
	scheduleEntryRepo repository.ScheduleEntryRepository
}

func NewScheduleEntrySave(_ context.Context, scheduleEntryRepo repository.ScheduleEntryRepository) *ScheduleEntrySave {
	return &ScheduleEntrySave{scheduleEntryRepo: scheduleEntryRepo}
}

func (e *ScheduleEntrySave) Name() string     { return ScheduleEntrySaveEvent }
func (e *ScheduleEntrySave) PayloadType() any { return &models.ScheduleEntry{} }

func (e *ScheduleEntrySave) Validate(_ context.Context, payload any) error {
	se, ok := payload.(*models.ScheduleEntry)
	if !ok {
		return errors.New("payload is not of type models.ScheduleEntry")
	}
	if se.GetID() == "" {
		return errors.New("schedule entry ID should already have been set")
	}
	return nil
}

func (e *ScheduleEntrySave) Execute(ctx context.Context, payload any) error {
	se, ok := payload.(*models.ScheduleEntry)
	if !ok {
		return errors.New("payload is not of type models.ScheduleEntry")
	}

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("schedule_entry_id", se.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	existing, getErr := e.scheduleEntryRepo.GetByID(ctx, se.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.scheduleEntryRepo.Update(ctx, se); err != nil {
			logger.WithError(err).Error("could not update schedule entry in db")
			return err
		}
		logger.Debug("event handler completed successfully")
		return nil
	}

	if err := e.scheduleEntryRepo.Create(ctx, se); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create schedule entry in db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}

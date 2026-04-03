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

const MotionSaveEvent = "motion.save"

type motionSave struct {
	repo repository.MotionRepository
}

// NewMotionSave creates a new motion save event handler.
func NewMotionSave(_ context.Context, repo repository.MotionRepository) *motionSave {
	return &motionSave{repo: repo}
}

func (e *motionSave) Name() string {
	return MotionSaveEvent
}

func (e *motionSave) PayloadType() any {
	return &models.Motion{}
}

func (e *motionSave) Validate(_ context.Context, payload any) error {
	motion, ok := payload.(*models.Motion)
	if !ok {
		return errors.New("invalid payload type for motion.save")
	}
	if motion.GroupID == "" {
		return errors.New("motion group ID is required")
	}
	return nil
}

func (e *motionSave) Execute(ctx context.Context, payload any) error {
	motion, ok := payload.(*models.Motion)
	if !ok {
		return errors.New("invalid payload type for motion.save")
	}
	log := util.Log(ctx)

	if motion.GetVersion() > 0 {
		_, err := e.repo.Update(ctx, motion)
		if err != nil {
			log.WithError(err).Error("motion.save -- could not update motion")
			return err
		}
		return nil
	}

	err := e.repo.Create(ctx, motion)
	if err != nil {
		if data.ErrorIsDuplicateKey(err) {
			log.WithError(err).Warn("motion.save -- duplicate motion, attempting update")
			existing, getErr := e.repo.GetByID(ctx, motion.GetID())
			if getErr != nil {
				return getErr
			}
			motion.Version = existing.Version
			_, err = e.repo.Update(ctx, motion)
			if err != nil {
				log.WithError(err).Error("motion.save -- could not update existing motion")
				return err
			}
			return nil
		}
		log.WithError(err).Error("motion.save -- could not create motion")
		return err
	}

	return nil
}

var _ events.EventI = (*motionSave)(nil)

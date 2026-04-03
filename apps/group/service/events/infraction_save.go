package events

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
)

const InfractionSaveEvent = "infraction.save"

type infractionSave struct {
	repo repository.InfractionRepository
}

// NewInfractionSave creates a new infraction save event handler.
func NewInfractionSave(_ context.Context, repo repository.InfractionRepository) *infractionSave {
	return &infractionSave{repo: repo}
}

func (e *infractionSave) Name() string {
	return InfractionSaveEvent
}

func (e *infractionSave) PayloadType() any {
	return &models.Infraction{}
}

func (e *infractionSave) Validate(_ context.Context, payload any) error {
	_, ok := payload.(*models.Infraction)
	if !ok {
		return errors.New("invalid payload type for infraction.save")
	}
	return nil
}

func (e *infractionSave) Execute(ctx context.Context, payload any) error {
	infraction, ok := payload.(*models.Infraction)
	if !ok {
		return errors.New("invalid payload type for infraction.save")
	}
	log := util.Log(ctx)

	if infraction.GetVersion() > 0 {
		_, err := e.repo.Update(ctx, infraction)
		if err != nil {
			log.WithError(err).Error("infraction.save -- could not update infraction")
			return err
		}
		return nil
	}

	err := e.repo.Create(ctx, infraction)
	if err != nil {
		if data.ErrorIsDuplicateKey(err) {
			log.WithError(err).Warn("infraction.save -- duplicate infraction, attempting update")
			existing, getErr := e.repo.GetByID(ctx, infraction.GetID())
			if getErr != nil {
				return getErr
			}
			infraction.Version = existing.Version
			_, err = e.repo.Update(ctx, infraction)
			if err != nil {
				log.WithError(err).Error("infraction.save -- could not update existing infraction")
				return err
			}
			return nil
		}
		log.WithError(err).Error("infraction.save -- could not create infraction")
		return err
	}

	return nil
}

var _ events.EventI = (*infractionSave)(nil)

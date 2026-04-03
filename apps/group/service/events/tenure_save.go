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

const TenureSaveEvent = "tenure.save"

type tenureSave struct {
	repo repository.TenureRepository
}

// NewTenureSave creates a new tenure save event handler.
func NewTenureSave(_ context.Context, repo repository.TenureRepository) *tenureSave {
	return &tenureSave{repo: repo}
}

func (e *tenureSave) Name() string {
	return TenureSaveEvent
}

func (e *tenureSave) PayloadType() any {
	return &models.Tenure{}
}

func (e *tenureSave) Validate(_ context.Context, payload any) error {
	tenure, ok := payload.(*models.Tenure)
	if !ok {
		return errors.New("invalid payload type for tenure.save")
	}
	if tenure.GroupID == "" {
		return errors.New("tenure group ID is required")
	}
	return nil
}

func (e *tenureSave) Execute(ctx context.Context, payload any) error {
	tenure, ok := payload.(*models.Tenure)
	if !ok {
		return errors.New("invalid payload type for tenure.save")
	}
	log := util.Log(ctx)

	if tenure.GetVersion() > 0 {
		_, err := e.repo.Update(ctx, tenure)
		if err != nil {
			log.WithError(err).Error("tenure.save -- could not update tenure")
			return err
		}
		return nil
	}

	err := e.repo.Create(ctx, tenure)
	if err != nil {
		if data.ErrorIsDuplicateKey(err) {
			log.WithError(err).Warn("tenure.save -- duplicate tenure, attempting update")
			existing, getErr := e.repo.GetByID(ctx, tenure.GetID())
			if getErr != nil {
				return getErr
			}
			tenure.Version = existing.Version
			_, err = e.repo.Update(ctx, tenure)
			if err != nil {
				log.WithError(err).Error("tenure.save -- could not update existing tenure")
				return err
			}
			return nil
		}
		log.WithError(err).Error("tenure.save -- could not create tenure")
		return err
	}

	return nil
}

var _ events.EventI = (*tenureSave)(nil)

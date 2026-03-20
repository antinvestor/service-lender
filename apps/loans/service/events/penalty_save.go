package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
)

const PenaltySaveEvent = "penalty.save"

type PenaltySave struct {
	penaltyRepo repository.PenaltyRepository
}

func NewPenaltySave(_ context.Context, penaltyRepo repository.PenaltyRepository) *PenaltySave {
	return &PenaltySave{penaltyRepo: penaltyRepo}
}

func (e *PenaltySave) Name() string     { return PenaltySaveEvent }
func (e *PenaltySave) PayloadType() any { return &models.Penalty{} }

func (e *PenaltySave) Validate(_ context.Context, payload any) error {
	p, ok := payload.(*models.Penalty)
	if !ok {
		return errors.New("payload is not of type models.Penalty")
	}
	if p.GetID() == "" {
		return errors.New("penalty ID should already have been set")
	}
	return nil
}

func (e *PenaltySave) Execute(ctx context.Context, payload any) error {
	p, ok := payload.(*models.Penalty)
	if !ok {
		return errors.New("payload is not of type models.Penalty")
	}

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("penalty_id", p.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	existing, getErr := e.penaltyRepo.GetByID(ctx, p.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.penaltyRepo.Update(ctx, p); err != nil {
			logger.WithError(err).Error("could not update penalty in db")
			return err
		}
		logger.Debug("event handler completed successfully")
		return nil
	}

	if err := e.penaltyRepo.Create(ctx, p); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create penalty in db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}

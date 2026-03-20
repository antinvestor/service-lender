package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/savings/service/models"
	"github.com/antinvestor/service-lender/apps/savings/service/repository"
)

const DepositSaveEvent = "deposit.save"

type DepositSave struct {
	repo repository.DepositRepository
}

func NewDepositSave(_ context.Context, repo repository.DepositRepository) *DepositSave {
	return &DepositSave{repo: repo}
}

func (e *DepositSave) Name() string     { return DepositSaveEvent }
func (e *DepositSave) PayloadType() any { return &models.Deposit{} }

func (e *DepositSave) Validate(_ context.Context, payload any) error {
	d, ok := payload.(*models.Deposit)
	if !ok {
		return errors.New("payload is not of type models.Deposit")
	}
	if d.GetID() == "" {
		return errors.New("deposit ID should already have been set")
	}
	return nil
}

func (e *DepositSave) Execute(ctx context.Context, payload any) error {
	d, ok := payload.(*models.Deposit)
	if !ok {
		return errors.New("payload is not of type models.Deposit")
	}

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("deposit_id", d.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	existing, getErr := e.repo.GetByID(ctx, d.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, d); err != nil {
			logger.WithError(err).Error("could not update deposit in db")
			return err
		}
		logger.Debug("event handler completed successfully")
		return nil
	}

	if err := e.repo.Create(ctx, d); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create deposit in db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}

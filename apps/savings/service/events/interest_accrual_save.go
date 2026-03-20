package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/savings/service/models"
	"github.com/antinvestor/service-lender/apps/savings/service/repository"
)

const InterestAccrualSaveEvent = "interest_accrual.save"

type InterestAccrualSave struct {
	repo repository.InterestAccrualRepository
}

func NewInterestAccrualSave(_ context.Context, repo repository.InterestAccrualRepository) *InterestAccrualSave {
	return &InterestAccrualSave{repo: repo}
}

func (e *InterestAccrualSave) Name() string     { return InterestAccrualSaveEvent }
func (e *InterestAccrualSave) PayloadType() any { return &models.InterestAccrual{} }

func (e *InterestAccrualSave) Validate(_ context.Context, payload any) error {
	ia, ok := payload.(*models.InterestAccrual)
	if !ok {
		return errors.New("payload is not of type models.InterestAccrual")
	}
	if ia.GetID() == "" {
		return errors.New("interest accrual ID should already have been set")
	}
	return nil
}

func (e *InterestAccrualSave) Execute(ctx context.Context, payload any) error {
	ia, ok := payload.(*models.InterestAccrual)
	if !ok {
		return errors.New("payload is not of type models.InterestAccrual")
	}

	logger := util.Log(ctx).WithField("type", e.Name()).WithField("interest_accrual_id", ia.GetID())
	defer logger.Release()
	logger.Debug("event handler started")

	existing, getErr := e.repo.GetByID(ctx, ia.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, ia); err != nil {
			logger.WithError(err).Error("could not update interest accrual in db")
			return err
		}
		logger.Debug("event handler completed successfully")
		return nil
	}

	if err := e.repo.Create(ctx, ia); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create interest accrual in db")
		return err
	}

	logger.Debug("event handler completed successfully")
	return nil
}

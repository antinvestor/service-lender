package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/loans/service/models"
	"github.com/antinvestor/service-fintech/apps/loans/service/repository"
)

const DisbursementSaveEvent = "disbursement.save"

type DisbursementSave struct {
	repo repository.DisbursementRepository
}

func NewDisbursementSave(_ context.Context, repo repository.DisbursementRepository) *DisbursementSave {
	return &DisbursementSave{repo: repo}
}

func (e *DisbursementSave) Name() string     { return DisbursementSaveEvent }
func (e *DisbursementSave) PayloadType() any { return &models.Disbursement{} }

func (e *DisbursementSave) Validate(_ context.Context, payload any) error {
	d, ok := payload.(*models.Disbursement)
	if !ok {
		return errors.New("payload is not of type models.Disbursement")
	}
	if d.GetID() == "" {
		return errors.New("disbursement ID should already have been set")
	}
	return nil
}

func (e *DisbursementSave) Execute(ctx context.Context, payload any) error {
	d, ok := payload.(*models.Disbursement)
	if !ok {
		return errors.New("payload is not of type models.Disbursement")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "disbursement_id": d.GetID()})
	defer logger.Release()

	existing, getErr := e.repo.GetByID(ctx, d.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repo.Update(ctx, d); err != nil {
			logger.WithError(err).Error("could not update disbursement in db")
			return err
		}
		return nil
	}

	if err := e.repo.Create(ctx, d); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create disbursement in db")
		return err
	}

	return nil
}

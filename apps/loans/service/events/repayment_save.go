package events //nolint:dupl // similar event handlers for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/loans/service/models"
	"github.com/antinvestor/service-fintech/apps/loans/service/repository"
)

const RepaymentSaveEvent = "repayment.save"

type RepaymentSave struct {
	repaymentRepo repository.RepaymentRepository
}

func NewRepaymentSave(_ context.Context, repaymentRepo repository.RepaymentRepository) *RepaymentSave {
	return &RepaymentSave{repaymentRepo: repaymentRepo}
}

func (e *RepaymentSave) Name() string     { return RepaymentSaveEvent }
func (e *RepaymentSave) PayloadType() any { return &models.Repayment{} }

func (e *RepaymentSave) Validate(_ context.Context, payload any) error {
	r, ok := payload.(*models.Repayment)
	if !ok {
		return errors.New("payload is not of type models.Repayment")
	}
	if r.GetID() == "" {
		return errors.New("repayment ID should already have been set")
	}
	return nil
}

func (e *RepaymentSave) Execute(ctx context.Context, payload any) error {
	r, ok := payload.(*models.Repayment)
	if !ok {
		return errors.New("payload is not of type models.Repayment")
	}

	logger := util.Log(ctx).WithFields(map[string]any{"type": e.Name(), "repayment_id": r.GetID()})
	defer logger.Release()

	existing, getErr := e.repaymentRepo.GetByID(ctx, r.GetID())
	if getErr == nil && existing != nil {
		if _, err := e.repaymentRepo.Update(ctx, r); err != nil {
			logger.WithError(err).Error("could not update repayment in db")
			return err
		}
		return nil
	}

	if err := e.repaymentRepo.Create(ctx, r); err != nil && !data.ErrorIsDuplicateKey(err) {
		logger.WithError(err).Error("could not create repayment in db")
		return err
	}

	return nil
}

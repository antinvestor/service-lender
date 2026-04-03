package events //nolint:dupl // similar patterns for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/apps/funding/service/repository"
)

const FundingAllocationSaveEvent = "funding_allocation.save"

type fundingAllocationSave struct {
	repo repository.FundingAllocationRepository
}

// NewFundingAllocationSave creates a new funding allocation save event handler.
func NewFundingAllocationSave(_ context.Context, repo repository.FundingAllocationRepository) *fundingAllocationSave {
	return &fundingAllocationSave{repo: repo}
}

func (e *fundingAllocationSave) Name() string {
	return FundingAllocationSaveEvent
}

func (e *fundingAllocationSave) PayloadType() any {
	return &models.FundingAllocation{}
}

func (e *fundingAllocationSave) Validate(_ context.Context, payload any) error {
	fa, ok := payload.(*models.FundingAllocation)
	if !ok {
		return errors.New("invalid payload type for funding_allocation.save")
	}
	if fa.LoanFundingID == "" {
		return errors.New("loan_funding_id is required")
	}
	return nil
}

func (e *fundingAllocationSave) Execute(ctx context.Context, payload any) error {
	fa, ok := payload.(*models.FundingAllocation)
	if !ok {
		return errors.New("invalid payload type for funding_allocation.save")
	}
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, fa.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("funding_allocation.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, fa)
		if err != nil {
			log.WithError(err).Error("funding_allocation.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, fa)
	if err != nil {
		log.WithError(err).Error("funding_allocation.save -- failed to create record")
		return err
	}
	return nil
}

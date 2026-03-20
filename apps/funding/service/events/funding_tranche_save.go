package events //nolint:dupl // similar patterns for different entity types

import (
	"context"
	"errors"

	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/apps/funding/service/repository"
)

const FundingTrancheSaveEvent = "funding_tranche.save"

type fundingTrancheSave struct {
	repo repository.FundingTrancheRepository
}

// NewFundingTrancheSave creates a new funding tranche save event handler.
func NewFundingTrancheSave(_ context.Context, repo repository.FundingTrancheRepository) *fundingTrancheSave {
	return &fundingTrancheSave{repo: repo}
}

func (e *fundingTrancheSave) Name() string {
	return FundingTrancheSaveEvent
}

func (e *fundingTrancheSave) PayloadType() any {
	return &models.FundingTranche{}
}

func (e *fundingTrancheSave) Validate(_ context.Context, payload any) error {
	ft, ok := payload.(*models.FundingTranche)
	if !ok {
		return errors.New("invalid payload type for funding_tranche.save")
	}
	if ft.LoanFundingID == "" {
		return errors.New("loan_funding_id is required")
	}
	return nil
}

func (e *fundingTrancheSave) Execute(ctx context.Context, payload any) error {
	ft := payload.(*models.FundingTranche)
	log := util.Log(ctx)

	existing, err := e.repo.GetByID(ctx, ft.ID)
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		log.WithError(err).Error("funding_tranche.save -- failed to check existing record")
		return err
	}

	if existing != nil && existing.GetID() != "" {
		_, err = e.repo.Update(ctx, ft)
		if err != nil {
			log.WithError(err).Error("funding_tranche.save -- failed to update record")
			return err
		}
		return nil
	}

	err = e.repo.Create(ctx, ft)
	if err != nil {
		log.WithError(err).Error("funding_tranche.save -- failed to create record")
		return err
	}
	return nil
}

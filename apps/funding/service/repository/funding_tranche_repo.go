package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
)

// FundingTrancheRepository provides data access for funding tranches.
type FundingTrancheRepository interface {
	datastore.BaseRepository[*models.FundingTranche]
	GetByLoanFundingID(ctx context.Context, loanFundingID string) ([]*models.FundingTranche, error)
	GetByLoanRequestID(ctx context.Context, loanRequestID string) ([]*models.FundingTranche, error)
}

// NewFundingTrancheRepository creates a new FundingTrancheRepository.
func NewFundingTrancheRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) FundingTrancheRepository {
	return &fundingTrancheRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.FundingTranche {
			return &models.FundingTranche{}
		}),
	}
}

type fundingTrancheRepository struct {
	datastore.BaseRepository[*models.FundingTranche]
}

func (r *fundingTrancheRepository) GetByLoanFundingID(
	ctx context.Context,
	loanFundingID string,
) ([]*models.FundingTranche, error) {
	var tranches []*models.FundingTranche
	err := r.Pool().DB(ctx, true).
		Where("loan_funding_id = ?", loanFundingID).
		Order("tranche_level ASC").
		Find(&tranches).Error
	return tranches, err
}

// GetByLoanRequestID returns all tranches for a loan request by joining through loan fundings.
func (r *fundingTrancheRepository) GetByLoanRequestID(
	ctx context.Context,
	loanRequestID string,
) ([]*models.FundingTranche, error) {
	var tranches []*models.FundingTranche
	err := r.Pool().DB(ctx, true).
		Where("loan_funding_id IN (SELECT id FROM loan_fundings WHERE loan_offer_id = ?)", loanRequestID).
		Order("tranche_level ASC").
		Find(&tranches).Error
	return tranches, err
}

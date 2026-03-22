package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/funding/service/models"
)

// LoanFundingRepository provides data access for loan fundings.
type LoanFundingRepository interface {
	datastore.BaseRepository[*models.LoanFunding]
	GetByLoanOfferID(ctx context.Context, loanOfferID string) ([]*models.LoanFunding, error)
}

// NewLoanFundingRepository creates a new LoanFundingRepository.
func NewLoanFundingRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) LoanFundingRepository {
	return &loanFundingRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.LoanFunding {
			return &models.LoanFunding{}
		}),
	}
}

type loanFundingRepository struct {
	datastore.BaseRepository[*models.LoanFunding]
}

func (r *loanFundingRepository) GetByLoanOfferID(
	ctx context.Context,
	loanOfferID string,
) ([]*models.LoanFunding, error) {
	var fundings []*models.LoanFunding
	err := r.Pool().DB(ctx, true).Where("loan_offer_id = ?", loanOfferID).Find(&fundings).Error
	return fundings, err
}

package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/funding/service/models"
)

// LoanOfferRepository provides data access for loan offers.
type LoanOfferRepository interface {
	datastore.BaseRepository[*models.LoanOffer]
	GetByMembershipID(ctx context.Context, membershipID string) ([]*models.LoanOffer, error)
	GetByLoanWindowID(ctx context.Context, loanWindowID string) ([]*models.LoanOffer, error)
}

// NewLoanOfferRepository creates a new LoanOfferRepository.
func NewLoanOfferRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) LoanOfferRepository {
	return &loanOfferRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.LoanOffer {
			return &models.LoanOffer{}
		}),
	}
}

type loanOfferRepository struct {
	datastore.BaseRepository[*models.LoanOffer]
}

func (r *loanOfferRepository) GetByMembershipID(ctx context.Context, membershipID string) ([]*models.LoanOffer, error) {
	var offers []*models.LoanOffer
	err := r.Pool().DB(ctx, true).Where("membership_id = ?", membershipID).Find(&offers).Error
	return offers, err
}

func (r *loanOfferRepository) GetByLoanWindowID(ctx context.Context, loanWindowID string) ([]*models.LoanOffer, error) {
	var offers []*models.LoanOffer
	err := r.Pool().DB(ctx, true).Where("loan_window_id = ?", loanWindowID).Find(&offers).Error
	return offers, err
}

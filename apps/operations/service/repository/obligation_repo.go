package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/operations/service/models"
)

// ObligationRepository provides data access for obligations.
type ObligationRepository interface {
	datastore.BaseRepository[*models.Obligation]
	GetByMembershipID(ctx context.Context, membershipID string) ([]*models.Obligation, error)
	GetByPeriodID(ctx context.Context, periodID string) ([]*models.Obligation, error)
	GetByCauseID(ctx context.Context, causeID string) ([]*models.Obligation, error)
}

// NewObligationRepository creates a new ObligationRepository.
func NewObligationRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) ObligationRepository {
	return &obligationRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.Obligation {
			return &models.Obligation{}
		}),
	}
}

// stateActive is the numeric value for the active state used in database queries.
const stateActive = 3

type obligationRepository struct {
	datastore.BaseRepository[*models.Obligation]
}

func (r *obligationRepository) GetByMembershipID(
	ctx context.Context,
	membershipID string,
) ([]*models.Obligation, error) {
	var obligations []*models.Obligation
	err := r.Pool().DB(ctx, true).
		Where("membership_id = ? AND state = ?", membershipID, stateActive).
		Order("deadline ASC").
		Find(&obligations).Error
	return obligations, err
}

func (r *obligationRepository) GetByPeriodID(ctx context.Context, periodID string) ([]*models.Obligation, error) {
	var obligations []*models.Obligation
	err := r.Pool().DB(ctx, true).Where("period_id = ?", periodID).Find(&obligations).Error
	return obligations, err
}

func (r *obligationRepository) GetByCauseID(ctx context.Context, causeID string) ([]*models.Obligation, error) {
	var obligations []*models.Obligation
	err := r.Pool().DB(ctx, true).Where("cause_id = ?", causeID).Find(&obligations).Error
	return obligations, err
}

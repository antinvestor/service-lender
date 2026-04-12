package repository

import (
	"context"
	"errors"
	"time"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"
	"gorm.io/gorm"

	"github.com/antinvestor/service-fintech/apps/savings/service/models"
)

type InterestAccrualRepository interface {
	datastore.BaseRepository[*models.InterestAccrual]
	// GetByAccountAndPeriod returns the accrual row for a specific closing
	// period if one exists. Used by the accrual job to detect reruns and
	// avoid double-crediting a member's interest.
	GetByAccountAndPeriod(
		ctx context.Context,
		savingsAccountID string,
		periodEnd time.Time,
	) (*models.InterestAccrual, error)
}

type interestAccrualRepository struct {
	datastore.BaseRepository[*models.InterestAccrual]
	dbPool pool.Pool
}

func NewInterestAccrualRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) InterestAccrualRepository {
	return &interestAccrualRepository{
		BaseRepository: datastore.NewBaseRepository[*models.InterestAccrual](
			ctx, dbPool, workMan, func() *models.InterestAccrual { return &models.InterestAccrual{} },
		),
		dbPool: dbPool,
	}
}

func (r *interestAccrualRepository) GetByAccountAndPeriod(
	ctx context.Context,
	savingsAccountID string,
	periodEnd time.Time,
) (*models.InterestAccrual, error) {
	entity := &models.InterestAccrual{}
	err := r.dbPool.DB(ctx, true).
		Where("savings_account_id = ? AND period_end = ?", savingsAccountID, periodEnd).
		First(entity).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return entity, nil
}

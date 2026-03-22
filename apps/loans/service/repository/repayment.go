package repository //nolint:dupl // similar patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
)

type RepaymentRepository interface {
	datastore.BaseRepository[*models.Repayment]
	GetByIdempotencyKey(ctx context.Context, key string) (*models.Repayment, error)
}

type repaymentRepository struct {
	datastore.BaseRepository[*models.Repayment]
}

func NewRepaymentRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) RepaymentRepository {
	return &repaymentRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Repayment](
			ctx, dbPool, workMan, func() *models.Repayment { return &models.Repayment{} },
		),
	}
}

func (repo *repaymentRepository) GetByIdempotencyKey(
	ctx context.Context,
	key string,
) (*models.Repayment, error) {
	repayment := models.Repayment{}
	err := repo.Pool().DB(ctx, true).
		First(&repayment, "idempotency_key = ?", key).Error
	if err != nil {
		return nil, err
	}
	return &repayment, nil
}

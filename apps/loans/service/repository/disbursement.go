package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/loans/service/models"
)

type DisbursementRepository interface {
	datastore.BaseRepository[*models.Disbursement]
	GetByIdempotencyKey(ctx context.Context, key string) (*models.Disbursement, error)
}

type disbursementRepository struct {
	entityRepository[*models.Disbursement]
}

func NewDisbursementRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) DisbursementRepository {
	return &disbursementRepository{
		entityRepository: newEntityRepository(ctx, dbPool, workMan, func() *models.Disbursement {
			return &models.Disbursement{}
		}),
	}
}

func (repo *disbursementRepository) GetByIdempotencyKey(
	ctx context.Context,
	key string,
) (*models.Disbursement, error) {
	return repo.findOneByField(ctx, "idempotency_key = ?", key)
}

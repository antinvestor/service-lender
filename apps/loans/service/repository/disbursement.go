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
	datastore.BaseRepository[*models.Disbursement]
}

func NewDisbursementRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) DisbursementRepository {
	return &disbursementRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Disbursement](
			ctx, dbPool, workMan, func() *models.Disbursement { return &models.Disbursement{} },
		),
	}
}

func (repo *disbursementRepository) GetByIdempotencyKey(
	ctx context.Context,
	key string,
) (*models.Disbursement, error) {
	disb := models.Disbursement{}
	err := repo.Pool().DB(ctx, true).
		First(&disb, "idempotency_key = ?", key).Error
	if err != nil {
		return nil, err
	}
	return &disb, nil
}

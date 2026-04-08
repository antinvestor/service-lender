package repository //nolint:dupl // similar repository patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/savings/service/models"
)

type DepositRepository interface {
	datastore.BaseRepository[*models.Deposit]
	GetByIdempotencyKey(ctx context.Context, key string) (*models.Deposit, error)
}

type depositRepository struct {
	datastore.BaseRepository[*models.Deposit]
}

func NewDepositRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) DepositRepository {
	return &depositRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Deposit](
			ctx, dbPool, workMan, func() *models.Deposit { return &models.Deposit{} },
		),
	}
}

func (repo *depositRepository) GetByIdempotencyKey(
	ctx context.Context,
	key string,
) (*models.Deposit, error) {
	deposit := models.Deposit{}
	err := repo.Pool().DB(ctx, true).
		First(&deposit, "idempotency_key = ?", key).Error
	if err != nil {
		return nil, err
	}
	return &deposit, nil
}

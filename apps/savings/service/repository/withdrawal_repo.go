package repository //nolint:dupl // similar repository patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/savings/service/models"
)

type WithdrawalRepository interface {
	datastore.BaseRepository[*models.Withdrawal]
	GetByIdempotencyKey(ctx context.Context, key string) (*models.Withdrawal, error)
}

type withdrawalRepository struct {
	datastore.BaseRepository[*models.Withdrawal]
}

func NewWithdrawalRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) WithdrawalRepository {
	return &withdrawalRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Withdrawal](
			ctx, dbPool, workMan, func() *models.Withdrawal { return &models.Withdrawal{} },
		),
	}
}

func (repo *withdrawalRepository) GetByIdempotencyKey(
	ctx context.Context,
	key string,
) (*models.Withdrawal, error) {
	withdrawal := models.Withdrawal{}
	err := repo.Pool().DB(ctx, true).
		First(&withdrawal, "idempotency_key = ?", key).Error
	if err != nil {
		return nil, err
	}
	return &withdrawal, nil
}

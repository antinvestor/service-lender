package repository //nolint:dupl // similar repository patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/savings/service/models"
)

type SavingsProductRepository interface {
	datastore.BaseRepository[*models.SavingsProduct]
	GetByCode(ctx context.Context, code string) (*models.SavingsProduct, error)
}

type savingsProductRepository struct {
	datastore.BaseRepository[*models.SavingsProduct]
}

func NewSavingsProductRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) SavingsProductRepository {
	return &savingsProductRepository{
		BaseRepository: datastore.NewBaseRepository[*models.SavingsProduct](
			ctx, dbPool, workMan, func() *models.SavingsProduct { return &models.SavingsProduct{} },
		),
	}
}

func (repo *savingsProductRepository) GetByCode(ctx context.Context, code string) (*models.SavingsProduct, error) {
	sp := models.SavingsProduct{}
	err := repo.Pool().DB(ctx, true).First(&sp, "code = ?", code).Error
	if err != nil {
		return nil, err
	}
	return &sp, nil
}

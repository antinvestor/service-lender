package repository //nolint:dupl // similar repository patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
)

type BankRepository interface {
	datastore.BaseRepository[*models.Bank]
	GetByCode(ctx context.Context, code string) (*models.Bank, error)
}

type bankRepository struct {
	datastore.BaseRepository[*models.Bank]
}

func NewBankRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) BankRepository {
	return &bankRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Bank](
			ctx, dbPool, workMan, func() *models.Bank { return &models.Bank{} },
		),
	}
}

func (repo *bankRepository) GetByCode(ctx context.Context, code string) (*models.Bank, error) {
	bank := models.Bank{}
	err := repo.Pool().DB(ctx, true).First(&bank, "code = ?", code).Error
	if err != nil {
		return nil, err
	}
	return &bank, nil
}

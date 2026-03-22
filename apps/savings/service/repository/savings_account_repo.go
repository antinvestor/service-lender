package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/savings/service/models"
)

type SavingsAccountRepository interface {
	datastore.BaseRepository[*models.SavingsAccount]
}

type savingsAccountRepository struct {
	datastore.BaseRepository[*models.SavingsAccount]
}

func NewSavingsAccountRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) SavingsAccountRepository {
	return &savingsAccountRepository{
		BaseRepository: datastore.NewBaseRepository[*models.SavingsAccount](
			ctx, dbPool, workMan, func() *models.SavingsAccount { return &models.SavingsAccount{} },
		),
	}
}

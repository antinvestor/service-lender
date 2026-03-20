package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
)

type ReconciliationRepository interface {
	datastore.BaseRepository[*models.Reconciliation]
}

type reconciliationRepository struct {
	datastore.BaseRepository[*models.Reconciliation]
}

func NewReconciliationRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) ReconciliationRepository {
	return &reconciliationRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Reconciliation](
			ctx, dbPool, workMan, func() *models.Reconciliation { return &models.Reconciliation{} },
		),
	}
}

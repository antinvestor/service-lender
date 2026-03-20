package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
)

type PenaltyRepository interface {
	datastore.BaseRepository[*models.Penalty]
}

type penaltyRepository struct {
	datastore.BaseRepository[*models.Penalty]
}

func NewPenaltyRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) PenaltyRepository {
	return &penaltyRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Penalty](
			ctx, dbPool, workMan, func() *models.Penalty { return &models.Penalty{} },
		),
	}
}

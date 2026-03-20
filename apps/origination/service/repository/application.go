package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/origination/service/models"
)

type ApplicationRepository interface {
	datastore.BaseRepository[*models.Application]
}

type applicationRepository struct {
	datastore.BaseRepository[*models.Application]
}

func NewApplicationRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) ApplicationRepository {
	return &applicationRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Application](
			ctx, dbPool, workMan, func() *models.Application { return &models.Application{} },
		),
	}
}

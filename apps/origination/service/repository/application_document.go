package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
)

type ApplicationDocumentRepository interface {
	datastore.BaseRepository[*models.ApplicationDocument]
}

type applicationDocumentRepository struct {
	datastore.BaseRepository[*models.ApplicationDocument]
}

func NewApplicationDocumentRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) ApplicationDocumentRepository {
	return &applicationDocumentRepository{
		BaseRepository: datastore.NewBaseRepository[*models.ApplicationDocument](
			ctx, dbPool, workMan, func() *models.ApplicationDocument { return &models.ApplicationDocument{} },
		),
	}
}

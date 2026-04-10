package repository

import (
	"context"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"
)

type entityRepository[P data.BaseModelI] struct {
	datastore.BaseRepository[P]
	newEntity func() P
}

func newEntityRepository[P data.BaseModelI](
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
	newEntity func() P,
) entityRepository[P] {
	return entityRepository[P]{
		BaseRepository: datastore.NewBaseRepository[P](ctx, dbPool, workMan, newEntity),
		newEntity:      newEntity,
	}
}

func (repo entityRepository[P]) findOneByField(
	ctx context.Context,
	filter string,
	value any,
) (P, error) {
	entity := repo.newEntity()
	if err := repo.Pool().DB(ctx, true).First(entity, filter, value).Error; err != nil {
		var zero P
		return zero, err
	}

	return entity, nil
}

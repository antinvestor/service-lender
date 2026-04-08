package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/group/service/models"
)

// MotionRepository provides data access for motions.
type MotionRepository interface {
	datastore.BaseRepository[*models.Motion]
}

// NewMotionRepository creates a new MotionRepository.
func NewMotionRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) MotionRepository {
	return &motionRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.Motion {
			return &models.Motion{}
		}),
	}
}

type motionRepository struct {
	datastore.BaseRepository[*models.Motion]
}

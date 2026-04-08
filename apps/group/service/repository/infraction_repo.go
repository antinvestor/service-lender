package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/group/service/models"
)

// InfractionRepository provides data access for infractions.
type InfractionRepository interface {
	datastore.BaseRepository[*models.Infraction]
}

// NewInfractionRepository creates a new InfractionRepository.
func NewInfractionRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) InfractionRepository {
	return &infractionRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.Infraction {
			return &models.Infraction{}
		}),
	}
}

type infractionRepository struct {
	datastore.BaseRepository[*models.Infraction]
}

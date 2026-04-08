package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/operations/service/models"
)

// TransferOrderRepository provides data access for transfer orders.
type TransferOrderRepository interface {
	datastore.BaseRepository[*models.TransferOrder]
}

// NewTransferOrderRepository creates a new TransferOrderRepository.
func NewTransferOrderRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) TransferOrderRepository {
	return &transferOrderRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.TransferOrder {
			return &models.TransferOrder{}
		}),
	}
}

type transferOrderRepository struct {
	datastore.BaseRepository[*models.TransferOrder]
}

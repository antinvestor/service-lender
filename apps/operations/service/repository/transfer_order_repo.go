package repository

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"
	"gorm.io/gorm"

	"github.com/antinvestor/service-fintech/apps/operations/service/models"
)

// TransferOrderRepository provides data access for transfer orders.
type TransferOrderRepository interface {
	datastore.BaseRepository[*models.TransferOrder]
	// GetByReference looks up a transfer order by its caller-supplied reference.
	// The reference is used as an idempotency key: callers must pass a stable,
	// deterministic value (e.g. "repayment:{id}:principal") and a unique index
	// enforces at-most-one row per non-empty reference.
	GetByReference(ctx context.Context, reference string) (*models.TransferOrder, error)
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
		dbPool: dbPool,
	}
}

type transferOrderRepository struct {
	datastore.BaseRepository[*models.TransferOrder]
	dbPool pool.Pool
}

func (r *transferOrderRepository) GetByReference(
	ctx context.Context,
	reference string,
) (*models.TransferOrder, error) {
	if reference == "" {
		return nil, nil
	}
	entity := &models.TransferOrder{}
	err := r.dbPool.DB(ctx, true).Where("reference = ?", reference).First(entity).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return entity, nil
}

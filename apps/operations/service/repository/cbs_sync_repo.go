package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/operations/service/models"
)

// CBSSyncRecordRepository provides data access for CBS sync records.
type CBSSyncRecordRepository interface {
	datastore.BaseRepository[*models.CBSSyncRecord]
}

// NewCBSSyncRecordRepository creates a new CBSSyncRecordRepository.
func NewCBSSyncRecordRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) CBSSyncRecordRepository {
	return &cbsSyncRecordRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.CBSSyncRecord {
			return &models.CBSSyncRecord{}
		}),
	}
}

type cbsSyncRecordRepository struct {
	datastore.BaseRepository[*models.CBSSyncRecord]
}

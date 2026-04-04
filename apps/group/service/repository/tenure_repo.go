package repository //nolint:dupl // similar patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/pkg/constants"
)

// TenureRepository provides data access for tenures.
type TenureRepository interface {
	datastore.BaseRepository[*models.Tenure]
	GetActiveByGroupID(ctx context.Context, groupID string) (*models.Tenure, error)
}

// NewTenureRepository creates a new TenureRepository.
func NewTenureRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) TenureRepository {
	return &tenureRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.Tenure {
			return &models.Tenure{}
		}),
	}
}

type tenureRepository struct {
	datastore.BaseRepository[*models.Tenure]
}

func (r *tenureRepository) GetActiveByGroupID(ctx context.Context, groupID string) (*models.Tenure, error) {
	var tenure models.Tenure
	err := r.Pool().
		DB(ctx, true).
		Where("group_id = ? AND state != ?", groupID, constants.StateDeleted).
		Order("created_at DESC").
		First(&tenure).
		Error
	return &tenure, err
}

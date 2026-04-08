package repository //nolint:dupl // similar patterns for different entity types

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/group/service/models"
	"github.com/antinvestor/service-fintech/pkg/constants"
)

// PeriodRepository provides data access for periods.
type PeriodRepository interface {
	datastore.BaseRepository[*models.Period]
	GetCurrentByGroupID(ctx context.Context, groupID string) (*models.Period, error)
}

// NewPeriodRepository creates a new PeriodRepository.
func NewPeriodRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) PeriodRepository {
	return &periodRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.Period {
			return &models.Period{}
		}),
	}
}

type periodRepository struct {
	datastore.BaseRepository[*models.Period]
}

func (r *periodRepository) GetCurrentByGroupID(ctx context.Context, groupID string) (*models.Period, error) {
	var period models.Period
	err := r.Pool().
		DB(ctx, true).
		Where("group_id = ? AND state != ?", groupID, constants.StateDeleted).
		Order("created_at DESC").
		First(&period).
		Error
	return &period, err
}

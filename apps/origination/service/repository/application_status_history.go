package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/origination/service/models"
)

type ApplicationStatusHistoryRepository interface {
	datastore.BaseRepository[*models.ApplicationStatusHistory]
	GetByApplicationID(ctx context.Context, applicationID string) ([]*models.ApplicationStatusHistory, error)
}

type applicationStatusHistoryRepository struct {
	datastore.BaseRepository[*models.ApplicationStatusHistory]
}

func NewApplicationStatusHistoryRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) ApplicationStatusHistoryRepository {
	return &applicationStatusHistoryRepository{
		BaseRepository: datastore.NewBaseRepository[*models.ApplicationStatusHistory](
			ctx,
			dbPool,
			workMan,
			func() *models.ApplicationStatusHistory { return &models.ApplicationStatusHistory{} },
		),
	}
}

func (repo *applicationStatusHistoryRepository) GetByApplicationID(
	ctx context.Context,
	applicationID string,
) ([]*models.ApplicationStatusHistory, error) {
	var history []*models.ApplicationStatusHistory
	err := repo.Pool().DB(ctx, true).
		Where("application_id = ?", applicationID).
		Order("created_at DESC").
		Find(&history).Error
	if err != nil {
		return nil, err
	}
	return history, nil
}

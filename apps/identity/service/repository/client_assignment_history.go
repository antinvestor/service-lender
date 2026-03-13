package repository

import (
	"context"

	"github.com/antinvestor/service-ant-lender/apps/identity/service/models"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"
)

type ClientAssignmentHistoryRepository interface {
	datastore.BaseRepository[*models.ClientAssignmentHistory]
	GetByClientID(ctx context.Context, clientID string) ([]*models.ClientAssignmentHistory, error)
}

type clientAssignmentHistoryRepository struct {
	datastore.BaseRepository[*models.ClientAssignmentHistory]
}

func NewClientAssignmentHistoryRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) ClientAssignmentHistoryRepository {
	return &clientAssignmentHistoryRepository{
		BaseRepository: datastore.NewBaseRepository[*models.ClientAssignmentHistory](
			ctx, dbPool, workMan, func() *models.ClientAssignmentHistory { return &models.ClientAssignmentHistory{} },
		),
	}
}

func (repo *clientAssignmentHistoryRepository) GetByClientID(ctx context.Context, clientID string) ([]*models.ClientAssignmentHistory, error) {
	var history []*models.ClientAssignmentHistory
	err := repo.Pool().DB(ctx, true).
		Where("client_id = ?", clientID).
		Order("created_at DESC").
		Find(&history).Error
	if err != nil {
		return nil, err
	}
	return history, nil
}

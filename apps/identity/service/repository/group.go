package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type ClientGroupRepository interface {
	datastore.BaseRepository[*models.ClientGroup]
	GetByAgentID(ctx context.Context, agentID string, offset, limit int) ([]*models.ClientGroup, error)
}

type clientGroupRepository struct {
	datastore.BaseRepository[*models.ClientGroup]
}

func NewClientGroupRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) ClientGroupRepository {
	return &clientGroupRepository{
		BaseRepository: datastore.NewBaseRepository[*models.ClientGroup](
			ctx, dbPool, workMan, func() *models.ClientGroup { return &models.ClientGroup{} },
		),
	}
}

func (repo *clientGroupRepository) GetByAgentID(
	ctx context.Context,
	agentID string,
	offset, limit int,
) ([]*models.ClientGroup, error) {
	var groups []*models.ClientGroup
	err := repo.Pool().DB(ctx, true).
		Where("agent_id = ?", agentID).
		Offset(offset).Limit(limit).
		Find(&groups).Error
	if err != nil {
		return nil, err
	}
	return groups, nil
}

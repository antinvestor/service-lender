package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type GroupRepository interface {
	datastore.BaseRepository[*models.Group]
	GetByAgentID(ctx context.Context, agentID string, offset, limit int) ([]*models.Group, error)
}

type groupRepository struct {
	datastore.BaseRepository[*models.Group]
}

func NewGroupRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) GroupRepository {
	return &groupRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Group](
			ctx, dbPool, workMan, func() *models.Group { return &models.Group{} },
		),
	}
}

func (repo *groupRepository) GetByAgentID(
	ctx context.Context,
	agentID string,
	offset, limit int,
) ([]*models.Group, error) {
	var groups []*models.Group
	err := repo.Pool().DB(ctx, true).
		Where("agent_id = ?", agentID).
		Offset(offset).Limit(limit).
		Find(&groups).Error
	if err != nil {
		return nil, err
	}
	return groups, nil
}

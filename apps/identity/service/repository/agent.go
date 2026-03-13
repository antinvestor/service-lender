package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
)

type AgentRepository interface {
	datastore.BaseRepository[*models.Agent]
	GetByBranchID(ctx context.Context, branchID string, offset, limit int) ([]*models.Agent, error)
	GetByParentAgentID(ctx context.Context, parentAgentID string, offset, limit int) ([]*models.Agent, error)
	GetByProfileID(ctx context.Context, profileID string) (*models.Agent, error)
	GetDescendants(ctx context.Context, agentID string, maxDepth int) ([]*models.Agent, error)
}

type agentRepository struct {
	datastore.BaseRepository[*models.Agent]
}

func NewAgentRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) AgentRepository {
	return &agentRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Agent](
			ctx, dbPool, workMan, func() *models.Agent { return &models.Agent{} },
		),
	}
}

func (repo *agentRepository) GetByBranchID(
	ctx context.Context,
	branchID string,
	offset, limit int,
) ([]*models.Agent, error) {
	var agents []*models.Agent
	err := repo.Pool().DB(ctx, true).
		Where("branch_id = ?", branchID).
		Offset(offset).Limit(limit).
		Find(&agents).Error
	if err != nil {
		return nil, err
	}
	return agents, nil
}

func (repo *agentRepository) GetByParentAgentID(
	ctx context.Context,
	parentAgentID string,
	offset, limit int,
) ([]*models.Agent, error) {
	var agents []*models.Agent
	err := repo.Pool().DB(ctx, true).
		Where("parent_agent_id = ?", parentAgentID).
		Offset(offset).Limit(limit).
		Find(&agents).Error
	if err != nil {
		return nil, err
	}
	return agents, nil
}

func (repo *agentRepository) GetByProfileID(ctx context.Context, profileID string) (*models.Agent, error) {
	agent := models.Agent{}
	err := repo.Pool().DB(ctx, true).First(&agent, "profile_id = ?", profileID).Error
	if err != nil {
		return nil, err
	}
	return &agent, nil
}

// GetDescendants returns all descendants of the given agent using a recursive CTE.
// If maxDepth is 0, all descendants are returned regardless of depth.
func (repo *agentRepository) GetDescendants(
	ctx context.Context,
	agentID string,
	maxDepth int,
) ([]*models.Agent, error) {
	var agents []*models.Agent

	query := `
		WITH RECURSIVE agent_tree AS (
			SELECT *, 0 AS level FROM agents WHERE id = ?
			UNION ALL
			SELECT a.*, t.level + 1 FROM agents a
			JOIN agent_tree t ON a.parent_agent_id = t.id
			WHERE (? = 0 OR t.level < ?)
		)
		SELECT * FROM agent_tree WHERE id != ?
	`

	err := repo.Pool().DB(ctx, true).
		Raw(query, agentID, maxDepth, maxDepth, agentID).
		Scan(&agents).Error
	if err != nil {
		return nil, err
	}
	return agents, nil
}

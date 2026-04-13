package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type ClientRepository interface {
	datastore.BaseRepository[*models.Client]
	GetByAgentID(ctx context.Context, agentID string, offset, limit int) ([]*models.Client, error)
	GetByOwningTeamID(ctx context.Context, teamID string, offset, limit int) ([]*models.Client, error)
	GetByProfileID(ctx context.Context, profileID string) (*models.Client, error)
}

type clientRepository struct {
	datastore.BaseRepository[*models.Client]
}

func NewClientRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) ClientRepository {
	return &clientRepository{
		BaseRepository: datastore.NewBaseRepository[*models.Client](
			ctx, dbPool, workMan, func() *models.Client { return &models.Client{} },
		),
	}
}

func (repo *clientRepository) GetByAgentID(
	ctx context.Context,
	agentID string,
	offset, limit int,
) ([]*models.Client, error) {
	var clients []*models.Client
	err := repo.Pool().DB(ctx, true).
		Where("agent_id = ?", agentID).
		Offset(offset).Limit(limit).
		Find(&clients).Error
	if err != nil {
		return nil, err
	}
	return clients, nil
}

func (repo *clientRepository) GetByOwningTeamID(
	ctx context.Context,
	teamID string,
	offset, limit int,
) ([]*models.Client, error) {
	var clients []*models.Client
	err := repo.Pool().DB(ctx, true).
		Where("owning_team_id = ?", teamID).
		Offset(offset).Limit(limit).
		Find(&clients).Error
	if err != nil {
		return nil, err
	}
	return clients, nil
}

func (repo *clientRepository) GetByProfileID(ctx context.Context, profileID string) (*models.Client, error) {
	client := models.Client{}
	err := repo.Pool().DB(ctx, true).First(&client, "profile_id = ?", profileID).Error
	if err != nil {
		return nil, err
	}
	return &client, nil
}

type ClientResponsibilityHistoryRepository interface {
	datastore.BaseRepository[*models.ClientResponsibilityHistory]
}

type clientResponsibilityHistoryRepository struct {
	datastore.BaseRepository[*models.ClientResponsibilityHistory]
}

func NewClientResponsibilityHistoryRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) ClientResponsibilityHistoryRepository {
	return &clientResponsibilityHistoryRepository{
		BaseRepository: datastore.NewBaseRepository[*models.ClientResponsibilityHistory](
			ctx,
			dbPool,
			workMan,
			func() *models.ClientResponsibilityHistory { return &models.ClientResponsibilityHistory{} },
		),
	}
}

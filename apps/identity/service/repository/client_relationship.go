package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type ClientRelationshipRepository interface {
	datastore.BaseRepository[*models.ClientRelationship]
	GetByClientAndMember(ctx context.Context, clientID, memberID string) (*models.ClientRelationship, error)
	GetPrimaryForClient(ctx context.Context, clientID string) (*models.ClientRelationship, error)
}

type clientRelationshipRepository struct {
	datastore.BaseRepository[*models.ClientRelationship]
}

func NewClientRelationshipRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) ClientRelationshipRepository {
	return &clientRelationshipRepository{
		BaseRepository: datastore.NewBaseRepository[*models.ClientRelationship](
			ctx, dbPool, workMan, func() *models.ClientRelationship { return &models.ClientRelationship{} },
		),
	}
}

func (repo *clientRelationshipRepository) GetByClientAndMember(
	ctx context.Context,
	clientID, memberID string,
) (*models.ClientRelationship, error) {
	cr := models.ClientRelationship{}
	err := repo.Pool().DB(ctx, true).
		First(&cr, "client_id = ? AND member_id = ?", clientID, memberID).Error
	if err != nil {
		return nil, err
	}
	return &cr, nil
}

func (repo *clientRelationshipRepository) GetPrimaryForClient(
	ctx context.Context,
	clientID string,
) (*models.ClientRelationship, error) {
	cr := models.ClientRelationship{}
	err := repo.Pool().DB(ctx, true).
		First(&cr, "client_id = ? AND is_primary = true", clientID).Error
	if err != nil {
		return nil, err
	}
	return &cr, nil
}

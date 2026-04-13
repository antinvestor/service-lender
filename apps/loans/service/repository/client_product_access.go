package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/loans/service/models"
)

type ClientProductAccessRepository interface {
	datastore.BaseRepository[*models.ClientProductAccess]
	GetByClientAndProduct(ctx context.Context, clientID, productID string) (*models.ClientProductAccess, error)
}

type clientProductAccessRepository struct {
	datastore.BaseRepository[*models.ClientProductAccess]
}

func NewClientProductAccessRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) ClientProductAccessRepository {
	return &clientProductAccessRepository{
		BaseRepository: datastore.NewBaseRepository[*models.ClientProductAccess](
			ctx, dbPool, workMan, func() *models.ClientProductAccess { return &models.ClientProductAccess{} },
		),
	}
}

func (repo *clientProductAccessRepository) GetByClientAndProduct(
	ctx context.Context,
	clientID, productID string,
) (*models.ClientProductAccess, error) {
	cpa := models.ClientProductAccess{}
	err := repo.Pool().DB(ctx, true).
		First(&cpa, "client_id = ? AND product_id = ?", clientID, productID).Error
	if err != nil {
		return nil, err
	}
	return &cpa, nil
}

package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
)

type ClientProductAccessRepository interface {
	datastore.BaseRepository[*models.ClientProductAccess]
	GetByClientID(ctx context.Context, clientID string) ([]*models.ClientProductAccess, error)
	HasAccess(ctx context.Context, clientID, productID string) (bool, error)
}

// stateActive is the numeric value for the active state used in database queries.
const stateActive = 3

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

func (r *clientProductAccessRepository) GetByClientID(
	ctx context.Context,
	clientID string,
) ([]*models.ClientProductAccess, error) {
	var records []*models.ClientProductAccess
	err := r.Pool().DB(ctx, true).
		Where("client_id = ? AND state = ?", clientID, stateActive).
		Find(&records).Error
	return records, err
}

// HasAccess returns true if the client is allowed to apply for the given product.
// If the client has NO access records at all, they have unrestricted access (returns true).
// If access records exist, the product must be among them.
func (r *clientProductAccessRepository) HasAccess(ctx context.Context, clientID, productID string) (bool, error) {
	var totalCount int64
	err := r.Pool().DB(ctx, true).
		Model(&models.ClientProductAccess{}).
		Where("client_id = ? AND state = ?", clientID, stateActive).
		Count(&totalCount).Error
	if err != nil {
		return false, err
	}

	// No access records = unrestricted access
	if totalCount == 0 {
		return true, nil
	}

	// Check if the specific product is in the access list
	var matchCount int64
	err = r.Pool().DB(ctx, true).
		Model(&models.ClientProductAccess{}).
		Where("client_id = ? AND product_id = ? AND state = ?", clientID, productID, stateActive).
		Count(&matchCount).Error
	if err != nil {
		return false, err
	}

	return matchCount > 0, nil
}

package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/stawi/service/models"
)

// CustomerGroupRepository provides data access for customer groups.
type CustomerGroupRepository interface {
	datastore.BaseRepository[*models.CustomerGroup]
}

// NewCustomerGroupRepository creates a new CustomerGroupRepository.
func NewCustomerGroupRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) CustomerGroupRepository {
	return &customerGroupRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.CustomerGroup {
			return &models.CustomerGroup{}
		}),
	}
}

type customerGroupRepository struct {
	datastore.BaseRepository[*models.CustomerGroup]
}

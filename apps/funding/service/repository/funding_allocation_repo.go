package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
)

// FundingAllocationRepository provides data access for funding allocations.
type FundingAllocationRepository interface {
	datastore.BaseRepository[*models.FundingAllocation]
}

// NewFundingAllocationRepository creates a new FundingAllocationRepository.
func NewFundingAllocationRepository(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
) FundingAllocationRepository {
	return &fundingAllocationRepository{
		BaseRepository: datastore.NewBaseRepository(ctx, dbPool, workMan, func() *models.FundingAllocation {
			return &models.FundingAllocation{}
		}),
	}
}

type fundingAllocationRepository struct {
	datastore.BaseRepository[*models.FundingAllocation]
}

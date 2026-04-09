package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
)

// Migrate runs database migrations for all funding models.
func Migrate(ctx context.Context, dbManager datastore.Manager, migrationsDirPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	return migratePool(ctx, dbPool, migrationsDirPath)
}

func migratePool(ctx context.Context, dbPool pool.Pool, migrationsDirPath string) error {
	return dbPool.Migrate(ctx, migrationsDirPath,
		&models.LoanFunding{},
		&models.FundingAllocation{},
		&models.InvestorAccount{},
		&models.FundingTranche{},
	)
}

package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"

	"github.com/antinvestor/service-fintech/apps/operations/service/models"
)

// Migrate runs database migrations for all operations models.
func Migrate(ctx context.Context, dbManager datastore.Manager, migrationsDirPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	return migratePool(ctx, dbPool, migrationsDirPath)
}

func migratePool(ctx context.Context, dbPool pool.Pool, migrationsDirPath string) error {
	return dbPool.Migrate(ctx, migrationsDirPath,
		&models.TransferOrder{},
		&models.Obligation{},
		&models.IncomingPayment{},
		&models.AccountRef{},
		&models.LedgerRef{},
		&models.CBSSyncRecord{},
		&models.PayBack{},
		&models.TransactionCost{},
		&models.ServiceFee{},
	)
}

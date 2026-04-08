package repository

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/datastore"

	"github.com/antinvestor/service-fintech/apps/savings/service/models"
)

func Migrate(ctx context.Context, dbManager datastore.Manager, migrationPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultMigrationPoolName)
	if dbPool == nil {
		return errors.New("datastore pool is not initialised")
	}

	return dbManager.Migrate(ctx, dbPool, migrationPath,
		&models.SavingsProduct{}, &models.SavingsAccount{}, &models.Deposit{},
		&models.Withdrawal{}, &models.InterestAccrual{})
}

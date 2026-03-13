package repository

import (
	"context"
	"errors"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/pitabwire/frame/datastore"
)

func Migrate(ctx context.Context, dbManager datastore.Manager, migrationPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultMigrationPoolName)
	if dbPool == nil {
		return errors.New("datastore pool is not initialised")
	}

	return dbManager.Migrate(ctx, dbPool, migrationPath,
		&models.Bank{}, &models.Branch{}, &models.Agent{},
		&models.Borrower{}, &models.BorrowerAssignmentHistory{},
		&models.Investor{}, &models.SystemUser{})
}

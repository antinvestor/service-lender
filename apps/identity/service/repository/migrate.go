package repository

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/datastore"

	"github.com/antinvestor/service-lender/apps/identity/service/models"
)

func Migrate(ctx context.Context, dbManager datastore.Manager, migrationPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultMigrationPoolName)
	if dbPool == nil {
		return errors.New("datastore pool is not initialised")
	}

	return dbManager.Migrate(ctx, dbPool, migrationPath,
		&models.Organization{}, &models.Branch{}, &models.Agent{},
		&models.Client{}, &models.ClientAssignmentHistory{}, &models.CreditLimitChangeRequest{},
		&models.Group{}, &models.Membership{},
		&models.Investor{}, &models.SystemUser{})
}

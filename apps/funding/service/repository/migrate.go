package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
)

// Migrate runs database migrations for all funding models.
func Migrate(ctx context.Context, dbManager datastore.Manager, migrationsDirPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	return migratePool(ctx, dbPool, migrationsDirPath)
}

func migratePool(ctx context.Context, dbPool pool.Pool, migrationsDirPath string) error {
	if db := dbPool.DB(ctx, false); db != nil {
		migrator := db.Migrator()
		if migrator.HasTable("loan_fundings") && migrator.HasColumn(&models.LoanFunding{}, "loan_offer_id") &&
			!migrator.HasColumn(&models.LoanFunding{}, "loan_request_id") {
			util.Log(ctx).Info("preMigrate -- renaming loan_fundings.loan_offer_id to loan_request_id")
			if err := db.Exec(
				"ALTER TABLE loan_fundings RENAME COLUMN loan_offer_id TO loan_request_id",
			).Error; err != nil {
				return err
			}
		}
	}

	return dbPool.Migrate(ctx, migrationsDirPath,
		&models.LoanFunding{},
		&models.FundingAllocation{},
		&models.InvestorAccount{},
		&models.FundingTranche{},
	)
}

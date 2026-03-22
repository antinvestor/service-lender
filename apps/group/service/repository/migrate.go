package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"

	"github.com/antinvestor/service-lender/apps/group/service/models"
)

// Migrate runs database migrations for all group models.
func Migrate(ctx context.Context, dbManager datastore.Manager, migrationsDirPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	return migratePool(ctx, dbPool, migrationsDirPath)
}

func migratePool(ctx context.Context, dbPool pool.Pool, migrationsDirPath string) error {
	return dbPool.Migrate(ctx, migrationsDirPath,
		&models.CustomerGroup{},
		&models.Membership{},
		&models.Tenure{},
		&models.Period{},
		&models.Motion{},
		&models.MotionVote{},
		&models.Infraction{},
		&models.GroupWarning{},
		&models.MemberScore{},
		&models.Occurrence{},
		&models.Report{},
		&models.ReportRecipient{},
		&models.RequestLog{},
	)
}

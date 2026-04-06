package repository

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/datastore"

	"github.com/antinvestor/service-lender/apps/loans/service/models"
	opsmodels "github.com/antinvestor/service-lender/apps/operations/service/models"
)

func Migrate(ctx context.Context, dbManager datastore.Manager, migrationPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultMigrationPoolName)
	if dbPool == nil {
		return errors.New("datastore pool is not initialised")
	}

	return dbManager.Migrate(ctx, dbPool, migrationPath,
		&models.LoanProduct{},
		&models.LoanAccount{},
		&models.RepaymentSchedule{},
		&models.ScheduleEntry{},
		&models.LoanBalance{},
		&models.Repayment{},
		&models.Penalty{},
		&models.LoanRestructure{},
		&models.LoanStatusChange{},
		&models.Reconciliation{},
		&opsmodels.TransferOrder{},
	)
}

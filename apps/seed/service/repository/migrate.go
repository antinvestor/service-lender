package repository

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/datastore"

	"github.com/antinvestor/service-fintech/apps/seed/service/models"
	"github.com/antinvestor/service-fintech/pkg/audit"
)

// Migrate runs GORM auto-migration for every seed model plus the shared
// audit_events table. Seed shares the platform postgres instance with
// the other fintech services, so the migration is additive and cannot
// conflict with existing tables.
func Migrate(ctx context.Context, dbManager datastore.Manager, migrationPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		return errors.New("datastore pool is not initialised")
	}

	return dbManager.Migrate(ctx, dbPool, migrationPath,
		&models.CreditProfile{},
		&models.CreditTierConfig{},
		&models.LoanRequest{},
		&audit.Event{},
	)
}

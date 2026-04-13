package repository

import (
	"context"
	"errors"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

func Migrate(ctx context.Context, dbManager datastore.Manager, migrationPath string) error {
	dbPool := dbManager.GetPool(ctx, datastore.DefaultMigrationPoolName)
	if dbPool == nil {
		return errors.New("datastore pool is not initialised")
	}

	// Run pre-migrations before AutoMigrate to handle table renames
	if err := preMigrate(ctx, dbPool); err != nil {
		util.Log(ctx).WithError(err).Warn("preMigrate -- non-fatal pre-migration issue")
	}

	return dbManager.Migrate(ctx, dbPool, migrationPath,
		&models.Organization{}, &models.Branch{}, &models.Agent{}, &models.AgentBranch{},
		&models.Client{}, &models.ClientAssignmentHistory{}, &models.CreditLimitChangeRequest{},
		&models.ApprovalCase{},
		&models.ClientGroup{}, &models.Membership{},
		&models.Investor{}, &models.SystemUser{},
		&models.ClientDataEntry{}, &models.ClientDataEntryHistory{})
}

// preMigrate handles structural changes that must happen before GORM AutoMigrate.
// Currently renames the 'banks' table to 'organizations' and updates foreign key columns.
func preMigrate(ctx context.Context, dbPool pool.Pool) error {
	db := dbPool.DB(ctx, false)
	if db == nil {
		return nil
	}

	migrator := db.Migrator()

	// Rename banks → organizations if the old table exists
	if migrator.HasTable("banks") && !migrator.HasTable("organizations") {
		util.Log(ctx).Info("preMigrate -- renaming 'banks' table to 'organizations'")
		if err := db.Exec("ALTER TABLE banks RENAME TO organizations").Error; err != nil {
			return err
		}

		// Rename indexes
		safeRenameIndex(db, "organizations", "uq_bank_code", "uq_organization_code")
	}

	// Rename branches → org_units before AutoMigrate so the canonical hierarchy table is used.
	if migrator.HasTable("branches") && !migrator.HasTable("org_units") {
		util.Log(ctx).Info("preMigrate -- renaming 'branches' table to 'org_units'")
		if err := db.Exec("ALTER TABLE branches RENAME TO org_units").Error; err != nil {
			return err
		}

		safeRenameIndex(db, "org_units", "idx_branch_organization", "idx_branch_organization")
		safeRenameIndex(db, "org_units", "uq_branch_code", "uq_branch_code")
	}

	// Rename bank_id → organization_id in org_units if the old column exists.
	if migrator.HasTable("org_units") && migrator.HasColumn(&models.Branch{}, "bank_id") {
		util.Log(ctx).Info("preMigrate -- renaming 'bank_id' to 'organization_id' in org_units")
		if err := db.Exec("ALTER TABLE org_units RENAME COLUMN bank_id TO organization_id").Error; err != nil {
			return err
		}

		safeRenameIndex(db, "org_units", "idx_branch_bank", "idx_branch_organization")
	}

	// Add organization_type column if it doesn't exist on organizations table
	if migrator.HasTable("organizations") && !migrator.HasColumn(&models.Organization{}, "organization_type") {
		util.Log(ctx).Info("preMigrate -- adding 'organization_type' column to organizations")
		if err := db.Exec(
			"ALTER TABLE organizations ADD COLUMN IF NOT EXISTS organization_type integer DEFAULT 0",
		).Error; err != nil {
			return err
		}
	}

	// Rename groups → client_groups if the old table exists
	if migrator.HasTable("groups") && !migrator.HasTable("client_groups") {
		util.Log(ctx).Info("preMigrate -- renaming 'groups' table to 'client_groups'")
		if err := db.Exec("ALTER TABLE groups RENAME TO client_groups").Error; err != nil {
			return err
		}
	}

	return nil
}

func safeRenameIndex(db *gorm.DB, _, oldName, newName string) {
	// PostgreSQL syntax for renaming indexes
	db.Exec("ALTER INDEX IF EXISTS " + oldName + " RENAME TO " + newName)
}

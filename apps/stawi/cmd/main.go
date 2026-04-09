package main

import (
	"context"
	"net/http"

	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/config"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/util"

	aconfig "github.com/antinvestor/service-fintech/apps/stawi/config"

	// Group domain
	groupbusiness "github.com/antinvestor/service-fintech/apps/stawi/service/business"
	groupevents "github.com/antinvestor/service-fintech/apps/stawi/service/events"
	"github.com/antinvestor/service-fintech/apps/stawi/service/handlers"
	grouprepo "github.com/antinvestor/service-fintech/apps/stawi/service/repository"

	// Funding domain
	fundingbusiness "github.com/antinvestor/service-fintech/apps/funding/service/business"
	fundingevents "github.com/antinvestor/service-fintech/apps/funding/service/events"
	fundingrepo "github.com/antinvestor/service-fintech/apps/funding/service/repository"

	// Operations domain
	opsbusiness "github.com/antinvestor/service-fintech/apps/operations/service/business"
	opsevents "github.com/antinvestor/service-fintech/apps/operations/service/events"
	opsrepo "github.com/antinvestor/service-fintech/apps/operations/service/repository"

	// Platform clients
	"github.com/antinvestor/service-fintech/pkg/clients"
)

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.StawiConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_stawi"
	}

	ctx, svc := frame.NewServiceWithContext(
		tmpCtx,
		frame.WithConfig(&cfg),
		frame.WithDatastore(),
	)
	defer svc.Stop(ctx)
	log := util.Log(ctx)

	dbManager := svc.DatastoreManager()
	workMan := svc.WorkManager()
	evtsMan := svc.EventsManager()

	// Handle database migration if requested (group domain only — funding and operations migrate independently)
	if handleDatabaseMigration(ctx, dbManager, cfg) {
		return
	}

	// Get database pool
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		log.Error("Database pool is nil - check DATABASE_PRIMARY_URL environment variable")
		return
	}

	// --- Platform clients ---
	platformClients, pcErr := clients.NewPlatformClients(ctx, &cfg, cfg.ServiceEndpoints())
	if pcErr != nil {
		log.WithError(pcErr).Warn("main -- Some platform clients could not be initialised")
	}

	// --- Group repositories ---
	grpRepo := grouprepo.NewCustomerGroupRepository(ctx, dbPool, workMan)
	memRepo := grouprepo.NewMembershipRepository(ctx, dbPool, workMan)
	tenRepo := grouprepo.NewTenureRepository(ctx, dbPool, workMan)
	perRepo := grouprepo.NewPeriodRepository(ctx, dbPool, workMan)
	motRepo := grouprepo.NewMotionRepository(ctx, dbPool, workMan)
	infRepo := grouprepo.NewInfractionRepository(ctx, dbPool, workMan)

	// --- Funding repositories (needed by workflow callbacks) ---
	lwRepo := fundingrepo.NewLoanWindowRepository(ctx, dbPool, workMan)
	loRepo := fundingrepo.NewLoanOfferRepository(ctx, dbPool, workMan)
	lfRepo := fundingrepo.NewLoanFundingRepository(ctx, dbPool, workMan)
	faRepo := fundingrepo.NewFundingAllocationRepository(ctx, dbPool, workMan)
	ftRepo := fundingrepo.NewFundingTrancheRepository(ctx, dbPool, workMan)
	iaRepo := fundingrepo.NewInvestorAccountRepository(ctx, dbPool, workMan)

	// --- Operations repositories (needed by workflow callbacks) ---
	toRepo := opsrepo.NewTransferOrderRepository(ctx, dbPool, workMan)
	obRepo := opsrepo.NewObligationRepository(ctx, dbPool, workMan)
	ipRepo := opsrepo.NewIncomingPaymentRepository(ctx, dbPool, workMan)
	arRepo := opsrepo.NewAccountRefRepository(ctx, dbPool, workMan)
	csRepo := opsrepo.NewCBSSyncRecordRepository(ctx, dbPool, workMan)

	// --- Group business ---
	grpBiz := groupbusiness.NewGroupBusiness(ctx, evtsMan, grpRepo, memRepo, platformClients)
	memBiz := groupbusiness.NewMembershipBusiness(ctx, evtsMan, memRepo, platformClients)
	tenBiz := groupbusiness.NewTenureBusiness(ctx, evtsMan, grpRepo, tenRepo, perRepo)
	perBiz := groupbusiness.NewPeriodBusiness(ctx, evtsMan, tenRepo, perRepo)
	_ = groupbusiness.NewMotionBusiness(ctx, evtsMan, motRepo)

	// --- Funding business (for workflow callbacks) ---
	lwBiz := fundingbusiness.NewLoanWindowBusiness(ctx, evtsMan, lwRepo)
	loBiz := fundingbusiness.NewLoanOfferBusiness(ctx, evtsMan, loRepo, lwRepo, memRepo, platformClients)
	lfBiz := fundingbusiness.NewFundingAllocationBusiness(
		ctx,
		evtsMan,
		lfRepo,
		faRepo,
		loRepo,
		iaRepo,
		ftRepo,
		platformClients,
	)

	// --- Operations business (for workflow callbacks) ---
	prBiz := opsbusiness.NewPaymentRoutingBusiness(
		ctx,
		evtsMan,
		ipRepo,
		toRepo,
		obRepo,
		arRepo,
		memRepo,
		platformClients,
	)
	toBiz := opsbusiness.NewTransferOrderBusiness(
		ctx,
		evtsMan,
		toRepo,
		csRepo,
		arRepo,
		lfRepo,
		ftRepo,
		iaRepo,
		platformClients,
	)
	obBiz := opsbusiness.NewObligationBusiness(ctx, evtsMan, obRepo, memRepo, grpRepo, perRepo)

	// --- HTTP mux with workflow callbacks only ---
	mux := http.NewServeMux()
	handlers.RegisterWorkflowCallbacks(mux, grpBiz, memBiz, tenBiz, perBiz,
		lwBiz, loBiz, lfBiz, prBiz, toBiz, obBiz, platformClients)

	// --- Assemble service options ---
	serviceOptions := []frame.Option{
		frame.WithHTTPHandler(mux),
		frame.WithRegisterEvents(
			// Group events
			groupevents.NewCustomerGroupSave(ctx, grpRepo),
			groupevents.NewMembershipSave(ctx, memRepo),
			groupevents.NewTenureSave(ctx, tenRepo),
			groupevents.NewPeriodSave(ctx, perRepo),
			groupevents.NewMotionSave(ctx, motRepo),
			groupevents.NewInfractionSave(ctx, infRepo),
			// Funding events
			fundingevents.NewLoanWindowSave(ctx, lwRepo),
			fundingevents.NewLoanOfferSave(ctx, loRepo),
			fundingevents.NewLoanFundingSave(ctx, lfRepo),
			fundingevents.NewFundingAllocationSave(ctx, faRepo),
			fundingevents.NewFundingTrancheSave(ctx, ftRepo),
			fundingevents.NewInvestorAccountSave(ctx, iaRepo),
			// Operations events
			opsevents.NewTransferOrderSave(ctx, toRepo),
			opsevents.NewObligationSave(ctx, obRepo),
			opsevents.NewIncomingPaymentSave(ctx, ipRepo),
			opsevents.NewAccountRefSave(ctx, arRepo),
			opsevents.NewCBSSyncRecordSave(ctx, csRepo),
		),
	}

	svc.Init(ctx, serviceOptions...)

	err = svc.Run(ctx, "")
	if err != nil {
		log.WithError(err).Fatal("could not run Server")
	}
}

func handleDatabaseMigration(
	ctx context.Context,
	dbManager datastore.Manager,
	cfg aconfig.StawiConfig,
) bool {
	if cfg.DoDatabaseMigrate() {
		migrationPath := cfg.GetDatabaseMigrationPath()

		if err := grouprepo.Migrate(ctx, dbManager, migrationPath); err != nil {
			util.Log(ctx).WithError(err).Fatal("main -- Could not migrate group tables")
		}

		return true
	}
	return false
}

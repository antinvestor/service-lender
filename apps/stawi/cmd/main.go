package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	"github.com/antinvestor/common"
	"github.com/antinvestor/common/connection"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/config"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/util"

	aconfig "github.com/antinvestor/service-fintech/apps/stawi/config"

	// Identity repos (still needed by funding/operations business within workflow callbacks)
	identityrepo "github.com/antinvestor/service-fintech/apps/identity/service/repository"

	// Stawi domain (Tenure, Period, Motion, Infraction)
	stawibusiness "github.com/antinvestor/service-fintech/apps/stawi/service/business"
	stawievents "github.com/antinvestor/service-fintech/apps/stawi/service/events"
	"github.com/antinvestor/service-fintech/apps/stawi/service/handlers"
	stawirepo "github.com/antinvestor/service-fintech/apps/stawi/service/repository"

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

	// Handle database migration if requested (stawi domain only)
	if handleDatabaseMigration(ctx, dbManager, cfg) {
		return
	}

	// Get database pool
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		log.Error("Database pool is nil - check DATABASE_PRIMARY_URL environment variable")
		return
	}

	// --- Identity SDK client (for ClientGroup + Membership) ---
	identityCli, idErr := setupIdentityClient(ctx, cfg)
	if idErr != nil {
		log.WithError(idErr).Warn("main -- Could not setup identity client")
	}

	// --- Platform clients ---
	platformClients, pcErr := clients.NewPlatformClients(ctx, &cfg, cfg.ServiceEndpoints())
	if pcErr != nil {
		log.WithError(pcErr).Warn("main -- Some platform clients could not be initialised")
	}

	// --- Stawi repositories (Tenure, Period, Motion, Infraction) ---
	tenRepo := stawirepo.NewTenureRepository(ctx, dbPool, workMan)
	perRepo := stawirepo.NewPeriodRepository(ctx, dbPool, workMan)
	motRepo := stawirepo.NewMotionRepository(ctx, dbPool, workMan)
	infRepo := stawirepo.NewInfractionRepository(ctx, dbPool, workMan)

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

	// --- Stawi business (uses identity SDK for group/membership) ---
	grpBiz := stawibusiness.NewClientGroupBusiness(ctx, identityCli, platformClients)
	memBiz := stawibusiness.NewMembershipBusiness(ctx, identityCli)
	tenBiz := stawibusiness.NewTenureBusiness(ctx, evtsMan, identityCli, tenRepo, perRepo)
	perBiz := stawibusiness.NewPeriodBusiness(ctx, evtsMan, tenRepo, perRepo)
	_ = stawibusiness.NewMotionBusiness(ctx, evtsMan, motRepo)

	// --- Identity repos (still needed by funding/operations business for workflow callbacks) ---
	identityMemRepo := identityrepo.NewMembershipRepository(ctx, dbPool, workMan)
	identityGrpRepo := identityrepo.NewClientGroupRepository(ctx, dbPool, workMan)

	// --- Funding business (for workflow callbacks) ---
	lwBiz := fundingbusiness.NewLoanWindowBusiness(ctx, evtsMan, lwRepo)
	loBiz := fundingbusiness.NewLoanOfferBusiness(
		ctx,
		evtsMan,
		loRepo,
		lwRepo,
		&fundingMembershipAdapter{repo: identityMemRepo},
		platformClients,
	)
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

	// --- Adapters wrapping external repos for operations business interfaces ---
	memAdapter := &membershipAdapter{repo: identityMemRepo}
	grpAdapter := &groupAdapter{repo: identityGrpRepo}
	perAdapter := &periodAdapter{repo: perRepo}
	lfAdapter := &loanFundingAdapter{repo: lfRepo}
	ftAdapter := &fundingTrancheAdapter{repo: ftRepo, eventsMan: evtsMan}
	iaAdapter := &investorAccountAdapter{repo: iaRepo, eventsMan: evtsMan}

	// --- Operations business (for workflow callbacks) ---
	prBiz := opsbusiness.NewPaymentRoutingBusiness(
		ctx,
		evtsMan,
		ipRepo,
		toRepo,
		obRepo,
		arRepo,
		memAdapter,
		platformClients,
	)
	toBiz := opsbusiness.NewTransferOrderBusiness(
		ctx,
		evtsMan,
		toRepo,
		csRepo,
		arRepo,
		lfAdapter,
		ftAdapter,
		iaAdapter,
		platformClients,
	)
	obBiz := opsbusiness.NewObligationBusiness(ctx, evtsMan, obRepo, memAdapter, grpAdapter, perAdapter)

	// --- HTTP mux with workflow callbacks only ---
	mux := http.NewServeMux()
	handlers.RegisterWorkflowCallbacks(mux, grpBiz, memBiz, tenBiz, perBiz,
		lwBiz, loBiz, lfBiz, prBiz, toBiz, obBiz, platformClients)

	// --- Assemble service options ---
	serviceOptions := []frame.Option{
		frame.WithHTTPHandler(mux),
		frame.WithRegisterEvents(
			// Stawi events (lifecycle)
			stawievents.NewTenureSave(ctx, tenRepo),
			stawievents.NewPeriodSave(ctx, perRepo),
			stawievents.NewMotionSave(ctx, motRepo),
			stawievents.NewInfractionSave(ctx, infRepo),
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
		if err := stawirepo.Migrate(ctx, dbManager, migrationPath); err != nil {
			util.Log(ctx).WithError(err).Fatal("main -- Could not migrate stawi tables")
		}
		return true
	}
	return false
}

func setupIdentityClient(
	ctx context.Context,
	cfg aconfig.StawiConfig,
) (identityv1connect.IdentityServiceClient, error) {
	return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
		Endpoint:  cfg.IdentityServiceURI,
		Audiences: []string{"service_identity"},
	}, identityv1connect.NewIdentityServiceClient)
}

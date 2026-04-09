package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/funding/connectrpc/go/funding/v1/fundingv1connect"
	fundingpb "buf.build/gen/go/antinvestor/funding/protocolbuffers/go/funding/v1"
	"connectrpc.com/connect"
	"github.com/antinvestor/common/permissions"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/config"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/frame/security/authorizer"
	connectInterceptors "github.com/pitabwire/frame/security/interceptors/connect"
	"github.com/pitabwire/frame/workerpool"
	"github.com/pitabwire/util"

	auditInterceptors "github.com/antinvestor/service-fintech/pkg/interceptors"

	aconfig "github.com/antinvestor/service-fintech/apps/funding/config"
	"github.com/antinvestor/service-fintech/apps/funding/service/business"
	fundingevents "github.com/antinvestor/service-fintech/apps/funding/service/events"
	fundinghandlers "github.com/antinvestor/service-fintech/apps/funding/service/handlers"
	"github.com/antinvestor/service-fintech/apps/funding/service/repository"

	// Group repos used by loan offer business
	grouprepo "github.com/antinvestor/service-fintech/apps/group/service/repository"

	"github.com/antinvestor/service-fintech/pkg/clients"
)

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.FundingConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_funding"
	}

	ctx, svc := frame.NewServiceWithContext(
		tmpCtx,
		frame.WithConfig(&cfg),
		frame.WithDatastore(),
	)
	defer svc.Stop(ctx)
	log := util.Log(ctx)

	sm := svc.SecurityManager()
	dbManager := svc.DatastoreManager()
	workMan := svc.WorkManager()
	evtsMan := svc.EventsManager()

	// Handle database migration if requested
	if handleDatabaseMigration(ctx, dbManager, cfg) {
		return
	}

	// Get database pool
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		log.Error("Database pool is nil - check DATABASE_PRIMARY_URL environment variable")
		return
	}

	// Platform clients for external service calls (origination, loan mgmt, ledger, etc.)
	platformClients, pcErr := clients.NewPlatformClients(ctx, &cfg, cfg.ServiceEndpoints())
	if pcErr != nil {
		log.WithError(pcErr).Warn("main -- Some platform clients could not be initialised")
	}

	serviceOptions := setupServiceOptions(ctx, sm, evtsMan, dbPool, workMan, platformClients)

	svc.Init(ctx, serviceOptions...)

	err = svc.Run(ctx, "")
	if err != nil {
		log.WithError(err).Fatal("could not run Server")
	}
}

func setupServiceOptions(
	ctx context.Context,
	sm security.Manager,
	evtsMan fevents.Manager,
	dbPool pool.Pool,
	workMan workerpool.Manager,
	platformClients *clients.PlatformClients,
) []frame.Option {
	// Funding repositories
	lwRepo := repository.NewLoanWindowRepository(ctx, dbPool, workMan)
	loRepo := repository.NewLoanOfferRepository(ctx, dbPool, workMan)
	lfRepo := repository.NewLoanFundingRepository(ctx, dbPool, workMan)
	faRepo := repository.NewFundingAllocationRepository(ctx, dbPool, workMan)
	ftRepo := repository.NewFundingTrancheRepository(ctx, dbPool, workMan)
	iaRepo := repository.NewInvestorAccountRepository(ctx, dbPool, workMan)

	// Group repositories (used by loan offer business)
	memRepo := grouprepo.NewMembershipRepository(ctx, dbPool, workMan)

	// Business logic
	_ = business.NewLoanWindowBusiness(ctx, evtsMan, lwRepo)
	_ = business.NewLoanOfferBusiness(ctx, evtsMan, loRepo, lwRepo, memRepo, platformClients)
	faBiz := business.NewFundingAllocationBusiness(
		ctx,
		evtsMan,
		lfRepo,
		faRepo,
		loRepo,
		iaRepo,
		ftRepo,
		platformClients,
	)
	iaBiz := business.NewInvestorAccountBusiness(ctx, evtsMan, iaRepo)

	// ConnectRPC handler
	connectHandler := setupConnectServer(ctx, sm, iaBiz, faBiz)

	sd := fundingpb.File_funding_v1_funding_proto.Services().ByName("FundingService")

	return []frame.Option{
		frame.WithHTTPHandler(connectHandler),
		frame.WithPermissionRegistration(sd),
		frame.WithRegisterEvents(
			fundingevents.NewLoanWindowSave(ctx, lwRepo),
			fundingevents.NewLoanOfferSave(ctx, loRepo),
			fundingevents.NewLoanFundingSave(ctx, lfRepo),
			fundingevents.NewFundingAllocationSave(ctx, faRepo),
			fundingevents.NewFundingTrancheSave(ctx, ftRepo),
			fundingevents.NewInvestorAccountSave(ctx, iaRepo),
		),
	}
}

func handleDatabaseMigration(
	ctx context.Context,
	dbManager datastore.Manager,
	cfg aconfig.FundingConfig,
) bool {
	if cfg.DoDatabaseMigrate() {
		err := repository.Migrate(ctx, dbManager, cfg.GetDatabaseMigrationPath())
		if err != nil {
			util.Log(ctx).WithError(err).Fatal("main -- Could not migrate successfully")
		}
		return true
	}
	return false
}

func setupConnectServer(
	ctx context.Context,
	sm security.Manager,
	iaBiz business.InvestorAccountBusiness,
	faBiz business.FundingAllocationBusiness,
) http.Handler {
	fundingHandler := fundinghandlers.NewFundingServer(iaBiz, faBiz)

	auth := sm.GetAuthorizer(ctx)

	tenancyAccessChecker := authorizer.NewTenancyAccessChecker(auth, "tenancy_access")
	tenancyAccessInterceptor := connectInterceptors.NewTenancyAccessInterceptor(tenancyAccessChecker)

	sd := fundingpb.File_funding_v1_funding_proto.Services().ByName("FundingService")
	procMap := permissions.BuildProcedureMap(sd)
	svcPerms := permissions.ForService(sd)
	functionChecker := authorizer.NewFunctionChecker(auth, svcPerms.Namespace)
	functionAccessInterceptor := connectInterceptors.NewFunctionAccessInterceptor(functionChecker, procMap)

	fundingAuditInterceptor := auditInterceptors.NewAuditInterceptor("service_funding")
	defaultInterceptorList, err := connectInterceptors.DefaultList(
		ctx, sm.GetAuthenticator(ctx), tenancyAccessInterceptor, functionAccessInterceptor, fundingAuditInterceptor)
	if err != nil {
		util.Log(ctx).WithError(err).Fatal("main -- Could not create default interceptors")
	}

	interceptorOption := connect.WithInterceptors(defaultInterceptorList...)

	fundingPath, fundingServerHandler := fundingv1connect.NewFundingServiceHandler(fundingHandler, interceptorOption)

	mux := http.NewServeMux()
	mux.Handle(fundingPath, fundingServerHandler)

	return mux
}

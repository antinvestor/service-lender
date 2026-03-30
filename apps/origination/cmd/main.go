package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/field/connectrpc/go/field/v1/fieldv1connect"
	"buf.build/gen/go/antinvestor/loans/connectrpc/go/loans/v1/loansv1connect"
	"buf.build/gen/go/antinvestor/origination/connectrpc/go/origination/v1/originationv1connect"
	originationpb "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"
	"github.com/antinvestor/common"
	"github.com/antinvestor/common/connection"
	"github.com/antinvestor/common/permissions"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/config"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/frame/security/authorizer"
	connectInterceptors "github.com/pitabwire/frame/security/interceptors/connect"
	"github.com/pitabwire/util"

	aconfig "github.com/antinvestor/service-lender/apps/origination/config"
	"github.com/antinvestor/service-lender/apps/origination/service/authz"
	"github.com/antinvestor/service-lender/apps/origination/service/business"
	originationevents "github.com/antinvestor/service-lender/apps/origination/service/events"
	"github.com/antinvestor/service-lender/apps/origination/service/handlers"
	"github.com/antinvestor/service-lender/apps/origination/service/repository"
)

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.OriginationConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_lender_origination"
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

	// Setup external service clients
	identityCli, err := setupIdentityClient(ctx, cfg)
	if err != nil {
		log.WithError(err).Warn("main -- Could not setup identity client, client/agent validation disabled")
	}

	loanMgmtCli, err := setupLoanManagementClient(ctx, cfg)
	if err != nil {
		log.WithError(err).
			Warn("main -- Could not setup loan management client, loan creation on offer acceptance disabled")
	}

	// Get database pool
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		log.Error("Database pool is nil - check DATABASE_PRIMARY_URL environment variable")
		return
	}

	// Initialise repositories
	appRepo := repository.NewApplicationRepository(ctx, dbPool, workMan)
	docRepo := repository.NewApplicationDocumentRepository(ctx, dbPool, workMan)
	vtRepo := repository.NewVerificationTaskRepository(ctx, dbPool, workMan)
	udRepo := repository.NewUnderwritingDecisionRepository(ctx, dbPool, workMan)
	ashRepo := repository.NewApplicationStatusHistoryRepository(ctx, dbPool, workMan)
	cpaRepo := repository.NewClientProductAccessRepository(ctx, dbPool, workMan)

	// Create business logic with all dependencies
	appBusiness := business.NewApplicationBusiness(ctx, evtsMan, appRepo, cpaRepo, identityCli, loanMgmtCli)
	docBusiness := business.NewApplicationDocumentBusiness(ctx, evtsMan, docRepo)
	vtBusiness := business.NewVerificationTaskBusiness(ctx, evtsMan, vtRepo, appBusiness)
	udBusiness := business.NewUnderwritingDecisionBusiness(
		ctx,
		evtsMan,
		udRepo,
		appRepo,
		appBusiness,
		cfg.OfferExpiryDays,
	)

	// Setup Connect RPC servers
	connectHandler := setupConnectServer(ctx, sm,
		appBusiness, docBusiness, vtBusiness, udBusiness)

	// Initialise the service with all options
	serviceOptions := []frame.Option{
		frame.WithHTTPHandler(connectHandler),
		frame.WithRegisterEvents(
			originationevents.NewApplicationSave(ctx, appRepo),
			originationevents.NewApplicationDocumentSave(ctx, docRepo),
			originationevents.NewVerificationTaskSave(ctx, vtRepo),
			originationevents.NewUnderwritingDecisionSave(ctx, udRepo),
			originationevents.NewApplicationStatusHistorySave(ctx, ashRepo),
		),
		// Background jobs
		frame.WithBackgroundConsumer(business.ExpireOffersJob(appRepo, appBusiness)),
		frame.WithBackgroundConsumer(business.CleanDraftApplicationsJob(appRepo, appBusiness, cfg.DraftExpiryDays)),
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
	cfg aconfig.OriginationConfig,
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

func setupIdentityClient(
	ctx context.Context,
	cfg aconfig.OriginationConfig,
) (fieldv1connect.FieldServiceClient, error) {
	return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
		Endpoint:              cfg.IdentityServiceURI,
		WorkloadAPITargetPath: cfg.IdentityServiceWorkloadAPITargetPath,
		Audiences:             []string{"service_lender_identity"},
	}, fieldv1connect.NewFieldServiceClient)
}

func setupLoanManagementClient(
	ctx context.Context,
	cfg aconfig.OriginationConfig,
) (loansv1connect.LoanManagementServiceClient, error) {
	return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
		Endpoint:              cfg.LoanMgmtServiceURI,
		WorkloadAPITargetPath: cfg.LoanMgmtServiceWorkloadAPITargetPath,
		Audiences:             []string{"service_lender_loan_management"},
	}, loansv1connect.NewLoanManagementServiceClient)
}

func setupConnectServer(
	ctx context.Context,
	sm security.Manager,
	appBusiness business.ApplicationBusiness,
	docBusiness business.ApplicationDocumentBusiness,
	vtBusiness business.VerificationTaskBusiness,
	udBusiness business.UnderwritingDecisionBusiness,
) http.Handler {
	// Create handler with injected dependencies
	originationHandler := handlers.NewOriginationServer(
		appBusiness,
		docBusiness,
		vtBusiness,
		udBusiness,
	)

	auth := sm.GetAuthorizer(ctx)

	// Layer 1: TenancyAccessChecker verifies caller can access the partition
	tenancyAccessChecker := authorizer.NewTenancyAccessChecker(auth, authz.NamespaceTenancyAccess)
	tenancyAccessInterceptor := connectInterceptors.NewTenancyAccessInterceptor(tenancyAccessChecker)

	// Layer 2: FunctionAccessInterceptor enforces per-RPC permissions from proto annotations.
	sd := originationpb.File_origination_v1_origination_proto.Services().ByName("OriginationService")
	procMap := permissions.BuildProcedureMap(sd)
	functionChecker := authorizer.NewFunctionChecker(auth, "service_lender_origination")
	functionAccessInterceptor := connectInterceptors.NewFunctionAccessInterceptor(functionChecker, procMap)

	defaultInterceptorList, err := connectInterceptors.DefaultList(
		ctx, sm.GetAuthenticator(ctx), tenancyAccessInterceptor, functionAccessInterceptor)
	if err != nil {
		util.Log(ctx).WithError(err).Fatal("main -- Could not create default interceptors")
	}

	interceptorOption := connect.WithInterceptors(defaultInterceptorList...)

	// Register the origination service on the mux
	originationPath, originationServerHandler := originationv1connect.NewOriginationServiceHandler(
		originationHandler,
		interceptorOption,
	)

	mux := http.NewServeMux()
	mux.Handle(originationPath, originationServerHandler)

	return mux
}

package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/operations/connectrpc/go/operations/v1/operationsv1connect"
	operationspb "buf.build/gen/go/antinvestor/operations/protocolbuffers/go/operations/v1"
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

	aconfig "github.com/antinvestor/service-fintech/apps/operations/config"
	"github.com/antinvestor/service-fintech/apps/operations/service/business"
	opsevents "github.com/antinvestor/service-fintech/apps/operations/service/events"
	"github.com/antinvestor/service-fintech/apps/operations/service/handlers"
	"github.com/antinvestor/service-fintech/apps/operations/service/repository"

	// Funding repos used by transfer order execution (tranche redistribution)
	fundingrepo "github.com/antinvestor/service-fintech/apps/funding/service/repository"

	// Group repos used by obligation business
	grouprepo "github.com/antinvestor/service-fintech/apps/group/service/repository"

	"github.com/antinvestor/service-fintech/pkg/clients"
)

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.OperationsConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_operations"
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

	// Platform clients for transfer order execution (ledger, payment, etc.)
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
	// Operations repositories
	toRepo := repository.NewTransferOrderRepository(ctx, dbPool, workMan)
	obRepo := repository.NewObligationRepository(ctx, dbPool, workMan)
	ipRepo := repository.NewIncomingPaymentRepository(ctx, dbPool, workMan)
	arRepo := repository.NewAccountRefRepository(ctx, dbPool, workMan)
	csRepo := repository.NewCBSSyncRecordRepository(ctx, dbPool, workMan)

	// Funding repositories (used by transfer order execution for tranche redistribution)
	lfRepo := fundingrepo.NewLoanFundingRepository(ctx, dbPool, workMan)
	ftRepo := fundingrepo.NewFundingTrancheRepository(ctx, dbPool, workMan)
	iaRepo := fundingrepo.NewInvestorAccountRepository(ctx, dbPool, workMan)

	// Group repositories (used by obligation business)
	memRepo := grouprepo.NewMembershipRepository(ctx, dbPool, workMan)
	grpRepo := grouprepo.NewCustomerGroupRepository(ctx, dbPool, workMan)
	perRepo := grouprepo.NewPeriodRepository(ctx, dbPool, workMan)

	// Business logic
	prBiz := business.NewPaymentRoutingBusiness(ctx, evtsMan, ipRepo, toRepo, obRepo, arRepo, memRepo, platformClients)
	toBiz := business.NewTransferOrderBusiness(
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
	_ = business.NewObligationBusiness(ctx, evtsMan, obRepo, memRepo, grpRepo, perRepo)
	_ = prBiz // used via workflow callbacks, not directly in ConnectRPC

	// ConnectRPC handler
	connectHandler := setupConnectServer(ctx, sm, toBiz, toRepo)

	sd := operationspb.File_operations_v1_operations_proto.Services().ByName("OperationsService")

	return []frame.Option{
		frame.WithHTTPHandler(connectHandler),
		frame.WithPermissionRegistration(sd),
		frame.WithRegisterEvents(
			opsevents.NewTransferOrderSave(ctx, toRepo),
			opsevents.NewObligationSave(ctx, obRepo),
			opsevents.NewIncomingPaymentSave(ctx, ipRepo),
			opsevents.NewAccountRefSave(ctx, arRepo),
			opsevents.NewCBSSyncRecordSave(ctx, csRepo),
		),
	}
}

func handleDatabaseMigration(
	ctx context.Context,
	dbManager datastore.Manager,
	cfg aconfig.OperationsConfig,
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
	toBiz business.TransferOrderBusiness,
	toRepo repository.TransferOrderRepository,
) http.Handler {
	opsHandler := handlers.NewOperationsServer(toBiz, toRepo)

	auth := sm.GetAuthorizer(ctx)

	tenancyAccessChecker := authorizer.NewTenancyAccessChecker(auth, "tenancy_access")
	tenancyAccessInterceptor := connectInterceptors.NewTenancyAccessInterceptor(tenancyAccessChecker)

	sd := operationspb.File_operations_v1_operations_proto.Services().ByName("OperationsService")
	procMap := permissions.BuildProcedureMap(sd)
	svcPerms := permissions.ForService(sd)
	functionChecker := authorizer.NewFunctionChecker(auth, svcPerms.Namespace)
	functionAccessInterceptor := connectInterceptors.NewFunctionAccessInterceptor(functionChecker, procMap)

	opsAuditInterceptor := auditInterceptors.NewAuditInterceptor("service_operations")
	defaultInterceptorList, err := connectInterceptors.DefaultList(
		ctx, sm.GetAuthenticator(ctx), tenancyAccessInterceptor, functionAccessInterceptor, opsAuditInterceptor)
	if err != nil {
		util.Log(ctx).WithError(err).Fatal("main -- Could not create default interceptors")
	}

	interceptorOption := connect.WithInterceptors(defaultInterceptorList...)

	opsPath, opsServerHandler := operationsv1connect.NewOperationsServiceHandler(opsHandler, interceptorOption)

	mux := http.NewServeMux()
	mux.Handle(opsPath, opsServerHandler)

	return mux
}

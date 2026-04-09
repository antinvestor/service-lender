package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/loans/connectrpc/go/loans/v1/loansv1connect"
	loanspb "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	"buf.build/gen/go/antinvestor/notification/connectrpc/go/notification/v1/notificationv1connect"
	"buf.build/gen/go/antinvestor/origination/connectrpc/go/origination/v1/originationv1connect"
	"connectrpc.com/connect"
	"github.com/antinvestor/common"
	"github.com/antinvestor/common/connection"
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

	aconfig "github.com/antinvestor/service-fintech/apps/loans/config"
	"github.com/antinvestor/service-fintech/apps/loans/service/authz"
	"github.com/antinvestor/service-fintech/apps/loans/service/business"
	lmevents "github.com/antinvestor/service-fintech/apps/loans/service/events"
	"github.com/antinvestor/service-fintech/apps/loans/service/handlers"
	"github.com/antinvestor/service-fintech/apps/loans/service/repository"
	opsevents "github.com/antinvestor/service-fintech/apps/operations/service/events"
	opsrepo "github.com/antinvestor/service-fintech/apps/operations/service/repository"
)

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.LoanManagementConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_loans"
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
	originationCli, err := setupOriginationClient(ctx, cfg)
	if err != nil {
		log.WithError(err).
			Warn("main -- Could not setup origination client, loan creation will use application ID only")
	}

	notificationCli, notifErr := setupNotificationClient(ctx, cfg)
	if notifErr != nil {
		log.WithError(notifErr).
			Warn("main -- Could not setup notification client, notifications will be disabled")
	}
	loanNotifier := business.NewLoanNotifier(notificationCli)

	// Get database pool
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		log.Error("Database pool is nil - check DATABASE_PRIMARY_URL environment variable")
		return
	}

	serviceOptions := setupServiceOptions(ctx, sm, evtsMan, dbPool, workMan, originationCli, loanNotifier)

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
	originationCli originationv1connect.OriginationServiceClient,
	loanNotifier *business.LoanNotifier,
) []frame.Option {
	lpRepo := repository.NewLoanProductRepository(ctx, dbPool, workMan)
	laRepo := repository.NewLoanAccountRepository(ctx, dbPool, workMan)
	rsRepo := repository.NewRepaymentScheduleRepository(ctx, dbPool, workMan)
	seRepo := repository.NewScheduleEntryRepository(ctx, dbPool, workMan)
	lbRepo := repository.NewLoanBalanceRepository(ctx, dbPool, workMan)
	repRepo := repository.NewRepaymentRepository(ctx, dbPool, workMan)
	penRepo := repository.NewPenaltyRepository(ctx, dbPool, workMan)
	lrRepo := repository.NewLoanRestructureRepository(ctx, dbPool, workMan)
	lscRepo := repository.NewLoanStatusChangeRepository(ctx, dbPool, workMan)
	reconRepo := repository.NewReconciliationRepository(ctx, dbPool, workMan)
	toRepo := opsrepo.NewTransferOrderRepository(ctx, dbPool, workMan)

	lpBusiness := business.NewLoanProductBusiness(ctx, evtsMan, lpRepo)
	scheduleBusiness := business.NewRepaymentScheduleBusiness(ctx, evtsMan, laRepo, lpRepo, rsRepo, seRepo)
	laBusiness := business.NewLoanAccountBusiness(
		ctx, evtsMan, lpRepo, laRepo, lbRepo, lscRepo, repRepo, penRepo,
		originationCli, scheduleBusiness,
	)
	repBusiness := business.NewRepaymentBusiness(ctx, evtsMan, laRepo, repRepo, rsRepo, seRepo, lbRepo, loanNotifier)
	penaltyBusiness := business.NewPenaltyBusiness(ctx, evtsMan, penRepo)
	restructBusiness := business.NewLoanRestructureBusiness(ctx, evtsMan, lrRepo, laRepo)
	reconBusiness := business.NewReconciliationBusiness(ctx, evtsMan, reconRepo)

	portfolioBusiness := business.NewPortfolioBusiness(ctx, dbPool)

	connectHandler := setupConnectServer(ctx, sm,
		lpBusiness, laBusiness, repBusiness, scheduleBusiness,
		penaltyBusiness, restructBusiness, reconBusiness, portfolioBusiness, lscRepo)

	sd := loanspb.File_loans_v1_loans_proto.Services().ByName("LoanManagementService")

	return []frame.Option{
		frame.WithHTTPHandler(connectHandler),
		frame.WithPermissionRegistration(sd),
		frame.WithRegisterEvents(
			lmevents.NewLoanProductSave(ctx, lpRepo),
			lmevents.NewLoanAccountSave(ctx, laRepo),
			lmevents.NewRepaymentScheduleSave(ctx, rsRepo),
			lmevents.NewScheduleEntrySave(ctx, seRepo),
			lmevents.NewLoanBalanceSave(ctx, lbRepo),
			lmevents.NewRepaymentSave(ctx, repRepo),
			lmevents.NewPenaltySave(ctx, penRepo),
			lmevents.NewLoanRestructureSave(ctx, lrRepo),
			lmevents.NewLoanStatusChangeSave(ctx, lscRepo),
			lmevents.NewReconciliationSave(ctx, reconRepo),
			opsevents.NewTransferOrderSave(ctx, toRepo),
		),
	}
}

func handleDatabaseMigration(
	ctx context.Context,
	dbManager datastore.Manager,
	cfg aconfig.LoanManagementConfig,
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

func setupOriginationClient(
	ctx context.Context,
	cfg aconfig.LoanManagementConfig,
) (originationv1connect.OriginationServiceClient, error) {
	return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
		Endpoint:              cfg.OriginationServiceURI,
		WorkloadAPITargetPath: cfg.OriginationServiceWorkloadAPITargetPath,
		Audiences:             []string{"service_origination"},
	}, originationv1connect.NewOriginationServiceClient)
}

func setupNotificationClient(
	ctx context.Context,
	cfg aconfig.LoanManagementConfig,
) (notificationv1connect.NotificationServiceClient, error) {
	return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
		Endpoint:              cfg.NotificationServiceURI,
		WorkloadAPITargetPath: cfg.NotificationServiceWorkloadAPITargetPath,
		Audiences:             []string{"service_notification"},
	}, notificationv1connect.NewNotificationServiceClient)
}

func setupConnectServer(
	ctx context.Context,
	sm security.Manager,
	lpBusiness business.LoanProductBusiness,
	laBusiness business.LoanAccountBusiness,
	repBusiness business.RepaymentBusiness,
	scheduleBusiness business.RepaymentScheduleBusiness,
	penaltyBusiness business.PenaltyBusiness,
	restructBusiness business.LoanRestructureBusiness,
	reconBusiness business.ReconciliationBusiness,
	portfolioBusiness business.PortfolioBusiness,
	statusChangeRepo repository.LoanStatusChangeRepository,
) http.Handler {
	// Create handler with injected dependencies
	lmHandler := handlers.NewLoanManagementServer(
		lpBusiness,
		laBusiness,
		repBusiness,
		scheduleBusiness,
		penaltyBusiness,
		restructBusiness,
		reconBusiness,
		portfolioBusiness,
		statusChangeRepo,
	)

	auth := sm.GetAuthorizer(ctx)

	// Layer 1: TenancyAccessChecker verifies caller can access the partition
	tenancyAccessChecker := authorizer.NewTenancyAccessChecker(auth, authz.NamespaceTenancyAccess)
	tenancyAccessInterceptor := connectInterceptors.NewTenancyAccessInterceptor(tenancyAccessChecker)

	// Layer 2: FunctionAccessInterceptor enforces per-RPC permissions from proto annotations.
	sd := loanspb.File_loans_v1_loans_proto.Services().ByName("LoanManagementService")
	procMap := permissions.BuildProcedureMap(sd)
	svcPerms := permissions.ForService(sd)
	functionChecker := authorizer.NewFunctionChecker(auth, svcPerms.Namespace)
	functionAccessInterceptor := connectInterceptors.NewFunctionAccessInterceptor(functionChecker, procMap)

	loansAuditInterceptor := auditInterceptors.NewAuditInterceptor("service_loans")
	defaultInterceptorList, err := connectInterceptors.DefaultList(
		ctx, sm.GetAuthenticator(ctx), tenancyAccessInterceptor, functionAccessInterceptor, loansAuditInterceptor)
	if err != nil {
		util.Log(ctx).WithError(err).Fatal("main -- Could not create default interceptors")
	}

	interceptorOption := connect.WithInterceptors(defaultInterceptorList...)

	// Register the loan management service on the mux
	lmPath, lmServerHandler := loansv1connect.NewLoanManagementServiceHandler(lmHandler, interceptorOption)

	mux := http.NewServeMux()
	mux.Handle(lmPath, lmServerHandler)

	return mux
}

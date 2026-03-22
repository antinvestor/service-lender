package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/loans/connectrpc/go/loans/v1/loansv1connect"
	"buf.build/gen/go/antinvestor/notification/connectrpc/go/notification/v1/notificationv1connect"
	"buf.build/gen/go/antinvestor/origination/connectrpc/go/origination/v1/originationv1connect"
	"connectrpc.com/connect"
	apis "github.com/antinvestor/apis/go/common"
	"github.com/antinvestor/apis/go/common/connection"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/config"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/frame/security/authorizer"
	connectInterceptors "github.com/pitabwire/frame/security/interceptors/connect"
	"github.com/pitabwire/util"

	aconfig "github.com/antinvestor/service-lender/apps/loans/config"
	"github.com/antinvestor/service-lender/apps/loans/service/authz"
	"github.com/antinvestor/service-lender/apps/loans/service/business"
	lmevents "github.com/antinvestor/service-lender/apps/loans/service/events"
	"github.com/antinvestor/service-lender/apps/loans/service/handlers"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
)

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.LoanManagementConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_lender_loan_management"
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

	if handleDatabaseMigration(ctx, dbManager, cfg) {
		return
	}

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

	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		log.Error("Database pool is nil - check DATABASE_PRIMARY_URL environment variable")
		return
	}

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

	lpBusiness := business.NewLoanProductBusiness(ctx, evtsMan, lpRepo)
	scheduleBusiness := business.NewRepaymentScheduleBusiness(ctx, evtsMan, laRepo, lpRepo, rsRepo, seRepo)
	laBusiness := business.NewLoanAccountBusiness(
		ctx,
		evtsMan,
		lpRepo,
		laRepo,
		lbRepo,
		lscRepo,
		repRepo,
		originationCli,
		scheduleBusiness,
	)
	repBusiness := business.NewRepaymentBusiness(ctx, evtsMan, laRepo, repRepo, rsRepo, seRepo, lbRepo, loanNotifier)
	penaltyBusiness := business.NewPenaltyBusiness(ctx, evtsMan, penRepo)
	restructBusiness := business.NewLoanRestructureBusiness(ctx, evtsMan, lrRepo, laRepo)
	reconBusiness := business.NewReconciliationBusiness(ctx, evtsMan, reconRepo)

	authzMiddleware := authz.NewMiddleware(sm.GetAuthorizer(ctx))

	connectHandler := setupConnectServer(
		ctx,
		sm,
		authzMiddleware,
		lpBusiness,
		laBusiness,
		repBusiness,
		scheduleBusiness,
		penaltyBusiness,
		restructBusiness,
		reconBusiness,
		lscRepo,
	)

	serviceOptions := []frame.Option{
		frame.WithHTTPHandler(connectHandler),
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
	return connection.NewServiceClient(ctx, &cfg, apis.ServiceTarget{
		Endpoint:              cfg.OriginationServiceURI,
		WorkloadAPITargetPath: cfg.OriginationServiceWorkloadAPITargetPath,
		Audiences:             []string{"service_lender_origination"},
	}, originationv1connect.NewOriginationServiceClient)
}

func setupNotificationClient(
	ctx context.Context,
	cfg aconfig.LoanManagementConfig,
) (notificationv1connect.NotificationServiceClient, error) {
	return connection.NewServiceClient(ctx, &cfg, apis.ServiceTarget{
		Endpoint:              cfg.NotificationServiceURI,
		WorkloadAPITargetPath: cfg.NotificationServiceWorkloadAPITargetPath,
		Audiences:             []string{"service_lender_notification"},
	}, notificationv1connect.NewNotificationServiceClient)
}

func setupConnectServer(
	ctx context.Context,
	sm security.Manager,
	authzMiddleware authz.Middleware,
	lpBusiness business.LoanProductBusiness,
	laBusiness business.LoanAccountBusiness,
	repBusiness business.RepaymentBusiness,
	scheduleBusiness business.RepaymentScheduleBusiness,
	penaltyBusiness business.PenaltyBusiness,
	restructBusiness business.LoanRestructureBusiness,
	reconBusiness business.ReconciliationBusiness,
	statusChangeRepo repository.LoanStatusChangeRepository,
) http.Handler {
	lmHandler := handlers.NewLoanManagementServer(
		authzMiddleware,
		lpBusiness,
		laBusiness,
		repBusiness,
		scheduleBusiness,
		penaltyBusiness,
		restructBusiness,
		reconBusiness,
		statusChangeRepo,
	)

	tenancyAccessChecker := authorizer.NewTenancyAccessChecker(
		sm.GetAuthorizer(ctx), authz.NamespaceTenancyAccess)
	tenancyAccessInterceptor := connectInterceptors.NewTenancyAccessInterceptor(tenancyAccessChecker)

	defaultInterceptorList, err := connectInterceptors.DefaultList(
		ctx, sm.GetAuthenticator(ctx), tenancyAccessInterceptor)
	if err != nil {
		util.Log(ctx).WithError(err).Fatal("main -- Could not create default interceptors")
	}

	interceptorOption := connect.WithInterceptors(defaultInterceptorList...)
	lmPath, lmServerHandler := loansv1connect.NewLoanManagementServiceHandler(lmHandler, interceptorOption)

	mux := http.NewServeMux()
	mux.Handle(lmPath, lmServerHandler)

	return mux
}

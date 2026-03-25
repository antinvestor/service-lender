package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/savings/connectrpc/go/savings/v1/savingsv1connect"
	savingspb "buf.build/gen/go/antinvestor/savings/protocolbuffers/go/savings/v1"
	"connectrpc.com/connect"
	"github.com/antinvestor/common/permissions"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/config"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/frame/security/authorizer"
	connectInterceptors "github.com/pitabwire/frame/security/interceptors/connect"
	"github.com/pitabwire/util"

	aconfig "github.com/antinvestor/service-lender/apps/savings/config"
	"github.com/antinvestor/service-lender/apps/savings/service/authz"
	"github.com/antinvestor/service-lender/apps/savings/service/business"
	savingsevents "github.com/antinvestor/service-lender/apps/savings/service/events"
	"github.com/antinvestor/service-lender/apps/savings/service/handlers"
	"github.com/antinvestor/service-lender/apps/savings/service/repository"
)

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.SavingsConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_lender_savings"
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

	// Initialise repositories
	spRepo := repository.NewSavingsProductRepository(ctx, dbPool, workMan)
	saRepo := repository.NewSavingsAccountRepository(ctx, dbPool, workMan)
	depRepo := repository.NewDepositRepository(ctx, dbPool, workMan)
	wdRepo := repository.NewWithdrawalRepository(ctx, dbPool, workMan)
	iaRepo := repository.NewInterestAccrualRepository(ctx, dbPool, workMan)

	// Create business logic with all dependencies
	spBusiness := business.NewSavingsProductBusiness(ctx, evtsMan, spRepo)
	saBusiness := business.NewSavingsAccountBusiness(ctx, evtsMan, saRepo, depRepo, wdRepo, iaRepo)
	depBusiness := business.NewDepositBusiness(ctx, evtsMan, depRepo, saRepo)
	wdBusiness := business.NewWithdrawalBusiness(ctx, evtsMan, wdRepo, saRepo, saBusiness)
	iaBusiness := business.NewInterestAccrualBusiness(ctx, iaRepo)

	// Setup Connect RPC servers
	connectHandler := setupConnectServer(ctx, sm,
		spBusiness, saBusiness, depBusiness, wdBusiness, iaBusiness)

	// Initialise the service with all options
	serviceOptions := []frame.Option{
		frame.WithHTTPHandler(connectHandler),
		frame.WithRegisterEvents(
			savingsevents.NewSavingsProductSave(ctx, spRepo),
			savingsevents.NewSavingsAccountSave(ctx, saRepo),
			savingsevents.NewDepositSave(ctx, depRepo),
			savingsevents.NewWithdrawalSave(ctx, wdRepo),
			savingsevents.NewInterestAccrualSave(ctx, iaRepo),
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
	cfg aconfig.SavingsConfig,
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
	spBusiness business.SavingsProductBusiness,
	saBusiness business.SavingsAccountBusiness,
	depBusiness business.DepositBusiness,
	wdBusiness business.WithdrawalBusiness,
	iaBusiness business.InterestAccrualBusiness,
) http.Handler {
	// Create handler with injected dependencies
	savingsHandler := handlers.NewSavingsServer(
		spBusiness,
		saBusiness,
		depBusiness,
		wdBusiness,
		iaBusiness,
	)

	auth := sm.GetAuthorizer(ctx)

	// Layer 1: TenancyAccessChecker verifies caller can access the partition
	tenancyAccessChecker := authorizer.NewTenancyAccessChecker(auth, authz.NamespaceTenancyAccess)
	tenancyAccessInterceptor := connectInterceptors.NewTenancyAccessInterceptor(tenancyAccessChecker)

	// Layer 2: FunctionAccessInterceptor enforces per-RPC permissions from proto annotations.
	sd := savingspb.File_savings_v1_savings_proto.Services().ByName("SavingsService")
	procMap := permissions.BuildProcedureMap(sd)
	functionChecker := authorizer.NewFunctionChecker(auth, "service_lender_savings")
	functionAccessInterceptor := connectInterceptors.NewFunctionAccessInterceptor(functionChecker, procMap)

	defaultInterceptorList, err := connectInterceptors.DefaultList(
		ctx, sm.GetAuthenticator(ctx), tenancyAccessInterceptor, functionAccessInterceptor)
	if err != nil {
		util.Log(ctx).WithError(err).Fatal("main -- Could not create default interceptors")
	}

	interceptorOption := connect.WithInterceptors(defaultInterceptorList...)

	// Register the savings service on the mux
	savingsPath, savingsServerHandler := savingsv1connect.NewSavingsServiceHandler(savingsHandler, interceptorOption)

	mux := http.NewServeMux()
	mux.Handle(savingsPath, savingsServerHandler)

	return mux
}

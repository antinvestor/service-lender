package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/field/connectrpc/go/field/v1/fieldv1connect"
	fieldpb "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	identitypb "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"buf.build/gen/go/antinvestor/profile/connectrpc/go/profile/v1/profilev1connect"
	"buf.build/gen/go/antinvestor/tenancy/connectrpc/go/tenancy/v1/tenancyv1connect"
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
	auditInterceptors "github.com/antinvestor/service-lender/pkg/interceptors"
	"github.com/pitabwire/frame/workerpool"
	"github.com/pitabwire/util"

	aconfig "github.com/antinvestor/service-lender/apps/identity/config"
	"github.com/antinvestor/service-lender/apps/identity/service/authz"
	"github.com/antinvestor/service-lender/apps/identity/service/business"
	identityevents "github.com/antinvestor/service-lender/apps/identity/service/events"
	"github.com/antinvestor/service-lender/apps/identity/service/handlers"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.IdentityConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_lender_identity"
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
	profileCli, err := setupProfileClient(ctx, cfg)
	if err != nil {
		log.WithError(err).Fatal("main -- Could not setup profile client")
	}
	_ = profileCli // Used for profile validation in future

	partitionCli, err := setupTenancyClient(ctx, cfg)
	if err != nil {
		log.WithError(err).Fatal("main -- Could not setup partition client")
	}
	_ = partitionCli // Used for partition validation in future

	// Get database pool
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		log.Error("Database pool is nil - check DATABASE_PRIMARY_URL environment variable")
		return
	}

	// Initialise repositories, business logic, handlers, and events
	serviceOptions := setupServiceOptions(ctx, sm, evtsMan, dbPool, workMan, cfg)

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
	cfg aconfig.IdentityConfig,
) []frame.Option {
	organizationRepo := repository.NewOrganizationRepository(ctx, dbPool, workMan)
	branchRepo := repository.NewBranchRepository(ctx, dbPool, workMan)
	agentRepo := repository.NewAgentRepository(ctx, dbPool, workMan)
	clientRepo := repository.NewClientRepository(ctx, dbPool, workMan)
	cahRepo := repository.NewClientAssignmentHistoryRepository(ctx, dbPool, workMan)
	clcrRepo := repository.NewCreditLimitChangeRequestRepository(ctx, dbPool, workMan)
	groupRepo := repository.NewGroupRepository(ctx, dbPool, workMan)
	membershipRepo := repository.NewMembershipRepository(ctx, dbPool, workMan)
	investorRepo := repository.NewInvestorRepository(ctx, dbPool, workMan)
	systemUserRepo := repository.NewSystemUserRepository(ctx, dbPool, workMan)

	organizationBusiness := business.NewOrganizationBusiness(ctx, evtsMan, organizationRepo)
	branchBusiness := business.NewBranchBusiness(ctx, evtsMan, organizationRepo, branchRepo)
	agentBusiness := business.NewAgentBusiness(ctx, evtsMan, cfg.MaxAgentDepth, branchRepo, agentRepo)
	clientBusiness := business.NewClientBusiness(ctx, evtsMan, agentRepo, clientRepo, cahRepo, branchRepo, clcrRepo)
	groupBusiness := business.NewGroupBusiness(ctx, evtsMan, agentRepo, groupRepo)
	membershipBusiness := business.NewMembershipBusiness(ctx, evtsMan, groupRepo, membershipRepo)
	investorBusiness := business.NewInvestorBusiness(ctx, evtsMan, investorRepo)
	suBusiness := business.NewSystemUserBusiness(ctx, evtsMan, branchRepo, systemUserRepo)

	connectHandler := setupConnectServer(
		ctx, sm,
		organizationBusiness, branchBusiness, agentBusiness, clientBusiness,
		groupBusiness, membershipBusiness, investorBusiness, suBusiness,
	)

	identitySD := identitypb.File_identity_v1_identity_proto.Services().ByName("IdentityService")
	fieldSD := fieldpb.File_field_v1_field_proto.Services().ByName("FieldService")

	return []frame.Option{
		frame.WithHTTPHandler(connectHandler),
		frame.WithPermissionRegistration(identitySD),
		frame.WithPermissionRegistration(fieldSD),
		frame.WithRegisterEvents(
			identityevents.NewOrganizationSave(ctx, organizationRepo),
			identityevents.NewBranchSave(ctx, branchRepo),
			identityevents.NewAgentSave(ctx, agentRepo),
			identityevents.NewClientSave(ctx, clientRepo),
			identityevents.NewGroupSave(ctx, groupRepo),
			identityevents.NewMembershipSave(ctx, membershipRepo),
			identityevents.NewInvestorSave(ctx, investorRepo),
			identityevents.NewSystemUserSave(ctx, systemUserRepo),
			identityevents.NewCreditLimitChangeRequestSave(ctx, clcrRepo),
		),
	}
}

func handleDatabaseMigration(
	ctx context.Context,
	dbManager datastore.Manager,
	cfg aconfig.IdentityConfig,
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

func setupProfileClient(
	ctx context.Context,
	cfg aconfig.IdentityConfig,
) (profilev1connect.ProfileServiceClient, error) {
	return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
		Endpoint:              cfg.ProfileServiceURI,
		WorkloadAPITargetPath: cfg.ProfileServiceWorkloadAPITargetPath,
		Audiences:             []string{"service_profile"},
	}, profilev1connect.NewProfileServiceClient)
}

func setupTenancyClient(
	ctx context.Context,
	cfg aconfig.IdentityConfig,
) (tenancyv1connect.TenancyServiceClient, error) {
	return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
		Endpoint:              cfg.TenancyServiceURI,
		WorkloadAPITargetPath: cfg.TenancyServiceWorkloadAPITargetPath,
		Audiences:             []string{"service_tenancy"},
	}, tenancyv1connect.NewTenancyServiceClient)
}

func setupConnectServer(
	ctx context.Context,
	sm security.Manager,
	organizationBusiness business.OrganizationBusiness,
	branchBusiness business.BranchBusiness,
	agentBusiness business.AgentBusiness,
	clientBusiness business.ClientBusiness,
	_ business.GroupBusiness,
	_ business.MembershipBusiness,
	investorBusiness business.InvestorBusiness,
	suBusiness business.SystemUserBusiness,
) http.Handler {
	// Create handlers with injected dependencies
	identityHandler := handlers.NewIdentityServer(
		organizationBusiness,
		branchBusiness,
		investorBusiness,
		suBusiness,
	)
	fieldHandler := handlers.NewFieldServer(
		agentBusiness,
		clientBusiness,
	)

	auth := sm.GetAuthorizer(ctx)

	// Layer 1: TenancyAccessChecker verifies caller can access the partition
	tenancyAccessChecker := authorizer.NewTenancyAccessChecker(auth, authz.NamespaceTenancyAccess)
	tenancyAccessInterceptor := connectInterceptors.NewTenancyAccessInterceptor(tenancyAccessChecker)

	// Layer 2: FunctionAccessInterceptor enforces per-RPC permissions from proto annotations.
	// Each service gets its own FunctionChecker with the correct namespace.
	identitySD := identitypb.File_identity_v1_identity_proto.Services().ByName("IdentityService")
	identityProcMap := permissions.BuildProcedureMap(identitySD)
	identitySvcPerms := permissions.ForService(identitySD)
	identityFunctionChecker := authorizer.NewFunctionChecker(auth, identitySvcPerms.Namespace)
	identityFunctionAccessInterceptor := connectInterceptors.NewFunctionAccessInterceptor(
		identityFunctionChecker,
		identityProcMap,
	)

	fieldSD := fieldpb.File_field_v1_field_proto.Services().ByName("FieldService")
	fieldProcMap := permissions.BuildProcedureMap(fieldSD)
	fieldSvcPerms := permissions.ForService(fieldSD)
	fieldFunctionChecker := authorizer.NewFunctionChecker(auth, fieldSvcPerms.Namespace)
	fieldFunctionAccessInterceptor := connectInterceptors.NewFunctionAccessInterceptor(
		fieldFunctionChecker,
		fieldProcMap,
	)

	// Layer 3: Audit interceptor logs all non-idempotent calls and failed reads.
	identityAuditInterceptor := auditInterceptors.NewAuditInterceptor("service_identity")
	fieldAuditInterceptor := auditInterceptors.NewAuditInterceptor("service_field")

	identityInterceptorList, err := connectInterceptors.DefaultList(
		ctx, sm.GetAuthenticator(ctx), tenancyAccessInterceptor, identityFunctionAccessInterceptor, identityAuditInterceptor)
	if err != nil {
		util.Log(ctx).WithError(err).Fatal("main -- Could not create identity interceptors")
	}

	fieldInterceptorList, err := connectInterceptors.DefaultList(
		ctx, sm.GetAuthenticator(ctx), tenancyAccessInterceptor, fieldFunctionAccessInterceptor, fieldAuditInterceptor)
	if err != nil {
		util.Log(ctx).WithError(err).Fatal("main -- Could not create field interceptors")
	}

	identityInterceptorOption := connect.WithInterceptors(identityInterceptorList...)
	fieldInterceptorOption := connect.WithInterceptors(fieldInterceptorList...)

	// Register both services on the same mux with their own interceptors
	identityPath, identityServerHandler := identityv1connect.NewIdentityServiceHandler(
		identityHandler,
		identityInterceptorOption,
	)
	fieldPath, fieldServerHandler := fieldv1connect.NewFieldServiceHandler(fieldHandler, fieldInterceptorOption)

	mux := http.NewServeMux()
	mux.Handle(identityPath, identityServerHandler)
	mux.Handle(fieldPath, fieldServerHandler)

	return mux
}

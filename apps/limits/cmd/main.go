// Copyright 2023-2026 Ant Investor Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitspb "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/antinvestor/common/permissions"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/config"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/frame/security/authorizer"
	connectInterceptors "github.com/pitabwire/frame/security/interceptors/connect"
	"github.com/pitabwire/util"

	auditmw "github.com/antinvestor/common/audit"

	aconfig "github.com/antinvestor/service-fintech/apps/limits/config"
	"github.com/antinvestor/service-fintech/apps/limits/service/business"
	"github.com/antinvestor/service-fintech/apps/limits/service/handlers"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

const namespaceTenancyAccess = "tenancy_access"

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.LimitsConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_limits"
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

	// Handle database migration if requested.
	if handleDatabaseMigration(ctx, dbManager, cfg) {
		return
	}

	// Get database pool.
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		log.Error("Database pool is nil - check DATABASE_PRIMARY_URL environment variable")
		return
	}

	// Initialise repositories.
	policyRepo := repository.NewPolicyRepository(ctx, dbPool, workMan)
	policyVerRepo := repository.NewPolicyVersionRepository(ctx, dbPool, workMan)

	// Initialise business logic.
	policyBiz := business.NewPolicyBusiness(policyRepo, policyVerRepo)

	// Initialise handler (approval and ledger wired in Task 19; nil is safe here
	// as the Unimplemented embed handles missing deps until the full stack lands).
	adminH := handlers.NewAdminService(policyBiz, nil, nil)

	// Build Connect RPC server.
	connectHandler := setupConnectServer(ctx, sm, adminH)

	// Register service descriptor for permission registration.
	sd := limitspb.File_limits_v1_limits_proto.Services().ByName("LimitsAdminService")

	serviceOptions := []frame.Option{
		frame.WithHTTPHandler(connectHandler),
		frame.WithPermissionRegistration(sd),
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
	cfg aconfig.LimitsConfig,
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
	adminH *handlers.AdminService,
) http.Handler {
	auth := sm.GetAuthorizer(ctx)

	// Layer 1: TenancyAccessChecker verifies caller can access the partition.
	tenancyAccessChecker := authorizer.NewTenancyAccessChecker(auth, namespaceTenancyAccess)
	tenancyAccessInterceptor := connectInterceptors.NewTenancyAccessInterceptor(tenancyAccessChecker)

	// Layer 2: FunctionAccessInterceptor enforces per-RPC permissions from proto annotations.
	sd := limitspb.File_limits_v1_limits_proto.Services().ByName("LimitsAdminService")
	procMap := permissions.BuildProcedureMap(sd)
	svcPerms := permissions.ForService(sd)
	functionChecker := authorizer.NewFunctionChecker(auth, svcPerms.Namespace)
	functionAccessInterceptor := connectInterceptors.NewFunctionAccessInterceptor(functionChecker, procMap)

	limitsAuditInterceptor := auditmw.NewInterceptor("service_limits", nil)
	defaultInterceptorList, err := connectInterceptors.DefaultList(
		ctx, sm.GetAuthenticator(ctx), tenancyAccessInterceptor, functionAccessInterceptor, limitsAuditInterceptor)
	if err != nil {
		util.Log(ctx).WithError(err).Fatal("main -- Could not create default interceptors")
	}

	interceptorOption := connect.WithInterceptors(defaultInterceptorList...)

	// Register the limits admin service on the mux.
	limitsPath, limitsServerHandler := limitsv1connect.NewLimitsAdminServiceHandler(adminH, interceptorOption)

	mux := http.NewServeMux()
	mux.Handle(limitsPath, limitsServerHandler)

	return mux
}

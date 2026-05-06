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

package handlers_test

import (
	"context"
	"testing"
	"time"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/frametests"
	"github.com/pitabwire/frame/frametests/definition"
	testpostgres "github.com/pitabwire/frame/frametests/deps/testpostgres"
	"github.com/pitabwire/util"
	"github.com/stretchr/testify/suite"
	moneypb "google.golang.org/genproto/googleapis/type/money"
	"google.golang.org/protobuf/types/known/durationpb"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/antinvestor/service-fintech/apps/limits/service/business"
	"github.com/antinvestor/service-fintech/apps/limits/service/handlers"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

type AdminHandlerSuite struct {
	frametests.FrameBaseTestSuite
	handler *handlers.AdminService
}

func (s *AdminHandlerSuite) SetupSuite() {
	s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
		return []definition.TestResource{
			testpostgres.NewWithOpts("limits_test", definition.WithUserName("test")),
		}
	}
	s.FrameBaseTestSuite.SetupSuite()
}

func (s *AdminHandlerSuite) SetupTest() {
	ctx := s.T().Context()
	ctx = s.WithAuthClaims(ctx, "tenant-a", "partition-a", "test-user")

	db := s.databaseResource(ctx)
	dsn, cleanup, err := db.GetRandomisedDS(ctx, util.RandomAlphaNumericString(8))
	s.Require().NoError(err)
	s.T().Cleanup(func() { cleanup(ctx) })

	ctx, svc := frame.NewServiceWithContext(
		ctx,
		frame.WithName("limits-handler-test"),
		frame.WithDatastore(pool.WithConnection(dsn.String(), false)),
	)
	s.T().Cleanup(func() { svc.Stop(ctx) })
	svc.Init(ctx)

	dbManager := svc.DatastoreManager()
	s.Require().NoError(repository.Migrate(ctx, dbManager, ""))

	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	s.Require().NotNil(dbPool)

	workMan := svc.WorkManager()
	policyRepo := repository.NewPolicyRepository(ctx, dbPool, workMan)
	versionRepo := repository.NewPolicyVersionRepository(ctx, dbPool, workMan)
	biz := business.NewPolicyBusiness(policyRepo, versionRepo)
	s.handler = handlers.NewAdminService(biz)
}

func (s *AdminHandlerSuite) databaseResource(ctx context.Context) definition.DependancyConn {
	s.T().Helper()
	for _, resource := range s.Resources() {
		if resource.Name() == testpostgres.PostgresqlDBImage && resource.GetDS(ctx).IsDB() {
			return resource
		}
	}
	s.T().Fatal("postgres test resource not found")
	return nil
}

func (s *AdminHandlerSuite) TestPolicySaveThenGet() {
	ctx := s.WithAuthClaims(s.T().Context(), "tenant-a", "partition-a", "")
	in := &limitsv1.PolicyObject{
		Scope:         limitsv1.PolicyScope_POLICY_SCOPE_ORG,
		Action:        limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		SubjectType:   limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
		CurrencyCode:  "KES",
		LimitKind:     limitsv1.LimitKind_LIMIT_KIND_PER_TXN_MAX,
		CapAmount:     &moneypb.Money{CurrencyCode: "KES", Units: 100},
		Mode:          limitsv1.PolicyMode_POLICY_MODE_SHADOW,
		EffectiveFrom: timestamppb.New(time.Now().UTC()),
		ApprovalTtl:   durationpb.New(72 * time.Hour),
	}

	saveResp, err := s.handler.PolicySave(ctx, connect.NewRequest(&limitsv1.PolicySaveRequest{Data: in}))
	s.Require().NoError(err)
	s.NotEmpty(saveResp.Msg.GetData().GetId())

	getResp, err := s.handler.PolicyGet(
		ctx,
		connect.NewRequest(&limitsv1.PolicyGetRequest{Id: saveResp.Msg.GetData().GetId()}),
	)
	s.Require().NoError(err)
	s.Equal(saveResp.Msg.GetData().GetId(), getResp.Msg.GetData().GetId())
}

func (s *AdminHandlerSuite) TestPolicyGetMissingReturnsNotFound() {
	ctx := s.WithAuthClaims(s.T().Context(), "tenant-a", "partition-a", "")
	_, err := s.handler.PolicyGet(ctx, connect.NewRequest(&limitsv1.PolicyGetRequest{Id: "nonexistent"}))
	s.Require().Error(err)
	s.Equal(connect.CodeNotFound, connect.CodeOf(err))
}

func (s *AdminHandlerSuite) TestPolicyDelete() {
	ctx := s.WithAuthClaims(s.T().Context(), "tenant-a", "partition-a", "")
	in := &limitsv1.PolicyObject{
		Scope:         limitsv1.PolicyScope_POLICY_SCOPE_ORG,
		Action:        limitsv1.LimitAction_LIMIT_ACTION_LOAN_REQUEST,
		SubjectType:   limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
		CurrencyCode:  "KES",
		LimitKind:     limitsv1.LimitKind_LIMIT_KIND_PER_TXN_MAX,
		CapAmount:     &moneypb.Money{CurrencyCode: "KES", Units: 1},
		Mode:          limitsv1.PolicyMode_POLICY_MODE_SHADOW,
		EffectiveFrom: timestamppb.New(time.Now().UTC()),
	}
	saveResp, err := s.handler.PolicySave(ctx, connect.NewRequest(&limitsv1.PolicySaveRequest{Data: in}))
	s.Require().NoError(err)

	_, err = s.handler.PolicyDelete(
		ctx,
		connect.NewRequest(&limitsv1.PolicyDeleteRequest{Id: saveResp.Msg.GetData().GetId()}),
	)
	s.Require().NoError(err)

	_, err = s.handler.PolicyGet(
		ctx,
		connect.NewRequest(&limitsv1.PolicyGetRequest{Id: saveResp.Msg.GetData().GetId()}),
	)
	s.Equal(connect.CodeNotFound, connect.CodeOf(err))
}

func TestAdminHandlerSuite(t *testing.T) {
	suite.Run(t, new(AdminHandlerSuite))
}

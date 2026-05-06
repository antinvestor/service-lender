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

package business_test

import (
	"context"
	"os"
	"strings"
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
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"
	moneypb "google.golang.org/genproto/googleapis/type/money"
	"google.golang.org/protobuf/types/known/durationpb"
	"google.golang.org/protobuf/types/known/timestamppb"
	"gorm.io/gorm"

	"github.com/antinvestor/service-fintech/apps/limits/service/business"
	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

type ReservationBusinessSuite struct {
	frametests.FrameBaseTestSuite
}

func (s *ReservationBusinessSuite) SetupSuite() {
	s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
		return []definition.TestResource{
			testpostgres.NewWithOpts("limits_test", definition.WithUserName("test")),
		}
	}
	s.FrameBaseTestSuite.SetupSuite()
}

func (s *ReservationBusinessSuite) databaseResource(ctx context.Context) definition.DependancyConn {
	s.T().Helper()
	for _, resource := range s.Resources() {
		if resource.Name() == testpostgres.PostgresqlDBImage && resource.GetDS(ctx).IsDB() {
			return resource
		}
	}
	s.T().Fatal("postgres test resource not found")
	return nil
}

// resvEnv provisions a fresh isolated DB and wires up all dependencies.
// Returns ctx (with tenancy), biz (ReservationBusiness), dbPool, and a
// policyRepo for test setup.
func (s *ReservationBusinessSuite) resvEnv(tenantID, partitionID string) (
	context.Context,
	business.ReservationBusiness,
	pool.Pool,
	repository.PolicyRepository,
	repository.LedgerRepository,
) {
	s.T().Helper()

	ctx := s.T().Context()
	ctx = s.WithAuthClaims(ctx, tenantID, partitionID, "test-user")

	db := s.databaseResource(ctx)
	dsn, cleanup, err := db.GetRandomisedDS(ctx, util.RandomAlphaNumericString(8))
	s.Require().NoError(err)
	s.T().Cleanup(func() { cleanup(ctx) })

	ctx, svc := frame.NewServiceWithContext(
		ctx,
		frame.WithName("limits-resvbiz-test"),
		frame.WithDatastore(pool.WithConnection(dsn.String(), false)),
	)
	s.T().Cleanup(func() { svc.Stop(ctx) })
	svc.Init(ctx)

	dbManager := svc.DatastoreManager()
	s.Require().NoError(repository.Migrate(ctx, dbManager, ""))

	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	s.Require().NotNil(dbPool)

	applyRuntimeIndexesForResv(s.T(), dbPool.DB(ctx, false))

	workMan := svc.WorkManager()

	resvRepo := repository.NewReservationRepository(ctx, dbPool, workMan)
	ledgerRepo := repository.NewLedgerRepository(ctx, dbPool, workMan)
	approvalRepo := repository.NewApprovalRequestRepository(ctx, dbPool, workMan)
	candidateRepo := repository.NewCandidatePolicyRepository(dbPool)
	policyRepo := repository.NewPolicyRepository(ctx, dbPool, workMan)
	policyVerRepo := repository.NewPolicyVersionRepository(ctx, dbPool, workMan)
	attrRepo := repository.NewSubjectAttributeRepository(ctx, dbPool, workMan)

	evaluator := business.NewEvaluator(resvRepo, ledgerRepo)
	// nil identity client: attribute resolver falls back to DB-only (no remote calls in tests).
	resolver := business.NewAttributeResolver(attrRepo, nil, 60*time.Second)
	// nil audit writer: audit events are dispatched via the frame events queue which
	// is not set up in unit tests. Audit-row verification is deferred to integration tests.
	auditing := business.NewAuditing(nil)

	biz := business.NewReservationBusiness(
		resvRepo, ledgerRepo, candidateRepo, approvalRepo, policyRepo,
		evaluator, resolver, auditing, dbPool,
	)

	_ = policyVerRepo // used indirectly via Save
	return ctx, biz, dbPool, policyRepo, ledgerRepo
}

// applyRuntimeIndexesForResv reads and applies the SQL migration file
// containing the idempotency unique constraint.
func applyRuntimeIndexesForResv(t *testing.T, db *gorm.DB) {
	t.Helper()
	sqlBytes, err := os.ReadFile("../../migrations/20260506_runtime_indexes.up.sql")
	require.NoError(t, err)

	var noComments strings.Builder
	for _, line := range strings.Split(string(sqlBytes), "\n") {
		trimmed := strings.TrimSpace(line)
		if strings.HasPrefix(trimmed, "--") {
			continue
		}
		noComments.WriteString(line)
		noComments.WriteByte('\n')
	}

	for _, stmt := range strings.Split(noComments.String(), ";") {
		stmt = strings.TrimSpace(stmt)
		if stmt == "" {
			continue
		}
		require.NoError(t, db.Exec(stmt).Error, "failed to execute SQL: %s", stmt)
	}
}

// seedPolicy persists a policy directly via PolicyRepository.Save, bypassing
// version tracking for test simplicity.
func seedPolicy(
	t *testing.T,
	ctx context.Context,
	policyRepo repository.PolicyRepository,
	in *limitsv1.PolicyObject,
) *models.Policy {
	t.Helper()
	p, err := models.PolicyFromAPI(in)
	require.NoError(t, err)
	// Do NOT pre-set ID or Version: Save with an empty ID calls BaseRepository.Create,
	// which stamps tenancy fields, generates an xid, and sets Version=1.
	p.ID = ""
	require.NoError(t, policyRepo.Save(ctx, p))
	require.NotEmpty(t, p.ID, "policy ID must be set by Save")
	saved, err := policyRepo.Get(ctx, p.ID)
	require.NoError(t, err)
	return saved
}

// ─── Intent builders ──────────────────────────────────────────────────

func kesIntent(action limitsv1.LimitAction, units int64) *limitsv1.LimitIntent {
	subjects := subjectsForAction(action)
	return &limitsv1.LimitIntent{
		TenantId: "tenant-a",
		Action:   action,
		Amount:   &moneypb.Money{CurrencyCode: "KES", Units: units, Nanos: 0},
		Subjects: subjects,
		MakerId:  "wf-maker-1",
	}
}

func subjectsForAction(action limitsv1.LimitAction) []*limitsv1.SubjectRef {
	switch action {
	case limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_REQUEST,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_REPAYMENT:
		return []*limitsv1.SubjectRef{
			{Type: limitsv1.SubjectType_SUBJECT_TYPE_CLIENT, Id: "client-1"},
			{Type: limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION, Id: "org-1"},
		}
	case limitsv1.LimitAction_LIMIT_ACTION_SAVINGS_DEPOSIT,
		limitsv1.LimitAction_LIMIT_ACTION_SAVINGS_WITHDRAWAL:
		return []*limitsv1.SubjectRef{
			{Type: limitsv1.SubjectType_SUBJECT_TYPE_CLIENT, Id: "client-1"},
			{Type: limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT, Id: "acct-1"},
		}
	case limitsv1.LimitAction_LIMIT_ACTION_FUNDING_INFLOW,
		limitsv1.LimitAction_LIMIT_ACTION_FUNDING_OUTFLOW:
		return []*limitsv1.SubjectRef{
			{Type: limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION, Id: "org-1"},
		}
	default:
		return []*limitsv1.SubjectRef{
			{Type: limitsv1.SubjectType_SUBJECT_TYPE_CLIENT, Id: "client-1"},
		}
	}
}

func perTxnMaxPolicy(
	currency string,
	capUnits int64,
	mode limitsv1.PolicyMode,
	action limitsv1.LimitAction,
	subjectType limitsv1.SubjectType,
) *limitsv1.PolicyObject {
	return &limitsv1.PolicyObject{
		Scope:         limitsv1.PolicyScope_POLICY_SCOPE_ORG,
		Action:        action,
		SubjectType:   subjectType,
		CurrencyCode:  currency,
		LimitKind:     limitsv1.LimitKind_LIMIT_KIND_PER_TXN_MAX,
		CapAmount:     &moneypb.Money{CurrencyCode: currency, Units: capUnits, Nanos: 0},
		Mode:          mode,
		EffectiveFrom: timestamppb.New(time.Now().Add(-1 * time.Hour).UTC()),
		ApprovalTtl:   durationpb.New(72 * time.Hour),
	}
}

func rollingWindowPolicy(
	currency string,
	capUnits int64,
	windowHours int,
	mode limitsv1.PolicyMode,
	action limitsv1.LimitAction,
	subjectType limitsv1.SubjectType,
) *limitsv1.PolicyObject {
	return &limitsv1.PolicyObject{
		Scope:         limitsv1.PolicyScope_POLICY_SCOPE_ORG,
		Action:        action,
		SubjectType:   subjectType,
		CurrencyCode:  currency,
		LimitKind:     limitsv1.LimitKind_LIMIT_KIND_ROLLING_WINDOW_AMOUNT,
		CapAmount:     &moneypb.Money{CurrencyCode: currency, Units: capUnits, Nanos: 0},
		Window:        durationpb.New(time.Duration(windowHours) * time.Hour),
		Mode:          mode,
		EffectiveFrom: timestamppb.New(time.Now().Add(-1 * time.Hour).UTC()),
		ApprovalTtl:   durationpb.New(72 * time.Hour),
	}
}

// ─── Tests ────────────────────────────────────────────────────────────

// TestReserveHappyPath: per_txn_max cap=1000 KES, intent 500 KES → ACTIVE.
func (s *ReservationBusinessSuite) TestReserveHappyPath() {
	ctx, biz, _, policyRepo, _ := s.resvEnv("tenant-a", "partition-a")

	seedPolicy(s.T(), ctx, policyRepo, perTxnMaxPolicy(
		"KES", 1000, limitsv1.PolicyMode_POLICY_MODE_ENFORCE,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	))

	intent := kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT, 500)
	resp, err := biz.Reserve(ctx, intent, "idem-happy-1", 5*time.Minute)
	s.Require().NoError(err)
	s.Require().NotNil(resp.GetReservation())
	s.Equal(limitsv1.ReservationStatus_RESERVATION_STATUS_ACTIVE, resp.GetReservation().GetStatus())
	s.True(resp.GetCheck().GetAllowed())
	s.False(resp.GetCheck().GetRequiresApproval())
}

// TestReserveHardBreach: per_txn_max cap=1000 KES, intent 2000 KES → FailedPrecondition.
func (s *ReservationBusinessSuite) TestReserveHardBreach() {
	ctx, biz, _, policyRepo, _ := s.resvEnv("tenant-a", "partition-a")

	seedPolicy(s.T(), ctx, policyRepo, perTxnMaxPolicy(
		"KES", 1000, limitsv1.PolicyMode_POLICY_MODE_ENFORCE,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	))

	intent := kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT, 2000)
	resp, err := biz.Reserve(ctx, intent, "idem-breach-1", 5*time.Minute)
	s.Require().Error(err)
	s.Nil(resp)

	var connectErr *connect.Error
	s.Require().ErrorAs(err, &connectErr)
	s.Equal(connect.CodeFailedPrecondition, connectErr.Code())
}

// TestReserveShadowBreach: same policy shape but mode=SHADOW →
// reservation created with is_shadow=true, status ACTIVE.
func (s *ReservationBusinessSuite) TestReserveShadowBreach() {
	ctx, biz, _, policyRepo, _ := s.resvEnv("tenant-a", "partition-a")

	seedPolicy(s.T(), ctx, policyRepo, perTxnMaxPolicy(
		"KES", 1000, limitsv1.PolicyMode_POLICY_MODE_SHADOW,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	))

	intent := kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT, 2000)
	resp, err := biz.Reserve(ctx, intent, "idem-shadow-1", 5*time.Minute)
	s.Require().NoError(err)
	s.Require().NotNil(resp.GetReservation())
	s.Equal(limitsv1.ReservationStatus_RESERVATION_STATUS_ACTIVE, resp.GetReservation().GetStatus())
	s.True(resp.GetReservation().GetIsShadow())
}

// TestReserveRollingWindowUnderCap: rolling 24h cap=1000 KES, pre-seeded 200 KES,
// intent 500 KES → ACTIVE.
func (s *ReservationBusinessSuite) TestReserveRollingWindowUnderCap() {
	ctx, biz, dbPool, policyRepo, ledgerRepo := s.resvEnv("tenant-a", "partition-a")

	seedPolicy(s.T(), ctx, policyRepo, rollingWindowPolicy(
		"KES", 1000, 24, limitsv1.PolicyMode_POLICY_MODE_ENFORCE,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	))

	// Pre-seed a committed ledger entry of 200 KES for client-1.
	seedLedger(s.T(), ctx, ledgerRepo, dbPool, models.ActionLoanDisbursement, "KES", 200, "client")

	intent := kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT, 500)
	resp, err := biz.Reserve(ctx, intent, "idem-rolling-under-1", 5*time.Minute)
	s.Require().NoError(err)
	s.Equal(limitsv1.ReservationStatus_RESERVATION_STATUS_ACTIVE, resp.GetReservation().GetStatus())
}

// TestReserveRollingWindowOverCap: same setup, intent 900 KES → FailedPrecondition.
func (s *ReservationBusinessSuite) TestReserveRollingWindowOverCap() {
	ctx, biz, dbPool, policyRepo, ledgerRepo := s.resvEnv("tenant-a", "partition-a")

	seedPolicy(s.T(), ctx, policyRepo, rollingWindowPolicy(
		"KES", 1000, 24, limitsv1.PolicyMode_POLICY_MODE_ENFORCE,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	))

	// Pre-seed a committed ledger entry of 200 KES for client-1.
	seedLedger(s.T(), ctx, ledgerRepo, dbPool, models.ActionLoanDisbursement, "KES", 200, "client")

	intent := kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT, 900)
	resp, err := biz.Reserve(ctx, intent, "idem-rolling-over-1", 5*time.Minute)
	s.Require().Error(err)
	s.Nil(resp)

	var connectErr *connect.Error
	s.Require().ErrorAs(err, &connectErr)
	s.Equal(connect.CodeFailedPrecondition, connectErr.Code())
}

// TestReserveIdempotencyReplay: second call with same key returns original reservation.
func (s *ReservationBusinessSuite) TestReserveIdempotencyReplay() {
	ctx, biz, _, policyRepo, _ := s.resvEnv("tenant-a", "partition-a")

	seedPolicy(s.T(), ctx, policyRepo, perTxnMaxPolicy(
		"KES", 1000, limitsv1.PolicyMode_POLICY_MODE_ENFORCE,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	))

	intent := kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT, 500)

	resp1, err := biz.Reserve(ctx, intent, "idem-replay-1", 5*time.Minute)
	s.Require().NoError(err)
	s.Require().NotNil(resp1.GetReservation())

	resp2, err := biz.Reserve(ctx, intent, "idem-replay-1", 5*time.Minute)
	s.Require().NoError(err)
	s.Require().NotNil(resp2.GetReservation())

	// Both calls must return the same reservation ID.
	s.Equal(resp1.GetReservation().GetId(), resp2.GetReservation().GetId())
}

// TestReserveIdempotencyConflictDifferentIntent: same key, different action → AlreadyExists.
func (s *ReservationBusinessSuite) TestReserveIdempotencyConflictDifferentIntent() {
	ctx, biz, _, policyRepo, _ := s.resvEnv("tenant-a", "partition-a")

	// Seed policies for both actions.
	seedPolicy(s.T(), ctx, policyRepo, perTxnMaxPolicy(
		"KES", 1000, limitsv1.PolicyMode_POLICY_MODE_ENFORCE,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	))
	seedPolicy(s.T(), ctx, policyRepo, perTxnMaxPolicy(
		"KES", 1000, limitsv1.PolicyMode_POLICY_MODE_ENFORCE,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_REQUEST,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	))

	intent1 := kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT, 500)
	intent2 := kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_REQUEST, 500) // different action

	_, err := biz.Reserve(ctx, intent1, "idem-conflict-1", 5*time.Minute)
	s.Require().NoError(err)

	_, err = biz.Reserve(ctx, intent2, "idem-conflict-1", 5*time.Minute)
	s.Require().Error(err)

	var connectErr *connect.Error
	s.Require().ErrorAs(err, &connectErr)
	s.Equal(connect.CodeAlreadyExists, connectErr.Code())
}

// TestReserveApprovalRequired: per_txn_max with an approver tier; intent over cap →
// PENDING_APPROVAL, ApprovalRequest row created.
func (s *ReservationBusinessSuite) TestReserveApprovalRequired() {
	ctx, biz, dbPool, policyRepo, _ := s.resvEnv("tenant-a", "partition-a")

	// Policy: cap=1000 KES, but allow approval up to 5000 KES.
	polIn := perTxnMaxPolicy(
		"KES", 1000, limitsv1.PolicyMode_POLICY_MODE_ENFORCE,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	)
	polIn.ApproverTiers = []*limitsv1.ApproverTier{
		{UpTo: 500000, Role: "branch_manager", Approvers: 1}, // up to 5000 KES (minor units)
	}
	seedPolicy(s.T(), ctx, policyRepo, polIn)

	intent := kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT, 2000) // 2000 KES > 1000 cap
	resp, err := biz.Reserve(ctx, intent, "idem-approval-1", 5*time.Minute)
	s.Require().NoError(err)
	s.Require().NotNil(resp.GetReservation())
	s.Equal(limitsv1.ReservationStatus_RESERVATION_STATUS_PENDING_APPROVAL, resp.GetReservation().GetStatus())
	s.True(resp.GetCheck().GetRequiresApproval())
	s.Equal(int32(1), resp.GetCheck().GetRequiredApprovers())

	// Verify ApprovalRequest row in DB.
	var count int64
	dbPool.DB(ctx, true).
		Table("limits_approval_requests").
		Where("reservation_id = ?", resp.GetReservation().GetId()).
		Count(&count)
	s.Equal(int64(1), count)
}

// ─── Ledger seed helper ───────────────────────────────────────────────

// seedLedger inserts a committed ledger entry directly to set up rolling-window state.
func seedLedger(
	t *testing.T,
	ctx context.Context,
	ledgerRepo repository.LedgerRepository,
	_ pool.Pool,
	action models.Action,
	currency string,
	amountUnits int64,
	subjectType string,
) {
	t.Helper()
	entry := &models.LedgerEntry{
		ReservationID: "seed-resv-" + util.IDString(),
		Action:        action,
		SubjectType:   models.Subject(subjectType),
		SubjectID:     "client-1",
		CurrencyCode:  currency,
		Amount:        amountUnits * 100, // minor units: KES has 2 decimal places
		CommittedAt:   time.Now().UTC(),
	}
	require.NoError(t, ledgerRepo.CreateBatch(ctx, []*models.LedgerEntry{entry}))
}

func TestReservationBusinessSuite(t *testing.T) {
	suite.Run(t, new(ReservationBusinessSuite))
}

# Limits Service — Consumer Integration (Loans Canary) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `pkg/limits.Gate` and the outbox worker functional, then wire `loans.DisbursementCreate` to call `Gate` behind a per-action env flag. The canary integration; other consumer services replay the pattern in follow-on plans.

**Architecture:** Three principles, each correcting Plan 1's stub-era choices:

1. **`pkg/limits` is a thin helper** — no `Client` interface, no `NewClient` factory, no client-construction concerns. The package exposes `Gate(ctx, rpc, intent, idempotencyKey, handler)` as a free function and the typed errors callers may inspect (`PendingApprovalError`, `LimitBreachedError`). Consumers build their `limitsv1connect.LimitsServiceClient` the same way they build any other Connect client (`connection.NewServiceClient` from `antinvestor/common`) and pass it into `Gate` and into the outbox worker.
2. **`pkg/limits/outbox` is a durable Commit/Release queue** — `Repository.ClaimDue` uses `FOR UPDATE SKIP LOCKED` so multiple worker pods drain concurrently. `Worker.Run` polls every 5s, retries with exponential backoff (30s × 2^attempt, capped at 1h), dead-letters at attempt 10. Worker takes the raw `limitsv1connect.LimitsServiceClient`.
3. **`apps/loans` integrates via the standard service-client pattern** — `setupLimitsClient(ctx, cfg)` mirrors the existing `setupOperationsClient`, `setupFundingClient`, `setupNotificationClient`. `DisbursementBusiness` takes `limitsv1connect.LimitsServiceClient` (just like it already takes the operations client). The Gate call is opt-in behind `LIMITS_GATE_ENABLED_LOAN_DISBURSEMENT` (default off).

**Tech Stack:** Go 1.26, `github.com/pitabwire/frame` v1.94.6, `github.com/antinvestor/common` connection helpers, Connect RPC, `pitabwire/util/money`, GORM via `data.BaseModel`, Postgres, testcontainers.

**Spec:** `docs/superpowers/specs/2026-05-05-fintech-limits-design.md` §6.1 (Gate semantics), §6.2 (outbox), §6.3 row 1 (`LOAN_DISBURSEMENT`), §10 phase 4.

**Prerequisite:** `milestone/limits-runtime-and-approvals` deployed and reachable.

**Out of scope:** Other 10 consumer integrations; shadow→enforce flip; consumer approval-resume subscribers.

---

## File Structure

### Modified files

```
pkg/limits/client.go                                     — DELETED (Client interface drops; Gate becomes free function)
pkg/limits/gate.go                                       — new: free Gate function
pkg/limits/gate_test.go                                  — new
pkg/limits/errors.go                                     — keep PendingApprovalError, LimitBreachedError; drop ErrUnimplemented
pkg/limits/outbox/repository.go                          — implement ClaimDue
pkg/limits/outbox/repository_test.go                     — new
pkg/limits/outbox/worker.go                              — implement Run drain loop, take raw connectrpc client
pkg/limits/outbox/worker_test.go                         — new

apps/loans/config/config.go                              — add LimitsServiceURI / WorkloadAPITargetPath / GateEnabled flag
apps/loans/service/repository/migrate.go                 — add &outbox.Row{} to migrate slice
apps/loans/cmd/main.go                                   — setupLimitsClient + outbox worker; pass into DisbursementBusiness
apps/loans/service/business/disbursement.go              — Gate-wrap Create when flag is on
apps/loans/service/business/disbursement_test.go         — extend with stub-rpc tests for Gate paths
apps/loans/Dockerfile                                    — verify pkg/ ships
```

### New files

```
apps/loans/migrations/20260506_limits_outbox.up.sql      — partial index
apps/loans/migrations/20260506_limits_outbox.down.sql
apps/loans/tests/integration/disbursement_gate_test.go   — end-to-end test
```

---

## Task 1: Replace `pkg/limits.Client` with a free `Gate` function

**Files:**
- Delete: `pkg/limits/client.go`
- Create: `pkg/limits/gate.go`
- Create: `pkg/limits/gate_test.go`
- Modify: `pkg/limits/errors.go` (drop `ErrUnimplemented`)

The `Client` interface from Plan 1 baked client-construction into `pkg/limits`. The corrected design: `pkg/limits` only owns the Gate composition logic. Consumers pass in their already-constructed `limitsv1connect.LimitsServiceClient` (built via `connection.NewServiceClient` like every other Connect client in the repo).

- [ ] **Step 1.1: Delete `pkg/limits/client.go`**

```bash
rm pkg/limits/client.go
```

- [ ] **Step 1.2: Update `pkg/limits/errors.go`**

Drop `ErrUnimplemented` (no more stubs). Keep `PendingApprovalError` and `LimitBreachedError`.

```go
// (Apache 2.0 header — keep)

// Package limits provides a thin helper around the limits.v1 LimitsService
// for consumer services. The Gate helper composes Reserve → handler →
// Commit/Release; the typed errors below let callers distinguish gating
// outcomes from infrastructure errors.
package limits

import (
	"fmt"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
)

// PendingApprovalError is returned by Gate when Reserve produces a
// PENDING_APPROVAL reservation. The caller is expected to persist its
// own local row in a pending state and await the limits.approval.* event.
type PendingApprovalError struct {
	ReservationID string
	Verdicts      []*limitsv1.PolicyVerdict
}

func (e *PendingApprovalError) Error() string {
	return fmt.Sprintf("limits: reservation %s pending approval", e.ReservationID)
}

// LimitBreachedError indicates the gate denied the action because at
// least one enforce-mode policy is breached and not eligible for approval.
type LimitBreachedError struct {
	Verdicts []*limitsv1.PolicyVerdict
}

func (e *LimitBreachedError) Error() string {
	if len(e.Verdicts) == 0 {
		return "limits: cap breached"
	}
	return fmt.Sprintf("limits: cap breached (%d policies)", len(e.Verdicts))
}
```

- [ ] **Step 1.3: Write the failing tests**

```go
// pkg/limits/gate_test.go
// (Apache 2.0 license header — copy verbatim from apps/savings/cmd/main.go:1-13)

package limits_test

import (
	"context"
	"errors"
	"testing"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/antinvestor/service-fintech/pkg/limits"
)

// stubLimitsClient implements limitsv1connect.LimitsServiceClient. Each
// method records its call and returns the configured response/error.
type stubLimitsClient struct {
	checkResp    *limitsv1.CheckResponse
	checkErr     error
	reserveResp  *limitsv1.ReserveResponse
	reserveErr   error
	commitResp   *limitsv1.CommitResponse
	commitErr    error
	releaseResp  *limitsv1.ReleaseResponse
	releaseErr   error
	reverseResp  *limitsv1.ReverseResponse
	reverseErr   error
	checkCalls   int
	reserveCalls int
	commitCalls  int
	releaseCalls int
	reverseCalls int
}

func (s *stubLimitsClient) Check(ctx context.Context, req *connect.Request[limitsv1.CheckRequest]) (*connect.Response[limitsv1.CheckResponse], error) {
	s.checkCalls++
	if s.checkErr != nil {
		return nil, s.checkErr
	}
	return connect.NewResponse(s.checkResp), nil
}

func (s *stubLimitsClient) Reserve(ctx context.Context, req *connect.Request[limitsv1.ReserveRequest]) (*connect.Response[limitsv1.ReserveResponse], error) {
	s.reserveCalls++
	if s.reserveErr != nil {
		return nil, s.reserveErr
	}
	return connect.NewResponse(s.reserveResp), nil
}

func (s *stubLimitsClient) Commit(ctx context.Context, req *connect.Request[limitsv1.CommitRequest]) (*connect.Response[limitsv1.CommitResponse], error) {
	s.commitCalls++
	if s.commitErr != nil {
		return nil, s.commitErr
	}
	return connect.NewResponse(s.commitResp), nil
}

func (s *stubLimitsClient) Release(ctx context.Context, req *connect.Request[limitsv1.ReleaseRequest]) (*connect.Response[limitsv1.ReleaseResponse], error) {
	s.releaseCalls++
	if s.releaseErr != nil {
		return nil, s.releaseErr
	}
	return connect.NewResponse(s.releaseResp), nil
}

func (s *stubLimitsClient) Reverse(ctx context.Context, req *connect.Request[limitsv1.ReverseRequest]) (*connect.Response[limitsv1.ReverseResponse], error) {
	s.reverseCalls++
	if s.reverseErr != nil {
		return nil, s.reverseErr
	}
	return connect.NewResponse(s.reverseResp), nil
}

// Compile-time interface check.
var _ limitsv1connect.LimitsServiceClient = (*stubLimitsClient)(nil)

func TestGate_HappyPath_CallsCommitOnSuccess(t *testing.T) {
	stub := &stubLimitsClient{
		reserveResp: &limitsv1.ReserveResponse{
			Reservation: &limitsv1.ReservationObject{
				Id:     "res-1",
				Status: limitsv1.ReservationStatus_RESERVATION_STATUS_ACTIVE,
			},
		},
		commitResp: &limitsv1.CommitResponse{
			Reservation: &limitsv1.ReservationObject{Status: limitsv1.ReservationStatus_RESERVATION_STATUS_COMMITTED},
		},
	}
	called := false
	err := limits.Gate(context.Background(), stub, &limitsv1.LimitIntent{}, "idem-1",
		func(ctx context.Context, reservationID string) error {
			called = true
			assert.Equal(t, "res-1", reservationID)
			return nil
		})
	require.NoError(t, err)
	assert.True(t, called, "handler must be invoked")
	assert.Equal(t, 1, stub.reserveCalls)
	assert.Equal(t, 1, stub.commitCalls)
	assert.Equal(t, 0, stub.releaseCalls)
}

func TestGate_HandlerError_CallsRelease(t *testing.T) {
	stub := &stubLimitsClient{
		reserveResp: &limitsv1.ReserveResponse{
			Reservation: &limitsv1.ReservationObject{
				Id:     "res-1",
				Status: limitsv1.ReservationStatus_RESERVATION_STATUS_ACTIVE,
			},
		},
		releaseResp: &limitsv1.ReleaseResponse{
			Reservation: &limitsv1.ReservationObject{Status: limitsv1.ReservationStatus_RESERVATION_STATUS_RELEASED},
		},
	}
	handlerErr := errors.New("local DB write failed")
	err := limits.Gate(context.Background(), stub, &limitsv1.LimitIntent{}, "idem-1",
		func(ctx context.Context, reservationID string) error {
			return handlerErr
		})
	require.ErrorIs(t, err, handlerErr)
	assert.Equal(t, 1, stub.reserveCalls)
	assert.Equal(t, 0, stub.commitCalls)
	assert.Equal(t, 1, stub.releaseCalls)
}

func TestGate_PendingApproval_ReturnsTypedError(t *testing.T) {
	verdict := &limitsv1.PolicyVerdict{
		PolicyId: "pol-1", WouldRequireApproval: true, Reason: "amount above max",
	}
	stub := &stubLimitsClient{
		reserveResp: &limitsv1.ReserveResponse{
			Reservation: &limitsv1.ReservationObject{
				Id:     "res-1",
				Status: limitsv1.ReservationStatus_RESERVATION_STATUS_PENDING_APPROVAL,
			},
			Check: &limitsv1.CheckResponse{Verdicts: []*limitsv1.PolicyVerdict{verdict}},
		},
	}
	called := false
	err := limits.Gate(context.Background(), stub, &limitsv1.LimitIntent{}, "idem-1",
		func(ctx context.Context, reservationID string) error {
			called = true
			return nil
		})
	require.Error(t, err)
	var pendingErr *limits.PendingApprovalError
	require.ErrorAs(t, err, &pendingErr)
	assert.Equal(t, "res-1", pendingErr.ReservationID)
	assert.Len(t, pendingErr.Verdicts, 1)
	assert.False(t, called, "handler must NOT run when reservation is pending approval")
	assert.Equal(t, 0, stub.commitCalls)
	assert.Equal(t, 0, stub.releaseCalls)
}

func TestGate_ReserveError_PropagatesAndDoesNotCallHandler(t *testing.T) {
	stub := &stubLimitsClient{reserveErr: errors.New("limits unavailable")}
	called := false
	err := limits.Gate(context.Background(), stub, &limitsv1.LimitIntent{}, "idem-1",
		func(ctx context.Context, reservationID string) error {
			called = true
			return nil
		})
	require.Error(t, err)
	assert.Contains(t, err.Error(), "limits unavailable")
	assert.False(t, called)
	assert.Equal(t, 0, stub.commitCalls)
	assert.Equal(t, 0, stub.releaseCalls)
}

func TestGate_NilClient_Errors(t *testing.T) {
	err := limits.Gate(context.Background(), nil, &limitsv1.LimitIntent{}, "idem-1",
		func(ctx context.Context, reservationID string) error { return nil })
	require.Error(t, err)
}
```

- [ ] **Step 1.4: Run tests — expect FAIL (Gate function doesn't exist yet)**

```bash
go test ./pkg/limits/...
```

- [ ] **Step 1.5: Implement `pkg/limits/gate.go`**

```go
// (Apache 2.0 license header)

package limits

import (
	"context"
	"errors"
	"fmt"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/util"
)

// Gate runs the standard Reserve → handler → Commit/Release lifecycle
// against the supplied limits Connect client. The handler is invoked
// only when the reservation is ACTIVE; PENDING_APPROVAL and Reserve
// errors short-circuit before the handler runs.
//
// Behaviour:
//   - Reserve error  → Gate returns the error verbatim. Handler is NOT called.
//   - PENDING_APPROVAL → Gate returns *PendingApprovalError. Handler is NOT called.
//                       Caller is expected to persist a local pending row and
//                       resume via the limits.approval.* event when approval lands.
//   - ACTIVE → handler is invoked.
//       - Handler success → Gate calls Commit synchronously, returns nil
//                           (or returns the Commit error if it fails;
//                           reconciliation closes the gap).
//       - Handler error → Gate calls Release synchronously and returns the
//                         handler's error. Release errors are logged.
//
// Outbox-driven Commit (see pkg/limits/outbox) is a separate path; callers
// that need durable Commit-after-local-tx should write an outbox row in
// their own transaction and let the outbox.Worker drive Commit. Gate's
// synchronous Commit is the simpler default.
func Gate(
	ctx context.Context,
	rpc limitsv1connect.LimitsServiceClient,
	intent *limitsv1.LimitIntent,
	idempotencyKey string,
	handler func(ctx context.Context, reservationID string) error,
) error {
	if rpc == nil {
		return errors.New("limits.Gate: nil rpc client")
	}
	if handler == nil {
		return errors.New("limits.Gate: nil handler")
	}

	res, err := rpc.Reserve(ctx, connect.NewRequest(&limitsv1.ReserveRequest{
		Intent:         intent,
		IdempotencyKey: idempotencyKey,
	}))
	if err != nil {
		return err
	}

	reservation := res.Msg.GetReservation()
	if reservation == nil {
		return errors.New("limits.Gate: Reserve returned no reservation")
	}

	switch reservation.GetStatus() {
	case limitsv1.ReservationStatus_RESERVATION_STATUS_PENDING_APPROVAL:
		var verdicts []*limitsv1.PolicyVerdict
		if check := res.Msg.GetCheck(); check != nil {
			verdicts = check.GetVerdicts()
		}
		return &PendingApprovalError{ReservationID: reservation.GetId(), Verdicts: verdicts}
	case limitsv1.ReservationStatus_RESERVATION_STATUS_ACTIVE:
		// Continue.
	default:
		return fmt.Errorf("limits.Gate: unexpected reservation status %s", reservation.GetStatus())
	}

	if handlerErr := handler(ctx, reservation.GetId()); handlerErr != nil {
		if _, releaseErr := rpc.Release(ctx, connect.NewRequest(&limitsv1.ReleaseRequest{
			ReservationId: reservation.GetId(),
			Reason:        handlerErr.Error(),
		})); releaseErr != nil {
			util.Log(ctx).WithError(releaseErr).
				With("reservation_id", reservation.GetId()).
				Error("limits.Gate: Release failed after handler error; relying on TTL reaper")
		}
		return handlerErr
	}

	if _, commitErr := rpc.Commit(ctx, connect.NewRequest(&limitsv1.CommitRequest{
		ReservationId: reservation.GetId(),
	})); commitErr != nil {
		util.Log(ctx).WithError(commitErr).
			With("reservation_id", reservation.GetId()).
			Error("limits.Gate: Commit failed after handler success — reconciliation gap")
		return commitErr
	}
	return nil
}
```

- [ ] **Step 1.6: Run tests — expect PASS**

```bash
go test -race ./pkg/limits/...
```

Expected: 5 of 5 Gate tests PASS. (Outbox tests still pass since they don't depend on the deleted `Client` interface.)

- [ ] **Step 1.7: Commit**

```bash
git add pkg/limits/
git commit -m "refactor(limits): make Gate a free function over the connectrpc client

Drops the bespoke Client interface that wrapped construction into the
package. Consumers build their limitsv1connect.LimitsServiceClient via
the standard connection.NewServiceClient helper from antinvestor/common
(same pattern as operations/funding/notification clients) and pass it
directly into limits.Gate. pkg/limits stays focused on the Gate
composition + typed errors."
```

---

## Task 2: Implement outbox `Repository.ClaimDue`

**Files:**
- Modify: `pkg/limits/outbox/repository.go`
- Create: `pkg/limits/outbox/repository_test.go`

`ClaimDue` selects up to `batchSize` rows where `status='pending'` and `next_attempt_at <= now()`, locking them with `FOR UPDATE SKIP LOCKED` so multiple worker pods don't double-process.

- [ ] **Step 2.1: Write the failing test**

```go
// pkg/limits/outbox/repository_test.go
// (Apache 2.0 license header)

package outbox_test

import (
	"context"
	"testing"
	"time"

	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/frametests"
	"github.com/pitabwire/frame/frametests/definition"
	testpostgres "github.com/pitabwire/frame/frametests/deps/testpostgres"
	"github.com/stretchr/testify/suite"

	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

type OutboxRepoSuite struct {
	frametests.FrameBaseTestSuite
	repo outbox.Repository
	svc  *frame.Service
	ctx  context.Context
}

func (s *OutboxRepoSuite) SetupSuite() {
	s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
		return []definition.TestResource{
			testpostgres.NewWithOpts("outbox_test", definition.WithUserName("test")),
		}
	}
	s.FrameBaseTestSuite.SetupSuite()
}

func (s *OutboxRepoSuite) SetupTest() {
	ctx := s.T().Context()
	dsn, _, _ := s.GetDS(ctx, 0)
	ctx, svc := frame.NewServiceWithContext(ctx,
		frame.WithDatastore(pool.WithConnection(dsn.String(), false)))
	s.svc, s.ctx = svc, ctx

	dbPool := svc.DatastoreManager().GetPool(ctx, datastore.DefaultPoolName)
	require := s.Require()
	require.NoError(svc.DatastoreManager().Migrate(ctx, dbPool, "", &outbox.Row{}))
	s.repo = outbox.NewRepository(ctx, dbPool, svc.WorkManager())
}

func (s *OutboxRepoSuite) ctxFor(tenant string) context.Context {
	return s.WithAuthClaims(s.ctx, tenant, "p-1", "wf-1")
}

func sampleRow(reservationID string, action outbox.Action, due time.Time) *outbox.Row {
	return &outbox.Row{
		ReservationID: reservationID,
		Action:        action,
		Status:        outbox.StatusPending,
		Attempt:       0,
		NextAttemptAt: due,
	}
}

func (s *OutboxRepoSuite) TestClaimDue_DueRowsReturned() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	due := sampleRow("res-1", outbox.ActionCommit, now.Add(-1*time.Minute))
	notYet := sampleRow("res-2", outbox.ActionCommit, now.Add(1*time.Minute))
	s.Require().NoError(s.repo.Insert(ctx, due))
	s.Require().NoError(s.repo.Insert(ctx, notYet))

	rows, err := s.repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Len(rows, 1)
	s.Equal(due.ID, rows[0].ID)
}

func (s *OutboxRepoSuite) TestClaimDue_RespectsBatchSize() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	for i := 0; i < 5; i++ {
		s.Require().NoError(s.repo.Insert(ctx, sampleRow("res-x", outbox.ActionCommit, now.Add(-1*time.Minute))))
	}
	rows, err := s.repo.ClaimDue(ctx, 3)
	s.Require().NoError(err)
	s.Len(rows, 3)
}

func (s *OutboxRepoSuite) TestClaimDue_SkipsTerminal() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	row := sampleRow("res-1", outbox.ActionCommit, now.Add(-1*time.Minute))
	row.Status = outbox.StatusDone
	s.Require().NoError(s.repo.Insert(ctx, row))
	rows, err := s.repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Empty(rows)
}

func (s *OutboxRepoSuite) TestMarkRetry_DefersFutureClaim() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	row := sampleRow("res-1", outbox.ActionCommit, now.Add(-1*time.Minute))
	s.Require().NoError(s.repo.Insert(ctx, row))
	nextAt := now.Add(30 * time.Second)
	s.Require().NoError(s.repo.MarkRetry(ctx, row.ID, "transient", nextAt))

	rows, err := s.repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Empty(rows, "row's NextAttemptAt is in the future after retry mark")
}

func TestOutboxRepoSuite(t *testing.T) { suite.Run(t, new(OutboxRepoSuite)) }
```

- [ ] **Step 2.2: Run test — expect FAIL**

`ClaimDue` returns `nil, nil` from the Plan 1 stub.

- [ ] **Step 2.3: Implement `ClaimDue`**

In `pkg/limits/outbox/repository.go`:

```go
func (r *repository) ClaimDue(ctx context.Context, batchSize int) ([]*Row, error) {
	if batchSize <= 0 {
		batchSize = 100
	}
	db := r.dbPool.DB(ctx, false)
	var rows []*Row
	err := db.Raw(
		`SELECT * FROM limits_outbox
		 WHERE status = ? AND next_attempt_at <= ? AND deleted_at IS NULL
		 ORDER BY next_attempt_at ASC
		 LIMIT ?
		 FOR UPDATE SKIP LOCKED`,
		string(StatusPending), time.Now().UTC(), batchSize,
	).Scan(&rows).Error
	return rows, err
}
```

(If the existing `repository` struct lacks a `dbPool` field, add one and capture it in `NewRepository`. Verify by reading the current file first.)

- [ ] **Step 2.4: Run tests — expect PASS**

```bash
go test -race ./pkg/limits/outbox/...
```

Expected: 4 tests PASS.

- [ ] **Step 2.5: Commit**

```bash
git add pkg/limits/outbox/
git commit -m "feat(limits/outbox): implement ClaimDue with FOR UPDATE SKIP LOCKED

Workers across multiple replicas can drain concurrently without
double-processing. Honours next_attempt_at so retried rows aren't
prematurely re-claimed."
```

---

## Task 3: Implement outbox `Worker.Run` (taking raw connectrpc client)

**Files:**
- Modify: `pkg/limits/outbox/worker.go`
- Create: `pkg/limits/outbox/worker_test.go`

The worker takes `limitsv1connect.LimitsServiceClient` directly — same pattern as `Gate`. No bespoke `Client` interface.

Loop: every `pollInterval` (default 5s), claim a batch, process each row (call `Commit` or `Release` based on `row.Action`), mark done on success, retry with exponential backoff, dead-letter at attempt ≥ 10.

- [ ] **Step 3.1: Write failing tests**

```go
// pkg/limits/outbox/worker_test.go
// (Apache 2.0 header)

package outbox_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"

	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

// stubRPC implements limitsv1connect.LimitsServiceClient with just the
// Commit / Release methods exercised by the worker.
type stubRPC struct {
	commitErr  error
	releaseErr error
	commits    []string
	releases   []releaseCall
}

type releaseCall struct {
	id     string
	reason string
}

func (s *stubRPC) Check(ctx context.Context, _ *connect.Request[limitsv1.CheckRequest]) (*connect.Response[limitsv1.CheckResponse], error) {
	return connect.NewResponse(&limitsv1.CheckResponse{}), nil
}
func (s *stubRPC) Reserve(ctx context.Context, _ *connect.Request[limitsv1.ReserveRequest]) (*connect.Response[limitsv1.ReserveResponse], error) {
	return connect.NewResponse(&limitsv1.ReserveResponse{}), nil
}
func (s *stubRPC) Commit(ctx context.Context, req *connect.Request[limitsv1.CommitRequest]) (*connect.Response[limitsv1.CommitResponse], error) {
	if s.commitErr != nil {
		return nil, s.commitErr
	}
	s.commits = append(s.commits, req.Msg.GetReservationId())
	return connect.NewResponse(&limitsv1.CommitResponse{}), nil
}
func (s *stubRPC) Release(ctx context.Context, req *connect.Request[limitsv1.ReleaseRequest]) (*connect.Response[limitsv1.ReleaseResponse], error) {
	if s.releaseErr != nil {
		return nil, s.releaseErr
	}
	s.releases = append(s.releases, releaseCall{id: req.Msg.GetReservationId(), reason: req.Msg.GetReason()})
	return connect.NewResponse(&limitsv1.ReleaseResponse{}), nil
}
func (s *stubRPC) Reverse(ctx context.Context, _ *connect.Request[limitsv1.ReverseRequest]) (*connect.Response[limitsv1.ReverseResponse], error) {
	return connect.NewResponse(&limitsv1.ReverseResponse{}), nil
}

var _ limitsv1connect.LimitsServiceClient = (*stubRPC)(nil)

type WorkerSuite struct {
	OutboxRepoSuite
	rpc *stubRPC
}

func (s *WorkerSuite) SetupTest() {
	s.OutboxRepoSuite.SetupTest()
	s.rpc = &stubRPC{}
}

func (s *WorkerSuite) TestWorker_DrainsCommitRow() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	row := &outbox.Row{
		ReservationID: "res-1", Action: outbox.ActionCommit,
		Status: outbox.StatusPending, NextAttemptAt: now.Add(-1 * time.Minute),
	}
	s.Require().NoError(s.repo.Insert(ctx, row))

	w := outbox.NewWorker(s.repo, s.rpc)
	require.NoError(s.T(), w.RunOnce(ctx))
	assert.Equal(s.T(), []string{"res-1"}, s.rpc.commits)
}

func (s *WorkerSuite) TestWorker_DrainsReleaseRow() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	row := &outbox.Row{
		ReservationID: "res-2", Action: outbox.ActionRelease, Reason: "user cancelled",
		Status: outbox.StatusPending, NextAttemptAt: now.Add(-1 * time.Minute),
	}
	s.Require().NoError(s.repo.Insert(ctx, row))

	w := outbox.NewWorker(s.repo, s.rpc)
	require.NoError(s.T(), w.RunOnce(ctx))
	require.Len(s.T(), s.rpc.releases, 1)
	assert.Equal(s.T(), "res-2", s.rpc.releases[0].id)
	assert.Equal(s.T(), "user cancelled", s.rpc.releases[0].reason)
}

func (s *WorkerSuite) TestWorker_RetriesOnTransientError() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	row := &outbox.Row{
		ReservationID: "res-3", Action: outbox.ActionCommit,
		Status: outbox.StatusPending, NextAttemptAt: now.Add(-1 * time.Minute),
	}
	s.Require().NoError(s.repo.Insert(ctx, row))

	s.rpc.commitErr = errors.New("network blip")
	w := outbox.NewWorker(s.repo, s.rpc)
	require.NoError(s.T(), w.RunOnce(ctx))

	rows, err := s.repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Empty(rows, "row's next_attempt_at bumped into the future after failure")
}

func (s *WorkerSuite) TestWorker_DeadAfterMaxAttempts() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	row := &outbox.Row{
		ReservationID: "res-4", Action: outbox.ActionCommit,
		Status: outbox.StatusPending, Attempt: 9,
		NextAttemptAt: now.Add(-1 * time.Minute),
	}
	s.Require().NoError(s.repo.Insert(ctx, row))

	s.rpc.commitErr = errors.New("persistently broken")
	w := outbox.NewWorker(s.repo, s.rpc)
	require.NoError(s.T(), w.RunOnce(ctx))

	rows, err := s.repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Empty(rows, "row was dead-lettered after attempt 10")
}

func TestWorkerSuite(t *testing.T) { suite.Run(t, new(WorkerSuite)) }
```

- [ ] **Step 3.2: Replace `worker.go`**

```go
// (Apache 2.0 license header — keep)

package outbox

import (
	"context"
	"errors"
	"time"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/util"
)

const (
	defaultPollInterval = 5 * time.Second
	defaultBatchSize    = 100
	maxAttempts         = 10
)

// Worker drains pending outbox rows and invokes the corresponding limits
// RPC. Wired up in each consumer service's main.go via Frame's WorkerPool
// or via a long-lived goroutine — Run blocks until ctx is cancelled.
type Worker struct {
	repo     Repository
	rpc      limitsv1connect.LimitsServiceClient
	interval time.Duration
	batch    int
}

func NewWorker(repo Repository, rpc limitsv1connect.LimitsServiceClient) *Worker {
	return &Worker{repo: repo, rpc: rpc, interval: defaultPollInterval, batch: defaultBatchSize}
}

// Run loops every pollInterval until ctx is cancelled, draining one
// batch of due outbox rows per tick.
func (w *Worker) Run(ctx context.Context) error {
	t := time.NewTicker(w.interval)
	defer t.Stop()
	for {
		select {
		case <-ctx.Done():
			if err := ctx.Err(); err != nil && !errors.Is(err, context.Canceled) {
				return err
			}
			return nil
		case <-t.C:
			if err := w.RunOnce(ctx); err != nil {
				util.Log(ctx).WithError(err).Error("limits outbox: drain pass failed")
			}
		}
	}
}

// RunOnce drains a single batch. Exposed for tests and external schedulers.
func (w *Worker) RunOnce(ctx context.Context) error {
	rows, err := w.repo.ClaimDue(ctx, w.batch)
	if err != nil {
		return err
	}
	for _, row := range rows {
		w.processRow(ctx, row)
	}
	return nil
}

func (w *Worker) processRow(ctx context.Context, row *Row) {
	log := util.Log(ctx).
		With("outbox_id", row.ID).
		With("reservation_id", row.ReservationID).
		With("action", string(row.Action))

	var rpcErr error
	switch row.Action {
	case ActionCommit:
		_, rpcErr = w.rpc.Commit(ctx, connect.NewRequest(&limitsv1.CommitRequest{
			ReservationId: row.ReservationID,
		}))
	case ActionRelease:
		_, rpcErr = w.rpc.Release(ctx, connect.NewRequest(&limitsv1.ReleaseRequest{
			ReservationId: row.ReservationID,
			Reason:        row.Reason,
		}))
	default:
		log.Error("limits outbox: unknown action; marking dead")
		_ = w.repo.MarkDead(ctx, row.ID, "unknown action: "+string(row.Action))
		return
	}

	if rpcErr == nil {
		if err := w.repo.MarkDone(ctx, row.ID); err != nil {
			log.WithError(err).Error("limits outbox: MarkDone failed")
		}
		return
	}

	if row.Attempt+1 >= maxAttempts {
		log.WithError(rpcErr).With("attempt", row.Attempt+1).Error("limits outbox: max attempts reached; dead-letter")
		_ = w.repo.MarkDead(ctx, row.ID, rpcErr.Error())
		return
	}

	// Exponential backoff: 30s × 2^attempt, capped at 1h.
	backoff := time.Duration(30) * time.Second
	for i := 0; i < row.Attempt && backoff < time.Hour; i++ {
		backoff *= 2
	}
	if backoff > time.Hour {
		backoff = time.Hour
	}
	nextAt := time.Now().Add(backoff).UTC()
	if err := w.repo.MarkRetry(ctx, row.ID, rpcErr.Error(), nextAt); err != nil {
		log.WithError(err).Error("limits outbox: MarkRetry failed")
	}
}
```

- [ ] **Step 3.3: Run tests**

```bash
go test -race -timeout=180s ./pkg/limits/...
```

Expected: PASS for all repo + worker tests.

- [ ] **Step 3.4: Commit**

```bash
git add pkg/limits/outbox/
git commit -m "feat(limits/outbox): Worker.Run drains via raw connectrpc client

Worker takes limitsv1connect.LimitsServiceClient directly (no
intermediate wrapper). Polls every 5s, claims up to 100 rows via
FOR UPDATE SKIP LOCKED. Failures retry with exponential backoff
(30s × 2^attempt, capped at 1h); dead-letter at attempt 10."
```

---

## Task 4: Loans config — env flags

**Files:**
- Modify: `apps/loans/config/config.go`

Mirror the existing operations/funding/notification client config: each gets an `Endpoint` and a `WorkloadAPITargetPath`. Plus the per-action gate flag.

- [ ] **Step 4.1: Read existing config**

```bash
cat apps/loans/config/config.go
```

Identify the existing fields like `OperationsServiceURI`, `OperationsServiceWorkloadAPITargetPath`. Mirror them for limits.

- [ ] **Step 4.2: Append the fields**

```go
// Inside the existing LoanManagementConfig struct:
LimitsServiceURI                  string `envDefault:"http://service_limits:80" env:"LIMITS_SERVICE_URI"`
LimitsServiceWorkloadAPITargetPath string `envDefault:""                          env:"LIMITS_SERVICE_WORKLOAD_API_TARGET_PATH"`
LimitsGateEnabledLoanDisbursement bool   `envDefault:"false"                     env:"LIMITS_GATE_ENABLED_LOAN_DISBURSEMENT"`
```

(Match the env-tag style of the surrounding fields. If the file uses `envconfig` style, mirror that.)

- [ ] **Step 4.3: Build + commit**

```bash
go build ./apps/loans/...
git add apps/loans/config/config.go
git commit -m "feat(loans): add LIMITS_SERVICE_URI / WORKLOAD_API_TARGET_PATH / GATE_ENABLED env flags

Mirrors the operations/funding/notification client config shape so the
limits client can be built via the standard connection.NewServiceClient
helper. LIMITS_GATE_ENABLED_LOAN_DISBURSEMENT defaults false; flipping
on causes DisbursementBusiness.Create to wrap its pipeline in
limits.Gate."
```

---

## Task 5: Loans migration — `limits_outbox` table

**Files:**
- Modify: `apps/loans/service/repository/migrate.go`
- Create: `apps/loans/migrations/20260506_limits_outbox.up.sql`
- Create: `apps/loans/migrations/20260506_limits_outbox.down.sql`

- [ ] **Step 5.1: Add `&outbox.Row{}` to the migrate slice**

In the existing `Migrate` function, append `&outbox.Row{}` to the model slice and add the import:

```go
import (
    // existing imports...
    "github.com/antinvestor/service-fintech/pkg/limits/outbox"
)
```

- [ ] **Step 5.2: Write `20260506_limits_outbox.up.sql`**

```sql
-- Outbox claim hot-path index (workers issue WHERE status='pending' AND next_attempt_at <= now()).
CREATE INDEX IF NOT EXISTS idx_limits_outbox_pending_due
ON limits_outbox (next_attempt_at)
WHERE status = 'pending' AND deleted_at IS NULL;

-- Reservation lookup for cross-checking (reconciliation queries).
CREATE INDEX IF NOT EXISTS idx_limits_outbox_reservation
ON limits_outbox (reservation_id)
WHERE deleted_at IS NULL;
```

- [ ] **Step 5.3: Write `20260506_limits_outbox.down.sql`**

```sql
DROP INDEX IF EXISTS idx_limits_outbox_pending_due;
DROP INDEX IF EXISTS idx_limits_outbox_reservation;
```

- [ ] **Step 5.4: Build + run loans repository tests**

```bash
go build ./apps/loans/...
go test -race -timeout=180s ./apps/loans/service/repository/...
```

Expected: PASS — existing tests still green; outbox table is created in the test container.

- [ ] **Step 5.5: Commit**

```bash
git add apps/loans/service/repository/migrate.go apps/loans/migrations/
git commit -m "feat(loans): add limits_outbox table to migrations

Loans runs an outbox worker draining pending Commit/Release events to
the limits service. Partial index on pending+due rows keeps the worker's
claim query fast."
```

---

## Task 6: Loans main.go — `setupLimitsClient` + outbox worker + business wiring

**Files:**
- Modify: `apps/loans/cmd/main.go`

- [ ] **Step 6.1: Read current main.go for the `setupOperationsClient` shape**

```bash
grep -B1 -A12 "func setupOperationsClient\|func setupFundingClient\|func setupNotificationClient" apps/loans/cmd/main.go
```

The pattern is:

```go
func setupOperationsClient(
    ctx context.Context,
    cfg aconfig.LoanManagementConfig,
) (operationsv1connect.OperationsServiceClient, error) {
    return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
        Endpoint:              cfg.OperationsServiceURI,
        WorkloadAPITargetPath: cfg.OperationsServiceWorkloadAPITargetPath,
        Audiences:             []string{"service_operations"},
    }, operationsv1connect.NewOperationsServiceClient)
}
```

- [ ] **Step 6.2: Add `setupLimitsClient`**

```go
func setupLimitsClient(
    ctx context.Context,
    cfg aconfig.LoanManagementConfig,
) (limitsv1connect.LimitsServiceClient, error) {
    return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
        Endpoint:              cfg.LimitsServiceURI,
        WorkloadAPITargetPath: cfg.LimitsServiceWorkloadAPITargetPath,
        Audiences:             []string{"service_limits"},
    }, limitsv1connect.NewLimitsServiceClient)
}
```

Add the import:

```go
import (
    // existing imports...
    "buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
    "github.com/antinvestor/service-fintech/pkg/limits/outbox"
)
```

- [ ] **Step 6.3: Wire client + outbox worker in `main`**

After the existing `operationsCli, err := setupOperationsClient(...)` etc., add:

```go
limitsCli, err := setupLimitsClient(ctx, cfg)
if err != nil {
    log.WithError(err).Fatal("could not initialise limits client")
}

outboxRepo := outbox.NewRepository(ctx, dbPool, workMan)
outboxWorker := outbox.NewWorker(outboxRepo, limitsCli)
go func() {
    if err := outboxWorker.Run(ctx); err != nil {
        log.WithError(err).Error("loans: limits outbox worker exited with error")
    }
}()
```

- [ ] **Step 6.4: Pass `limitsCli` and the gate flag into `NewDisbursementBusiness`**

Update the existing call:

```go
disbBusiness := business.NewDisbursementBusiness(
    ctx, evtsMan, disbRepo, loanAccountRepo, laBusiness, operationsCli, auditWriter,
    limitsCli,                                  // new
    cfg.LimitsGateEnabledLoanDisbursement,      // new
)
```

(Constructor signature update happens in Task 7, where they're committed together.)

- [ ] **Step 6.5: Build**

```bash
go build ./apps/loans/...
```

Expected: build fails until Task 7 lands the constructor change. Don't commit yet — Tasks 6+7 commit together.

---

## Task 7: DisbursementBusiness uses Gate behind env flag

**Files:**
- Modify: `apps/loans/service/business/disbursement.go`
- Modify (or create): `apps/loans/service/business/disbursement_test.go`

- [ ] **Step 7.1: Update the struct + constructor**

```go
type disbursementBusiness struct {
    eventsMan         fevents.Manager
    disbRepo          repository.DisbursementRepository
    loanAccountRepo   repository.LoanAccountRepository
    laBusiness        LoanAccountBusiness
    operationsCli     operationsv1connect.OperationsServiceClient
    auditWriter       *audit.Writer
    limitsCli         limitsv1connect.LimitsServiceClient   // new
    limitsGateEnabled bool                                  // new
}

func NewDisbursementBusiness(
    _ context.Context,
    eventsMan fevents.Manager,
    disbRepo repository.DisbursementRepository,
    loanAccountRepo repository.LoanAccountRepository,
    laBusiness LoanAccountBusiness,
    operationsCli operationsv1connect.OperationsServiceClient,
    auditWriter *audit.Writer,
    limitsCli limitsv1connect.LimitsServiceClient,
    limitsGateEnabled bool,
) DisbursementBusiness {
    return &disbursementBusiness{
        eventsMan: eventsMan, disbRepo: disbRepo, loanAccountRepo: loanAccountRepo,
        laBusiness: laBusiness, operationsCli: operationsCli, auditWriter: auditWriter,
        limitsCli: limitsCli, limitsGateEnabled: limitsGateEnabled,
    }
}
```

Add imports:

```go
import (
    // existing imports...
    "buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
    limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
    "github.com/antinvestor/service-fintech/pkg/limits"
    "github.com/pitabwire/frame/security"
    moneyx "github.com/pitabwire/util/money"
)
```

- [ ] **Step 7.2: Refactor `Create` to wrap the existing pipeline in `Gate`**

```go
func (b *disbursementBusiness) Create(ctx context.Context, req *loansv1.DisbursementCreateRequest) (*loansv1.DisbursementObject, error) {
    logger := util.Log(ctx).WithField("method", "DisbursementBusiness.Create")

    // Idempotency short-circuit (local).
    if req.GetIdempotencyKey() != "" {
        existing, idErr := b.disbRepo.GetByIdempotencyKey(ctx, req.GetIdempotencyKey())
        if idErr == nil && existing != nil {
            return existing.ToAPI(), nil
        }
    }

    if !b.limitsGateEnabled || b.limitsCli == nil {
        return b.createInner(ctx, req)
    }

    la, err := b.loanAccountRepo.GetByID(ctx, req.GetLoanAccountId())
    if err != nil {
        return nil, ErrLoanAccountNotFound
    }
    intent := buildDisbursementIntent(la, ctx)
    var result *loansv1.DisbursementObject
    gateErr := limits.Gate(ctx, b.limitsCli, intent, req.GetIdempotencyKey(),
        func(innerCtx context.Context, reservationID string) error {
            logger.With("limits_reservation_id", reservationID).Info("disbursement gated by limits")
            inner, innerErr := b.createInner(innerCtx, req)
            if innerErr != nil {
                return innerErr
            }
            result = inner
            return nil
        })

    var pendingErr *limits.PendingApprovalError
    if errors.As(gateErr, &pendingErr) {
        return nil, fmt.Errorf("disbursement requires approval (reservation %s): %w",
            pendingErr.ReservationID, gateErr)
    }
    if gateErr != nil {
        return nil, gateErr
    }
    return result, nil
}

// createInner is the pre-Gate body factored out so Gate's handler
// can wrap it. The existing Create body (idempotency check excluded)
// moves here verbatim.
func (b *disbursementBusiness) createInner(ctx context.Context, req *loansv1.DisbursementCreateRequest) (*loansv1.DisbursementObject, error) {
    // (Move the original Create body here, minus the idempotency short-circuit.)
}

// buildDisbursementIntent constructs a LimitIntent from the loan account.
func buildDisbursementIntent(la *models.LoanAccount, ctx context.Context) *limitsv1.LimitIntent {
    intent := &limitsv1.LimitIntent{
        Action:   limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
        TenantId: la.TenantID,
        Amount:   moneyx.FromMinorUnitsByCurrency(la.CurrencyCode, la.PrincipalAmount),
        Subjects: []*limitsv1.SubjectRef{
            {Type: limitsv1.SubjectType_SUBJECT_TYPE_CLIENT, Id: la.ClientID},
            {Type: limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION, Id: la.TenantID},
        },
        MakerId: callerSubject(ctx),
    }
    return intent
}

func callerSubject(ctx context.Context) string {
    if claims := security.ClaimsFromContext(ctx); claims != nil {
        return claims.GetProfileID()
    }
    return ""
}
```

(`la.ClientID`, `la.TenantID`, `la.PrincipalAmount`, `la.CurrencyCode` field names must match the actual `models.LoanAccount` struct — verify by grepping `apps/loans/service/models/`. Adapt if the struct uses different names.)

- [ ] **Step 7.3: Add tests**

In `apps/loans/service/business/disbursement_test.go` (create or extend) add cases:

1. `TestDisbursement_Create_GateDisabled_BehavesAsBefore` — `limitsGateEnabled=false`, `limitsCli=nil` — `Create` calls existing pipeline; existing tests pass.
2. `TestDisbursement_Create_GateAllowed` — flag true, stub RPC returns ACTIVE on Reserve and OK on Commit → disbursement created.
3. `TestDisbursement_Create_GateDenied` — stub Reserve returns Connect FailedPrecondition → `Create` returns error, no Disbursement row persisted.
4. `TestDisbursement_Create_GatePending` — stub returns PENDING_APPROVAL → `Create` returns wrapped pending error.

Use a test-only `stubLimitsClient` similar to Task 1's `stubLimitsClient`. Real-server integration is Task 9.

- [ ] **Step 7.4: Build + run loans tests**

```bash
go build ./apps/loans/...
go test -race -timeout=240s ./apps/loans/...
```

Expected: PASS. Pre-existing disbursement test (if any) continues to pass with `limitsGateEnabled=false`.

- [ ] **Step 7.5: Commit Tasks 6 + 7 together**

```bash
git add apps/loans/cmd/main.go apps/loans/service/business/disbursement.go apps/loans/service/business/disbursement_test.go
git commit -m "feat(loans): wire limits.Gate into DisbursementBusiness behind env flag

setupLimitsClient builds the limitsv1connect.LimitsServiceClient via
connection.NewServiceClient (same pattern as operations/funding/notification).
The outbox worker is spawned on startup so future Gate-driven flows can
defer Commit through the outbox.

DisbursementBusiness.Create wraps its existing pipeline in limits.Gate
when LIMITS_GATE_ENABLED_LOAN_DISBURSEMENT=true. Pending-approval results
surface as a typed error; consumers can resume via approval events in
a future plan."
```

---

## Task 8: Loans Dockerfile

**Files:**
- Verify: `apps/loans/Dockerfile`

The Dockerfile must `COPY ./pkg ./pkg` so `pkg/limits` and `pkg/limits/outbox` are present in the build.

- [ ] **Step 8.1: Inspect**

```bash
grep "COPY.*pkg" apps/loans/Dockerfile
```

If absent, add a `COPY ./pkg ./pkg` line in the builder stage (mirror `apps/savings/Dockerfile`).

- [ ] **Step 8.2: Local Docker build (optional sanity check)**

```bash
docker build -f apps/loans/Dockerfile -t service-loans:dev .
```

Expected: success.

- [ ] **Step 8.3: Commit if changed**

```bash
git add apps/loans/Dockerfile
git commit -m "build(loans): ensure pkg/limits ships in the loans image"
```

---

## Task 9: End-to-end integration test

**Files:**
- Create: `apps/loans/tests/integration/disbursement_gate_test.go`

Brings up Postgres (testcontainer), runs both the loans and limits migrations, mounts the limits Connect handler on `httptest.Server`, points a `limitsv1connect.NewLimitsServiceClient` at it, and exercises `DisbursementBusiness.Create` with the gate enabled. Verifies the limits ledger reflects the disbursement.

The shape mirrors `apps/limits/tests/integration/runtime_test.go` plus the loans-side fixture for setting up a loan account.

- [ ] **Step 9.1: Skeleton + the three core test cases**

```go
// apps/loans/tests/integration/disbursement_gate_test.go
// (Apache 2.0 license header)

package integration_test

// Required test fixtures:
// 1. Postgres testcontainer.
// 2. Apply both apps/limits + apps/loans migrations into separate logical DBs (or schemas).
// 3. Construct a real ReservationBusiness from apps/limits + the policy seed.
// 4. Mount limitsv1connect.NewLimitsServiceHandler on httptest.Server with fixedClaimsInterceptor.
// 5. Construct loans DisbursementBusiness with limitsCli pointing at the test server.
// 6. Author a policy via PolicyBusiness covering loan_disbursement.
// 7. Seed a loan account in PENDING_DISBURSEMENT state.
// 8. Call DisbursementBusiness.Create.

// Three tests:
// - TestDisbursement_GateAllowed_LedgerPopulated: cap >> intent → Reserve+Commit succeed; LedgerEntry visible.
// - TestDisbursement_GateDenied_NoLocalRow: cap < intent (enforce) → Create returns error; no Disbursement row.
// - TestDisbursement_GatePending_TypedError: per_txn_max with approver_tiers triggers approval → Create returns wrapped pending error.
```

The full setup is non-trivial — the implementer should read `apps/limits/tests/integration/runtime_test.go` for the canonical setup and adapt. If the full real-server path proves too heavy for the canary (substantially more code than expected), the implementer may fall back to a stub-RPC test in `apps/loans/service/business/disbursement_test.go` that exercises the same scenarios without HTTP. The fallback is acceptable but document the choice in the report.

- [ ] **Step 9.2: Run**

```bash
go test -race -timeout=300s ./apps/loans/tests/integration/...
```

Expected: PASS.

- [ ] **Step 9.3: Commit**

```bash
git add apps/loans/tests/integration/
git commit -m "test(loans): integration test for disbursement+limits Gate

Real Postgres testcontainer + httptest.Server hosting the limits
Connect handler. Exercises gate-allowed (Reserve+Commit, ledger
populated), gate-denied (FailedPrecondition, no local row), and
gate-pending (approver tiers cover, typed PendingApprovalError)."
```

---

## Task 10: End-of-plan verification + tag

- [ ] **Step 10.1:** `go build ./...` — clean.
- [ ] **Step 10.2:** `go vet ./...` — clean.
- [ ] **Step 10.3:** `go test -race -timeout=20m ./...` — green.
- [ ] **Step 10.4:** Tag the milestone.

```bash
git tag milestone/limits-consumer-loans
```

---

## Summary

After this plan:

- `pkg/limits.Gate` is a free function that takes the consumer's already-built `limitsv1connect.LimitsServiceClient`. The package no longer owns client construction concerns.
- `pkg/limits/outbox` ships a working drain loop with retry/dead-letter, also taking the raw connectrpc client.
- `apps/loans` uses `connection.NewServiceClient` to build its limits client (same pattern as operations/funding/notification). `DisbursementBusiness.Create` consults limits via `Gate` when `LIMITS_GATE_ENABLED_LOAN_DISBURSEMENT=true`.

Follow-on plans (each ~3-5 tasks, replaying this pattern):

- **Plan 5a — Savings deposit/withdrawal** (`apps/savings`).
- **Plan 5b — Operations transfer/incoming payment** (`apps/operations`).
- **Plan 5c — Funding inflow/outflow** (`apps/funding`).
- **Plan 5d — Stawi contribution/payout** (`apps/stawi`).
- **Plan 5e — Loan request/repayment** (other `apps/loans` paths).
- **Plan 6 — Shadow → Enforce flip**: configuration-only, action by action.
- **Plan 7 — Hardening**: chaos drills, capacity review, runbook rehearsal.

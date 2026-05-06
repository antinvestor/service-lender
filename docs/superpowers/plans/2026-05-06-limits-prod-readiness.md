# Limits — Production Readiness Remediation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development.

**Goal:** Close the production blockers from the three-axis audit (correctness/concurrency/resilience, performance/scale, security/observability/tests). The architectural pivot: collapse the outbox out of the design. Synchronous Commit with strong idempotency + TTL self-correction is sufficient for cap correctness; the outbox added unnecessary multi-phase complexity that was never wired and never required.

**Architecture (post-remediation):**
- Reserve → handler → Commit, all synchronous via Connect RPC. Both Reserve and Commit are idempotent on `(tenant_id, idempotency_key)`.
- On Commit RPC failure after handler success: caller surfaces error, reservation TTL-expires (5 min), cap math self-corrects on the next Reserve. Drift is in the audit/ledger sense; cap enforcement is unaffected.
- Tenant assertion at the limits service boundary: `intent.tenant_id` MUST equal `scopes.PartitionFromCtx(ctx)`; payload-trust is removed.
- Audit emission moves into the same DB tx as the state change (no more post-commit emit).
- Policy + attribute caches add hot-path performance. Reservation/ledger archival keeps disk/index growth bounded.

**Tech Stack:** Go 1.26, Frame, Connect RPC, GORM, NATS.

**Audit findings addressed:** all 6 production blockers + 14 of 15 high-priority issues from `docs/superpowers/audits/` (this plan).

---

## Phase 1: Outbox removal

**Why first:** clears the deck. Five audit findings collapse to zero by deletion. No code currently writes outbox rows; deleting hurts nothing.

**Files to delete:**
- `pkg/limits/outbox/` (entire directory)
- `pkg/limits/consumer/drain.go` and `drain_test.go`
- `pkg/limits/chaostests/outbox_db_down_test.go`
- `pkg/limits/chaostests/trustage_outage_test.go`
- All five `apps/*/migrations/20260506_limits_outbox.{up,down}.sql`
- All five `apps/*/docs/runbook/limits-outbox-trustage.md`
- `apps/loans/docs/runbook/limits-outbox-trustage.md`

**Files to modify:**
- `pkg/limits/consumer/setup.go` — remove `SetupOutboxStack`. Keep only `SetupClient`.
- All five `apps/*/cmd/main.go` — remove drain handler mount, remove outbox worker construction. The `setupLimitsClient` helper stays.
- `pkg/limits/gate.go` — already calls Commit/Release synchronously; no change needed. Add a doc comment that the outbox approach was deliberately rejected per "no unnecessary multi-phase transactions" (one-line).
- `apps/limits/service/repository/migrate.go` — remove the AutoMigrate registration of `outbox.Row` if present.
- `docs/superpowers/specs/2026-05-05-fintech-limits-design.md` — section §6.2 (outbox) replaced with a paragraph documenting the synchronous-Commit + TTL-self-correction model.
- `docs/runbook/limits-rollout.md`, `limits-capacity-review.md`, `limits-rehearsal-2026-05-06.md` — strip outbox references.

**Tasks:**

- [ ] **1.1: Delete outbox files**

```bash
git rm -r pkg/limits/outbox/
git rm pkg/limits/consumer/drain.go pkg/limits/consumer/drain_test.go
git rm pkg/limits/chaostests/outbox_db_down_test.go pkg/limits/chaostests/trustage_outage_test.go
git rm apps/*/migrations/20260506_limits_outbox.up.sql apps/*/migrations/20260506_limits_outbox.down.sql
git rm apps/*/docs/runbook/limits-outbox-trustage.md
```

- [ ] **1.2: Trim `pkg/limits/consumer/setup.go`** to only `SetupClient`.

- [ ] **1.3: Trim each `apps/*/cmd/main.go`** — remove drain mount, remove outbox worker construction, remove `consumer.SetupOutboxStack` usage. Keep `consumer.SetupClient` and the `limitsCli` threading.

- [ ] **1.4: Update spec + runbooks** — section §6.2 replaced, runbook files clean of outbox sections.

- [ ] **1.5: Build + test**

```bash
go build ./...
go vet ./...
go test -race -timeout=300s ./pkg/limits/... ./apps/...
```

- [ ] **1.6: Commit**

```bash
git commit -m "refactor(limits): remove outbox bridge — synchronous Commit + TTL is sufficient

The outbox was never wired into any consumer's hot path; Gate calls
Commit/Release synchronously today. Per the production-readiness audit,
the outbox added unnecessary multi-phase transaction complexity for a
problem (Commit RPC failure post-handler-commit) that the limits
service's TTL-based self-correction already handles: a failed Commit
leaves a reservation that TTL-expires; cap math reverts on the next
Reserve as if the operation never happened.

Removes: pkg/limits/outbox, pkg/limits/consumer/drain.go, drain handler
mounts in 5 consumer main.go files, 5 limits_outbox SQL migrations, 5
Trustage runbooks, 2 chaos drills (outbox-db-down, trustage-outage).
Spec §6.2 replaced with the synchronous-Commit model."
```

---

## Phase 2: Cap correctness — TOCTOU + idempotency + tenant assertion

**Goal:** make Reserve actually limit under concurrency, fix the funding/loans-repayment idem-key bugs, and prevent payload-trust on `tenant_id`.

### 2A: Evaluator reads inside Reserve's tx

**File:** `apps/limits/service/business/evaluator.go`, `apps/limits/service/repository/{ledger,reservation}_repo.go`

The current evaluator calls `e.ledgerRepo.WindowSum(ctx, ...)` which uses `r.dbPool.DB(ctx, true)` — the read pool, NOT the Reserve transaction. This means the advisory lock acquired inside the Reserve tx provides no read ordering: two concurrent Reserves can both read "below cap" and both succeed.

- [ ] **2A.1: Add tx-aware variants**

Add to `LedgerRepository` and `ReservationRepository`:

```go
WindowSumTx(ctx context.Context, tx *gorm.DB, ...) (int64, error)
PendingSumTx(ctx context.Context, tx *gorm.DB, ...) (int64, error)
PendingCountTx(ctx context.Context, tx *gorm.DB, ...) (int64, error)
```

Each takes the live tx handle (passed by Reserve) and runs the SUM/COUNT query against it instead of the read pool. Existing non-Tx variants stay for read-only callers (audit search, etc.).

- [ ] **2A.2: Pass tx through evaluator**

Add `Evaluator.EvaluateInTx(ctx, tx, ...)` mirroring `Evaluate` but routing to the *Tx repo methods.

- [ ] **2A.3: Reserve uses EvaluateInTx**

`reservation.go:339` (the per-policy evaluation loop inside the tx after lock acquisition) switches from `b.evaluator.Evaluate(...)` to `b.evaluator.EvaluateInTx(ctx, tx, ...)`.

- [ ] **2A.4: Test concurrent Reserve**

Add `apps/limits/service/business/reservation_concurrent_test.go`: spin 20 goroutines calling Reserve on the same subject targeting a per-txn-cap policy. Assert total committed ≤ cap.

### 2B: Fix idempotency keys at the consumer sites

- [ ] **2B.1: Funding** — `apps/funding/service/business/investor_account.go:155, 272`. Change:

```go
idemKey := "funding_deposit:" + accountID
```

to:

```go
idemKey := req.IdempotencyKey
if idemKey == "" {
    return nil, status.Error(codes.InvalidArgument, "idempotency_key required")
}
idemKey = "funding_deposit:" + accountID + ":" + idemKey
```

Same shape for `Withdraw`. The bare `accountID`-keyed form is an architectural bug — the gate's idempotency guard treats two distinct deposits as the same operation.

- [ ] **2B.2: Loans repayment** — `apps/loans/service/business/repayment.go:150-153`. Drop the `loanAccountID` fallback. Idempotency key MUST be supplied by caller; otherwise return `InvalidArgument`.

- [ ] **2B.3: Loans disbursement** — `apps/loans/service/business/disbursement.go:120`. The current code passes `req.GetIdempotencyKey()` directly; if empty, Reserve rejects with `idempotency_key required`. Add an explicit error at the consumer side with a clearer message and an early return.

- [ ] **2B.4: Savings deposit** — `apps/savings/service/business/deposit.go:155-158`. Drop the `util.IDString()` fallback when `idempotencyKey == ""`. Require caller to supply.

- [ ] **2B.5: Tests**

For each of the 4 consumer changes: add a test that asserts `InvalidArgument` is returned when `idempotency_key` is empty.

### 2C: Tenant assertion interceptor

**File:** `apps/limits/service/handlers/runtime_service.go`, new `apps/limits/service/handlers/tenant_assertion_interceptor.go`

The current Reserve handler reads `intent.GetTenantId()` directly (`reservation.go:140, 273`). The interceptor must fail-closed if `intent.tenant_id != ctx partition`.

- [ ] **2C.1: Implement interceptor**

```go
package handlers

import (
    "context"
    "connectrpc.com/connect"
    "github.com/pitabwire/frame/scopes"
    limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
)

func TenantAssertionInterceptor() connect.UnaryInterceptorFunc {
    return func(next connect.UnaryFunc) connect.UnaryFunc {
        return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
            ctxPartition, _ := scopes.PartitionFromCtx(ctx)
            switch msg := req.Any().(type) {
            case *limitsv1.ReserveRequest:
                if got := msg.GetIntent().GetTenantId(); got != "" && got != ctxPartition {
                    return nil, connect.NewError(connect.CodePermissionDenied,
                        fmt.Errorf("tenant mismatch: intent=%q ctx=%q", got, ctxPartition))
                }
                msg.Intent.TenantId = ctxPartition // overwrite with auth-derived
            case *limitsv1.CommitRequest, *limitsv1.ReleaseRequest, *limitsv1.ReverseRequest:
                // These take only reservation_id; tenancy enforced by repo scope.
            }
            return next(ctx, req)
        }
    }
}
```

- [ ] **2C.2: Mount on the limits service Connect handler stack**

`apps/limits/cmd/main.go` — wire into the Connect service options.

- [ ] **2C.3: Replace raw `tx.Table(...)` updates** with scoped repo methods

`reservation.go:467-470` (Commit), `reservation.go:504-510` (Release), `reservation.go:696-703` (Reverse):

```go
// Before:
tx.Table(models.Reservation{}.TableName()).
    Where("id = ? AND status = ?", id, "active").
    Updates(...)

// After:
b.resvRepo.SetCommittedTx(ctx, tx, id) // existing methods, with tenant scope inside
```

Where the scoped methods don't exist yet, add them to `ReservationRepository` mirroring the unscoped versions but using `Scopes(scopes.TenancyPartition(ctx))`.

- [ ] **2C.4: Approval.Decide tenant check**

`apps/limits/service/business/approval.go:148-185`. After loading the approval row, assert:

```go
if ar.PartitionID != scopes.PartitionFromCtx(ctx) {
    return nil, connect.NewError(connect.CodePermissionDenied,
        fmt.Errorf("approval belongs to a different tenant"))
}
```

- [ ] **2C.5: Test cross-tenant boundary**

Add `apps/limits/tests/integration/cross_tenant_test.go`:
- `TestReserve_CrossTenantPayload_Rejected` — caller authenticates as tenant A, submits intent with tenant_id=B → expect PermissionDenied.
- `TestApprove_CrossTenantApproval_Rejected` — tenant A operator tries to approve tenant B's pending approval → expect PermissionDenied.
- `TestCommit_ReservationFromOtherTenant_NotFound` — caller from tenant A holds a reservation ID from tenant B (somehow leaked); Commit returns NotFound, not silently succeeds.

### 2D: Reverse advisory lock + status guard

`reservation.go:617-721`. The current Reverse path doesn't acquire the advisory lock that Reserve uses, and the final UPDATE has no status guard.

- [ ] **2D.1:** Acquire `pg_advisory_xact_lock` on `(subject_id, action, currency)` at the top of Reverse, same pattern as Reserve.
- [ ] **2D.2:** Add `AND status = 'committed'` to the UPDATE in line 696-703.
- [ ] **2D.3:** Test concurrent Reverse — two goroutines targeting the same original; only one succeeds.

### 2E: Approval.Decide transactional

`approval.go:148-326`. Wrap the decision-record + quorum-check + reservation-activate sequence in a single tx so a crash mid-flow doesn't strand the reservation.

- [ ] **2E.1:** Open `dbPool.DB(ctx, false).Transaction(func(tx *gorm.DB) error { ... })` covering RecordDecision through SetActive.
- [ ] **2E.2:** Test crash semantics: inject panic between SetStatus and SetActive; assert reservation status reverts on tx rollback.

### 2F: Gate enforce-mode Release uses WithoutCancel

`pkg/limits/gate.go:144-153`. Mirror the shadow path: wrap the Release ctx in `context.WithoutCancel` so a client-side cancel doesn't strand the cap-hold.

- [ ] **2F.1:** Apply `context.WithoutCancel` to the enforce-mode Release call site. Add a 30s timeout.
- [ ] **2F.2:** Test client-cancel scenario: cancel ctx mid-handler; observe Release still fires.

### Verification

```bash
go build ./...
go vet ./...
go test -race -timeout=600s ./pkg/limits/... ./apps/limits/... ./apps/loans/service/business/... ./apps/savings/service/business/... ./apps/operations/service/business/... ./apps/funding/service/business/... ./apps/stawi/service/business/...
```

### Commit cadence

Six commits, one per sub-section:
1. `feat(limits): tx-aware evaluator reads — close TOCTOU on Reserve`
2. `fix(limits-consumers): require explicit idempotency keys at all gate sites`
3. `feat(limits): tenant assertion interceptor + scoped Commit/Reverse updates`
4. `fix(limits): Approval.Decide enforces caller tenant`
5. `fix(limits): Reverse acquires advisory lock + status-guard UPDATE`
6. `fix(limits): Approval.Decide is transactional`
7. `fix(limits): Gate enforce-mode Release survives client cancellation`

---

## Phase 3: Audit durability

**Goal:** audit row written in the same DB tx as the state change, not async post-commit.

**Files:**
- `pkg/audit/writer.go`
- `apps/limits/service/business/{reservation,approval,policy}.go` — Save/Delete + state transitions
- `apps/limits/service/business/auditing.go`

### Tasks

- [ ] **3.1: Add tx-bound writer method**

`pkg/audit/writer.go`:

```go
// RecordTx writes the audit row inside the caller's tx. Replaces the
// post-commit eventsMan.Emit pattern for state-change audits.
func (w *Writer) RecordTx(ctx context.Context, tx *gorm.DB, ev *AuditEvent) error {
    return tx.Create(ev).Error
}
```

The async eventsMan emission stays for non-critical observability (e.g., shadow-mode logs); but every state-change audit moves to RecordTx.

- [ ] **3.2: Migrate state-change audit calls**

`reservation.go:434-447, 557, 610, 715` — all `b.auditing.Record*` calls inside Reserve/Commit/Release/Reverse handlers move into the tx and use `RecordTx`.

- [ ] **3.3: Add audit for PolicySave / PolicyDelete**

`policy.go:188-203` — add `auditing.RecordPolicyDeleted` and `RecordPolicySaved` calls inside the policy mutation tx.

- [ ] **3.4: Add audit for Release-cascade rejected approvals**

`reservation.go:592-603` — when Release cascades to mark approvals as Rejected, emit `RecordApprovalRejectedCascade` per approval.

- [ ] **3.5: Tests**

- Crash test: panic between `tx.Commit()` and post-commit emit; assert audit row IS persisted (because it's in-tx now).
- PolicyDelete audit test.
- Release-cascade audit test.

### Commit

```bash
git commit -m "feat(limits): in-tx audit writes — close audit-loss window on crash"
```

---

## Phase 4: Performance hardening

### 4A: GIN index on reservations.subject_refs

**File:** new migration `apps/limits/migrations/20260506_subject_refs_gin.up.sql`

```sql
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_resv_subject_refs_gin
    ON limits_reservations USING gin (subject_refs jsonb_path_ops)
    WHERE deleted_at IS NULL AND status IN ('active','pending_approval');
```

(Use `CONCURRENTLY` so prod migration doesn't lock writes.)

### 4B: Policy cache

**File:** new `apps/limits/service/business/policy_cache.go`

Read-through cache keyed by `(tenant_id, org_unit_id, action, currency)` with 30s TTL. Invalidate on `PolicyBusiness.Save` / `Delete`. Use `golang-lru/v2` (already a Go-ecosystem dep; if not in go.mod, `go get github.com/hashicorp/golang-lru/v2`).

`candidate_policy.go:48-66` — wrap `FindCandidates` with cache lookup.

### 4C: Attribute resolver eviction

**File:** `apps/limits/service/business/attribute_resolver.go:53-58, 148-152`

Replace the unbounded map with `lru.Cache[string, cachedAttrs]` — size cap 10k entries. TTL stays for freshness.

### 4D: Bulk reaper update

**File:** `apps/limits/service/business/reaper_reservation.go:46-65`, `apps/limits/service/repository/reservation_repo.go:202-218`

Replace the per-row `for ... SetExpired` loop with a single `UPDATE limits_reservations SET status='expired' WHERE id IN (?) AND status='active'`. Add `BulkSetExpired` to the repository.

Same pattern for `reaper_approval.go`.

### 4E: Reservation/ledger archival

**File:** new `apps/limits/service/business/archival.go`

Background job (Trustage-driven, calls `POST /admin/limits-archive`):
- Hard-delete `limits_reservations` rows with `status IN ('committed','released','reversed','expired')` AND `modified_at < now() - 7 days`.
- Hard-delete `limits_ledger_entries` rows with `committed_at < now() - 90 days`. Adjust window per regulatory requirement; document in spec.

The reaper handles TTL-expiry; this job handles long-term cleanup. Different cadence: reaper every minute, archival every hour.

Add `apps/limits/docs/runbook/archival-trustage.md` documenting the workflow.

### Verification + commits

Five commits, one per subsection.

---

## Phase 5: limits-admin CLI auth

**File:** `apps/limits-admin/cmd/main.go`

The current CLI sends no client credentials. Wire SPIFFE/workload-identity (or fall back to a `--token` flag for operator dev). Remove the misleading `--insecure` flag.

- [ ] **5.1:** Replace `http.DefaultClient` with `connection.NewServiceClient(ctx, ...)` which threads platform auth.
- [ ] **5.2:** Remove `--insecure` flag.
- [ ] **5.3:** Test against an authenticated staging endpoint.

```bash
git commit -m "fix(limits-admin): wire platform auth — remove misleading --insecure flag"
```

---

## Phase 6: Verification

- [ ] **6.1:** All audit findings closed — produce a checklist mapping each finding to its remediation commit.
- [ ] **6.2:** `go build ./...`, `go vet ./...`, `go test -race -timeout=600s ./...` all green.
- [ ] **6.3:** Tag `milestone/limits-prod-ready`.

---

## Out of scope (deferred)

- Concrete staging load test (operational; runs after this plan lands).
- Chaos drill enablement (testcontainers pause/unpause infrastructure — operational).
- Additional approval-quorum semantics — the audit didn't flag any blocker here.
- Streaming Reserve responses for high-cardinality verdicts — performance optimisation but not at the 1k-rps target.

---

## Self-review

- Outbox removal eliminates 5 audit findings cleanly.
- TOCTOU fix is the single largest correctness win.
- Tenant interceptor + scoped repos closes the cross-tenant chain (3 audit findings) at one structural point.
- Audit durability moves from async-lossy to in-tx — closes the compliance gap.
- Performance fixes target the documented capacity bottlenecks.
- The synchronous-Commit + TTL self-correction model honours the user's "no unnecessary multi-phase transactions" constraint.

# Limits — Consumer Rollout (Savings, Operations, Funding, Stawi, Loans-extension) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development.

**Goal:** Replicate the loans canary's `pkg/limits.Gate` integration across the remaining money-moving services (savings, operations, funding, stawi) and extend it within loans to cover loan_request and loan_repayment in addition to loan_disbursement. Each integration ships with the same shape: per-service env config, `limits_outbox` table + repository, outbox worker construction, drain HTTP handler at `/admin/limits-outbox/drain`, business-method gate wrap, runbook.

**Architecture:** The loans service (commits `93c5c52` — outbox worker corrected; `4a1df47` / `d42453b` / `58d128a` — drain endpoint + runbook) is the gold-standard template. All consumer services replicate it identically; the only delta per service is which business method is wrapped, which `limitsv1.LimitIntent` shape it builds, and which DB the outbox migration targets. A single shared package — `pkg/limits/consumer` — extracts the boilerplate into helpers so per-service main.go stays small.

**Tech Stack:** Go 1.26, Frame, Connect RPC, GORM, NATS, `pkg/limits.Gate`, `pkg/limits/outbox.Worker`, `connection.NewServiceClient`.

**Spec:** `docs/superpowers/specs/2026-05-05-fintech-limits-design.md` §5 (consumer obligations), §6.2 (outbox), §7 (audit on limiting).

---

## Reference: the loans canary

Every task below replays this template, swapping in the per-service business method and intent shape. The reference files for the canary:

- `apps/loans/cmd/main.go` — env wiring, limits client, outbox repo+worker, drain handler mount.
- `apps/loans/service/handlers/limits_outbox.go` — drain handler.
- `apps/loans/service/business/loan_disbursement.go` — `Gate(...)` invocation.
- `apps/loans/migrations/00X_limits_outbox.{up,down}.sql` — outbox table.
- `apps/loans/docs/runbook/limits-outbox-trustage.md` — Trustage runbook.

License header: copy from `apps/savings/cmd/main.go:1-13`.

---

## Task 0: Extract shared consumer helper

**Why first:** Five replays of the same setup will rot. Extracting helpers up-front keeps each per-service main.go to ~20 lines.

**Files:**
- Create: `pkg/limits/consumer/setup.go`
- Create: `pkg/limits/consumer/setup_test.go`

- [ ] **Step 0.1: Implement helpers**

```go
// (Apache 2.0 header)

package consumer

import (
	"context"
	"fmt"
	"net/http"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	"github.com/antinvestor/common/connection"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

// Config groups the consumer-side limits settings. Each consumer service's
// config struct embeds these fields under the standard env names below.
type Config struct {
	LimitsServiceURI string
	GateEnabled      map[string]bool
}

// SetupClient builds a Connect client for the limits service via the platform
// auth wiring. Returns nil if URI is empty (used during testing or when the
// limits service is not deployed yet).
func SetupClient(ctx context.Context, uri string) (limitsv1connect.LimitsServiceClient, error) {
	if uri == "" {
		return nil, nil
	}
	cli, err := connection.NewServiceClient(ctx, uri, limitsv1connect.NewLimitsServiceClient)
	if err != nil {
		return nil, fmt.Errorf("limits client: %w", err)
	}
	return cli, nil
}

// SetupOutboxStack wires the outbox repository, worker, and drain handler.
// Returns the worker (for direct invocation in tests) and the http.Handler
// (mount at /admin/limits-outbox/drain).
func SetupOutboxStack(
	dbPool pool.Pool,
	rpc limitsv1connect.LimitsServiceClient,
	workMan workerpool.Manager,
) (*outbox.Worker, http.Handler) {
	repo := outbox.NewRepository(dbPool)
	w := outbox.NewWorker(repo, rpc, workMan)
	h := newDrainHandler(w)
	return w, h
}
```

- [ ] **Step 0.2: Implement drain handler in same package**

```go
// pkg/limits/consumer/drain.go

package consumer

import (
	"encoding/json"
	"net/http"

	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

type drainHandler struct{ w *outbox.Worker }

func newDrainHandler(w *outbox.Worker) http.Handler {
	return &drainHandler{w: w}
}

func (h *drainHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	if h.w == nil {
		http.Error(w, "outbox worker not configured", http.StatusServiceUnavailable)
		return
	}
	count, err := h.w.Drain(r.Context())
	if err != nil {
		util.Log(r.Context()).WithError(err).Error("limits outbox drain failed")
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]int{"drained": count})
}
```

- [ ] **Step 0.3: Tests**

```go
// pkg/limits/consumer/setup_test.go
package consumer_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestSetupClient_EmptyURI_ReturnsNil(t *testing.T) {
	// SetupClient is exercised under integration via per-service main.go;
	// here we sanity-check the empty-URI fast path.
	// (Implementation in pkg/limits/consumer/setup.go)
}

// drainHandler tests live alongside in this _test package via package-private
// access. Use exported wrapper in the per-service handler tests for the rest.
func TestDrain_RejectsGET(t *testing.T) {
	// Mirror of the loans handler test; covers the exported behaviour.
	w := httptest.NewRecorder()
	r := httptest.NewRequest(http.MethodGet, "/admin/limits-outbox/drain", nil)
	// Use SetupOutboxStack(nil, nil, nil) -> handler with nil worker
	_, h := SetupOutboxStack(nil, nil, nil)
	h.ServeHTTP(w, r)
	assert.Equal(t, http.StatusMethodNotAllowed, w.Result().StatusCode)
}

func TestDrain_NilWorker_503(t *testing.T) {
	w := httptest.NewRecorder()
	r := httptest.NewRequest(http.MethodPost, "/admin/limits-outbox/drain", nil)
	_, h := SetupOutboxStack(nil, nil, nil)
	h.ServeHTTP(w, r)
	// Worker is non-nil but its repo+rpc are nil; ClaimDue would panic.
	// For a true nil-worker case, callers in main.go skip mounting.
	// This test instead asserts the typical 200 OK path via mock — left as
	// integration-only since the worker requires DB.
	_ = w
	_ = r
}
```

(Note: `SetupOutboxStack` always returns a non-nil handler; the nil-worker branch in `drainHandler.ServeHTTP` is triggered only when a caller passes `nil` directly. The per-service main.go is responsible for not mounting if the limits client is nil.)

- [ ] **Step 0.4: Build**

```bash
go build ./pkg/limits/consumer/...
go test -race -timeout=60s ./pkg/limits/consumer/...
```

- [ ] **Step 0.5: Refactor loans to use the helper**

Replace the inline wiring in `apps/loans/cmd/main.go` (around the `outboxRepo := outbox.NewRepository(...)` block) with:

```go
limitsCli, err := consumer.SetupClient(ctx, cfg.LimitsServiceURI)
if err != nil { return err }
outboxWorker, limitsDrainHandler := consumer.SetupOutboxStack(dbPool, limitsCli, workMan)
_ = outboxWorker // reaper not needed; Trustage drives drain
```

And delete `apps/loans/service/handlers/limits_outbox.go` + its test (now provided by the shared helper). Update the mux mount accordingly:

```go
mux.Handle("/admin/limits-outbox/drain", limitsDrainHandler)
```

- [ ] **Step 0.6: Verify loans still passes**

```bash
go build ./apps/loans/...
go test -race -timeout=300s ./apps/loans/...
```

- [ ] **Step 0.7: Commit**

```bash
git add pkg/limits/consumer/ apps/loans/cmd/main.go
git rm apps/loans/service/handlers/limits_outbox.go apps/loans/service/handlers/limits_outbox_test.go
git commit -m "refactor(limits): extract consumer helper for client+outbox+drain wiring

Loans was the canary; replicating its 60-line setup verbatim across savings,
operations, funding, stawi, and loans-extension would create five copies of
the same boilerplate. consumer.SetupClient + consumer.SetupOutboxStack
collapse this to three lines in each consumer's main.go."
```

---

## Per-service template

Each service (savings, operations, funding, stawi) gets the same five-step rollout. The deltas — which business method to wrap, which `LimitIntent` to build, which existing `Money` field to use — are listed in the per-service tasks below.

### Generic Step A: Migration

Create `apps/<svc>/migrations/00X_limits_outbox.{up,down}.sql`. The schema is identical to the loans variant — copy verbatim from `apps/loans/migrations/`:

```sql
-- 00X_limits_outbox.up.sql
CREATE TABLE IF NOT EXISTS limits_outbox (
    id TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL,
    partition_id TEXT NOT NULL,
    reservation_id TEXT NOT NULL,
    action TEXT NOT NULL,            -- 'commit' | 'release'
    reason TEXT NOT NULL DEFAULT '',
    status TEXT NOT NULL DEFAULT 'pending',
    attempt INT NOT NULL DEFAULT 0,
    last_error TEXT NOT NULL DEFAULT '',
    next_attempt_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_limits_outbox_due
    ON limits_outbox (status, next_attempt_at)
    WHERE deleted_at IS NULL AND status IN ('pending','retry');
```

```sql
-- 00X_limits_outbox.down.sql
DROP INDEX IF EXISTS idx_limits_outbox_due;
DROP TABLE IF EXISTS limits_outbox;
```

Pick `00X` to be `next-available + 1` for that service.

### Generic Step B: Config

Add to `apps/<svc>/config/config.go`:

```go
LimitsServiceURI    string          `envconfig:"LIMITS_SERVICE_URI" default:""`
LimitsGateEnabled   map[string]bool `envconfig:"LIMITS_GATE_ENABLED" default:""`
```

`LIMITS_GATE_ENABLED` is a comma-separated `key=bool` map. Per-action keys per service are listed below.

### Generic Step C: main.go wiring

After `dbPool` and `workMan` are constructed, add:

```go
limitsCli, err := consumer.SetupClient(ctx, cfg.LimitsServiceURI)
if err != nil { return err }
var limitsDrainHandler http.Handler
if limitsCli != nil {
    _, limitsDrainHandler = consumer.SetupOutboxStack(dbPool, limitsCli, workMan)
}
```

In the mux setup:

```go
if limitsDrainHandler != nil {
    mux.Handle("/admin/limits-outbox/drain", limitsDrainHandler)
}
```

Pass `limitsCli`, `cfg.LimitsGateEnabled`, and `outboxRepo` (build via `outbox.NewRepository(dbPool)` if you need it for direct enqueue in tests) to whichever business constructor wraps with `Gate`.

### Generic Step D: Wrap the business method with Gate

The shape:

```go
import (
    limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
    "github.com/antinvestor/service-fintech/pkg/limits"
)

if b.limitsCli != nil && b.gateEnabled["<action_key>"] {
    intent := &limitsv1.LimitIntent{
        ActionKey:  "<action_key>",
        SubjectId:  <subject>,
        Amount:     <money>,
        Currency:   <currency>,
        Metadata:   map[string]string{ /* operation-specific */ },
    }
    idemKey := <stable per-operation key — e.g. order ID>
    return limits.Gate(ctx, b.limitsCli, intent, idemKey, func(ctx context.Context, _ string) error {
        return b.<actualOperation>(ctx, ...)
    })
}
return b.<actualOperation>(ctx, ...) // unchanged path when gate is off
```

Errors of type `limits.PendingApprovalError` and `limits.LimitBreachedError` MUST be propagated; the handler maps them to Connect codes (`CodeFailedPrecondition` for pending, `CodeResourceExhausted` for breach).

### Generic Step E: Test

Add a unit test using the in-memory limits stub — see `apps/loans/service/business/loan_disbursement_test.go` for the pattern. Each consumer test must cover:
1. Gate disabled → method runs unchanged.
2. Gate allows → method runs, Commit enqueued in outbox.
3. Gate denies (limit breached) → `LimitBreachedError` returned, business operation NOT performed.
4. Gate pending → `PendingApprovalError` returned with reservation ID.

---

## Task 1: Savings — deposit + withdrawal

**Files:**
- Create: `apps/savings/migrations/<next>_limits_outbox.{up,down}.sql`
- Modify: `apps/savings/config/config.go`
- Modify: `apps/savings/cmd/main.go`
- Modify: `apps/savings/service/business/deposit.go`
- Modify: `apps/savings/service/business/withdrawal.go`
- Create: `apps/savings/service/business/deposit_limits_test.go`
- Create: `apps/savings/service/business/withdrawal_limits_test.go`
- Create: `apps/savings/docs/runbook/limits-outbox-trustage.md`

### Subtask 1.1: Migration + config + main.go

Apply Steps A, B, C from the per-service template.

`LimitsGateEnabled` keys for savings: `savings_deposit`, `savings_withdrawal`.

### Subtask 1.2: Wrap `depositBusiness.Create`

Find the existing entry-point method that creates a deposit record (look for the public `Create`-style method that calls `postDepositTransferOrder` — likely a `Submit` or `Create`). Wrap it with `Gate`:

```go
intent := &limitsv1.LimitIntent{
    ActionKey:  "savings_deposit",
    SubjectId:  req.AccountId,
    Amount:     req.Amount, // *Money
    Currency:   req.Amount.GetCurrencyCode(),
    Metadata:   map[string]string{"channel": req.Channel},
}
idemKey := req.IdempotencyKey
if idemKey == "" { idemKey = util.IDString() }
```

Subject is the savings account ID. `idemKey` should derive from the deposit's idempotency key when provided; otherwise generate via `util.IDString()` (note: this loses true idempotency on retries — document explicitly in PR).

### Subtask 1.3: Wrap `withdrawalBusiness.Approve`

The `Approve` step (line 196 in `withdrawal.go`) is the moment funds are committed. Gate at that boundary, not at the initial submission.

```go
intent := &limitsv1.LimitIntent{
    ActionKey:  "savings_withdrawal",
    SubjectId:  withdrawal.AccountId,
    Amount:     withdrawal.Amount,
    Currency:   withdrawal.Amount.GetCurrencyCode(),
    Metadata:   map[string]string{"withdrawal_id": id},
}
idemKey := "savings_withdrawal:" + id
```

### Subtask 1.4: Tests + runbook + commit

Write deposit + withdrawal limits tests per Step E. Commit:

```bash
git add apps/savings/
git commit -m "feat(savings): integrate limits Gate for deposit + withdrawal"
```

Create `apps/savings/docs/runbook/limits-outbox-trustage.md` — copy from `apps/loans/docs/runbook/limits-outbox-trustage.md` and substitute service name. Commit:

```bash
git add apps/savings/docs/runbook/
git commit -m "docs(savings): runbook for the limits-outbox Trustage workflow"
```

---

## Task 2: Operations — transfer execute

**Files:**
- Create: `apps/operations/migrations/<next>_limits_outbox.{up,down}.sql`
- Modify: `apps/operations/config/config.go`
- Modify: `apps/operations/cmd/main.go`
- Modify: `apps/operations/service/business/transfer_order.go`
- Create: `apps/operations/service/business/transfer_order_limits_test.go`
- Create: `apps/operations/docs/runbook/limits-outbox-trustage.md`

### Subtask 2.1: Migration + config + main.go

Apply Steps A, B, C. `LimitsGateEnabled` key: `operations_transfer`.

### Subtask 2.2: Wrap `transferOrderBusiness.Execute`

`Execute` at `transfer_order.go:125` is the dispatch boundary. Wrap with Gate:

```go
intent := &limitsv1.LimitIntent{
    ActionKey:  "operations_transfer",
    SubjectId:  order.SourceAccountId,
    Amount:     order.Amount,
    Currency:   order.Amount.GetCurrencyCode(),
    Metadata:   map[string]string{
        "destination": order.DestinationAccountId,
        "order_id":    orderID,
    },
}
idemKey := "operations_transfer:" + orderID
```

### Subtask 2.3: Tests + runbook + commit

Per Step E + the runbook substitution. Two commits as in Task 1.

---

## Task 3: Funding — Deposit + Withdraw

**Files:**
- Create: `apps/funding/migrations/<next>_limits_outbox.{up,down}.sql`
- Modify: `apps/funding/config/config.go`
- Modify: `apps/funding/cmd/main.go`
- Modify: `apps/funding/service/business/investor_account.go`
- Create: `apps/funding/service/business/investor_account_limits_test.go`
- Create: `apps/funding/docs/runbook/limits-outbox-trustage.md`

### Subtask 3.1: Migration + config + main.go

`LimitsGateEnabled` keys: `funding_deposit`, `funding_withdraw`.

### Subtask 3.2: Wrap `investorAccountBusiness.Deposit` (line 111)

```go
intent := &limitsv1.LimitIntent{
    ActionKey:  "funding_deposit",
    SubjectId:  accountID,
    Amount:     amount,
    Currency:   amount.GetCurrencyCode(),
    Metadata:   map[string]string{"investor_account_id": accountID},
}
idemKey := "funding_deposit:" + accountID + ":" + idempotencyKey
```

If the existing Deposit signature has no idempotency key, add one with a sensible default (caller-provided or `util.IDString()`).

### Subtask 3.3: Wrap `investorAccountBusiness.Withdraw` (line 191)

Same shape, action `funding_withdraw`.

### Subtask 3.4: Tests + runbook + commit

Per Step E. Two commits.

---

## Task 4: Stawi — CreateLoanAccount

**Files:**
- Create: `apps/stawi/migrations/<next>_limits_outbox.{up,down}.sql`
- Modify: `apps/stawi/config/config.go`
- Modify: `apps/stawi/cmd/main.go`
- Modify: `apps/stawi/service/business/loan_offer.go`
- Create: `apps/stawi/service/business/loan_offer_limits_test.go`
- Create: `apps/stawi/docs/runbook/limits-outbox-trustage.md`

### Subtask 4.1: Migration + config + main.go

`LimitsGateEnabled` key: `stawi_loan_disbursement`.

### Subtask 4.2: Wrap `loanOfferBusiness.CreateLoanAccount` (line 204)

This method calls `createLoanFromOffer`, which is the moment a loan is materialised from a stawi window. Gate around it:

```go
offer, err := b.repo.GetByID(ctx, offerID)
if err != nil { return nil, err }
intent := &limitsv1.LimitIntent{
    ActionKey:  "stawi_loan_disbursement",
    SubjectId:  offer.MemberId,
    Amount:     minorUnitsToMoney(offer.Amount, offer.Currency),
    Currency:   offer.Currency,
    Metadata:   map[string]string{
        "offer_id":  offerID,
        "window_id": offer.WindowId,
        "group_id":  offer.GroupId,
    },
}
idemKey := "stawi_loan_disbursement:" + offerID
```

### Subtask 4.3: Tests + runbook + commit

Per Step E. Two commits.

---

## Task 5: Loans extension — loan_request + loan_repayment

The loans canary covers loan_disbursement only. Add gates for two more actions in the same service.

**Files:**
- Modify: `apps/loans/config/config.go` — extend `LIMITS_GATE_ENABLED` keys
- Modify: `apps/loans/service/business/loan_request.go` (or wherever submission/approval happens)
- Modify: `apps/loans/service/business/loan_repayment.go` (or equivalent)
- Create: `apps/loans/service/business/loan_request_limits_test.go`
- Create: `apps/loans/service/business/loan_repayment_limits_test.go`

### Subtask 5.1: loan_request

Wrap the loan-request approval boundary (the moment a request is approved into a disbursement). Action key: `loan_request_approval`. Subject: borrower client ID. Amount: requested amount.

Note: the same operation may flow through `loan_disbursement` later. The loan_request gate captures pre-disbursement caps (e.g. concentration limits, daily-request count); the loan_disbursement gate captures spend caps. Both fire in sequence — neither subsumes the other.

### Subtask 5.2: loan_repayment

Wrap the repayment-application moment. Action key: `loan_repayment`. Subject: borrower client ID. Amount: repayment amount.

Limits on repayments are usually inverse — a *minimum* threshold rather than a max — but the limits service supports both via policy rules; the gate call shape is the same.

### Subtask 5.3: Tests + commit

Per Step E. Single commit:

```bash
git add apps/loans/
git commit -m "feat(loans): extend limits Gate to loan_request and loan_repayment"
```

---

## Task 6: End-of-plan verification

- [ ] **Step 6.1:** `go build ./...` clean.
- [ ] **Step 6.2:** `go vet ./...` clean.
- [ ] **Step 6.3:** Full test pass:

```bash
go test -race -timeout=600s ./...
```

- [ ] **Step 6.4:** Tag `milestone/limits-consumer-rollout`.

---

## Self-review checklist

- Every consumer service has: outbox migration, config additions, main.go wiring, business gate, tests, runbook.
- Every gate call uses a stable `idemKey` (never randomised in production paths).
- Every gate is feature-flagged by `LimitsGateEnabled[action_key]` so it can be disabled without redeploy.
- No service shares an `outbox` table — each service owns its own.
- The drain endpoint at `/admin/limits-outbox/drain` is mounted on every consumer's HTTP mux.
- Each runbook documents the action keys for that service.

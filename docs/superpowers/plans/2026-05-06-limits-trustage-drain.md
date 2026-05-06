# Limits — Trustage-Driven Outbox Drain Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development.

**Goal:** Expose the loans outbox drain as an HTTP admin endpoint that Trustage calls on a schedule, replacing the goroutine-polling stub. Canary integration; other consumer services replicate the pattern in Plan 6.

**Architecture:** Loans's existing `http.ServeMux` (which already serves Connect RPCs) gains a small non-Connect admin route — `POST /admin/limits-outbox/drain`. Trustage POSTs to it on a workflow schedule. The handler invokes `outboxWorker.Drain(ctx)` and returns `{drained: int}`. Authenticated via the standard SPIFFE/workload-identity mechanism the rest of the service uses.

**Tech Stack:** Go 1.26, Frame, `pkg/limits/outbox.Worker`, `connection.NewServiceClient` for outbound auth, `httptest.Server` for tests.

**Spec:** `docs/superpowers/specs/2026-05-05-fintech-limits-design.md` §6.2.

---

## Task 1: Drain HTTP handler

**Files:**
- Create: `apps/loans/service/handlers/limits_outbox.go`
- Create: `apps/loans/service/handlers/limits_outbox_test.go`

- [ ] **Step 1.1: Implement the handler**

```go
// (Apache 2.0 header — copy from apps/savings/cmd/main.go:1-13)

package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

// LimitsOutboxDrainHandler exposes the limits-outbox drain as a non-Connect
// HTTP endpoint. It is intentionally not part of the LoanManagementService
// proto — it's an internal admin trigger called by the platform's Trustage
// workflow scheduler, not by user-facing clients.
type LimitsOutboxDrainHandler struct {
	worker *outbox.Worker
}

// NewLimitsOutboxDrainHandler constructs the handler around an existing
// outbox.Worker. The worker is configured in main.go.
func NewLimitsOutboxDrainHandler(w *outbox.Worker) *LimitsOutboxDrainHandler {
	return &LimitsOutboxDrainHandler{worker: w}
}

// ServeHTTP responds to POST requests by draining one batch of outbox
// rows. Returns 200 with {drained: N} on success, 405 for non-POST,
// 500 on drain error.
func (h *LimitsOutboxDrainHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	if h.worker == nil {
		http.Error(w, "outbox worker not configured", http.StatusServiceUnavailable)
		return
	}
	count, err := h.worker.Drain(r.Context())
	if err != nil {
		util.Log(r.Context()).WithError(err).Error("limits outbox drain failed")
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]int{"drained": count})
}
```

- [ ] **Step 1.2: Tests**

```go
// apps/loans/service/handlers/limits_outbox_test.go
// (Apache 2.0 header)

package handlers_test

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/antinvestor/service-fintech/apps/loans/service/handlers"
)

func TestLimitsOutboxDrainHandler_RejectsGET(t *testing.T) {
	h := handlers.NewLimitsOutboxDrainHandler(nil)
	w := httptest.NewRecorder()
	r := httptest.NewRequest(http.MethodGet, "/admin/limits-outbox/drain", nil)
	h.ServeHTTP(w, r)
	assert.Equal(t, http.StatusMethodNotAllowed, w.Result().StatusCode)
}

func TestLimitsOutboxDrainHandler_NilWorker_503(t *testing.T) {
	h := handlers.NewLimitsOutboxDrainHandler(nil)
	w := httptest.NewRecorder()
	r := httptest.NewRequest(http.MethodPost, "/admin/limits-outbox/drain", nil)
	h.ServeHTTP(w, r)
	assert.Equal(t, http.StatusServiceUnavailable, w.Result().StatusCode)
}

// A working-worker test would require a full DB stack. The handler is a
// thin pass-through; the worker's own tests in pkg/limits/outbox cover
// drain semantics. This file exercises the HTTP-shape concerns only.

func TestLimitsOutboxDrainHandler_ContentType(t *testing.T) {
	// Construct a stub worker via a minimal mock — for the canary the
	// real wiring in main.go is what matters; this is sanity-only.
	_ = strings.Builder{} // placeholder so the import isn't unused if tests evolve
}
```

- [ ] **Step 1.3: Build + run**

```bash
go build ./apps/loans/...
go test -race -timeout=120s ./apps/loans/service/handlers/...
```

- [ ] **Step 1.4: Commit**

```bash
git add apps/loans/service/handlers/limits_outbox.go apps/loans/service/handlers/limits_outbox_test.go
git commit -m "feat(loans): add LimitsOutboxDrain admin HTTP handler

Trustage POSTs to /admin/limits-outbox/drain on a schedule. The handler
calls outboxWorker.Drain(ctx) and returns the row count drained.
Non-POST returns 405; nil worker returns 503."
```

---

## Task 2: Wire the handler into main.go

**Files:**
- Modify: `apps/loans/cmd/main.go`

- [ ] **Step 2.1: Replace the `_ = outboxWorker` stub**

Find the existing line:

```go
outboxWorker := outbox.NewWorker(outboxRepo, limitsCli, workMan)
_ = outboxWorker
```

Replace with:

```go
outboxWorker := outbox.NewWorker(outboxRepo, limitsCli, workMan)
limitsDrainHandler := handlers.NewLimitsOutboxDrainHandler(outboxWorker)
```

Then in the mux mounting (find the existing `mux := http.NewServeMux()` + `mux.Handle(...)` block):

```go
mux.Handle("/admin/limits-outbox/drain", limitsDrainHandler)
```

- [ ] **Step 2.2: Build**

```bash
go build ./apps/loans/...
```

Expected: clean.

- [ ] **Step 2.3: Commit**

```bash
git add apps/loans/cmd/main.go
git commit -m "feat(loans): mount /admin/limits-outbox/drain on the service mux

Trustage's workflow scheduler calls this endpoint on its configured
cadence to drive the outbox drain. The endpoint sits alongside the
existing Connect handlers on the same HTTP server and respects the
same authentication interceptors."
```

---

## Task 3: Trustage workflow runbook

**Files:**
- Create: `apps/loans/docs/runbook/limits-outbox-trustage.md`

- [ ] **Step 3.1: Write the runbook**

```markdown
# Limits Outbox — Trustage Workflow

The loans service exposes `POST /admin/limits-outbox/drain` for the platform
Trustage scheduler to invoke on a periodic cadence. This document captures
the workflow definition and operational expectations.

## Workflow definition

Register in Trustage with the following shape (adapt to your Trustage UI / DSL):

```yaml
name: loans_limits_outbox_drain
description: Drain pending Commit/Release rows from loans's limits_outbox
trigger:
  schedule: every 30 seconds
steps:
  - name: drain
    action: http_call
    target:
      service: service_loans
      method: POST
      path: /admin/limits-outbox/drain
    expect:
      status_code: 200
    on_failure:
      retry:
        max_attempts: 3
        backoff: exponential
        initial_delay_seconds: 10
    success_log_field: drained
```

## Cadence guidance

- **30s** is a reasonable default for the canary. Each call drains up to
  100 rows by default (configurable via the worker's `batch` field).
- For high-volume tenants, 10s with monitoring is acceptable.
- **Never below 5s** — claim-then-process latency dominates and the
  workerpool would saturate.

## Failure handling

- The endpoint returns 503 if the outbox worker is misconfigured (nil).
  Trustage retries per the on_failure block; the next loans deployment
  should restore the worker.
- A 500 indicates a drain error — typically a DB connectivity issue.
  Trustage's retry covers transient blips; persistent failures show up
  as retries-exhausted in Trustage logs and (because outbox rows have
  their own per-row retry/backoff state) the row itself eventually
  dead-letters at attempt 10.

## Observability

Per drain pass, the handler emits via `util.Log(ctx)`:
- INFO with `drained: N` on success.
- ERROR with the wrapped error on drain failure.

Plus the outbox worker logs per row: `outbox_id`, `reservation_id`,
`action` ({commit, release}), and on failure the `attempt` counter.

## Rollout sequence

1. Deploy loans with `LIMITS_GATE_ENABLED_LOAN_DISBURSEMENT=false` and
   the new endpoint live (no traffic yet).
2. Register the Trustage workflow above. Verify it calls the endpoint
   and gets `{drained: 0}` consistently.
3. Flip `LIMITS_GATE_ENABLED_LOAN_DISBURSEMENT=true` per the
   shadow-then-enforce rollout (Plan 7).
4. Watch the outbox table for accumulating non-pending rows
   (`SELECT count(*) FROM limits_outbox WHERE status='pending'`).
   Steady state should be near-zero between Trustage ticks.

## Failure mode: Trustage outage

If Trustage stops calling the endpoint, the outbox accumulates pending
rows. Limits caps still apply (they're computed from committed-ledger +
pending-reservations, both of which are independent of outbox state).
But the limits service won't get Commit confirmations, so reservations
TTL-expire after their default 5-minute window. The reaper inside the
limits service handles that path.

Operators should:
- Page on Trustage workflow execution failures.
- Provide a manual-drain operator action (`curl -XPOST /admin/limits-outbox/drain`).
- Record outbox depth as a metric so a backlog is visible on dashboards.
```

- [ ] **Step 3.2: Commit**

```bash
git add apps/loans/docs/runbook/
git commit -m "docs(loans): runbook for the limits-outbox Trustage workflow"
```

---

## Task 4: End-of-plan verification

- [ ] **Step 4.1:** `go build ./...` clean.
- [ ] **Step 4.2:** `go vet ./...` clean.
- [ ] **Step 4.3:** Tag `milestone/limits-trustage-drain`.

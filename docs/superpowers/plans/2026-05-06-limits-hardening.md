# Limits — Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development.

**Goal:** Validate the production-readiness of the limits service and its consumer integrations through chaos drills, runbook rehearsal, and capacity review. Outputs are: a chaos-drill harness exercising failure modes (limits service down, outbox DB down, Trustage outage, partial network partition); a load-test harness exercising 1k req/s sustained; a capacity-review document recording the results and recommended dimensions.

**Architecture:** The chaos harness is a Go-driven test (`pkg/limits/chaostests/`) that uses testcontainers to spin up the full limits-service + consumer (loans canary) stack, then simulates each failure mode by killing/blocking specific containers and asserting the consumer behaviour matches the spec (degrade open, degrade closed, queue, etc.). The load test uses `vegeta` against a deployed staging environment; results captured as a runbook artifact.

**Tech Stack:** Go 1.26, testcontainers-go, vegeta, k6 (alt), Frame.

**Spec:** `docs/superpowers/specs/2026-05-05-fintech-limits-design.md` §9 (operational concerns), §10 (capacity).

---

## Task 1: Chaos drill harness

**Files:**
- Create: `pkg/limits/chaostests/setup.go`
- Create: `pkg/limits/chaostests/limits_service_down_test.go`
- Create: `pkg/limits/chaostests/outbox_db_down_test.go`
- Create: `pkg/limits/chaostests/trustage_outage_test.go`
- Create: `pkg/limits/chaostests/network_partition_test.go`

- [ ] **Step 1.1: Setup**

```go
// pkg/limits/chaostests/setup.go

package chaostests

import (
    "context"
    "testing"

    "github.com/pitabwire/frame/frametests"
    "github.com/pitabwire/frame/frametests/definition"
    testpostgres "github.com/pitabwire/frame/frametests/deps/testpostgres"
)

type ChaosSuite struct {
    frametests.FrameBaseTestSuite
    LimitsContainerID string
    OutboxContainerID string
}

func (s *ChaosSuite) SetupSuite() {
    s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
        return []definition.TestResource{
            testpostgres.NewWithOpts("limits_test", definition.WithUserName("test")),
            testpostgres.NewWithOpts("loans_test",  definition.WithUserName("test")),
        }
    }
    s.FrameBaseTestSuite.SetupSuite()
}

// PauseLimitsService blocks the limits container's network for `d` then unblocks.
// Implementation: docker pause/unpause via testcontainers control client.
func (s *ChaosSuite) PauseLimitsService(t *testing.T, d time.Duration) {
    // ... testcontainers Pause/Unpause API
}
```

- [ ] **Step 1.2: Limits-service-down drill**

```go
func (s *ChaosSuite) TestLimitsServiceDown_GateFailsClosed(t *testing.T) {
    // Premise: with limits service unreachable, Gate (in ModeEnforce) returns
    // an error rather than admitting traffic. Spec §9.1: fail-closed by default.

    s.PauseLimitsService(t, 30*time.Second)
    defer s.UnpauseLimitsService(t)

    err := callGatedOperation(ctx)
    require.Error(t, err)
    assert.True(t, isUnavailableError(err))
}

func (s *ChaosSuite) TestLimitsServiceDown_ShadowModeProceeds(t *testing.T) {
    // Same scenario, but mode=shadow: handler runs despite RPC failure.
    s.PauseLimitsService(t, 30*time.Second)
    defer s.UnpauseLimitsService(t)

    err := callShadowGatedOperation(ctx)
    require.NoError(t, err)
}
```

- [ ] **Step 1.3: Outbox DB down drill**

```go
func (s *ChaosSuite) TestOutboxDBDown_GateAllowsAndQueues(t *testing.T) {
    // Reserve+handler succeed against the limits service. Then the outbox
    // INSERT fails because the consumer's DB is down.
    // Spec §6.2: handler must rollback its work to avoid drift.
    s.PauseConsumerDB(t, 30*time.Second)
    defer s.UnpauseConsumerDB(t)

    err := callGatedOperation(ctx)
    require.Error(t, err)

    // Reservation should still be live in the limits service; the reaper
    // will TTL it after 5 minutes.
    res, err := limitsClient.GetReservation(ctx, ...)
    require.NoError(t, err)
    assert.Equal(t, limitsv1.ReservationStatus_RESERVED, res.Status)
}
```

- [ ] **Step 1.4: Trustage outage drill**

```go
func (s *ChaosSuite) TestTrustageOutage_OutboxAccumulates_LimitsStillEnforced(t *testing.T) {
    // Stop calling /admin/limits-outbox/drain. Confirm:
    //   1. Outbox table accumulates pending rows.
    //   2. Reservations TTL after 5min and the limits service reaper handles them.
    //   3. Cap math (committed-ledger + pending-reservations) stays correct
    //      because pending reservations are independent of outbox state.
    //   4. After Trustage resumes (we manually call drain), the backlog drains.

    // Run 100 gated operations.
    for i := 0; i < 100; i++ {
        require.NoError(t, callGatedOperation(ctx))
    }
    // Verify all 100 outbox rows are pending.
    var pending int64
    require.NoError(t, db.Model(&Outbox{}).Where("status = ?", "pending").Count(&pending).Error)
    assert.EqualValues(t, 100, pending)

    // Wait for reservation TTL (5 minutes) — short-circuit by triggering
    // the reaper directly.
    require.NoError(t, runReaper(ctx))

    // Confirm cap math is still correct.
    cap, err := limitsClient.GetCurrentCap(ctx, ...)
    require.NoError(t, err)
    assert.Equal(t, expectedCap, cap)

    // Manually drain.
    drained, err := outboxWorker.Drain(ctx)
    require.NoError(t, err)
    assert.Equal(t, 100, drained)
}
```

- [ ] **Step 1.5: Network partition drill**

```go
func (s *ChaosSuite) TestNetworkPartition_PartialReachability(t *testing.T) {
    // Induce a partition where the consumer can reach the limits service
    // but the limits service cannot reach its own DB.
    // Expected: limits service returns Unavailable; consumer fails closed
    // (or proceeds in shadow); no half-applied state.
    s.BlockLimitsToDB(t, 30*time.Second)
    defer s.UnblockLimitsToDB(t)

    err := callGatedOperation(ctx)
    require.Error(t, err)
    assert.True(t, isUnavailableError(err))
}
```

- [ ] **Step 1.6: Run + commit**

```bash
go test -race -timeout=600s -tags=chaos ./pkg/limits/chaostests/...
git add pkg/limits/chaostests/
git commit -m "test(limits): chaos drills for fail-closed, fail-open, partition, Trustage outage

Each drill spins up the limits-service + consumer stack via testcontainers
and pauses the relevant container to simulate the failure. Asserts the
consumer behaviour matches the spec section 9 contract."
```

(Tag with `-tags=chaos` so these are opt-in; CI can run them on a nightly schedule rather than every PR.)

---

## Task 2: Load test harness

**Files:**
- Create: `pkg/limits/loadtests/run.go` — vegeta orchestrator
- Create: `pkg/limits/loadtests/scenarios.json` — request mix definitions
- Create: `docs/runbook/limits-loadtest-results-2026-05-06.md` — results capture

- [ ] **Step 2.1: Vegeta orchestrator**

A small Go program that:
1. Generates 1k req/s of mixed Reserve-then-Commit pairs (80%) and Reserve-then-Release (20%).
2. Runs for 10 minutes (configurable).
3. Captures p50/p95/p99 latency and error rates per RPC.
4. Outputs a markdown summary.

```go
func main() {
    rate := vegeta.Rate{Freq: 1000, Per: time.Second}
    duration := 10 * time.Minute
    targeter := makeTargeter(*targetURL)
    attacker := vegeta.NewAttacker()

    var metrics vegeta.Metrics
    for res := range attacker.Attack(targeter, rate, duration, "limits") {
        metrics.Add(res)
    }
    metrics.Close()

    fmt.Printf("p99 latency: %v\n", metrics.Latencies.P99)
    fmt.Printf("success rate: %.2f%%\n", metrics.Success*100)
}
```

- [ ] **Step 2.2: Results capture**

Run against staging. Record in `docs/runbook/limits-loadtest-results-2026-05-06.md`:

- Achieved RPS, p50/p95/p99 latencies for Reserve, Commit, Release.
- DB connection-pool saturation at peak.
- Approval-queue insert throughput (test pending-approval path separately).
- Memory/CPU on limits service pods.
- Recommended HPA dimensions (CPU target, replicas at peak).

- [ ] **Step 2.3: Commit**

```bash
git add pkg/limits/loadtests/ docs/runbook/limits-loadtest-results-2026-05-06.md
git commit -m "test(limits): load test harness + 1k rps staging results"
```

---

## Task 3: Capacity review document

**Files:**
- Create: `docs/runbook/limits-capacity-review.md`

- [ ] **Step 3.1: Write the review**

```markdown
# Limits — Capacity Review

## Production targets

| Metric                | Target           | Headroom |
|-----------------------|------------------|----------|
| Reserve p99 latency   | <50ms            | 30%      |
| Commit p99 latency    | <50ms            | 30%      |
| Throughput            | 1k rps sustained | 50%      |
| Approval-queue depth  | <100 pending     | n/a      |

## Bottlenecks identified during load testing

1. **DB connection pool**: at 1k rps Reserve+Commit, the limits service
   needs ~80 connections per pod. Pool size set to 100; HPA target CPU
   60% so pods scale before connection saturation.
2. **Advisory locks on subject_id**: Reserve serialises per-subject. At
   1k rps with 1k unique subjects, no contention. With <100 unique
   subjects (e.g. concentrated traffic on a single account), Reserve
   degrades to sequential per-subject. Mitigation: observability metric
   `limits_reserve_subject_contention` to detect.
3. **Outbox table growth**: at 1k rps, ~86M rows/day at full retention.
   Recommend: nightly job that deletes done rows >7 days old. Migration
   pre-stages a partial index only on pending+retry rows so done-row
   bulk doesn't slow ClaimDue.

## Headroom plan

- 50% above peak production load. If Reserve sustained traffic exceeds
  1.5k rps, scale limits service replicas and DB pool linearly.
- Approval-queue depth >500: page on-call. Either pending volume is
  spiking (legitimate — investigate cause) or approvers are not
  acting fast enough (process issue).
- Outbox depth >10k pending across all consumer services: page on-call.
  Trustage may be unhealthy or one of the consumer DBs is down.

## Reaper SLAs

- Reserved-but-not-committed reservations: TTL 5 minutes. Reaper
  releases on the next pass after TTL expiry.
- Pending-approval reservations: TTL 24 hours. Operator action required
  before that.
- Outbox dead-letter rows: notify ops on creation; manual triage.

## Open issues

1. Approval queue currently has no priority ordering. Future work:
   priority lane for high-value subjects.
2. Per-tenant rate limiting on Reserve itself (not just on the operations
   it gates) is not implemented. Future work: token bucket per tenant.
3. Bridge to org/orgUnit-level cap aggregation is computed at Reserve
   time. Future work: materialised aggregates updated by a worker for
   sub-1ms p99.
```

- [ ] **Step 3.2: Commit**

```bash
git add docs/runbook/limits-capacity-review.md
git commit -m "docs(limits): capacity review with load-test findings + headroom plan"
```

---

## Task 4: Runbook rehearsal log

**Files:**
- Create: `docs/runbook/limits-rehearsal-2026-05-06.md`

- [ ] **Step 4.1: Run a rehearsal**

A team member walks through `docs/runbook/limits-rollout.md` step-by-step in staging for one canary action (`loan_disbursement`). Record:

- Time-to-shadow-on (target: <5 min from decision to traffic flowing).
- Time-to-enforce-on (target: <5 min from shadow-clean to enforce).
- Time-to-rollback (target: <2 min from incident page to mode flip).
- Any steps in the runbook that were unclear or required interpretation.

Update the master runbook with corrections.

- [ ] **Step 4.2: Commit the rehearsal log + runbook fixes**

```bash
git add docs/runbook/
git commit -m "docs(limits): rehearsal log + runbook corrections from staging dry-run"
```

---

## Task 5: End-of-plan verification

- [ ] **Step 5.1:** `go build ./...` clean.
- [ ] **Step 5.2:** `go vet ./...` clean.
- [ ] **Step 5.3:** Run chaos suite once, confirm all drills green.
- [ ] **Step 5.4:** Tag `milestone/limits-hardening`.

---

## Definition of done

- All four chaos drills pass.
- Load test shows 1k rps sustained with p99 <50ms on Reserve and Commit.
- Capacity review documents bottlenecks with mitigation.
- Runbook rehearsal completed; corrections merged.
- Tag `milestone/limits-hardening` applied — limits initiative complete.

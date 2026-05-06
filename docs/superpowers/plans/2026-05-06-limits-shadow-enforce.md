# Limits — Shadow → Enforce Rollout Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development.

**Goal:** Provide the operational utilities and runbook for flipping each `LIMITS_GATE_ENABLED_<action>` flag from off → shadow → enforce, the safe rollout sequence used in production. Outputs are: a `pkg/limits/shadow` middleware that lets a Gate call be evaluated without enforcing, a CLI helper for operators to inspect the queue and toggle policies, and a master runbook.

**Architecture:** Shadow mode invokes the same `Reserve` RPC the production gate uses, but on `LimitBreachedError` it logs+audits the would-have-blocked decision and proceeds with the underlying operation. Pending-approval errors degrade similarly to "would have queued for approval." The only material change to `pkg/limits/gate.go` is a `Mode` parameter. The CLI utility (`cmd/limits-admin`) wraps the limits service's `ListPolicies`, `ListReservations`, `ApprovePending` Connect endpoints with operator-friendly output.

**Tech Stack:** Go 1.26, Frame, Connect RPC, `pkg/audit`, cobra for CLI.

**Spec:** `docs/superpowers/specs/2026-05-05-fintech-limits-design.md` §8 (rollout), §6A (audit on limiting).

---

## Task 1: Add shadow mode to pkg/limits.Gate

**Files:**
- Modify: `pkg/limits/gate.go`
- Modify: `pkg/limits/gate_test.go`

- [ ] **Step 1.1: Extend the Gate signature**

Current shape:

```go
func Gate(ctx context.Context, rpc limitsv1connect.LimitsServiceClient,
    intent *limitsv1.LimitIntent, idempotencyKey string,
    handler func(ctx context.Context, reservationID string) error) error
```

New shape:

```go
type Mode int

const (
    ModeEnforce Mode = iota // default; breach blocks, pending blocks
    ModeShadow              // breach logged+audited, then runs; pending logged, then runs
)

func Gate(ctx context.Context, rpc limitsv1connect.LimitsServiceClient,
    intent *limitsv1.LimitIntent, idempotencyKey string, mode Mode,
    handler func(ctx context.Context, reservationID string) error) error
```

The default value `ModeEnforce` matches the existing behaviour, so callers can be migrated incrementally.

- [ ] **Step 1.2: Implement shadow handling**

```go
res, err := rpc.Reserve(ctx, connect.NewRequest(&limitsv1.ReserveRequest{
    Intent:         intent,
    IdempotencyKey: idempotencyKey,
}))
if err != nil {
    if mode == ModeShadow {
        util.Log(ctx).
            With("action_key", intent.ActionKey).
            With("subject_id", intent.SubjectId).
            With("shadow_outcome", "rpc_error").
            WithError(err).Warn("limits shadow: Reserve failed; proceeding")
        // No reservation ID, so handler runs without one.
        return handler(ctx, "")
    }
    return err
}

verdict := res.Msg.GetOutcome()
switch verdict {
case limitsv1.Outcome_OUTCOME_ALLOW:
    // Same as today — run handler with reservation; on success, enqueue Commit.
case limitsv1.Outcome_OUTCOME_DENY:
    if mode == ModeShadow {
        util.Log(ctx).
            With("action_key", intent.ActionKey).
            With("reservation_id", res.Msg.GetReservationId()).
            With("verdicts", verdictSummary(res.Msg.GetVerdicts())).
            With("shadow_outcome", "would_block").
            Warn("limits shadow: would have blocked; proceeding")
        // Release the reservation so it doesn't sit in the limits service.
        _, _ = rpc.Release(ctx, connect.NewRequest(&limitsv1.ReleaseRequest{
            ReservationId: res.Msg.GetReservationId(),
            Reason:        "shadow_mode_release",
        }))
        return handler(ctx, "")
    }
    return &LimitBreachedError{Verdicts: res.Msg.GetVerdicts()}
case limitsv1.Outcome_OUTCOME_PENDING_APPROVAL:
    if mode == ModeShadow {
        util.Log(ctx).
            With("action_key", intent.ActionKey).
            With("reservation_id", res.Msg.GetReservationId()).
            With("shadow_outcome", "would_pend").
            Warn("limits shadow: would have queued for approval; proceeding")
        _, _ = rpc.Release(ctx, connect.NewRequest(&limitsv1.ReleaseRequest{
            ReservationId: res.Msg.GetReservationId(),
            Reason:        "shadow_mode_release",
        }))
        return handler(ctx, "")
    }
    return &PendingApprovalError{
        ReservationID: res.Msg.GetReservationId(),
        Verdicts:      res.Msg.GetVerdicts(),
    }
}
```

- [ ] **Step 1.3: Add tests**

Three new tests exercising shadow mode:

```go
func TestGate_Shadow_DeniedReservation_RunsHandler(t *testing.T)
func TestGate_Shadow_PendingReservation_RunsHandler(t *testing.T)
func TestGate_Shadow_RPCError_RunsHandler(t *testing.T)
```

Each uses an in-memory `limitsv1connect.LimitsServiceClient` stub that returns the relevant outcome, asserts the handler ran, and checks the log output via `util.Log`'s test capture.

- [ ] **Step 1.4: Migrate callers**

Add `mode` parameter to every Gate caller. Default to `ModeEnforce`. Drive from a per-action `LIMITS_GATE_MODE_<action>` env (one of: `off`, `shadow`, `enforce`).

```go
mode := limits.ModeEnforce
if cfg.LimitsGateMode[actionKey] == "shadow" {
    mode = limits.ModeShadow
}
```

Apply across loans, savings, operations, funding, stawi.

- [ ] **Step 1.5: Build + test**

```bash
go build ./...
go test -race -timeout=600s ./pkg/limits/... ./apps/...
```

- [ ] **Step 1.6: Commit**

```bash
git commit -m "feat(limits): add shadow mode to Gate for safe rollout

Shadow mode invokes Reserve as in enforce, but on deny/pending logs the
verdict and proceeds with the underlying operation. Releases the dummy
reservation so it doesn't accumulate in the limits service. Per-action
LIMITS_GATE_MODE env switches off/shadow/enforce; defaults to off (no
RPC call), matches old behaviour when set to enforce."
```

---

## Task 2: limits-admin CLI

**Files:**
- Create: `cmd/limits-admin/main.go`
- Create: `cmd/limits-admin/policies.go`
- Create: `cmd/limits-admin/reservations.go`
- Create: `cmd/limits-admin/approvals.go`

- [ ] **Step 2.1: Skeleton**

Use cobra. Top-level: `limits-admin --uri=https://limits.internal <subcommand>`. Subcommands:

- `policies list [--scope=...] [--action=...]`
- `policies show <id>`
- `policies enable <id>` / `policies disable <id>`
- `reservations list --status=pending`
- `reservations show <id>`
- `approvals approve <reservation-id> --reason=...`
- `approvals reject <reservation-id> --reason=...`

Each subcommand calls the existing Connect endpoints; no new server-side surface.

- [ ] **Step 2.2: Output format**

Default to `tabwriter` plaintext. `--json` flag emits JSON for scripting. `--watch` flag for `reservations list --status=pending` re-runs every 5s.

- [ ] **Step 2.3: Tests**

```go
func TestPoliciesList_FormatsTable(t *testing.T)
func TestApprove_RequiresReason(t *testing.T)
```

Use `httptest.Server` + the Connect handler to wire up the CLI under test.

- [ ] **Step 2.4: Build + commit**

```bash
go build ./cmd/limits-admin/
go test -race -timeout=120s ./cmd/limits-admin/...
git add cmd/limits-admin/
git commit -m "feat(limits): add limits-admin CLI for operator workflows"
```

---

## Task 3: Master rollout runbook

**Files:**
- Create: `docs/runbook/limits-rollout.md`

- [ ] **Step 3.1: Write the runbook**

```markdown
# Limits — Production Rollout Runbook

This runbook walks through enabling limits enforcement for a new action key.
Use it once per (service, action) pair.

## Stages

```
off → shadow → enforce
```

Never skip shadow. Shadow mode is the only way to detect false positives
(policies that would block legitimate operations) without customer impact.

## Stage 1 — off (initial deployment)

1. Deploy the consumer service with the limits Gate code in place but
   `LIMITS_GATE_MODE_<action>=off`. The Gate is a no-op: it does not call
   Reserve at all. Handler runs unchanged.
2. Verify deployment health: error rates, latency, business KPIs steady.

## Stage 2 — shadow (24-72 hours, depending on volume)

1. Set `LIMITS_GATE_MODE_<action>=shadow` and redeploy (or rolling-restart
   pods). The Gate now calls Reserve but does not enforce.
2. Watch for shadow-outcome logs. Specifically:
   - Aggregate count of `shadow_outcome=would_block` per action_key per hour.
   - Top subject_ids triggering would_block.
   - Top policy_ids cited in verdicts.
3. **Threshold for "ready to enforce":**
   - would_block rate is <0.1% of total operations, OR
   - the operations triggering would_block are explicable (matched the
     policy intent) and reviewed with stakeholders.
4. **If the rate is too high:** loosen the policy, or carve out exceptions
   via `policies disable <id>` for the offending policy. Repeat the
   24-72h soak before flipping to enforce.

## Stage 3 — enforce

1. Set `LIMITS_GATE_MODE_<action>=enforce` and redeploy.
2. Watch for:
   - HTTP 412 (FailedPrecondition) and 429 (ResourceExhausted) on the
     consumer service's Connect endpoints.
   - Approval queue depth (`limits-admin reservations list --status=pending`).
   - Customer support tickets about blocked operations.
3. Have an on-call operator with `limits-admin approvals approve` ready
   for legitimate-but-blocked cases. Document the override workflow in
   the consumer service's customer-facing runbook.

## Rollback

If enforce mode causes incidents:

1. **Fastest:** flip `LIMITS_GATE_MODE_<action>` back to `shadow` and
   redeploy. Operations stop being blocked but observability stays on.
2. **Slower:** disable the offending policy via
   `limits-admin policies disable <id>`. Gate still fires Reserve but the
   verdict comes back ALLOW for everything.
3. **Coldest:** flip to `off`. Useful only if Reserve itself is unhealthy.

## Per-action keys

| Service     | Action key                   | Subject       |
|-------------|------------------------------|---------------|
| loans       | loan_disbursement            | borrower      |
| loans       | loan_request_approval        | borrower      |
| loans       | loan_repayment               | borrower      |
| savings     | savings_deposit              | account       |
| savings     | savings_withdrawal           | account       |
| operations  | operations_transfer          | source acct   |
| funding     | funding_deposit              | invest acct   |
| funding     | funding_withdraw             | invest acct   |
| stawi       | stawi_loan_disbursement      | member        |

## Escalation

- Slack: #fintech-limits
- On-call: limits-oncall (PagerDuty)
- Emergency disable: see "Rollback" above; any of the three modes
  resolves an incident in under 5 minutes.
```

- [ ] **Step 3.2: Commit**

```bash
git add docs/runbook/limits-rollout.md
git commit -m "docs: master rollout runbook for limits Gate flag flips"
```

---

## Task 4: End-of-plan verification

- [ ] **Step 4.1:** `go build ./...` clean.
- [ ] **Step 4.2:** `go vet ./...` clean.
- [ ] **Step 4.3:** Tag `milestone/limits-shadow-enforce`.

# Limits Outbox — Trustage Workflow

The funding service exposes `POST /admin/limits-outbox/drain` for the platform
Trustage scheduler to invoke on a periodic cadence. This document captures
the workflow definition and operational expectations.

## Workflow definition

Register in Trustage with the following shape (adapt to your Trustage UI / DSL):

```yaml
name: funding_limits_outbox_drain
description: Drain pending Commit/Release rows from funding's limits_outbox
trigger:
  schedule: every 30 seconds
steps:
  - name: drain
    action: http_call
    target:
      service: service_funding
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
  Trustage retries per the on_failure block; the next funding deployment
  should restore the worker.
- A 500 indicates a drain error — typically a DB connectivity issue.
  Trustage's retry covers transient blips; persistent failures show up
  as retries-exhausted in Trustage logs. Per-row retry/backoff state on
  outbox rows means individual rows still dead-letter at attempt 10
  even if Trustage isn't running.

## Observability

Per drain pass, the handler emits via `util.Log(ctx)`:
- INFO with `drained: N` on success.
- ERROR with the wrapped error on drain failure.

Plus the outbox worker logs per row: `outbox_id`, `reservation_id`,
`action` ({commit, release}), and on failure the `attempt` counter.

## Rollout sequence

1. Deploy funding with `LIMITS_GATE_ENABLED_FUNDING_DEPOSIT=false` and
   `LIMITS_GATE_ENABLED_FUNDING_WITHDRAW=false` and the new endpoint live
   (no traffic yet).
2. Register the Trustage workflow above. Verify it calls the endpoint
   and gets `{drained: 0}` consistently.
3. Flip `LIMITS_GATE_ENABLED_FUNDING_DEPOSIT=true` and/or
   `LIMITS_GATE_ENABLED_FUNDING_WITHDRAW=true` per the
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

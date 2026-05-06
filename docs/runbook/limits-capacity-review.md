# Limits — Capacity Review

## Production targets

| Metric                | Target           | Headroom |
|-----------------------|------------------|----------|
| Reserve p99 latency   | <50ms            | 30%      |
| Commit p99 latency    | <50ms            | 30%      |
| Throughput            | 1k rps sustained | 50%      |
| Approval-queue depth  | <100 pending     | n/a      |

## Bottlenecks identified during load testing

**Status:** Targets and headroom expectations below were established from architecture review. Actual measurements from production load tests should be filled in after each staging run; see `pkg/limits/loadtests/README.md` for the harness.

1. **DB connection pool**: at 1k rps Reserve+Commit, the limits service
   needs ~80 connections per pod. Pool size set to 100; HPA target CPU
   60% so pods scale before connection saturation.
2. **Advisory locks on subject_id**: Reserve serialises per-subject. At
   1k rps with 1k unique subjects, no contention. With <100 unique
   subjects (e.g. concentrated traffic on a single account), Reserve
   degrades to sequential per-subject. Mitigation: observability metric
   `limits_reserve_subject_contention` to detect.
3. No outbox; cap reconciliation via TTL + audit pipeline.

## Headroom plan

- 50% above peak production load. If Reserve sustained traffic exceeds
  1.5k rps, scale limits service replicas and DB pool linearly.
- Approval-queue depth >500: page on-call. Either pending volume is
  spiking (legitimate — investigate cause) or approvers are not
  acting fast enough (process issue).
## Reaper SLAs

- Reserved-but-not-committed reservations: TTL 5 minutes. Reaper
  releases on the next pass after TTL expiry.
- Pending-approval reservations: TTL 24 hours. Operator action required
  before that.

## Open issues

1. Approval queue currently has no priority ordering. Future work:
   priority lane for high-value subjects.
2. Per-tenant rate limiting on Reserve itself (not just on the operations
   it gates) is not implemented. Future work: token bucket per tenant.
3. Bridge to org/orgUnit-level cap aggregation is computed at Reserve
   time. Future work: materialised aggregates updated by a worker for
   sub-1ms p99.

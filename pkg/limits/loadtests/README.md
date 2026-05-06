# Limits Load Test

A bounded-throughput orchestrator that exercises the limits service
Reserve+Commit+Release path at production-target rates using the
[vegeta](https://github.com/tsenart/vegeta) HTTP load testing library.

## Build

```bash
go build -tags=loadtest -o limits-loadtest ./pkg/limits/loadtests/
```

The `loadtest` build tag keeps this binary out of normal `go build ./...`
and CI per-PR runs.

## Run

```bash
./limits-loadtest \
  --target=https://limits.staging.internal \
  --rps=1000 \
  --duration=10m \
  --subjects=1000 \
  --output=loadtest-results.json
```

### Flags

| Flag | Default | Description |
|------|---------|-------------|
| `--target` | (required) | Limits service base URL |
| `--rps` | 1000 | Target requests per second |
| `--duration` | 10m | Attack duration |
| `--subjects` | 1000 | Number of distinct subject IDs to rotate through |
| `--output` | `loadtest-results.json` | Path for JSON metrics output |

## Request mix

The targeter emits an 80/20 mix of Reserve+Commit and Reserve+Release pairs.
Each Reserve uses a subject ID drawn from a rotating pool of `--subjects`
synthetic subject IDs to avoid all requests hitting the same per-subject
advisory lock.

Requests use the Connect protocol JSON encoding over HTTP/1.1
(`Content-Type: application/json`, `Connect-Protocol-Version: 1`), which
allows vegeta to exercise the full HTTP stack without requiring binary proto
serialisation at load-test build time.

## Capacity targets

| Metric | Target |
|--------|--------|
| p99 Reserve+Commit latency | < 50 ms |
| Sustained throughput | 1 000 req/s for 10 minutes |
| Success rate | > 99.9 % |

Failures at these levels surface DB-pool contention, advisory-lock hot
spots, or downstream Trustage backlog. See
`docs/runbook/limits-capacity-review.md` for the diagnosis workflow.

## Output

Results are written to `loadtest-results.json` in `vegeta.Metrics` JSON
format and can be ingested by the capacity review documents. A summary is
also printed to stdout:

```
=== Limits Load Test Results ===
requests    : 600000
rate        : 1000.00 req/s
throughput  :  999.87 req/s
p50 latency : 12ms
p95 latency : 31ms
p99 latency : 46ms
max latency : 210ms
success rate: 99.9987%
errors      : 0

[PASS] p99 latency 46ms is within target of 50ms
[PASS] success rate 99.9987% meets target 99.9%
```

## Alternative: goroutine-pool approach

If you need accurate two-phase Reserve→Commit sequencing (vegeta cannot
naturally carry state between requests), an alternative is to bypass
vegeta's attack loop and instead run a goroutine pool where each goroutine
calls the real generated Connect client:

```go
// Pseudocode — replace vegeta.Attacker with direct Connect client calls
sem := make(chan struct{}, rps)
for i := 0; i < totalRequests; i++ {
    sem <- struct{}{}
    go func() {
        defer func() { <-sem }()
        res, _ := limitsClient.Reserve(ctx, ...)
        start := time.Now()
        limitsClient.Commit(ctx, &limitsv1.CommitRequest{ReservationId: res.Msg.GetReservation().GetId()})
        recordLatency(time.Since(start))
    }()
}
```

This gives exact Reserve+Commit pairing at the cost of losing vegeta's
built-in metrics aggregation. Implement in a separate `cmd/limits-e2e-bench`
binary if needed.

## Prerequisites

- The limits service must be reachable from the machine running the binary.
- The service must accept unauthenticated requests on the load-test endpoint,
  or you must inject an auth header (e.g. a staging service account token)
  via an HTTP middleware proxy in front of `--target`.
- For accurate results, run from a machine in the same network region as the
  limits service to eliminate cross-region latency.

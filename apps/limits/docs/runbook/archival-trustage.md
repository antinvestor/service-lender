# Limits — Archival Trustage Workflow

The limits service exposes `POST /admin/archive` for periodic cleanup of
terminal reservations (>7 days old) and ledger entries (>90 days old).
Trustage calls this endpoint on a schedule.

## Authentication

`POST /admin/archive` is protected by the same JWT bearer-token authenticator
used by all Connect RPC endpoints in the limits service (via
`httptor.AuthenticationMiddleware`). Trustage must present a valid OIDC access
token issued by the configured identity provider.

Add the `Authorization` header to the Trustage step:

```yaml
headers:
  Authorization: "Bearer <oidc-access-token>"
```

Requests without a bearer token receive **HTTP 401**.  
Requests with an invalid or expired token receive **HTTP 403**.

The identity used must be a machine/service-account principal that the OIDC
provider recognises. Rotate the token according to your OIDC provider's
service-account credential lifecycle (typically via Workload Identity or a
client-credentials grant).

## Workflow

```yaml
name: limits_archive
trigger:
  schedule: every 1 hour
steps:
  - name: archive
    action: http_call
    target:
      service: service_limits
      method: POST
      path: /admin/archive
    expect:
      status_code: 200
```

## Cadence guidance

- Hourly is the recommended cadence.
- Daily is acceptable for low-volume deployments.
- Sub-hourly is unnecessary overhead.

## Failure handling

- HTTP 500 indicates a DB connectivity or query error. Trustage retries;
  an hour-long pause is acceptable for archival purposes.
- HTTP 405 indicates the caller used GET instead of POST.

## Observability

Each run emits an INFO log with:

```
{"job":"archival","reservations_deleted":N,"ledger_deleted":M,"msg":"archival run complete"}
```

- Steadily non-zero counts → DB is keeping up with the inflow.
- Stuck at zero for more than a week → nothing is eligible (unexpected for
  a busy service; investigate whether terminal statuses are being set).
- Rising counts that never fall → archival frequency may need increasing or
  the cutoff windows may need shortening.

## Cutoffs

| Table                  | Column        | Cutoff |
|------------------------|---------------|--------|
| `limits_reservations`  | `modified_at` | 7 days |
| `limits_ledger`        | `committed_at`| 90 days|

Terminal reservation statuses eligible for deletion: `committed`, `released`,
`reversed`, `expired`.

Active and `pending_approval` reservations are never deleted by this job.

# Fintech Limits Service — Design

**Status:** Draft for review
**Date:** 2026-05-05
**Owner:** Peter Bwire (`bwire517@gmail.com`)
**Related memories:** `feedback_sql_migrations`, `feedback_no_manual_keto`, `feedback_opl_management`, `feedback_go_permissions`, `project_tenancy_hierarchy`, `project_keto_partition_sync`, `project_audit_middleware_library`

---

## 1. Problem & goals

The fintech platform handles disbursements, loan requests, repayments, savings deposits/withdrawals, transfer orders, funding flows, and group contributions/payouts across multiple services. Today, amount validation is scattered: `LoanProduct.MinAmount/MaxAmount` is enforced in-process inside `loans`, `seed/CreditTierConfig` provides per-client tiered caps for loans only, and several monetary actions have no caps at all.

There is no platform-wide notion of velocity caps (rolling-window aggregates), no transaction-count caps, no maker-checker thresholds, and no cross-service usage ledger. Without these, regulatory caps cannot be enforced uniformly, fraud/AML signals must be reconstructed from consumer-service logs, and risk officers cannot tighten policy without a code release.

**Goal:** introduce a robust, dedicated `limits` service that every monetary action consults pre-commit. It owns:

- Policy authoring (per-tenant, per-organization, per-branch, with platform overlay).
- A usage ledger (rolling-window counters).
- An approval workflow (maker-checker with N-of-M and re-evaluation).
- Reservation lifecycle (Reserve → Commit/Release/Reverse).

Out of scope: AML/fraud detection (limits service emits signals; a separate pipeline reacts), and approval UI (separate spec).

## 2. Decisions made during design

The following choices are settled. References point to the dialogue that produced them.

| # | Decision | Source |
|---|---|---|
| D1 | Scope: amount + velocity + count + approval thresholds | Q1 |
| D2 | Subjects: per-product, per-client, per-account, per-organization, per-org-unit, per-workforce-member; "lowest applicable cap wins" composition | Q2 |
| D3 | Architecture: dedicated service `apps/limits` with Postgres-backed ledger; not a shared library | Q3 |
| D4 | Surfaces: every monetary action consults the gate (11 RPCs across `loans`, `savings`, `operations`, `funding`, `stawi`); inflows use soft mode | Q4 |
| D5 | Approver model: specific role per policy, anyone-with-role-not-the-maker; tiered N-of-M up to 11 approvers; re-evaluate on decision; default 72h timeout | Q5 |
| D6 | Failure: fail-closed always; both hard and soft (shadow-emit) modes; shadow mode supported per policy | Q6 |
| D7 | Layered config: platform + org + org-unit, min-take across layers; rolling windows (not fixed) | Q7 |
| D8 | Per-currency ledgers (no FX conversion at check time); three-phase Reserve+Commit+Release with 5min default TTL (72h when pending approval); reversal marks ledger rows but doesn't retroactively unblock past breaches; KYC tier as a subject-attribute predicate (read-through from identity) | Q8 |
| D9 | Integration shape: explicit business-layer integration via `pkg/limits.Client.Gate`, with a CI lint enforcing every `method_money: true` RPC reaches the limits client | Q-approach |
| D10 | Tenancy: `data.BaseModel` provides `TenantID`/`PartitionID`/`AccessID`; queries rely on Frame's `scopes.TenancyPartition`; explicit `OrgUnitID` column for branch-level scoping | user feedback during Section 2 |
| D11 | Money: stored as `int64` minor units in DB, transported as `google.type.Money` on the wire, math in `decimalx.Decimal`; new `pkg/money` provides currency-precision-aware helpers | user feedback during Section 2 |
| D12 | Migrations: Go-driven via `dbManager.Migrate(ctx, dbPool, migrationPath, &models...)`; SQL files only for column-rename / data-transform edges (per repo policy) | user feedback during Section 2 |
| D13 | Audit-on-limiting: every gating decision (hard breach, shadow breach, approval-required, approval-decided, TTL-expired, commit, release, reverse) is recorded via the existing `pkg/audit` infrastructure — `audit.Writer.Record` dispatches via Frame events to the per-service `EventSave` handler that persists into the limits DB's `audit_events` table (already migrated in Plan 1). No new model, no new table; namespaced action verbs (`limits.breach.hard`, `limits.approval.approved`, ...) plus the existing `Metadata` JSON bag carry the structured detail. | user feedback post-foundations plan |
| D14 | UI: a dedicated `ui/limits/` Flutter package mirroring the per-domain pattern of `ui/savings/`, `ui/loans/`, etc. Consumes `antinvestor_api_limits` (a new Dart proto package generated via `proto/buf.gen.dart.limits.yaml` and added to `DART_MODULES` in the Makefile). Riverpod 3 state, go_router routing, embeds in `ui/seed/`. | user feedback post-foundations plan |
| D15 | Money: pitabwire/util/money is the canonical platform-wide helper. Local `pkg/money` is gone; loans/savings/operations/funding/identity/limits all delegate via thin wrappers. ISO 4217 precision is honoured (JPY/KRW/KWD/BHD correct). | user feedback during platform cleanup |

## 3. Service shape & deployment

A new app `apps/limits` joins the fleet, following the standard three-layer Frame pattern (handlers → business → repository). Persistence: dedicated Postgres database `fintech_limits`. Public surface: Connect RPC.

Two services in one proto package, split because of differing permission profiles, latency budgets, and SLOs:

- **`limits.v1.LimitsService`** — runtime path: `Check`, `Reserve`, `Commit`, `Release`, `Reverse`. Called by every monetary action across the platform.
- **`limits.v1.LimitsAdminService`** — control plane: policy CRUD, approval queue + decisions, ledger search.

Both registered with `frame.WithPermissionRegistration` so permissions flow from proto annotations into Keto via the standard sync (never written manually).

**HA topology:**

- ≥3 replicas, anti-affinity across nodes/AZs, HPA on CPU + RPS.
- Postgres primary + 2 replicas; one sync replica gives RPO=0 on the Reserve/Commit path.
- Reads that depend on rolling-window state route to primary; policy reads can hit replicas.
- In-process LRU policy cache (60s TTL); invalidation via `limits.policy.invalidate.v1` Frame Queue events.
- Subject-attribute cache (KYC tier etc.) keyed on `(subject_type, subject_id)`, 60s TTL, invalidated by `identity.client.attribute_changed.v1`.
- Standard Frame logging (`util.Log(ctx)`) and OpenTelemetry traces/metrics.

**Permissions registered:**

| Permission | Scope | Granted to |
|---|---|---|
| `limits_use` | Service-account | Every consumer service (`loans`, `savings`, `operations`, `funding`, `stawi`) |
| `limits_policy_manage` | Platform / per-org | Platform admins (platform policies); org admins (org / org-unit policies) |
| `limits_policy_view` | Per-org | Org admins, risk officers |
| `limits_approval_view` | Per-org | Operations leads, queues view |
| `limits_approval_act` | Per-org | Roles named in `policy.approver_tiers` |
| `limits_approval_override` | Per-org | Senior risk role; emergency-cancel only; audit-heavy |
| `limits_ledger_view` | Per-org | Risk, audit, compliance |

## 4. Domain model

All entities embed `data.BaseModel`, which provides `ID`, `TenantID` (org), `PartitionID`, `AccessID`, `CreatedBy`, `ModifiedBy`, `Version`, `CreatedAt`, `ModifiedAt`, `DeletedAt`. **No model redeclares those columns.** Filtering by tenant relies on Frame's `scopes.TenancyPartition` reading auth claims; queries do not reference `tenant_id` directly except in repository methods explicitly bypassing the scope (see §6.4).

### 4.1 Money handling rules

- **Wire (proto):** `google.type.Money` with `currency_code` + `units` + `nanos`. Never plain int.
- **In-flight math:** `pitabwire/util/decimalx.Decimal`. Never `float64`.
- **At rest:** `BIGINT NOT NULL` minor units (`int64`), paired with `VARCHAR(3) NOT NULL` currency on the same row.
- **Currency precision:** new `pkg/money` (or extension of `pkg/calculation`) provides `MinorUnitsPerMajor(code)` (100 for USD/KES, 1 for JPY, 1000 for KWD/BHD), with strict `MoneyToMinorUnits(m, expectedCurrency)` that returns an error on currency mismatch or overflow.
- **Cross-currency aggregation forbidden:** every rolling-window query has `currency_code = $1`. Independent ledgers per currency.
- **Overflow safety:** server-side check that policy `value <= 9_000_000_000_000_000_000` (well under `int64.MAX`).

### 4.2 Models

```go
type Policy struct {
    data.BaseModel `gorm:"embedded"`
    Scope           PolicyScope    `gorm:"column:scope;type:varchar(16);not null;index:idx_policy_lookup,priority:1"`
    OrgUnitID       string         `gorm:"column:org_unit_id;type:varchar(50);index:idx_policy_lookup,priority:2"`
    Action          LimitAction    `gorm:"column:action;type:varchar(64);not null;index:idx_policy_lookup,priority:3"`
    SubjectType     SubjectType    `gorm:"column:subject_type;type:varchar(32);not null;index:idx_policy_lookup,priority:4"`
    CurrencyCode    string         `gorm:"column:currency_code;type:varchar(3);index:idx_policy_lookup,priority:5"`
    LimitKind       LimitKind      `gorm:"column:limit_kind;type:varchar(32);not null"`
    WindowSeconds   int64          `gorm:"column:window_seconds;not null;default:0"`
    Value           int64          `gorm:"column:value;not null;check:value >= 0"`
    Mode            PolicyMode     `gorm:"column:mode;type:varchar(16);not null;default:'shadow'"`
    AttributeFilter datatypes.JSON `gorm:"column:attribute_filter;type:jsonb"`
    ApproverTiers   datatypes.JSON `gorm:"column:approver_tiers;type:jsonb"`
    ApprovalTTLSec  int64          `gorm:"column:approval_ttl_sec;not null;default:259200"`
    EffectiveFrom   time.Time      `gorm:"column:effective_from;type:timestamptz;not null"`
    EffectiveTo     *time.Time     `gorm:"column:effective_to;type:timestamptz"`
    Notes           string         `gorm:"column:notes;type:text"`
}
func (Policy) TableName() string { return "limits_policies" }

type PolicyVersion struct {
    data.BaseModel `gorm:"embedded"`
    PolicyID  string         `gorm:"column:policy_id;type:varchar(50);not null;index"`
    Version   int32          `gorm:"column:version;not null"`
    Snapshot  datatypes.JSON `gorm:"column:snapshot;type:jsonb;not null"`
}

type Reservation struct {
    data.BaseModel `gorm:"embedded"`
    IdempotencyKey        string            `gorm:"column:idempotency_key;type:varchar(80);not null"`
    OrgUnitID             string            `gorm:"column:org_unit_id;type:varchar(50);index:idx_resv_window,priority:1"`
    Action                LimitAction       `gorm:"column:action;type:varchar(64);not null;index:idx_resv_window,priority:2"`
    CurrencyCode          string            `gorm:"column:currency_code;type:varchar(3);not null;index:idx_resv_window,priority:3"`
    Amount                int64             `gorm:"column:amount;not null;check:amount >= 0"`
    SubjectRefs           datatypes.JSON    `gorm:"column:subject_refs;type:jsonb;not null"`
    MakerID               string            `gorm:"column:maker_id;type:varchar(50);not null"`
    Status                ReservationStatus `gorm:"column:status;type:varchar(24);not null;index:idx_resv_window,priority:4"`
    PoliciesEvaluated     datatypes.JSON    `gorm:"column:policies_evaluated;type:jsonb;not null"`
    IsShadow              bool              `gorm:"column:is_shadow;not null;default:false"`
    ReservedAt            time.Time         `gorm:"column:reserved_at;type:timestamptz;not null"`
    TTLAt                 time.Time         `gorm:"column:ttl_at;type:timestamptz;not null;index:idx_resv_ttl"`
    CommittedAt           *time.Time        `gorm:"column:committed_at;type:timestamptz;index:idx_resv_window,priority:5"`
    ReleasedAt            *time.Time        `gorm:"column:released_at;type:timestamptz"`
    ReversesReservationID *string           `gorm:"column:reverses_reservation_id;type:varchar(50);index"`
    Notes                 string            `gorm:"column:notes;type:text"`
}
func (Reservation) TableName() string { return "limits_reservations" }
```

A SQL migration adds `UNIQUE(tenant_id, idempotency_key)` on `limits_reservations` (the `tenant_id` column is provided physically by `BaseModel`; the unique constraint must reference it explicitly).

```go
type LedgerEntry struct {
    data.BaseModel `gorm:"embedded"`
    ReservationID string      `gorm:"column:reservation_id;type:varchar(50);not null;index"`
    OrgUnitID     string      `gorm:"column:org_unit_id;type:varchar(50)"`
    Action        LimitAction `gorm:"column:action;type:varchar(64);not null"`
    SubjectType   SubjectType `gorm:"column:subject_type;type:varchar(32);not null"`
    SubjectID     string      `gorm:"column:subject_id;type:varchar(50);not null"`
    CurrencyCode  string      `gorm:"column:currency_code;type:varchar(3);not null"`
    Amount        int64       `gorm:"column:amount;not null;check:amount >= 0"`
    CommittedAt   time.Time   `gorm:"column:committed_at;type:timestamptz;not null"`
    ReversedAt    *time.Time  `gorm:"column:reversed_at;type:timestamptz"`
}
func (LedgerEntry) TableName() string { return "limits_ledger" }
```

A SQL migration creates the partial index for the hot path:

```sql
CREATE INDEX CONCURRENTLY idx_ledger_window
ON limits_ledger (tenant_id, subject_type, subject_id, action, currency_code, committed_at DESC)
WHERE reversed_at IS NULL AND deleted_at IS NULL;
```

Tenant first because every query is tenant-scoped — keeps the rolling-window scan inside the tenant's slice of the index. Partial index drops half the leaf pages by excluding reversed rows. Partition by `RANGE (committed_at)` monthly when single-tenant volume exceeds ~50M rows — not required day one.

```go
type ApprovalRequest struct {
    data.BaseModel `gorm:"embedded"`
    ReservationID      string         `gorm:"column:reservation_id;type:varchar(50);not null;index"`
    OrgUnitID          string         `gorm:"column:org_unit_id;type:varchar(50)"`
    TriggeringPolicyID string         `gorm:"column:triggering_policy_id;type:varchar(50);not null"`
    PolicyVersion      int32          `gorm:"column:policy_version;not null"`
    RequiredRole       string         `gorm:"column:required_role;type:varchar(64);not null"`
    RequiredCount      int32          `gorm:"column:required_count;not null;check:required_count between 1 and 11"`
    MakerID            string         `gorm:"column:maker_id;type:varchar(50);not null"`
    Status             ApprovalStatus `gorm:"column:status;type:varchar(32);not null"`
    SubmittedAt        time.Time      `gorm:"column:submitted_at;type:timestamptz;not null"`
    ExpiresAt          time.Time      `gorm:"column:expires_at;type:timestamptz;not null;index"`
    DecidedAt          *time.Time     `gorm:"column:decided_at;type:timestamptz"`
}

type ApprovalDecision struct {
    data.BaseModel `gorm:"embedded"`
    ApprovalRequestID string    `gorm:"column:approval_request_id;type:varchar(50);not null;uniqueIndex:uq_decision,priority:1"`
    ApproverID        string    `gorm:"column:approver_id;type:varchar(50);not null;uniqueIndex:uq_decision,priority:2"`
    Decision          string    `gorm:"column:decision;type:varchar(16);not null"`
    Note              string    `gorm:"column:note;type:text"`
    DecidedAt         time.Time `gorm:"column:decided_at;type:timestamptz;not null"`
}
```

```go
type SubjectAttributeSnapshot struct {
    data.BaseModel `gorm:"embedded"`
    SubjectType SubjectType    `gorm:"column:subject_type;type:varchar(32);not null;uniqueIndex:uq_subj,priority:1"`
    SubjectID   string         `gorm:"column:subject_id;type:varchar(50);not null;uniqueIndex:uq_subj,priority:2"`
    Attributes  datatypes.JSON `gorm:"column:attributes;type:jsonb;not null"`
    FetchedAt   time.Time      `gorm:"column:fetched_at;type:timestamptz;not null"`
}
```

### 4.3 Concurrency & correctness primitives

- **Per-subject serialization on Reserve.** Inside the Reserve transaction, before reading the rolling-window sum:
  ```sql
  SELECT pg_advisory_xact_lock(hashtextextended(
      $1 || '|' || $2 || '|' || $3 || '|' || $4, 0));
  ```
  Lock granularity: `(subject_type, subject_id, action, currency_code)`. Released at transaction end (`xact_lock`). Hot subjects serialize; unrelated subjects do not contend.
- **Transaction isolation:** `READ COMMITTED` is sufficient given the advisory lock.
- **Idempotency:** `INSERT ... ON CONFLICT (tenant_id, idempotency_key) DO UPDATE SET id = limits_reservations.id RETURNING *`.
- **TTL reaper:** Frame Queue subscriber every 30s, batch up to 1000 reservations whose `ttl_at < now()` from `status='active'` to `expired`.
- **Approval expiry reaper:** parallel pattern for `approval_requests WHERE status='pending' AND expires_at < now()`.
- **All timestamps `TIMESTAMPTZ`.** `now()` is server-side; clients never pass times to the cap path.

## 5. Public RPC API

### 5.1 Shared types (proto)

```proto
syntax = "proto3";
package limits.v1;

enum LimitAction {
  LIMIT_ACTION_UNSPECIFIED = 0;
  LIMIT_ACTION_LOAN_DISBURSEMENT = 1;
  LIMIT_ACTION_LOAN_REQUEST = 2;
  LIMIT_ACTION_LOAN_REPAYMENT = 3;
  LIMIT_ACTION_SAVINGS_DEPOSIT = 4;
  LIMIT_ACTION_SAVINGS_WITHDRAWAL = 5;
  LIMIT_ACTION_TRANSFER_ORDER_EXECUTE = 6;
  LIMIT_ACTION_INCOMING_PAYMENT = 7;
  LIMIT_ACTION_FUNDING_INFLOW = 8;
  LIMIT_ACTION_FUNDING_OUTFLOW = 9;
  LIMIT_ACTION_STAWI_CONTRIBUTION = 10;
  LIMIT_ACTION_STAWI_PAYOUT = 11;
}

enum SubjectType {
  SUBJECT_TYPE_UNSPECIFIED = 0;
  SUBJECT_TYPE_CLIENT = 1;
  SUBJECT_TYPE_ACCOUNT = 2;
  SUBJECT_TYPE_PRODUCT = 3;
  SUBJECT_TYPE_ORGANIZATION = 4;
  SUBJECT_TYPE_ORG_UNIT = 5;
  SUBJECT_TYPE_WORKFORCE_MEMBER = 6;
}

enum LimitKind {
  LIMIT_KIND_UNSPECIFIED = 0;
  LIMIT_KIND_PER_TXN_MIN = 1;
  LIMIT_KIND_PER_TXN_MAX = 2;
  LIMIT_KIND_ROLLING_WINDOW_AMOUNT = 3;
  LIMIT_KIND_ROLLING_WINDOW_COUNT = 4;
}

enum PolicyMode { POLICY_MODE_UNSPECIFIED = 0; OFF = 1; SHADOW = 2; ENFORCE = 3; }
enum PolicyScope { POLICY_SCOPE_UNSPECIFIED = 0; PLATFORM = 1; ORG = 2; ORG_UNIT = 3; }
enum ReservationStatus {
  RESERVATION_STATUS_UNSPECIFIED = 0; ACTIVE = 1; PENDING_APPROVAL = 2;
  COMMITTED = 3; RELEASED = 4; REVERSED = 5; EXPIRED = 6;
}
enum ApprovalStatus {
  APPROVAL_STATUS_UNSPECIFIED = 0; PENDING = 1; APPROVED = 2;
  REJECTED = 3; EXPIRED = 4; AUTO_REJECTED_ON_RECHECK = 5;
}

message SubjectRef { SubjectType type = 1; string id = 2; }

message LimitIntent {
  LimitAction action = 1;
  string tenant_id = 2;
  string org_unit_id = 3;
  google.type.Money amount = 4;
  repeated SubjectRef subjects = 5;
  string maker_id = 6;
}

message PolicyVerdict {
  string policy_id = 1;
  int32 policy_version = 2;
  bool matched = 3;
  bool breached = 4;
  bool would_require_approval = 5;
  PolicyMode mode = 6;
  string reason = 7;
  google.type.Money current_usage = 8;
  google.type.Money cap = 9;
  int64 current_count = 10;
  int64 cap_count = 11;
}
```

### 5.2 LimitsService (runtime)

```proto
service LimitsService {
  rpc Check(CheckRequest) returns (CheckResponse) {
    option (common.v1.method_permissions) = { permissions: ["limits_use"] };
  }
  rpc Reserve(ReserveRequest) returns (ReserveResponse) {
    option (common.v1.method_permissions) = { permissions: ["limits_use"] };
  }
  rpc Commit(CommitRequest) returns (CommitResponse) {
    option (common.v1.method_permissions) = { permissions: ["limits_use"] };
  }
  rpc Release(ReleaseRequest) returns (ReleaseResponse) {
    option (common.v1.method_permissions) = { permissions: ["limits_use"] };
  }
  rpc Reverse(ReverseRequest) returns (ReverseResponse) {
    option (common.v1.method_permissions) = { permissions: ["limits_use"] };
  }
}
```

A single `limits_use` permission rather than per-method, because consumers are services acting under their own service-account claims; per-RPC granularity would add Keto churn without security value (per-action authorization is what the policies themselves enforce).

**Behavioral contracts:**

- **`Check`** — pure read. Returns `allowed`, `requires_approval`, `required_approvers`, per-policy `verdicts`. **Not authoritative**; clients must still call `Reserve`. Documented prominently in the proto comments.
- **`Reserve`** — authoritative gate. Idempotent on `(tenant_id, idempotency_key)`. Status `ACTIVE` → caller proceeds; `PENDING_APPROVAL` → caller persists local row in pending state; `FailedPrecondition` (with `LimitsBreachDetail`) on enforce-mode breach; `Unavailable` on infrastructure failure (consumer fails closed and propagates).
- **`Commit`** — finalize on local transaction success. Idempotent on `reservation_id`. Transitions `ACTIVE` → `COMMITTED` and writes per-subject `LedgerEntry` rows in one DB transaction. Returns `FailedPrecondition` (with `WaitForApprovalDetail`) if reservation is `PENDING_APPROVAL`.
- **`Release`** — free the reservation on local transaction failure. Idempotent. `ACTIVE | PENDING_APPROVAL` → `RELEASED`; closes any open `ApprovalRequest` rows as `REJECTED` with `reason="released_by_caller"`.
- **`Reverse`** — for already-committed reversal events. Idempotent on its own `idempotency_key`. Marks `LedgerEntry.reversed_at` for all rows of the original reservation; creates a traceability `Reservation` of `status=REVERSED`. Does not retroactively unblock past in-window evaluations.

### 5.3 LimitsAdminService (control plane)

```proto
service LimitsAdminService {
  rpc PolicySave(...) returns (...) { permissions: ["limits_policy_manage"]; }
  rpc PolicyGet(...) returns (...) { permissions: ["limits_policy_view"]; }
  rpc PolicySearch(...) returns (stream ...) { permissions: ["limits_policy_view"]; }
  rpc PolicyDelete(...) returns (...) { permissions: ["limits_policy_manage"]; }

  rpc ApprovalRequestList(...) returns (stream ...) { permissions: ["limits_approval_view"]; }
  rpc ApprovalRequestGet(...) returns (...) { permissions: ["limits_approval_view"]; }
  rpc ApprovalRequestDecide(...) returns (...) { permissions: ["limits_approval_act"]; }

  rpc LedgerSearch(...) returns (stream ...) { permissions: ["limits_ledger_view"]; }
}
```

Streaming for `*Search` and `*List` matches the repo's existing convention (`TransferOrderSearch`, `LoanProductSearch`, etc.).

`ApprovalRequestDecide` validates: caller is not the maker; caller's role assignments include `approval.required_role` for the same org as `reservation.tenant_id`; caller has not already decided on this request; request is `PENDING` and not past `expires_at`.

When the last-required decision lands, the service re-runs all caps. If a previously-passing policy now breaches, transitions to `AUTO_REJECTED_ON_RECHECK` and releases the reservation. Otherwise transitions to `APPROVED`, the reservation to `ACTIVE`, and emits `limits.approval.approved.v1`.

### 5.4 Subject validation registry

Every `LimitAction` declares which subject types it requires:

```go
var actionSubjectRequirements = map[limitsv1.LimitAction][]limitsv1.SubjectType{
    LIMIT_ACTION_LOAN_DISBURSEMENT:      {CLIENT, ACCOUNT, PRODUCT, ORGANIZATION},
    LIMIT_ACTION_SAVINGS_WITHDRAWAL:     {CLIENT, ACCOUNT, ORGANIZATION},
    LIMIT_ACTION_TRANSFER_ORDER_EXECUTE: {ACCOUNT, ORGANIZATION},
    // ...one row per action...
}
```

`Check`/`Reserve` reject intents whose subject list doesn't cover the requirements with `InvalidArgument`.

### 5.5 Connect error mapping

| Situation | Connect code | Detail |
|---|---|---|
| Cap breached (enforce) | `FailedPrecondition` | `LimitsBreachDetail` with verdicts |
| Approval required, not yet granted | `FailedPrecondition` | `WaitForApprovalDetail` with `approval_request_id` |
| Missing required subject in intent | `InvalidArgument` | which subject type missing |
| Idempotency-key collision with different intent | `AlreadyExists` | the existing reservation_id |
| Caller lacks `limits_use` | `PermissionDenied` | (handled by interceptor) |
| Limits DB unreachable | `Unavailable` | retry-after |
| Approval request expired | `FailedPrecondition` | `ApprovalExpired` |
| Approver is the maker | `PermissionDenied` | "maker cannot approve" |

## 6. Cross-service integration

### 6.1 Shared `pkg/limits` client

```go
type Client interface {
    Gate(ctx context.Context, intent *limitsv1.LimitIntent, idempotencyKey string,
        handler func(ctx context.Context, reservationID string) error) error

    Check(ctx context.Context, intent *limitsv1.LimitIntent) (*limitsv1.CheckResponse, error)
    Reserve(ctx context.Context, intent *limitsv1.LimitIntent, idempotencyKey string) (*limitsv1.ReserveResponse, error)
    Commit(ctx context.Context, reservationID string) (*limitsv1.CommitResponse, error)
    Release(ctx context.Context, reservationID, reason string) (*limitsv1.ReleaseResponse, error)
    Reverse(ctx context.Context, reservationID, idempotencyKey, reason string) (*limitsv1.ReverseResponse, error)
}
```

`Gate` is the 80% path — Reserve, run handler, Commit on success, Release on failure. Returns a typed `PendingApprovalError{ReservationID, Verdicts}` when Reserve returns `PENDING_APPROVAL`. Built-in circuit breaker around `Reserve`/`Commit`/`Release`/`Reverse`.

### §6.2 Synchronous Commit + TTL self-correction

Gate calls Commit and Release synchronously via Connect RPC. Both endpoints are idempotent on `(tenant_id, idempotency_key)`. On Commit RPC failure after the consumer's handler tx committed, the caller surfaces the error; the reservation TTL-expires (default 5 minutes) and cap math reverts on the next Reserve as if the operation never happened. The audit pipeline (which writes audit rows in the same DB tx as state changes — see §6A) records the drift event for offline reconciliation.

An earlier design proposed a transactional outbox to bridge handler-success → Commit. It was rejected as unnecessary multi-phase complexity: the cap-correctness story is unaffected by Commit failure (TTL handles it), and audit durability is solved by in-tx writes rather than by an outbox.

### 6.3 Per-action integration map

| # | Action | Service / file | Integration | Subjects |
|---|---|---|---|---|
| 1 | `LOAN_DISBURSEMENT` | `apps/loans/.../business/disbursement.go: Create` | `Gate` | client, account, product, organization, org_unit |
| 2 | `LOAN_REQUEST` | `apps/loans/.../business/loan_request.go: Save` | `Gate` (initial submission only) | client, product, organization, org_unit |
| 3 | `LOAN_REPAYMENT` | `apps/loans/.../business/repayment.go: Create` | `Gate` (soft) | client, account, organization |
| 4 | `SAVINGS_DEPOSIT` | `apps/savings/.../business/savings_account.go` | `Gate` (soft) | client, account, organization |
| 5 | `SAVINGS_WITHDRAWAL` | `apps/savings/.../business/savings_account.go` | `Gate` | client, account, organization, org_unit |
| 6 | `TRANSFER_ORDER_EXECUTE` | `apps/operations/.../business/transfer_order.go` | Lower-level primitives | account (debit), account (credit), organization, org_unit |
| 7 | `INCOMING_PAYMENT` | `apps/operations/.../business/transfer_order.go: IncomingPaymentNotify` | `Gate` (soft) | account, organization |
| 8 | `FUNDING_INFLOW` | `apps/funding/.../business/...` | `Gate` (soft) | organization, account |
| 9 | `FUNDING_OUTFLOW` | `apps/funding/.../business/...` | `Gate` | organization, account |
| 10 | `STAWI_CONTRIBUTION` | `apps/stawi/.../business/group.go` | `Gate` (soft) | client, account, organization |
| 11 | `STAWI_PAYOUT` | `apps/stawi/.../business/group.go` | `Gate` | client, account, organization, org_unit |

### 6.4 Approval round-trip via Frame events

Limits service emits:

- `limits.approval.requested.v1` — when a Reserve produces `PENDING_APPROVAL`
- `limits.approval.approved.v1` — when all approvals land and re-eval passes
- `limits.approval.rejected.v1` — explicit reject by approver
- `limits.approval.expired.v1` — passed `expires_at`
- `limits.approval.auto_rejected.v1` — re-eval failed at decision time

Each consumer service subscribes to events filtered by `action`. On `approved`: look up local row by `reservation_id`, transition out of `PENDING_LIMITS_APPROVAL`, insert `limits_outbox` row for `Commit`, proceed with side effects. On `rejected | expired | auto_rejected`: terminal state `REJECTED_BY_LIMITS`; reservation already released by limits service; idempotent on `reservation_id`.

### 6.5 Proto annotation + CI lint

```proto
extend google.protobuf.MethodOptions {
  bool method_money = 90211;
}
```

Every monetary RPC declares `option (common.v1.method_money) = true;`. `tools/lint/method_money_check.go`:

- Walks every `.proto` file's services.
- For each method tagged `method_money: true`, asserts the corresponding handler reaches a business method whose body invokes a `pkg/limits.Client` method or transitively delegates to one.
- Conservative — false positives get a `// limits-ok` escape hatch.
- Runs in CI; failure blocks merge.

### 6.6 ReBAC plumbing

`limits_use` is granted to consumer service bots via the limits OPL, by adding a `service_uses_limits` permit and the relevant role assignments — never via direct Keto-write API calls (per `feedback_no_manual_keto.md`). Generated through `make generate_opl`.

Admin permissions (`limits_policy_manage`, `limits_policy_view`, `limits_approval_view`, `limits_approval_act`, `limits_approval_override`, `limits_ledger_view`, `limits_audit_view`) are granted via ordinary org-scoped role assignments — outside the runtime path.

## 6A. Audit-on-limiting

The existing `pkg/audit` infrastructure already provides the right shape for gating-decision audit. Plan 1 migrated `audit.Event` into the limits DB; this section specifies *how* the runtime gate writes to it, with namespaced action verbs and the existing `Metadata` JSON bag carrying the structured detail. **No new model, no new table.**

### 6A.1 What gets audited

Every gating decision is recorded via `audit.Writer.Record`. Action verbs (the namespaced domain string `audit.Event.Action`):

| Verb | When emitted | Entity |
|---|---|---|
| `limits.breach.hard` | A `Reserve` is denied — at least one enforce-mode policy breached and not approval-eligible | `reservation` (or `policy` for the breached one — caller chooses primary) |
| `limits.breach.shadow` | A shadow-mode policy would have blocked | `policy` |
| `limits.approval.required` | A `Reserve` produced `PENDING_APPROVAL` | `approval_request` (one row per triggering policy) |
| `limits.approval.approved` | An `ApprovalRequest` reached its required-count and re-evaluation passed | `approval_request` |
| `limits.approval.rejected` | An approver rejected | `approval_request` |
| `limits.approval.auto_rejected` | Re-evaluation at decision time newly breached a previously-passing policy | `approval_request` |
| `limits.approval.expired` | A pending `ApprovalRequest` passed its `expires_at` | `approval_request` |
| `limits.reservation.committed` | A `Commit` finalised a reservation | `reservation` |
| `limits.reservation.released` | A `Release` freed a reservation | `reservation` |
| `limits.reservation.reversed` | A `Reverse` marked ledger entries reversed | `reservation` |
| `limits.reservation.expired_ttl` | The TTL reaper auto-expired an `active` reservation | `reservation` |

`audit.Event.EntityID` is the reservation_id, approval_request_id, or policy_id depending on the verb's primary subject.

### 6A.2 Metadata schema

The `Metadata` JSON bag carries the structured fields specific to gating events. By convention every limits-audit row populates the same keys (when applicable) so consumers can index uniformly:

```json
{
  "action_kind": "loan_disbursement",          // LimitAction enum value
  "policy_id": "pol-abc",
  "policy_version": 3,
  "amount_minor": 2500000,
  "currency": "KES",
  "subjects": [{"type":"client","id":"c1"},{"type":"organization","id":"org-1"}],
  "verdicts": [
    {"policy_id": "pol-abc", "matched": true, "breached": true, "reason": "rolling_24h sum 950000+100000>cap 1000000",
     "current_usage_minor": 950000, "cap_minor": 1000000}
  ],
  "org_unit_id": "branch-a",
  "approver_id": "wf-42"                        // for approval verbs
}
```

The `Reason` field on `audit.Event` carries a one-line human-readable summary; `Metadata` carries the structured detail.

### 6A.3 Emission

The platform convention from `pkg/audit/writer.go` is to dispatch asynchronously via Frame events: `audit.Writer.Record` publishes to the `audit_event.save` topic, the per-service `EventSave` handler subscribes and persists. Audit writes are *advisory* — they should not block the user-visible action on a transient persistence failure.

Limits follows that convention. Each business method that produces a gating decision takes a `*audit.Writer` and calls `RecordOrLog` after the state change has committed. A small `auditing.go` helper in `apps/limits/service/business/` builds the typed `audit.Record` from a `(verb, reservation, intent, verdicts)` tuple so call-sites stay short:

```go
auditing.RecordBreachHard(ctx, b.audit, reservation, intent, breachedVerdicts)
auditing.RecordReservationCommitted(ctx, b.audit, reservation)
auditing.RecordApprovalApproved(ctx, b.audit, approvalRequest, decisions)
// ...one helper per verb
```

The reapers and the approval-decide path also emit via the same helpers.

### 6A.4 Admin RPC

A new admin RPC queries the existing `audit_events` table filtered to limits-namespaced verbs:

```proto
service LimitsAdminService {
  // ...existing RPCs...
  rpc LimitsAuditSearch(LimitsAuditSearchRequest) returns (stream LimitsAuditSearchResponse) {
    option (common.v1.method_permissions) = { permissions: ["limits_audit_view"] };
  }
}

message LimitsAuditSearchRequest {
  // Filter on action verb prefix or exact match.
  // If empty, all "limits.*" verbs are returned.
  repeated string actions = 1;
  string entity_type = 2;     // reservation / approval_request / policy
  string entity_id = 3;
  string actor_id = 4;
  google.protobuf.Timestamp from = 5;
  google.protobuf.Timestamp to = 6;
  common.v1.PageCursor cursor = 7;
}

message LimitsAuditEventObject {
  string id = 1;
  string entity_type = 2;
  string entity_id = 3;
  string action = 4;
  string actor_id = 5;
  string actor_type = 6;
  string reason = 7;
  google.protobuf.Struct metadata = 8;
  google.protobuf.Timestamp occurred_at = 9;
}

message LimitsAuditSearchResponse { repeated LimitsAuditEventObject data = 1; }
```

The handler reads from the limits service's own `audit_events` table, filters `WHERE action LIKE 'limits.%'` (plus user-supplied predicates), and streams batches. Tenancy is applied via `scopes.TenancyPartition`. Cursor pagination on `(occurred_at, id)` DESC.

A new permission `limits_audit_view` joins the existing admin permissions, granted to risk / compliance / audit roles via OPL.

### 6A.5 Retention

The platform's `audit_events` tables are retained indefinitely by default. Compliance-driven retention pruning (e.g. partition-prune after N years) is operational follow-up, not v1.

### 6A.6 What's *not* in audit-on-limiting

- Per-RPC who/when on policy CRUD: still recorded by the existing `pkg/audit` middleware on `LimitsAdminService.PolicySave` etc., using non-`limits.*` action verbs (the middleware names them after the RPC). Both stream into the same `audit_events` table; the search RPC filters on the `limits.*` prefix.
- Identity-service KYC-tier changes: land in identity's audit trail, not limits'.
- Runtime metrics (`limits_breach_total` etc.): observability, not audit. Different consumer, different retention.

## 7. Policy resolution & evaluation algorithm

### 7.1 Algorithm

```
ALGORITHM Reserve(intent, idempotency_key, ttl):
  // 0. Idempotency short-circuit
  existing := SELECT * FROM limits_reservations WHERE idempotency_key = $1
              -- TenancyPartition adds tenant_id filter
  IF existing exists:
      IF intent_hash(existing) != intent_hash(intent): RETURN AlreadyExists(existing.id)
      RETURN existing

  // 1. Subject schema validation
  required := actionSubjectRequirements[intent.action]
  IF NOT required ⊆ {s.type for s in intent.subjects}:
      RETURN InvalidArgument

  // 2. Candidate policy lookup (raw pool — bypasses TenancyPartition to union platform + org + org-unit)
  candidates := SELECT * FROM limits_policies
      WHERE deleted_at IS NULL
        AND mode != 'OFF'
        AND effective_from <= now() AND (effective_to IS NULL OR effective_to > now())
        AND action = $1
        AND (currency_code = $2 OR currency_code = '')
        AND (
            (scope = 'PLATFORM' AND tenant_id = '')
         OR (scope = 'ORG'      AND tenant_id = $3)
         OR (scope = 'ORG_UNIT' AND tenant_id = $3 AND org_unit_id = $4)
        )

  // 3. Filter by subject_type and attribute predicate
  applicable := []
  FOR policy IN candidates:
      subject := first s in intent.subjects WHERE s.type = policy.subject_type
      IF subject IS NULL: CONTINUE
      IF policy.attribute_filter IS NOT NULL:
          attrs := resolveSubjectAttributes(policy.subject_type, subject.id) // 60s cache
          IF NOT evaluatePredicate(policy.attribute_filter, attrs): CONTINUE
      applicable.append({policy, subject})

  // 4. Acquire per-subject advisory locks (deterministic order, only for rolling kinds)
  lockKeys := sort({hash(s.type, s.id, intent.action, intent.currency_code)
                    for {policy, s} in applicable
                    where policy.limit_kind in ROLLING_KINDS})
  FOR k IN lockKeys: pg_advisory_xact_lock(k)

  // 5. Per-policy evaluation
  verdicts := [evaluate(p, s, intent) for {p, s} in applicable]

  // 6. Aggregate verdict
  enforceVerdicts := [v in verdicts where v.policy.mode = ENFORCE]
  hardBreaches    := [v in enforceVerdicts where v.breached AND NOT v.would_require_approval]
  approvalNeeded  := [v in enforceVerdicts where v.would_require_approval]

  IF hardBreaches NOT EMPTY:
      emitShadowBreachMetrics(...)
      RETURN FailedPrecondition(LimitsBreachDetail{verdicts: hardBreaches})

  // 7. Persist
  status := approvalNeeded EMPTY ? 'ACTIVE' : 'PENDING_APPROVAL'
  isShadow := enforceVerdicts EMPTY AND has_shadow_match(verdicts)
  INSERT INTO limits_reservations (...)
  FOR v IN approvalNeeded:
      tier := pickTier(v.policy.approver_tiers, intent.amount)
      INSERT INTO limits_approval_requests (..., required_role=tier.role,
                                            required_count=tier.approvers,
                                            expires_at=now()+v.policy.approval_ttl_sec)
      emit('limits.approval.requested.v1', ...)

  RETURN reservation, verdicts
```

### 7.2 Per-policy evaluation

```
FUNCTION evaluate(policy, subject, intent) → verdict:
  switch policy.limit_kind:
    case PER_TXN_MIN: breach := intent.amount < policy.value
    case PER_TXN_MAX:
        breach := intent.amount > policy.value
        wouldApproval := breach AND policy.approver_tiers != NULL
                                AND any tier covers intent.amount
        breach := breach AND NOT wouldApproval
    case ROLLING_WINDOW_AMOUNT:
        committed := SUM(amount) FROM limits_ledger
                     WHERE subject_type=$1 AND subject_id=$2
                       AND action=$3 AND currency_code=$4
                       AND committed_at >= now() - policy.window_seconds * interval '1s'
                       AND reversed_at IS NULL
                     -- TenancyPartition adds tenant_id filter
        pending   := SUM(amount) FROM limits_reservations
                     WHERE status IN ('ACTIVE','PENDING_APPROVAL')
                       AND action=$3 AND currency_code=$4
                       AND subject_refs @> jsonb([{type:$1, id:$2}])
                       AND ttl_at > now()
                     -- TenancyPartition adds tenant_id filter
        breach := (committed + pending + intent.amount) > policy.value
        wouldApproval := breach AND tier matches
        breach := breach AND NOT wouldApproval
    case ROLLING_WINDOW_COUNT: similar, with COUNT(*)
```

### 7.3 Composition

- Denied iff ANY enforce-mode verdict has `breached=true AND NOT would_require_approval`.
- Requires approval iff (no denials) AND ANY enforce-mode verdict has `would_require_approval=true`.
- Each approval-requiring verdict spawns its OWN `ApprovalRequest`. All must approve before reservation transitions to `ACTIVE`.
- Shadow verdicts never block; they always emit metrics + a `limits.shadow_breach.v1` event for risk monitoring.

### 7.4 Tenancy in queries

Frame's `scopes.TenancyPartition` applies `tenant_id = ? AND partition_id = ?` automatically to every `BaseRepository` query, reading from `security.ClaimsFromContext(ctx)`. Application-level code never references `tenant_id` directly. The single exception: the candidate-policy lookup in step 2 must union platform + org + org-unit policies in one query, which a single tenancy scope cannot express. That repository method uses raw `pool.Pool` and constructs the SQL explicitly (per the `golang-patterns` carve-out for "complex aggregations"). The bypass is isolated to one method and gated by the `limits_use` permission.

### 7.5 Performance shape

| Step | Cost |
|---|---|
| Idempotency lookup | 1 indexed read |
| Candidate policies | 1 indexed read + warm-cache hit on policy table |
| Subject attributes | N cache hits (60s TTL); rare cold reads ~5ms each |
| Advisory locks | M trivial Postgres ops (M = #subjects-with-rolling-policies) |
| Per-policy evaluation | M queries on `idx_ledger_window` + M queries on `idx_resv_window` |
| Persist | 1 INSERT to reservations + 0..K INSERTs to approval_requests |
| Total | p99 < 75ms; p50 < 15ms |

### 7.6 Hardened failure modes

- **Race between two Reserves on same hot subject** → advisory lock serializes; second sees first's pending sum.
- **Stale attribute filter (KYC tier just changed)** → 60s cache window worst case; manual-invalidate API for emergencies.
- **Policy created mid-flight** → step 2 reads at evaluation time; live policies apply.
- **Policy deleted mid-flight** → soft-delete; historical snapshots resolve via `policy_versions`.
- **Clock skew between replicas** → `now()` is server-side from Postgres.
- **Approval landing post-expiry** → `ApprovalRequestDecide` checks `expires_at` first.

## 8. Failure modes & operational concerns

### 8.1 HA topology — recap

≥3 replicas, anti-affinity, HPA. Primary + 1 sync replica + 1 async replica Postgres. Reads on primary for ledger paths; replicas OK for policy lookups. In-process LRU cache with pub-sub invalidation. See §3.

### 8.2 Fail-closed mechanics

`Reserve` returning `Unavailable` propagates as `Unavailable` to the consumer's caller — no local DB write. Consumer-side circuit breaker opens after 10 failures in 5s. Half-open probe every 5s. Inflows are also fail-closed by default; per-action override `LIMITS_FAIL_OPEN_ACTIONS` documented but off.

### 8.3 Observability

**Metrics** (Prometheus via Frame `telemetry`):

| Metric | Type | Labels |
|---|---|---|
| `limits_check_total` | counter | `action`, `verdict`, `mode` |
| `limits_reserve_total` | counter | `action`, `status` |
| `limits_reserve_duration_seconds` | histogram | `action` |
| `limits_commit_total` | counter | `action`, `status` |
| `limits_breach_total` | counter | `policy_id`, `scope`, `mode`, `kind` |
| `limits_shadow_breach_total` | counter | `policy_id`, `scope` |
| `limits_approval_pending` | gauge | `action`, `required_role` |
| `limits_approval_decided_total` | counter | `decision`, `required_role` |
| `limits_ttl_expired_total` | counter | `action` |
| `limits_outbox_lag_seconds` | gauge | `service`, `kind` |
| `limits_policy_cache_hit_ratio` | gauge | — |
| `limits_advisory_lock_wait_seconds` | histogram | — |

**Tracing.** Every RPC is one span via `telemetry.StartSpan`. Span attributes: `action`, `tenant_id`, `org_unit_id`, `currency_code`, `subject_count`, `policy_count_evaluated`, `verdict`, `is_shadow`, `requires_approval`. Traceparent propagates through Frame's HTTP client.

**Logs** via `util.Log(ctx)`: Info on every Reserve outcome, every `ApprovalRequestDecide`, every `PolicySave`. Warn on enforce-mode breaches with `reservation_id`, `policy_id`, `current_usage`, `cap`, `subjects`. Error on outbox retry exhaustion, advisory-lock wait threshold, attribute lookup failure. PII excluded.

**Audit** via `pkg/audit` middleware on every policy mutation, every `ApprovalDecision`, every `Reverse`.

### 8.4 SLOs

| Metric | Target |
|---|---|
| `Reserve` availability | 99.95% / 30d |
| `Commit` availability | 99.99% / 30d |
| `Reserve` p99 | < 75ms |
| `Reserve` p50 | < 15ms |
| `Commit` p99 | < 30ms |
| Approval → reservation transition | < 1s p99 |
| **False-allow rate (enforce policies)** | exactly 0 (verified by daily reconciliation) |
| Outbox commit lag | < 5s p95 |

### 8.5 Runbook scenarios

Top scenarios documented in `apps/limits/docs/runbook/`:

- `limits` service unhealthy
- Spike in shadow breaches
- Stuck approval queue
- Policy hot-edit went wrong (rollback via `PolicySave` reverts)
- Reservation TTL leak / orphans

### 8.6 Reconciliation

Nightly job in `apps/limits/cmd/reconcile`:

1. For each consumer service, query its local money-action tables for actions in COMMITTED/SETTLED state finalized in the last 24h.
2. Look up matching `LedgerEntry` by `reservation_id`.
3. Three outcomes per row: match, local-no-ledger (alert + replay outbox + page if still missing), ledger-no-local (investigate; mark reversed if confirmed orphan).
4. Aggregate `(tenant, action, currency, day)` sums compared exactly between systems. Any mismatch is P1.

### 8.7 Capacity & scaling

Reservations: ~2M/day at 10× current; 30d retention ≈ 60M rows; single Postgres comfortable. Ledger: ~6M/day across subjects; ≈180M @ 30d. Partition `RANGE (committed_at)` monthly when single-tenant volume exceeds 50M. Vertical scale primary; replicas autoscale on read load.

### 8.8 Bootstrap & migration story

1. Deploy `apps/limits` with no policies. No caps enforced.
2. Wire each consumer service to `Gate`, behind per-action env flag (off).
3. Author existing implicit caps as `mode=SHADOW` policies.
4. Watch `limits_shadow_breach_total` for one week per action.
5. Flip to `mode=ENFORCE` per action; remove legacy in-process check after stable.
6. Author new caps (rolling-window, approval-thresholded) directly in shadow first.

## 9. Testing strategy

Inherits `testing-core` and `testing-go`: real integration over mocks, `BaseTestSuite` extending `frametests.FrameBaseTestSuite`, testcontainers, race detection.

### 9.1 Unit tests

- **Handlers:** validation, serialization, Connect-error mapping. Table-driven over invalid `LimitIntent` shapes. No DB.
- **Business:** policy resolver, evaluator, approval-tier picker, attribute predicate. In-memory inputs + stub repository.
- **Repository:** real Postgres testcontainer; the raw-pool candidate-policy query gets a dedicated fixture covering all `(scope × tenant_id × org_unit_id)` combos.

### 9.2 Integration tests

`apps/limits/tests/integration` extending `BaseTestSuite`. Coverage matrix:

- Reserve happy path (per-txn-max, rolling-window-amount with prior committed, with prior pending, mixed)
- Reserve breach for each `LimitKind`; min-take across multiple policies; platform-overrides-org
- Reserve approval required (tier first/middle/last; multiple policies; N=1 to N=11)
- Idempotency (retry, collision-with-different-intent)
- Currency isolation
- Attribute predicate (in/out, cache miss, identity unreachable)
- Commit (success, double-commit, on-pending fails)
- Release (active, pending-approval, double)
- Reverse (ledger marking, exclusion from windows, double)
- Approval flow (submit, partial, final, re-eval failure auto-rejects)
- TTL expiry (reservation, approval)
- Subject schema (each action's required subjects, missing returns `InvalidArgument`)
- Permissions (non-`limits_use` denied; `limits_approval_act` without role denied; maker rejected)

### 9.3 Property-based tests

Using `gopter`:

- Min-take invariant
- Shadow never blocks
- Reverse-of-Commit invariance (rolling-window sum matches non-reversed entries)
- Idempotent commit invariance
- Min-take with windows (smallest binding)
- Approval composition (order doesn't affect outcome)

CI fixed-seed + nightly random-seed.

### 9.4 Concurrency & race tests

- Two Reserves on same subject: exactly one succeeds.
- Two Reserves with same `idempotency_key`: deterministic AlreadyExists vs same-reservation behavior.
- Commit-vs-TTL-reaper race.

Run with `go test -race -count=10`.

### 9.5 Contract tests

Per consumer service in `pkg/limits/tests`. End-to-end through the consumer's business code with a real `limits` testcontainer. Verifies right intent, outbox row in same tx as business row, retry semantics, approval round-trip.

### 9.6 Load & SLO

`apps/limits/tests/load` (vegeta or k6):

- Steady 500 RPS for 10min: p99 < 75ms, errors ≤ 0.05%
- Hot-key contention 200 RPS same subject: no errors, p99 acceptable
- Spike 100 → 2000 → 100 RPS: graceful degradation
- Approval-heavy workload: `limits_approval_pending` bounded

Weekly in staging; pre-prod on RC pipelines.

### 9.7 Cross-service E2E

`tests/e2e/limits` brings up `limits` + `loans` + `operations` together. Two golden paths:

1. Disbursement velocity cap: 90k allowed → 20k denied → reverse first → 20k allowed
2. Approval round-trip: submit → admin reads → decides → event consumed → local resumes → ledger lands

### 9.8 Reconciliation tests

- Inject out-of-band local action → reconciliation reports gap
- Inject Commit-RPC failure → reconciliation reports gap; outbox replay closes it
- Inject ledger-only entry → reconciliation flags

### 9.9 Test data hygiene

Fixture factories per entity. Time control via `frame.TimeProvider`. Per-suite testcontainer DBs. Synthetic data for load tests.

## 10. Build sequence

| Phase | Goal | Reversibility |
|---|---|---|
| **0 — Foundations** | `pkg/money`, proto definitions, `pkg/limits` skeleton, `pkg/limits/outbox`, `method_money` annotation + report-only lint, OPL permits | Revert PRs |
| **1 — Limits core (admin)** | Scaffold `apps/limits`, models for policies, `LimitsAdminService`, ReBAC | Scale to 0 replicas |
| **2 — Runtime path (shadow only)** | Reservation/Ledger/Approval models, full algorithm, all RPCs, TTL reapers, attribute cache, canary integration in `loans.DisbursementCreate` behind env flag, reconciliation MVP, property tests | Per-action env flag |
| **3 — Approval workflow** | `ApprovalRequest*` admin RPCs, re-evaluation, events, canary `PENDING_LIMITS_APPROVAL` integration | Per-action env flag |
| **4 — Roll out remaining 10 actions** | One PR per consumer service, lowest-risk first; lint flips to enforcing | Per-action env flag |
| **5 — Shadow → Enforce** | Per-policy `PolicySave` flips mode; legacy in-process checks removed after 14d steady | `PolicySave` back to SHADOW |
| **6 — Hardening** | Approval UI integration, risk dashboard, chaos drills, runbook rehearsal, capacity review | Independent of gate |

Per-phase exit criteria:

- **Phase 0:** `go build ./...` passes; report-only lint runs in CI.
- **Phase 1:** policies authored end-to-end through the admin client in staging; migrations clean.
- **Phase 2:** `LIMITS_GATE_ENABLED_DISBURSEMENT=true` in staging; `limits_check_total` flowing; reconciliation green for 7 days.
- **Phase 3:** in staging, an admin authors an approver-tier policy, submits a Reserve that triggers approval, decides via admin RPC, observes local disbursement resume.
- **Phase 4:** every action observed in `limits_check_total` in staging and prod; reconciliation green for 14 days across all pairs.
- **Phase 5:** all 11 actions enforced; legacy in-process cap checks removed; reconciliation green for 30 days.
- **Phase 6:** rotational on-call confidence at "I could be paged on this at 3am"; documented in standard ops review.

### Action ordering for phase 4

Soft (low-risk) first, hard last:

1. `savings.DepositCreate` (soft)
2. `loans.LoanRequestSave`
3. `loans.RepaymentCreate` (soft)
4. `funding.Inflow` (soft)
5. `stawi.Contribution` (soft)
6. `operations.IncomingPaymentNotify` (soft)
7. `savings.WithdrawalCreate` (hard)
8. `operations.TransferOrderExecute` (hard, multi-leg)
9. `funding.Outflow` (hard)
10. `stawi.Payout` (hard)

(`loans.DisbursementCreate` is the canary in phase 2.)

## 11. UI architecture (limits operator surface)

A new Flutter package `ui/limits/` mirrors the per-domain pattern of `ui/savings/`, `ui/loans/`, `ui/funding/`, `ui/operations/`. It is consumed by the main app at `ui/seed/lib/features/limits/` and by any embedding host through the package's exported screens and widgets.

### 11.1 Package shape

```
ui/limits/
├── pubspec.yaml                         — antinvestor_ui_limits package
├── lib/
│   ├── antinvestor_ui_limits.dart       — entry: exports public API
│   └── src/
│       ├── providers/                    — Riverpod 3 providers (one per RPC)
│       ├── routing/                      — go_router routes (/limits, /limits/policies/..., /limits/approvals, etc.)
│       ├── screens/                      — full-page composites
│       ├── widgets/                      — reusable widgets
│       └── utils/                        — formatters, intent builders, currency rendering
└── test/                                 — widget tests + provider tests
```

Dependencies (mirroring `ui/savings/`):
- `antinvestor_ui_core` — shared theme, layout primitives, page chrome.
- `antinvestor_api_limits` — Dart proto stubs (new — generated from `proto/limits` via `proto/buf.gen.dart.limits.yaml` and added to `DART_MODULES`).
- `antinvestor_api_common` — shared types (`PageCursor`, `STATE`, `Money`).
- `connectrpc` — Connect RPC client.
- `flutter_riverpod 3.x` — state.
- `go_router 17.x` — routing.

### 11.2 Widget catalogue

The full operator surface, grouped by data domain. Every widget is a real Flutter widget backed by real RPC data — no mocks.

**Policies (admin path)**
- `PolicyListScreen` + `PolicyListTile` — paginated list with `action` / `mode` / `scope` filters; pull-to-refresh.
- `PolicyEditorScreen` + `PolicyEditorForm` — create or update; client-side validation mirroring server-side rules.
- `PolicyDetailScreen` + `PolicyDetailCard` — read-only view with edit / delete actions and version history button.
- `PolicyVersionHistoryWidget` — chronological list of policy versions, expandable diffs.
- `PolicyModeBadge`, `PolicyScopeBadge`, `LimitKindBadge` — small color-coded pills used across screens.
- `ApproverTiersEditor` + `ApproverTiersDisplay` — N-of-M tier table editor and read-only render.
- `AttributeFilterEditor` + `AttributeFilterDisplay` — KYC-tier predicate builder using identity attributes.
- `CapAmountField` — money input with currency dropdown; uses `moneyx`-compatible string conversion.
- `WindowDurationField` — duration input for rolling windows (24h / 7d / 30d preset shortcuts).

**Runtime visibility**
- `VerdictBadge` + `VerdictDetailCard` — small pill (allowed / blocked / pending) + expandable card showing every per-policy verdict.
- `UsageBarWidget` — current usage / cap progress bar with tier markers (color shift at approval thresholds).
- `PolicyVerdictPlayground` — admin tool that calls `Check` with an editable `LimitIntent` and renders the full verdict tree.

**Approvals**
- `ApprovalQueueScreen` + `ApprovalRequestTile` — pending approvals routable to the operator; live count.
- `ApprovalRequestDetailScreen` — full intent context, the triggering policy, the verdict, the approval tier, and an `ApprovalDecisionForm` (approve / reject + note).
- `ApprovalDecisionTimelineWidget` — who decided what when; resolves approver IDs to names via identity.

**Ledger**
- `LedgerSearchScreen` + `LedgerSearchFilters` — searchable history filterable by tenant / action / subject / currency / time range.
- `LedgerEntryTile` + `LedgerTimelineWidget` — single-row and chronological views.

**Audit-on-limiting feed**
- `LimitsAuditFeedScreen` + `AuditEventTile` — every gating event (breach / approval / TTL / commit / release / reverse) live, filterable.
- `AuditEventFilters` — composite of kind / time-range / policy / subject filters.
- `ShadowBreachAlertBanner` — surfaces shadow-mode would-have-blocked events for risk teams; threshold-based.

**Currency rendering**
- `CurrencyAmountText` — single-source-of-truth display widget. Receives a `Money` proto + caller's preferred locale, renders with the correct ISO 4217 precision (matches the moneyx-driven backend conversions).

### 11.3 Routing

`go_router` routes mounted under `/limits`:

| Route | Screen |
|---|---|
| `/limits/policies` | `PolicyListScreen` |
| `/limits/policies/new` | `PolicyEditorScreen` (create) |
| `/limits/policies/:id` | `PolicyDetailScreen` |
| `/limits/policies/:id/edit` | `PolicyEditorScreen` (edit) |
| `/limits/policies/:id/history` | screen wrapping `PolicyVersionHistoryWidget` |
| `/limits/playground` | `PolicyVerdictPlayground` |
| `/limits/approvals` | `ApprovalQueueScreen` |
| `/limits/approvals/:id` | `ApprovalRequestDetailScreen` |
| `/limits/ledger` | `LedgerSearchScreen` |
| `/limits/audit` | `LimitsAuditFeedScreen` |

`ui/seed/lib/features/limits/limits_feature.dart` mounts these routes and adds a sidebar entry. Permission-gated: each route uses the appropriate `limits_*_view` permission via existing `antinvestor_ui_core` route-guard primitives.

### 11.4 State management

One Riverpod provider per RPC. The `policiesProvider` family is parameterised by search filter; `approvalQueueProvider` polls (or subscribes) for pending requests; `auditFeedProvider` is paginated streaming. Following the team's `feedback_riverpod_caching.md` — interactive flows use direct client calls plus `ref.refresh` for retry, never `ref.read(provider.future)` for write actions.

### 11.5 Testing

- Widget tests for every screen and complex widget — using real Connect clients pointed at a stubbed in-process server, OR using the standard `antinvestor_ui_core` test harness.
- Provider tests for state transitions (loading / success / error / refresh).
- Visual-regression tests for the badge/pill widgets via golden files.
- Per the `testing-flutter` skill: thorough form validation tests, responsive-layout tests for the Policy Editor and Audit Feed.

### 11.6 Build pipeline

- `proto/buf.gen.dart.limits.yaml` — new generation config for the limits Dart package.
- `Makefile` — add `limits` to `DART_MODULES`.
- `make proto-generate-dart` regenerates the Dart proto package.
- `antinvestor_api_limits` is published the same way as `antinvestor_api_savings` (or used via path dependency in the monorepo).

## 12. Open items / out of scope

- **AML/fraud detection pipeline:** consumer of `limits.shadow_breach.v1` events; out of scope.
- **Multi-currency aggregate caps** (sum across currencies via FX): out of scope for v1.
- **Sharding `fintech_limits` Postgres:** out of scope; vertical + partitioning sufficient for foreseeable volume.
- **Compliance-driven audit retention pruning:** the audit table grows without bound by default; a partition-prune job after N years is operational follow-up.
- **Localisation of UI strings:** not addressed in v1; use English only initially.
- **Mobile-first responsive design:** the operator surface targets desktop first; mobile is "works but not optimised" for v1.

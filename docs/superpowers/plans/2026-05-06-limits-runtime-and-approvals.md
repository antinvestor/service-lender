# Limits Service — Runtime, Approvals, Audit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the `LimitsService` runtime path (Check/Reserve/Commit/Release/Reverse) and the approval workflow (`ApprovalRequestList/Get/Decide`, `LedgerSearch`, `LimitsAuditSearch`) fully functional. Every gating decision lands an audit row via the existing `pkg/audit` infrastructure with `limits.*` action verbs.

**Architecture:** Frame three-layer (handlers → business → repository); Postgres advisory locks for per-subject serialisation; in-band evaluation algorithm with shadow / enforce / approval-required composition; outbox-driven Commit on consumer side (added in this plan only as a stub — actual consumer integration lives in Plan 3); reaper workers for TTL and approval expiry; audit emission via `audit.Writer.Record` per platform convention.

**Tech Stack:** Go 1.26, `github.com/pitabwire/frame` v1.94.6, Connect RPC, GORM via `data.BaseModel`, `pitabwire/util` (logging, decimalx, advisory-lock helpers), `pitabwire/util/money` v0.8.0, Postgres 16, buf.build registry for proto stubs.

**Spec:** `docs/superpowers/specs/2026-05-05-fintech-limits-design.md` — sections covered: §3 (runtime topology), §4.2 (Reservation/Ledger/Approval models), §5.2 (LimitsService), §5.3 admin half (Approval + Ledger + Audit RPCs), §6A (audit-on-limiting), §7 (full algorithm), §8 (failure modes), §9 (testing), §10 phases 2-3.

**Out of scope (future plans):** Consumer-service integration (Plan 4 will wire `loans.DisbursementCreate`, etc., to `pkg/limits.Gate` behind env flags); shadow→enforce rollout; UI (separate plan: `2026-05-XX-limits-ui.md`).

**External prerequisite:** A buf.build push of the limits proto module after Task 4 (LimitsAuditSearch is new). Same pattern as Plan 1 Task 3.

---

## File Structure

### Modified files

```
proto/limits/limits/v1/limits.proto                     — add LimitsAuditSearch RPC + messages, audit-view permission
opl/limits/service_limits.opl.ts                        — regenerated to include limits_audit_view
apps/default/service_limits.opl.ts                      — same (canonical generator output)
go.mod / go.sum                                          — pin new buf.build/gen versions
apps/limits/service/repository/migrate.go               — add the new models
apps/limits/cmd/main.go                                 — wire EventSave handler, runtime handler, reapers
apps/limits/config/config.go                            — add cache TTL + reaper interval knobs
```

### New files

```
apps/limits/service/models/
├── reservation.go                                       — Reservation + ReservationStatus + helpers
├── ledger.go                                            — LedgerEntry + helpers
├── approval.go                                          — ApprovalRequest + ApprovalDecision + ApprovalStatus
├── subject_attribute.go                                 — SubjectAttributeSnapshot

apps/limits/service/repository/
├── reservation_repo.go + _test.go                       — ReservationRepository
├── ledger_repo.go      + _test.go                       — LedgerRepository
├── approval_repo.go    + _test.go                       — ApprovalRequestRepository + ApprovalDecisionRepository
├── subject_attribute_repo.go + _test.go                 — SubjectAttributeRepository (with cache layer)
├── candidate_policy.go + _test.go                       — raw-pool candidate policy lookup (platform + org + org_unit union)

apps/limits/service/business/
├── auditing.go                                          — verb constants + Record* helpers wrapping audit.Writer
├── auditing_test.go
├── evaluator.go                                          — per-policy verdict computation
├── evaluator_test.go
├── reservation.go                                       — Reserve / Commit / Release / Reverse / Check
├── reservation_test.go
├── approval.go                                          — ApprovalRequestList / Get / Decide + re-evaluation
├── approval_test.go
├── ledger_search.go                                     — LedgerSearch
├── ledger_search_test.go
├── audit_search.go                                      — LimitsAuditSearch
├── audit_search_test.go
├── reaper_reservation.go                                — TTL reaper for reservations
├── reaper_reservation_test.go
├── reaper_approval.go                                   — expiry reaper for approvals
├── reaper_approval_test.go
├── attribute_resolver.go                                — read-through SubjectAttribute cache via identity client
├── attribute_resolver_test.go
├── advisory_lock.go                                     — pg_advisory_xact_lock helpers

apps/limits/service/handlers/
├── runtime_service.go + _test.go                        — LimitsService Connect handler
├── admin_service_runtime.go                             — extends AdminService with approval/ledger/audit handlers
├── admin_service_runtime_test.go

apps/limits/service/events/
├── events.go                                            — Frame event names & payloads
├── policy_invalidation_publisher.go                     — emits limits.policy.invalidate.v1 on policy save/delete
├── policy_invalidation_subscriber.go                    — drops cached policies on event

apps/limits/tests/integration/
├── runtime_test.go                                      — full Reserve→Commit/Release/Reverse over HTTP
├── approval_test.go                                     — full PENDING_APPROVAL → Decide → ACTIVE → Commit
├── audit_test.go                                        — every verb produces an audit row
├── ledger_search_test.go
└── reapers_test.go                                      — TTL + approval expiry

```

---

## Task 1: Migration scaffolding for new SQL artefacts

**Files:**
- Create: `apps/limits/migrations/20260506_runtime_indexes.up.sql`
- Create: `apps/limits/migrations/20260506_runtime_indexes.down.sql`

These SQL files run *after* AutoMigrate via Frame's standard migration path (the `migrationPath` argument to `dbManager.Migrate`). They carry the bits AutoMigrate cannot express: partial indexes, advisory-lock-friendly indexes, and the unique-on-(tenant, idempotency) constraint that depends on a `BaseModel`-provided column.

- [ ] **Step 1.1: Write `20260506_runtime_indexes.up.sql`**

```sql
-- Reservation idempotency: per-tenant unique on (tenant_id, idempotency_key).
-- Frame's BaseModel provides tenant_id; this constraint must be SQL because
-- GORM tag-driven composite uniques don't reach into embedded fields.
CREATE UNIQUE INDEX IF NOT EXISTS uq_resv_idempotency
ON limits_reservations (tenant_id, idempotency_key)
WHERE deleted_at IS NULL;

-- Ledger hot path: rolling-window queries scan by (tenant, subject, action,
-- currency, committed_at). Partial index drops the reversed-or-deleted rows.
CREATE INDEX IF NOT EXISTS idx_ledger_window
ON limits_ledger (tenant_id, subject_type, subject_id, action, currency_code, committed_at DESC)
WHERE reversed_at IS NULL AND deleted_at IS NULL;

-- Reservation TTL reaper scans for active rows past their TTL.
CREATE INDEX IF NOT EXISTS idx_resv_ttl_active
ON limits_reservations (ttl_at)
WHERE status = 'active' AND deleted_at IS NULL;

-- Reservation pending sums during evaluation: scan by tenant+action+currency.
CREATE INDEX IF NOT EXISTS idx_resv_pending_sum
ON limits_reservations (tenant_id, action, currency_code, status)
WHERE status IN ('active', 'pending_approval') AND deleted_at IS NULL;

-- Approval expiry reaper scans for pending rows past expires_at.
CREATE INDEX IF NOT EXISTS idx_approval_expiry
ON limits_approval_requests (expires_at)
WHERE status = 'pending' AND deleted_at IS NULL;

-- Approval decisions: a single approver can vote at most once per request.
CREATE UNIQUE INDEX IF NOT EXISTS uq_approval_decision
ON limits_approval_decisions (approval_request_id, approver_id)
WHERE deleted_at IS NULL;

-- Subject attribute snapshot: one row per (tenant, subject_type, subject_id).
CREATE UNIQUE INDEX IF NOT EXISTS uq_subject_attribute
ON limits_subject_attributes (tenant_id, subject_type, subject_id)
WHERE deleted_at IS NULL;
```

- [ ] **Step 1.2: Write `20260506_runtime_indexes.down.sql`**

```sql
DROP INDEX IF EXISTS uq_resv_idempotency;
DROP INDEX IF EXISTS idx_ledger_window;
DROP INDEX IF EXISTS idx_resv_ttl_active;
DROP INDEX IF EXISTS idx_resv_pending_sum;
DROP INDEX IF EXISTS idx_approval_expiry;
DROP INDEX IF EXISTS uq_approval_decision;
DROP INDEX IF EXISTS uq_subject_attribute;
```

- [ ] **Step 1.3: Commit**

```bash
git add apps/limits/migrations/
git commit -m "migrations(limits): add SQL artefacts AutoMigrate cannot express

Partial indexes (ledger window scan, reaper scans, pending-sum scan)
and per-tenant idempotency uniqueness, applied after AutoMigrate via
the standard migrationPath argument."
```

---

## Task 2: `Reservation` model

**Files:**
- Create: `apps/limits/service/models/reservation.go`
- Create: `apps/limits/service/models/reservation_test.go`

- [ ] **Step 2.1: Write the failing test**

```go
// apps/limits/service/models/reservation_test.go
// (Apache 2.0 license header — copy verbatim from apps/savings/cmd/main.go:1-13)
package models

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	moneypb "google.golang.org/genproto/googleapis/type/money"
	"google.golang.org/protobuf/types/known/timestamppb"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
)

func TestReservationFromIntent(t *testing.T) {
	intent := &limitsv1.LimitIntent{
		Action:     limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		TenantId:   "t-1",
		OrgUnitId:  "branch-a",
		Amount:     &moneypb.Money{CurrencyCode: "KES", Units: 100, Nanos: 0},
		Subjects:   []*limitsv1.SubjectRef{{Type: limitsv1.SubjectType_SUBJECT_TYPE_CLIENT, Id: "c1"}},
		MakerId:    "wf-1",
	}
	r, err := ReservationFromIntent(intent, "idem-1")
	require.NoError(t, err)
	assert.Equal(t, "idem-1", r.IdempotencyKey)
	assert.Equal(t, "branch-a", r.OrgUnitID)
	assert.Equal(t, ActionLoanDisbursement, r.Action)
	assert.Equal(t, "KES", r.CurrencyCode)
	assert.Equal(t, int64(10000), r.Amount) // 100.00 KES = 10000 minor units
	assert.Equal(t, "wf-1", r.MakerID)
	assert.Equal(t, ReservationStatusActive, r.Status) // default until evaluator overrides
}

func TestReservationToAPI(t *testing.T) {
	now := time.Date(2026, 5, 1, 0, 0, 0, 0, time.UTC)
	r := &Reservation{
		IdempotencyKey: "idem-1",
		OrgUnitID:      "branch-a",
		Action:         ActionLoanDisbursement,
		CurrencyCode:   "KES",
		Amount:         10000,
		MakerID:        "wf-1",
		Status:         ReservationStatusCommitted,
		ReservedAt:     now,
		TTLAt:          now.Add(5 * time.Minute),
	}
	r.ID = "res-1"
	r.TenantID = "t-1"
	out := r.ToAPI()
	assert.Equal(t, "res-1", out.GetId())
	assert.Equal(t, "t-1", out.GetTenantId())
	assert.Equal(t, limitsv1.ReservationStatus_RESERVATION_STATUS_COMMITTED, out.GetStatus())
	assert.Equal(t, int64(100), out.GetAmount().GetUnits())
	assert.Equal(t, timestamppb.New(now).AsTime(), out.GetReservedAt().AsTime())
}

func TestReservationTableName(t *testing.T) {
	assert.Equal(t, "limits_reservations", Reservation{}.TableName())
}
```

- [ ] **Step 2.2: Run test — expect FAIL**

Run: `go test ./apps/limits/service/models/...`
Expected: FAIL — undefined types.

- [ ] **Step 2.3: Implement `apps/limits/service/models/reservation.go`**

```go
// (Apache 2.0 header)
package models

import (
	"errors"
	"time"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"github.com/pitabwire/frame/data"
	moneyx "github.com/pitabwire/util/money"
	"google.golang.org/protobuf/types/known/timestamppb"
	"gorm.io/datatypes"
)

// ReservationStatus is the state machine for a reservation.
type ReservationStatus string

const (
	ReservationStatusActive          ReservationStatus = "active"
	ReservationStatusPendingApproval ReservationStatus = "pending_approval"
	ReservationStatusCommitted       ReservationStatus = "committed"
	ReservationStatusReleased        ReservationStatus = "released"
	ReservationStatusReversed        ReservationStatus = "reversed"
	ReservationStatusExpired         ReservationStatus = "expired"
)

// Reservation is the per-intent hold against the usage budget.
type Reservation struct {
	data.BaseModel `gorm:"embedded"`

	IdempotencyKey        string            `gorm:"column:idempotency_key;type:varchar(80);not null"`
	OrgUnitID             string            `gorm:"column:org_unit_id;type:varchar(50);index:idx_resv_window,priority:1"`
	Action                Action            `gorm:"column:action;type:varchar(64);not null;index:idx_resv_window,priority:2"`
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

// ReservationFromIntent constructs an unsaved Reservation from a wire intent.
// The IsShadow flag and Status are decided by the evaluator afterwards.
func ReservationFromIntent(intent *limitsv1.LimitIntent, idempotencyKey string) (*Reservation, error) {
	if intent == nil {
		return nil, errors.New("reservation: nil intent")
	}
	currency := intent.GetAmount().GetCurrencyCode()
	amountMinor, err := moneyx.ToMinorUnitsByCurrency(intent.GetAmount(), currency)
	if err != nil {
		return nil, err
	}
	action, err := actionFromAPI(intent.GetAction())
	if err != nil {
		return nil, err
	}
	subjectsJSON, err := marshalSubjectRefs(intent.GetSubjects())
	if err != nil {
		return nil, err
	}
	return &Reservation{
		IdempotencyKey: idempotencyKey,
		OrgUnitID:      intent.GetOrgUnitId(),
		Action:         action,
		CurrencyCode:   currency,
		Amount:         amountMinor,
		SubjectRefs:    datatypes.JSON(subjectsJSON),
		MakerID:        intent.GetMakerId(),
		Status:         ReservationStatusActive, // overridden by evaluator if approval required
		ReservedAt:     time.Now().UTC(),
	}, nil
}

// ToAPI converts a persisted Reservation to its wire shape.
func (r *Reservation) ToAPI() *limitsv1.ReservationObject {
	out := &limitsv1.ReservationObject{
		Id:             r.ID,
		TenantId:       r.TenantID,
		IdempotencyKey: r.IdempotencyKey,
		OrgUnitId:      r.OrgUnitID,
		Action:         actionToAPI(r.Action),
		Amount:         moneyx.FromMinorUnitsByCurrency(r.CurrencyCode, r.Amount),
		MakerId:        r.MakerID,
		Status:         reservationStatusToAPI(r.Status),
		IsShadow:       r.IsShadow,
		ReservedAt:     timestamppb.New(r.ReservedAt),
		TtlAt:          timestamppb.New(r.TTLAt),
	}
	if subjects, err := unmarshalSubjectRefs(r.SubjectRefs); err == nil {
		out.Subjects = subjects
	}
	if r.CommittedAt != nil {
		out.CommittedAt = timestamppb.New(*r.CommittedAt)
	}
	if r.ReleasedAt != nil {
		out.ReleasedAt = timestamppb.New(*r.ReleasedAt)
	}
	return out
}

func reservationStatusToAPI(s ReservationStatus) limitsv1.ReservationStatus {
	switch s {
	case ReservationStatusActive:
		return limitsv1.ReservationStatus_RESERVATION_STATUS_ACTIVE
	case ReservationStatusPendingApproval:
		return limitsv1.ReservationStatus_RESERVATION_STATUS_PENDING_APPROVAL
	case ReservationStatusCommitted:
		return limitsv1.ReservationStatus_RESERVATION_STATUS_COMMITTED
	case ReservationStatusReleased:
		return limitsv1.ReservationStatus_RESERVATION_STATUS_RELEASED
	case ReservationStatusReversed:
		return limitsv1.ReservationStatus_RESERVATION_STATUS_REVERSED
	case ReservationStatusExpired:
		return limitsv1.ReservationStatus_RESERVATION_STATUS_EXPIRED
	default:
		return limitsv1.ReservationStatus_RESERVATION_STATUS_UNSPECIFIED
	}
}
```

- [ ] **Step 2.4: Add subject-ref marshallers to `apps/limits/service/models/helpers.go`**

```go
// At the bottom of helpers.go, add:

import (
	// ... existing imports ...
	"encoding/json"
)

func marshalSubjectRefs(refs []*limitsv1.SubjectRef) ([]byte, error) {
	if len(refs) == 0 {
		return []byte("[]"), nil
	}
	type sr struct {
		Type string `json:"type"`
		ID   string `json:"id"`
	}
	out := make([]sr, len(refs))
	for i, r := range refs {
		out[i] = sr{Type: subjectTypeJSON(r.GetType()), ID: r.GetId()}
	}
	return json.Marshal(out)
}

func unmarshalSubjectRefs(b []byte) ([]*limitsv1.SubjectRef, error) {
	if len(b) == 0 {
		return nil, nil
	}
	type sr struct {
		Type string `json:"type"`
		ID   string `json:"id"`
	}
	var raw []sr
	if err := json.Unmarshal(b, &raw); err != nil {
		return nil, err
	}
	out := make([]*limitsv1.SubjectRef, len(raw))
	for i, r := range raw {
		out[i] = &limitsv1.SubjectRef{Type: subjectTypeFromJSON(r.Type), Id: r.ID}
	}
	return out, nil
}

func subjectTypeJSON(t limitsv1.SubjectType) string {
	switch t {
	case limitsv1.SubjectType_SUBJECT_TYPE_CLIENT:
		return "client"
	case limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT:
		return "account"
	case limitsv1.SubjectType_SUBJECT_TYPE_PRODUCT:
		return "product"
	case limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION:
		return "organization"
	case limitsv1.SubjectType_SUBJECT_TYPE_ORG_UNIT:
		return "org_unit"
	case limitsv1.SubjectType_SUBJECT_TYPE_WORKFORCE_MEMBER:
		return "workforce_member"
	default:
		return ""
	}
}

func subjectTypeFromJSON(s string) limitsv1.SubjectType {
	switch s {
	case "client":
		return limitsv1.SubjectType_SUBJECT_TYPE_CLIENT
	case "account":
		return limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT
	case "product":
		return limitsv1.SubjectType_SUBJECT_TYPE_PRODUCT
	case "organization":
		return limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION
	case "org_unit":
		return limitsv1.SubjectType_SUBJECT_TYPE_ORG_UNIT
	case "workforce_member":
		return limitsv1.SubjectType_SUBJECT_TYPE_WORKFORCE_MEMBER
	default:
		return limitsv1.SubjectType_SUBJECT_TYPE_UNSPECIFIED
	}
}
```

- [ ] **Step 2.5: Run tests**

`go test -race ./apps/limits/service/models/...`
Expected: PASS.

- [ ] **Step 2.6: Commit**

```bash
git add apps/limits/service/models/
git commit -m "feat(limits): add Reservation model with intent/wire converters"
```

---

## Task 3: `LedgerEntry`, `ApprovalRequest`/`ApprovalDecision`, `SubjectAttributeSnapshot` models

**Files:**
- Create: `apps/limits/service/models/ledger.go`
- Create: `apps/limits/service/models/approval.go`
- Create: `apps/limits/service/models/subject_attribute.go`
- Modify: `apps/limits/service/repository/migrate.go`

This task lands the rest of the runtime/approval/cache models in one commit since they're all small and similar in shape.

- [ ] **Step 3.1: Write `apps/limits/service/models/ledger.go`**

```go
// (Apache 2.0 header)
package models

import (
	"time"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"github.com/pitabwire/frame/data"
	moneyx "github.com/pitabwire/util/money"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// LedgerEntry is the per-(reservation, subject) row used by rolling-window
// scans. Created when a reservation is committed; its ReversedAt is set
// when the reservation is reversed.
type LedgerEntry struct {
	data.BaseModel `gorm:"embedded"`

	ReservationID string      `gorm:"column:reservation_id;type:varchar(50);not null;index:idx_ledger_resv"`
	OrgUnitID     string      `gorm:"column:org_unit_id;type:varchar(50)"`
	Action        Action      `gorm:"column:action;type:varchar(64);not null"`
	SubjectType   Subject     `gorm:"column:subject_type;type:varchar(32);not null"`
	SubjectID     string      `gorm:"column:subject_id;type:varchar(50);not null"`
	CurrencyCode  string      `gorm:"column:currency_code;type:varchar(3);not null"`
	Amount        int64       `gorm:"column:amount;not null;check:amount >= 0"`
	CommittedAt   time.Time   `gorm:"column:committed_at;type:timestamptz;not null"`
	ReversedAt    *time.Time  `gorm:"column:reversed_at;type:timestamptz"`
}

func (LedgerEntry) TableName() string { return "limits_ledger" }

// ToAPI converts to the wire shape.
func (e *LedgerEntry) ToAPI() *limitsv1.LedgerEntryObject {
	out := &limitsv1.LedgerEntryObject{
		Id:            e.ID,
		ReservationId: e.ReservationID,
		TenantId:      e.TenantID,
		OrgUnitId:     e.OrgUnitID,
		Action:        actionToAPI(e.Action),
		SubjectType:   subjectToAPI(e.SubjectType),
		SubjectId:     e.SubjectID,
		Amount:        moneyx.FromMinorUnitsByCurrency(e.CurrencyCode, e.Amount),
		CommittedAt:   timestamppb.New(e.CommittedAt),
	}
	if e.ReversedAt != nil {
		out.ReversedAt = timestamppb.New(*e.ReversedAt)
	}
	return out
}
```

- [ ] **Step 3.2: Write `apps/limits/service/models/approval.go`**

```go
// (Apache 2.0 header)
package models

import (
	"time"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"github.com/pitabwire/frame/data"
	moneyx "github.com/pitabwire/util/money"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// ApprovalStatus is the state machine for an ApprovalRequest.
type ApprovalStatus string

const (
	ApprovalStatusPending             ApprovalStatus = "pending"
	ApprovalStatusApproved            ApprovalStatus = "approved"
	ApprovalStatusRejected            ApprovalStatus = "rejected"
	ApprovalStatusExpired             ApprovalStatus = "expired"
	ApprovalStatusAutoRejectedRecheck ApprovalStatus = "auto_rejected_on_recheck"
)

// ApprovalRequest is one approval gate per (reservation, triggering policy).
// Multiple requests may exist for a single reservation if multiple policies
// each require approval; the reservation transitions to ACTIVE only when
// every request reaches APPROVED.
type ApprovalRequest struct {
	data.BaseModel `gorm:"embedded"`

	ReservationID      string         `gorm:"column:reservation_id;type:varchar(50);not null;index"`
	OrgUnitID          string         `gorm:"column:org_unit_id;type:varchar(50)"`
	Action             Action         `gorm:"column:action;type:varchar(64);not null"`
	CurrencyCode       string         `gorm:"column:currency_code;type:varchar(3);not null"`
	Amount             int64          `gorm:"column:amount;not null;check:amount >= 0"`
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

func (ApprovalRequest) TableName() string { return "limits_approval_requests" }

// ApprovalDecision records a single approver's vote on an approval request.
// The unique-on-(approval_request_id, approver_id) constraint (declared in
// the SQL migration) prevents double-voting.
type ApprovalDecision struct {
	data.BaseModel `gorm:"embedded"`

	ApprovalRequestID string    `gorm:"column:approval_request_id;type:varchar(50);not null;index"`
	ApproverID        string    `gorm:"column:approver_id;type:varchar(50);not null"`
	Decision          string    `gorm:"column:decision;type:varchar(16);not null"` // approve | reject
	Note              string    `gorm:"column:note;type:text"`
	DecidedAt         time.Time `gorm:"column:decided_at;type:timestamptz;not null"`
}

func (ApprovalDecision) TableName() string { return "limits_approval_decisions" }

// ToAPI builds the wire shape from a request and its decisions.
func (r *ApprovalRequest) ToAPI(decisions []*ApprovalDecision) *limitsv1.ApprovalRequestObject {
	out := &limitsv1.ApprovalRequestObject{
		Id:                 r.ID,
		ReservationId:      r.ReservationID,
		TenantId:           r.TenantID,
		OrgUnitId:          r.OrgUnitID,
		TriggeringPolicyId: r.TriggeringPolicyID,
		PolicyVersion:      r.PolicyVersion,
		Action:             actionToAPI(r.Action),
		Amount:             moneyx.FromMinorUnitsByCurrency(r.CurrencyCode, r.Amount),
		RequiredRole:       r.RequiredRole,
		RequiredCount:      r.RequiredCount,
		MakerId:            r.MakerID,
		Status:             approvalStatusToAPI(r.Status),
		SubmittedAt:        timestamppb.New(r.SubmittedAt),
		ExpiresAt:          timestamppb.New(r.ExpiresAt),
	}
	if r.DecidedAt != nil {
		out.DecidedAt = timestamppb.New(*r.DecidedAt)
	}
	for _, d := range decisions {
		out.Decisions = append(out.Decisions, &limitsv1.ApprovalDecisionObject{
			ApproverId: d.ApproverID,
			Decision:   d.Decision,
			Note:       d.Note,
			DecidedAt:  timestamppb.New(d.DecidedAt),
		})
	}
	return out
}

func approvalStatusToAPI(s ApprovalStatus) limitsv1.ApprovalStatus {
	switch s {
	case ApprovalStatusPending:
		return limitsv1.ApprovalStatus_APPROVAL_STATUS_PENDING
	case ApprovalStatusApproved:
		return limitsv1.ApprovalStatus_APPROVAL_STATUS_APPROVED
	case ApprovalStatusRejected:
		return limitsv1.ApprovalStatus_APPROVAL_STATUS_REJECTED
	case ApprovalStatusExpired:
		return limitsv1.ApprovalStatus_APPROVAL_STATUS_EXPIRED
	case ApprovalStatusAutoRejectedRecheck:
		return limitsv1.ApprovalStatus_APPROVAL_STATUS_AUTO_REJECTED_ON_RECHECK
	default:
		return limitsv1.ApprovalStatus_APPROVAL_STATUS_UNSPECIFIED
	}
}
```

- [ ] **Step 3.3: Write `apps/limits/service/models/subject_attribute.go`**

```go
// (Apache 2.0 header)
package models

import (
	"time"

	"github.com/pitabwire/frame/data"
	"gorm.io/datatypes"
)

// SubjectAttributeSnapshot caches a subject's identity-side attributes
// (KYC tier, region, risk score, etc.) for fast policy predicate evaluation.
// Refreshed by the AttributeResolver and invalidated by identity events.
type SubjectAttributeSnapshot struct {
	data.BaseModel `gorm:"embedded"`

	SubjectType Subject        `gorm:"column:subject_type;type:varchar(32);not null"`
	SubjectID   string         `gorm:"column:subject_id;type:varchar(50);not null"`
	Attributes  datatypes.JSON `gorm:"column:attributes;type:jsonb;not null"`
	FetchedAt   time.Time      `gorm:"column:fetched_at;type:timestamptz;not null"`
}

func (SubjectAttributeSnapshot) TableName() string { return "limits_subject_attributes" }
```

- [ ] **Step 3.4: Update `apps/limits/service/repository/migrate.go`**

Edit the model slice to add the four new types:

```go
return dbManager.Migrate(ctx, dbPool, migrationPath,
	&models.Policy{},
	&models.PolicyVersion{},
	&models.Reservation{},                  // ← new
	&models.LedgerEntry{},                  // ← new
	&models.ApprovalRequest{},              // ← new
	&models.ApprovalDecision{},             // ← new
	&models.SubjectAttributeSnapshot{},     // ← new
	&audit.Event{},
)
```

- [ ] **Step 3.5: Verify build**

`go build ./apps/limits/...`
Expected: success.

- [ ] **Step 3.6: Run existing tests with the migration extended**

`go test -race -timeout=120s ./apps/limits/service/repository/... ./apps/limits/service/business/...`
Expected: PASS — repositories/business tests already work; the new models migrate without breaking the existing ones.

- [ ] **Step 3.7: Commit**

```bash
git add apps/limits/service/models/ apps/limits/service/repository/migrate.go
git commit -m "feat(limits): add Ledger, Approval, and SubjectAttribute models

LedgerEntry is the per-(reservation, subject) row that powers rolling-
window scans. ApprovalRequest + ApprovalDecision are the maker-checker
state machine (one request per triggering policy). SubjectAttributeSnapshot
caches identity attributes for predicate evaluation. All extend
data.BaseModel and are added to the migrate.go slice."
```

---

## Task 4: Proto extension — `LimitsAuditSearch` + audit-view permission

**Files:**
- Modify: `proto/limits/limits/v1/limits.proto`

The runtime RPCs (Check/Reserve/Commit/Release/Reverse) and the approval admin RPCs already exist in the proto from Plan 1. This task adds the new `LimitsAuditSearch` RPC and the `limits_audit_view` permission.

- [ ] **Step 4.1: Edit `proto/limits/limits/v1/limits.proto`**

Add the `LimitsAuditEventObject`, request, response, and RPC under `LimitsAdminService`. Add `limits_audit_view` to the `service_permissions` block on `LimitsAdminService` and to one or more role bindings (mirror the loans/savings patterns).

```proto
// New messages (place near the existing admin-message group):

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

message LimitsAuditSearchRequest {
  repeated string actions = 1;
  string entity_type = 2;
  string entity_id = 3;
  string actor_id = 4;
  google.protobuf.Timestamp from = 5;
  google.protobuf.Timestamp to = 6;
  common.v1.PageCursor cursor = 7;
}

message LimitsAuditSearchResponse {
  repeated LimitsAuditEventObject data = 1;
}

// New RPC under service LimitsAdminService:

rpc LimitsAuditSearch(LimitsAuditSearchRequest) returns (stream LimitsAuditSearchResponse) {
  option (common.v1.method_permissions) = { permissions: ["limits_audit_view"] };
}
```

Also extend the `service_permissions` permission list with `limits_audit_view` and add it to the role bindings for OWNER/ADMIN/OPERATOR/VIEWER/MEMBER roles where appropriate (read-only access goes to all of them; write/decide is unchanged).

- [ ] **Step 4.2: Lint and verify**

```
cd proto && buf lint limits
```
Expected: clean.

- [ ] **Step 4.3: Push proto, regen Go stubs, regen OPL**

(Operator-only step — same pattern as Plan 1 Task 3.)

```
cd proto && buf push
go get buf.build/gen/go/antinvestor/limits/protocolbuffers/go@latest
go get buf.build/gen/go/antinvestor/limits/connectrpc/go@latest
go mod tidy
make proto-generate
```

Expected: new buf.build commit hash for limits; `apps/default/service_limits.opl.ts` regenerated to include `granted_limits_audit_view` and corresponding permits.

- [ ] **Step 4.4: Mirror OPL into `opl/limits/`**

```
cp apps/default/service_limits.opl.ts opl/limits/
```

- [ ] **Step 4.5: Build + commit**

`go build ./...` clean.

```
git add proto/limits/limits/v1/limits.proto opl/limits/ apps/default/service_limits.opl.ts go.mod go.sum
git commit -m "proto(limits): add LimitsAuditSearch RPC and limits_audit_view permission

Risk and compliance roles need a queryable feed of every gating
decision. LimitsAuditSearch reads the existing audit_events table
(populated by audit.Writer.Record with limits.* action verbs)."
```

---

## Task 5: `ReservationRepository`

**Files:**
- Create: `apps/limits/service/repository/reservation_repo.go`
- Create: `apps/limits/service/repository/reservation_repo_test.go`

- [ ] **Step 5.1: Write the failing test**

Use the same `frametests.FrameBaseTestSuite` pattern as `policy_repo_test.go`. Cover:
- `CreateAndGetByIdempotencyKey` — saving and retrieving by `(tenant_id, idempotency_key)` returns the same row.
- `IdempotencyConflictDifferentIntent` — saving with the same idempotency key but a different action returns the existing row's ID (caller decides whether to error).
- `PendingSumByTenantSubject` — sums `Amount` across `active`/`pending_approval` rows in the time window for a given subject.
- `TransitionStatus` — `Update` to commit/release/expire flips `Status` correctly.
- `ListExpiredActive` — finds reservations with `status='active' AND ttl_at < now()`.

```go
// apps/limits/service/repository/reservation_repo_test.go
// (Apache 2.0 header)
package repository_test

import (
	"context"
	"testing"
	"time"

	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/frametests"
	"github.com/pitabwire/frame/frametests/definition"
	testpostgres "github.com/pitabwire/frame/frametests/deps/testpostgres"
	"github.com/stretchr/testify/suite"
	"gorm.io/datatypes"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

type ReservationRepoSuite struct {
	frametests.FrameBaseTestSuite
	repo repository.ReservationRepository
	svc  *frame.Service
	ctx  context.Context
}

func (s *ReservationRepoSuite) SetupSuite() {
	s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
		return []definition.TestResource{
			testpostgres.NewWithOpts("limits_test", definition.WithUserName("test")),
		}
	}
	s.FrameBaseTestSuite.SetupSuite()
}

func (s *ReservationRepoSuite) SetupTest() {
	ctx := s.T().Context()
	dsURL, _ := s.GetResource(0).(*testpostgres.Resource).GetRandomisedDS()
	ctx, svc := frame.NewServiceWithContext(ctx,
		frame.WithDatastoreConnection(dsURL.String()),
	)
	s.svc, s.ctx = svc, ctx
	require := s.Require()
	dbManager := svc.DatastoreManager()
	require.NoError(repository.Migrate(ctx, dbManager, ""))
	pool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	s.repo = repository.NewReservationRepository(ctx, pool, svc.WorkManager())
}

func (s *ReservationRepoSuite) ctxFor(tenant string) context.Context {
	return s.WithAuthClaims(s.ctx, tenant, "p-1", "wf-1")
}

func sampleResv(idem string, action models.Action, amount int64) *models.Reservation {
	return &models.Reservation{
		IdempotencyKey: idem,
		Action:         action,
		CurrencyCode:   "KES",
		Amount:         amount,
		SubjectRefs:    datatypes.JSON([]byte(`[{"type":"client","id":"c1"}]`)),
		MakerID:        "wf-1",
		Status:         models.ReservationStatusActive,
		PoliciesEvaluated: datatypes.JSON([]byte(`[]`)),
		ReservedAt:     time.Now().UTC(),
		TTLAt:          time.Now().Add(5 * time.Minute).UTC(),
	}
}

func (s *ReservationRepoSuite) TestCreateAndGetByIdempotencyKey() {
	ctx := s.ctxFor("t-1")
	r := sampleResv("idem-1", models.ActionLoanDisbursement, 1000)
	s.Require().NoError(s.repo.Create(ctx, r))
	s.NotEmpty(r.ID)
	got, err := s.repo.GetByIdempotencyKey(ctx, "idem-1")
	s.Require().NoError(err)
	s.Equal(r.ID, got.ID)
}

func (s *ReservationRepoSuite) TestPendingSumByTenantSubject() {
	ctx := s.ctxFor("t-1")
	r1 := sampleResv("idem-1", models.ActionLoanDisbursement, 1000)
	r2 := sampleResv("idem-2", models.ActionLoanDisbursement, 2000)
	s.Require().NoError(s.repo.Create(ctx, r1))
	s.Require().NoError(s.repo.Create(ctx, r2))
	sum, err := s.repo.PendingSum(ctx, models.ActionLoanDisbursement, "KES",
		repository.SubjectFilter{Type: models.SubjectClient, ID: "c1"})
	s.Require().NoError(err)
	s.Equal(int64(3000), sum)
}

func (s *ReservationRepoSuite) TestListExpiredActive() {
	ctx := s.ctxFor("t-1")
	r := sampleResv("idem-old", models.ActionLoanDisbursement, 1)
	r.TTLAt = time.Now().Add(-1 * time.Minute).UTC()
	s.Require().NoError(s.repo.Create(ctx, r))
	out, err := s.repo.ListExpiredActive(ctx, time.Now().UTC(), 100)
	s.Require().NoError(err)
	s.Len(out, 1)
	s.Equal(r.ID, out[0].ID)
}

func (s *ReservationRepoSuite) TestTransitionToCommitted() {
	ctx := s.ctxFor("t-1")
	r := sampleResv("idem-1", models.ActionLoanDisbursement, 1)
	s.Require().NoError(s.repo.Create(ctx, r))
	now := time.Now().UTC()
	s.Require().NoError(s.repo.SetCommitted(ctx, r.ID, now))
	got, err := s.repo.GetByID(ctx, r.ID)
	s.Require().NoError(err)
	s.Equal(models.ReservationStatusCommitted, got.Status)
	s.NotNil(got.CommittedAt)
}

func TestReservationRepoSuite(t *testing.T) {
	suite.Run(t, new(ReservationRepoSuite))
}
```

- [ ] **Step 5.2: Run test — expect FAIL**

Run: `go test ./apps/limits/service/repository/...`
Expected: FAIL — undefined types.

- [ ] **Step 5.3: Implement `apps/limits/service/repository/reservation_repo.go`**

```go
// (Apache 2.0 header)
package repository

import (
	"context"
	"errors"
	"time"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/datastore/scopes"
	"github.com/pitabwire/frame/workerpool"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
)

// SubjectFilter narrows pending-sum queries to a specific subject ref.
type SubjectFilter struct {
	Type models.Subject
	ID   string
}

// ReservationRepository persists Reservation rows. Read paths route through
// the BaseRepository; aggregate queries (PendingSum, ListExpiredActive) drop
// to a raw pool because the BaseRepository surface does not cover them.
type ReservationRepository interface {
	Create(ctx context.Context, r *models.Reservation) error
	GetByID(ctx context.Context, id string) (*models.Reservation, error)
	GetByIdempotencyKey(ctx context.Context, key string) (*models.Reservation, error)
	PendingSum(ctx context.Context, action models.Action, currency string, subject SubjectFilter) (int64, error)
	PendingCount(ctx context.Context, action models.Action, currency string, subject SubjectFilter, since time.Time) (int64, error)
	SetCommitted(ctx context.Context, id string, at time.Time) error
	SetReleased(ctx context.Context, id, reason string, at time.Time) error
	SetExpired(ctx context.Context, id string, at time.Time) error
	SetReversed(ctx context.Context, id string, at time.Time) error
	SetPendingApproval(ctx context.Context, id string) error
	SetActive(ctx context.Context, id string) error
	ListExpiredActive(ctx context.Context, before time.Time, limit int) ([]*models.Reservation, error)
}

type reservationRepository struct {
	datastore.BaseRepository[*models.Reservation]
	dbPool pool.Pool
}

// NewReservationRepository constructs the repository.
func NewReservationRepository(ctx context.Context, p pool.Pool, workMan workerpool.Manager) ReservationRepository {
	r := &reservationRepository{dbPool: p}
	r.BaseRepository = datastore.NewBaseRepository[*models.Reservation](
		ctx, p, workMan,
		func() *models.Reservation { return &models.Reservation{} },
	)
	return r
}

func (r *reservationRepository) Create(ctx context.Context, m *models.Reservation) error {
	if m.ID == "" {
		m.ID = util.IDString()
	}
	return r.BaseRepository.Create(ctx, m)
}

func (r *reservationRepository) GetByIdempotencyKey(ctx context.Context, key string) (*models.Reservation, error) {
	db := r.dbPool.DB(ctx, true).Scopes(scopes.TenancyPartition(ctx))
	var out models.Reservation
	if err := db.Where("idempotency_key = ?", key).First(&out).Error; err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *reservationRepository) PendingSum(ctx context.Context, action models.Action, currency string, subject SubjectFilter) (int64, error) {
	db := r.dbPool.DB(ctx, true).Scopes(scopes.TenancyPartition(ctx))
	var sum int64
	err := db.Model(&models.Reservation{}).
		Where("action = ? AND currency_code = ?", string(action), currency).
		Where("status IN ?", []string{string(models.ReservationStatusActive), string(models.ReservationStatusPendingApproval)}).
		Where("ttl_at > ?", time.Now().UTC()).
		Where("subject_refs @> ?", subjectMatch(subject)).
		Select("COALESCE(SUM(amount), 0)").
		Scan(&sum).Error
	if err != nil {
		return 0, err
	}
	return sum, nil
}

func (r *reservationRepository) PendingCount(ctx context.Context, action models.Action, currency string, subject SubjectFilter, since time.Time) (int64, error) {
	db := r.dbPool.DB(ctx, true).Scopes(scopes.TenancyPartition(ctx))
	var count int64
	err := db.Model(&models.Reservation{}).
		Where("action = ? AND currency_code = ?", string(action), currency).
		Where("status IN ?", []string{string(models.ReservationStatusActive), string(models.ReservationStatusPendingApproval)}).
		Where("reserved_at >= ?", since).
		Where("subject_refs @> ?", subjectMatch(subject)).
		Count(&count).Error
	return count, err
}

func subjectMatch(s SubjectFilter) string {
	// Postgres jsonb @> requires a JSON-encoded array of objects.
	return `[{"type":"` + string(s.Type) + `","id":"` + s.ID + `"}]`
}

func (r *reservationRepository) SetCommitted(ctx context.Context, id string, at time.Time) error {
	db := r.dbPool.DB(ctx, false).Scopes(scopes.TenancyPartition(ctx))
	res := db.Model(&models.Reservation{}).
		Where("id = ? AND status = ?", id, string(models.ReservationStatusActive)).
		Updates(map[string]any{
			"status":       string(models.ReservationStatusCommitted),
			"committed_at": at,
			"modified_at":  at,
		})
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return errors.New("reservation: cannot commit (not active or missing)")
	}
	return nil
}

func (r *reservationRepository) SetReleased(ctx context.Context, id, reason string, at time.Time) error {
	db := r.dbPool.DB(ctx, false).Scopes(scopes.TenancyPartition(ctx))
	res := db.Model(&models.Reservation{}).
		Where("id = ? AND status IN ?", id, []string{string(models.ReservationStatusActive), string(models.ReservationStatusPendingApproval)}).
		Updates(map[string]any{
			"status":       string(models.ReservationStatusReleased),
			"released_at":  at,
			"notes":        reason,
			"modified_at":  at,
		})
	if res.Error != nil {
		return res.Error
	}
	if res.RowsAffected == 0 {
		return errors.New("reservation: cannot release (terminal or missing)")
	}
	return nil
}

func (r *reservationRepository) SetExpired(ctx context.Context, id string, at time.Time) error {
	db := r.dbPool.DB(ctx, false).Scopes(scopes.TenancyPartition(ctx))
	return db.Model(&models.Reservation{}).
		Where("id = ? AND status = ?", id, string(models.ReservationStatusActive)).
		Updates(map[string]any{"status": string(models.ReservationStatusExpired), "modified_at": at}).Error
}

func (r *reservationRepository) SetReversed(ctx context.Context, id string, at time.Time) error {
	db := r.dbPool.DB(ctx, false).Scopes(scopes.TenancyPartition(ctx))
	return db.Model(&models.Reservation{}).
		Where("id = ?", id).
		Updates(map[string]any{"status": string(models.ReservationStatusReversed), "modified_at": at}).Error
}

func (r *reservationRepository) SetPendingApproval(ctx context.Context, id string) error {
	db := r.dbPool.DB(ctx, false).Scopes(scopes.TenancyPartition(ctx))
	return db.Model(&models.Reservation{}).
		Where("id = ?", id).
		Updates(map[string]any{"status": string(models.ReservationStatusPendingApproval), "modified_at": time.Now().UTC()}).Error
}

func (r *reservationRepository) SetActive(ctx context.Context, id string) error {
	db := r.dbPool.DB(ctx, false).Scopes(scopes.TenancyPartition(ctx))
	return db.Model(&models.Reservation{}).
		Where("id = ? AND status = ?", id, string(models.ReservationStatusPendingApproval)).
		Updates(map[string]any{"status": string(models.ReservationStatusActive), "modified_at": time.Now().UTC()}).Error
}

func (r *reservationRepository) ListExpiredActive(ctx context.Context, before time.Time, limit int) ([]*models.Reservation, error) {
	if limit <= 0 {
		limit = 1000
	}
	// Reaper queries cross-tenant: skip TenancyPartition.
	db := r.dbPool.DB(ctx, true)
	var rows []*models.Reservation
	err := db.Where("status = ? AND ttl_at < ?", string(models.ReservationStatusActive), before).
		Order("ttl_at ASC").
		Limit(limit).
		Find(&rows).Error
	return rows, err
}
```

- [ ] **Step 5.4: Run test — expect PASS**

`go test -race -timeout=120s ./apps/limits/service/repository/...`
Expected: PASS.

- [ ] **Step 5.5: Commit**

```bash
git add apps/limits/service/repository/reservation_repo.go apps/limits/service/repository/reservation_repo_test.go
git commit -m "feat(limits): add ReservationRepository with idempotency, pending-sum, and reaper queries"
```

---

## Task 6: `LedgerRepository`

**Files:**
- Create: `apps/limits/service/repository/ledger_repo.go`
- Create: `apps/limits/service/repository/ledger_repo_test.go`

The ledger has fewer methods because it's append-only (committed entries from reservations) plus a single "mark reversed" path. The hot read is the rolling-window `SUM(amount)` and `COUNT(*)`.

- [ ] **Step 6.1: Write the failing test**

Cases:
- `CreateBatch` — multiple `LedgerEntry` rows in one call (one per subject).
- `WindowSum` — sum committed amount for `(tenant, subject, action, currency)` since `from` time, excluding reversed.
- `WindowCount` — count rows similarly.
- `MarkReversed` — sets `ReversedAt` for all entries of a reservation; `WindowSum`/`Count` exclude them.

```go
// apps/limits/service/repository/ledger_repo_test.go
// (Apache 2.0 header)
package repository_test

import (
	"context"
	"testing"
	"time"

	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/frametests"
	"github.com/pitabwire/frame/frametests/definition"
	testpostgres "github.com/pitabwire/frame/frametests/deps/testpostgres"
	"github.com/stretchr/testify/suite"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

type LedgerRepoSuite struct {
	frametests.FrameBaseTestSuite
	repo repository.LedgerRepository
	svc  *frame.Service
	ctx  context.Context
}

func (s *LedgerRepoSuite) SetupSuite() {
	s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
		return []definition.TestResource{
			testpostgres.NewWithOpts("limits_test", definition.WithUserName("test")),
		}
	}
	s.FrameBaseTestSuite.SetupSuite()
}

func (s *LedgerRepoSuite) SetupTest() {
	ctx := s.T().Context()
	dsURL, _ := s.GetResource(0).(*testpostgres.Resource).GetRandomisedDS()
	ctx, svc := frame.NewServiceWithContext(ctx, frame.WithDatastoreConnection(dsURL.String()))
	s.svc, s.ctx = svc, ctx
	dbManager := svc.DatastoreManager()
	s.Require().NoError(repository.Migrate(ctx, dbManager, ""))
	pool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	s.repo = repository.NewLedgerRepository(ctx, pool, svc.WorkManager())
}

func (s *LedgerRepoSuite) ctxFor(tenant string) context.Context {
	return s.WithAuthClaims(s.ctx, tenant, "p-1", "wf-1")
}

func entry(rid string, amt int64, at time.Time) *models.LedgerEntry {
	return &models.LedgerEntry{
		ReservationID: rid,
		Action:        models.ActionLoanDisbursement,
		SubjectType:   models.SubjectClient,
		SubjectID:     "c1",
		CurrencyCode:  "KES",
		Amount:        amt,
		CommittedAt:   at,
	}
}

func (s *LedgerRepoSuite) TestCreateBatchAndWindowSum() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	s.Require().NoError(s.repo.CreateBatch(ctx, []*models.LedgerEntry{
		entry("r1", 100, now.Add(-1*time.Hour)),
		entry("r2", 200, now.Add(-30*time.Minute)),
		entry("r3", 50, now.Add(-2*time.Hour)),
	}))
	sum, err := s.repo.WindowSum(ctx, models.ActionLoanDisbursement, "KES",
		repository.SubjectFilter{Type: models.SubjectClient, ID: "c1"},
		now.Add(-90*time.Minute))
	s.Require().NoError(err)
	s.Equal(int64(300), sum)
}

func (s *LedgerRepoSuite) TestMarkReversedExcludedFromSum() {
	ctx := s.ctxFor("t-1")
	now := time.Now().UTC()
	s.Require().NoError(s.repo.CreateBatch(ctx, []*models.LedgerEntry{
		entry("r1", 100, now.Add(-1*time.Hour)),
		entry("r2", 200, now.Add(-30*time.Minute)),
	}))
	s.Require().NoError(s.repo.MarkReversed(ctx, "r1", now))
	sum, err := s.repo.WindowSum(ctx, models.ActionLoanDisbursement, "KES",
		repository.SubjectFilter{Type: models.SubjectClient, ID: "c1"},
		now.Add(-2*time.Hour))
	s.Require().NoError(err)
	s.Equal(int64(200), sum) // r1 excluded
}

func TestLedgerRepoSuite(t *testing.T) { suite.Run(t, new(LedgerRepoSuite)) }
```

- [ ] **Step 6.2: Run test — expect FAIL**

`go test ./apps/limits/service/repository/...`
Expected: FAIL.

- [ ] **Step 6.3: Implement `apps/limits/service/repository/ledger_repo.go`**

```go
// (Apache 2.0 header)
package repository

import (
	"context"
	"time"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/datastore/scopes"
	"github.com/pitabwire/frame/workerpool"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
)

type LedgerRepository interface {
	CreateBatch(ctx context.Context, entries []*models.LedgerEntry) error
	WindowSum(ctx context.Context, action models.Action, currency string, subject SubjectFilter, since time.Time) (int64, error)
	WindowCount(ctx context.Context, action models.Action, currency string, subject SubjectFilter, since time.Time) (int64, error)
	MarkReversed(ctx context.Context, reservationID string, at time.Time) error
	Search(ctx context.Context, f LedgerSearchFilter, limit int, cursor string) (*LedgerSearchResult, error)
}

type LedgerSearchFilter struct {
	Action       models.Action
	SubjectType  models.Subject
	SubjectID    string
	CurrencyCode string
	From         time.Time
	To           time.Time
}

type LedgerSearchResult struct {
	Items      []*models.LedgerEntry
	NextCursor string
}

type ledgerRepository struct {
	datastore.BaseRepository[*models.LedgerEntry]
	dbPool pool.Pool
}

func NewLedgerRepository(ctx context.Context, p pool.Pool, workMan workerpool.Manager) LedgerRepository {
	r := &ledgerRepository{dbPool: p}
	r.BaseRepository = datastore.NewBaseRepository[*models.LedgerEntry](
		ctx, p, workMan,
		func() *models.LedgerEntry { return &models.LedgerEntry{} },
	)
	return r
}

func (r *ledgerRepository) CreateBatch(ctx context.Context, entries []*models.LedgerEntry) error {
	for _, e := range entries {
		if e.ID == "" {
			e.ID = util.IDString()
		}
	}
	db := r.dbPool.DB(ctx, false)
	return db.Create(&entries).Error
}

func (r *ledgerRepository) WindowSum(ctx context.Context, action models.Action, currency string, subject SubjectFilter, since time.Time) (int64, error) {
	db := r.dbPool.DB(ctx, true).Scopes(scopes.TenancyPartition(ctx))
	var sum int64
	err := db.Model(&models.LedgerEntry{}).
		Where("action = ? AND currency_code = ? AND subject_type = ? AND subject_id = ?",
			string(action), currency, string(subject.Type), subject.ID).
		Where("committed_at >= ? AND reversed_at IS NULL", since).
		Select("COALESCE(SUM(amount), 0)").
		Scan(&sum).Error
	return sum, err
}

func (r *ledgerRepository) WindowCount(ctx context.Context, action models.Action, currency string, subject SubjectFilter, since time.Time) (int64, error) {
	db := r.dbPool.DB(ctx, true).Scopes(scopes.TenancyPartition(ctx))
	var count int64
	err := db.Model(&models.LedgerEntry{}).
		Where("action = ? AND currency_code = ? AND subject_type = ? AND subject_id = ?",
			string(action), currency, string(subject.Type), subject.ID).
		Where("committed_at >= ? AND reversed_at IS NULL", since).
		Count(&count).Error
	return count, err
}

func (r *ledgerRepository) MarkReversed(ctx context.Context, reservationID string, at time.Time) error {
	db := r.dbPool.DB(ctx, false).Scopes(scopes.TenancyPartition(ctx))
	return db.Model(&models.LedgerEntry{}).
		Where("reservation_id = ? AND reversed_at IS NULL", reservationID).
		Update("reversed_at", at).Error
}

func (r *ledgerRepository) Search(ctx context.Context, f LedgerSearchFilter, limit int, cursor string) (*LedgerSearchResult, error) {
	if limit <= 0 {
		limit = 50
	}
	db := r.dbPool.DB(ctx, true).Scopes(scopes.TenancyPartition(ctx)).
		Model(&models.LedgerEntry{}).
		Where("deleted_at IS NULL")
	if f.Action != "" {
		db = db.Where("action = ?", string(f.Action))
	}
	if f.SubjectType != "" {
		db = db.Where("subject_type = ?", string(f.SubjectType))
	}
	if f.SubjectID != "" {
		db = db.Where("subject_id = ?", f.SubjectID)
	}
	if f.CurrencyCode != "" {
		db = db.Where("currency_code = ?", f.CurrencyCode)
	}
	if !f.From.IsZero() {
		db = db.Where("committed_at >= ?", f.From)
	}
	if !f.To.IsZero() {
		db = db.Where("committed_at < ?", f.To)
	}
	if cursor != "" {
		db = db.Where("id > ?", cursor)
	}
	var rows []*models.LedgerEntry
	if err := db.Order("id ASC").Limit(limit + 1).Find(&rows).Error; err != nil {
		return nil, err
	}
	out := &LedgerSearchResult{}
	if len(rows) > limit {
		out.NextCursor = rows[limit-1].ID
		rows = rows[:limit]
	}
	out.Items = rows
	return out, nil
}
```

- [ ] **Step 6.4: Run tests**

`go test -race -timeout=120s ./apps/limits/service/repository/...`
Expected: PASS.

- [ ] **Step 6.5: Commit**

```bash
git add apps/limits/service/repository/ledger_repo.go apps/limits/service/repository/ledger_repo_test.go
git commit -m "feat(limits): add LedgerRepository with rolling-window aggregates and search"
```

---

## Task 7: `ApprovalRequestRepository` + `ApprovalDecisionRepository`

**Files:**
- Create: `apps/limits/service/repository/approval_repo.go`
- Create: `apps/limits/service/repository/approval_repo_test.go`

Methods needed by approval business:
- `Create(ctx, request)` — append (one per triggering policy).
- `GetByID(ctx, id)`.
- `ListByReservation(ctx, reservationID)` — all approval requests for a single reservation.
- `RecordDecision(ctx, decision)` — append; the unique-on-(approval_request_id, approver_id) constraint guards against double-vote.
- `ListDecisions(ctx, approvalRequestID)`.
- `SetStatus(ctx, id, status, decidedAt)` — terminal transitions.
- `ListExpired(ctx, before, limit)` — for the reaper.
- `Search(ctx, filter, limit, cursor)` — admin queue.

(Implementation mirrors `reservation_repo.go` pattern. Tests cover: append, get-by-id, list-by-reservation, double-vote uniqueness, status transitions, expired listing.)

- [ ] **Step 7.1: Write the failing test, including the unique-on-double-vote case.**

```go
// apps/limits/service/repository/approval_repo_test.go
// (Apache 2.0 header — same suite skeleton as reservation_repo_test.go)

func (s *ApprovalRepoSuite) TestDoubleVoteRejected() {
	ctx := s.ctxFor("t-1")
	req := sampleApproval()
	s.Require().NoError(s.reqRepo.Create(ctx, req))
	first := &models.ApprovalDecision{
		ApprovalRequestID: req.ID, ApproverID: "wf-2",
		Decision: "approve", DecidedAt: time.Now().UTC(),
	}
	s.Require().NoError(s.decRepo.RecordDecision(ctx, first))
	second := &models.ApprovalDecision{
		ApprovalRequestID: req.ID, ApproverID: "wf-2",
		Decision: "approve", DecidedAt: time.Now().UTC(),
	}
	err := s.decRepo.RecordDecision(ctx, second)
	s.Require().Error(err) // unique constraint violation
}
```

- [ ] **Step 7.2: Run test — expect FAIL**

- [ ] **Step 7.3: Implement `apps/limits/service/repository/approval_repo.go`**

(Mirrors `reservation_repo.go`. Two repository interfaces: `ApprovalRequestRepository` with create / get / list-by-reservation / set-status / list-expired / search; `ApprovalDecisionRepository` with record-decision / list-decisions. Both backed by `BaseRepository`. Search applies `scopes.TenancyPartition`.)

- [ ] **Step 7.4: Run tests — expect PASS**

- [ ] **Step 7.5: Commit**

```bash
git add apps/limits/service/repository/approval_repo.go apps/limits/service/repository/approval_repo_test.go
git commit -m "feat(limits): add ApprovalRequest + ApprovalDecision repositories

Decisions are append-only with a per-request-per-approver unique
constraint preventing double-voting."
```

---

## Task 8: `SubjectAttributeRepository` and the in-process cache

**Files:**
- Create: `apps/limits/service/repository/subject_attribute_repo.go`
- Create: `apps/limits/service/repository/subject_attribute_repo_test.go`

The `SubjectAttributeRepository` is the persisted snapshot. The cache layer (LRU + TTL) lives in `apps/limits/service/business/attribute_resolver.go` (Task 13). This task only does the persistence.

- [ ] **Step 8.1: Write the failing test**

Cases:
- `Upsert` — first save creates, second save updates `Attributes` and `FetchedAt`.
- `Get` returns the latest snapshot for `(subject_type, subject_id)`.
- Tenant isolation works.

- [ ] **Step 8.2: Implement**

```go
// (Apache 2.0 header)
package repository

import (
	"context"
	"errors"
	"time"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/datastore/scopes"
	"github.com/pitabwire/frame/workerpool"
	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
)

type SubjectAttributeRepository interface {
	Get(ctx context.Context, subjectType models.Subject, subjectID string) (*models.SubjectAttributeSnapshot, error)
	Upsert(ctx context.Context, snap *models.SubjectAttributeSnapshot) error
}

type subjectAttributeRepository struct {
	datastore.BaseRepository[*models.SubjectAttributeSnapshot]
	dbPool pool.Pool
}

func NewSubjectAttributeRepository(ctx context.Context, p pool.Pool, workMan workerpool.Manager) SubjectAttributeRepository {
	r := &subjectAttributeRepository{dbPool: p}
	r.BaseRepository = datastore.NewBaseRepository[*models.SubjectAttributeSnapshot](
		ctx, p, workMan,
		func() *models.SubjectAttributeSnapshot { return &models.SubjectAttributeSnapshot{} },
	)
	return r
}

func (r *subjectAttributeRepository) Get(ctx context.Context, subjectType models.Subject, subjectID string) (*models.SubjectAttributeSnapshot, error) {
	db := r.dbPool.DB(ctx, true).Scopes(scopes.TenancyPartition(ctx))
	var out models.SubjectAttributeSnapshot
	err := db.Where("subject_type = ? AND subject_id = ?", string(subjectType), subjectID).First(&out).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *subjectAttributeRepository) Upsert(ctx context.Context, snap *models.SubjectAttributeSnapshot) error {
	db := r.dbPool.DB(ctx, false).Scopes(scopes.TenancyPartition(ctx))
	existing, err := r.Get(ctx, snap.SubjectType, snap.SubjectID)
	if err != nil {
		return err
	}
	if existing == nil {
		if snap.ID == "" {
			snap.ID = util.IDString()
		}
		if snap.FetchedAt.IsZero() {
			snap.FetchedAt = time.Now().UTC()
		}
		return r.BaseRepository.Create(ctx, snap)
	}
	return db.Model(&models.SubjectAttributeSnapshot{}).
		Where("id = ?", existing.ID).
		Updates(map[string]any{
			"attributes":  snap.Attributes,
			"fetched_at":  time.Now().UTC(),
			"modified_at": time.Now().UTC(),
		}).Error
}
```

- [ ] **Step 8.3: Run tests, commit.**

```bash
git add apps/limits/service/repository/subject_attribute_repo.go apps/limits/service/repository/subject_attribute_repo_test.go
git commit -m "feat(limits): add SubjectAttributeRepository with upsert semantics"
```

---

## Task 9: Candidate-policy repository (raw pool, union platform + org + org_unit)

**Files:**
- Create: `apps/limits/service/repository/candidate_policy.go`
- Create: `apps/limits/service/repository/candidate_policy_test.go`

This is the single SQL query that gathers every applicable policy for a `(action, currency, tenant, org_unit)` tuple, unioning the three scopes. Per spec §7.4 it must use the raw pool because Frame's `TenancyPartition` scope cannot match both a tenant and the empty platform tenant in one query.

- [ ] **Step 9.1: Write the failing test**

Setup: insert one platform policy (`tenant_id = ''`), one org policy (`tenant_id = 'org-A'`), one org_unit policy (`tenant_id = 'org-A', org_unit_id = 'branch-x'`), one out-of-scope org policy (`tenant_id = 'org-B'`). Query for `(action, currency, 'org-A', 'branch-x')` → must return the first three but not the fourth.

- [ ] **Step 9.2: Implement**

```go
// (Apache 2.0 header)
package repository

import (
	"context"
	"time"

	"github.com/pitabwire/frame/datastore/pool"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
)

// CandidatePolicyRepository finds every policy applicable to a given intent.
// Bypasses the TenancyPartition scope deliberately to union platform-scoped
// policies (tenant_id = '') with the calling tenant's own policies.
type CandidatePolicyRepository interface {
	FindCandidates(ctx context.Context, q CandidateQuery) ([]*models.Policy, error)
}

type CandidateQuery struct {
	Action       models.Action
	CurrencyCode string
	TenantID     string
	OrgUnitID    string
}

type candidatePolicyRepository struct {
	dbPool pool.Pool
}

func NewCandidatePolicyRepository(p pool.Pool) CandidatePolicyRepository {
	return &candidatePolicyRepository{dbPool: p}
}

func (r *candidatePolicyRepository) FindCandidates(ctx context.Context, q CandidateQuery) ([]*models.Policy, error) {
	db := r.dbPool.DB(ctx, true)
	var rows []*models.Policy
	now := time.Now().UTC()
	err := db.Model(&models.Policy{}).
		Where("deleted_at IS NULL AND mode != ?", string(models.ModeOff)).
		Where("effective_from <= ? AND (effective_to IS NULL OR effective_to > ?)", now, now).
		Where("action = ?", string(q.Action)).
		Where("(currency_code = ? OR currency_code = '')", q.CurrencyCode).
		Where(
			"(scope = ? AND tenant_id = '') OR "+
				"(scope = ? AND tenant_id = ?) OR "+
				"(scope = ? AND tenant_id = ? AND org_unit_id = ?)",
			string(models.ScopePlatform),
			string(models.ScopeOrg), q.TenantID,
			string(models.ScopeOrgUnit), q.TenantID, q.OrgUnitID,
		).
		Find(&rows).Error
	return rows, err
}
```

- [ ] **Step 9.3: Run tests — expect PASS**

- [ ] **Step 9.4: Commit**

```bash
git add apps/limits/service/repository/candidate_policy.go apps/limits/service/repository/candidate_policy_test.go
git commit -m "feat(limits): add CandidatePolicyRepository unioning platform + org + org_unit scopes"
```

---

## Task 10: Audit verb constants and `auditing.go` helpers

**Files:**
- Create: `apps/limits/service/business/auditing.go`
- Create: `apps/limits/service/business/auditing_test.go`

Per spec §6A, every gating event flows through `audit.Writer.Record` with namespaced action verbs and a structured `Metadata` bag. This task centralises those calls so each business path stays terse.

- [ ] **Step 10.1: Write `auditing.go`**

```go
// (Apache 2.0 header)
package business

import (
	"context"
	"strconv"
	"time"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/pkg/audit"
)

// Audit verbs for the limits gate. Stable strings; never renamed.
const (
	VerbBreachHard            = "limits.breach.hard"
	VerbBreachShadow          = "limits.breach.shadow"
	VerbApprovalRequired      = "limits.approval.required"
	VerbApprovalApproved      = "limits.approval.approved"
	VerbApprovalRejected      = "limits.approval.rejected"
	VerbApprovalAutoRejected  = "limits.approval.auto_rejected"
	VerbApprovalExpired       = "limits.approval.expired"
	VerbReservationCommitted  = "limits.reservation.committed"
	VerbReservationReleased   = "limits.reservation.released"
	VerbReservationReversed   = "limits.reservation.reversed"
	VerbReservationExpiredTTL = "limits.reservation.expired_ttl"
)

// Auditing wraps audit.Writer with the limits-specific verbs and metadata
// shape. Injected into business methods that emit gating events.
type Auditing struct {
	writer *audit.Writer
}

// NewAuditing constructs an Auditing wrapper.
func NewAuditing(w *audit.Writer) *Auditing { return &Auditing{writer: w} }

// RecordBreachHard records that a Reserve was denied.
func (a *Auditing) RecordBreachHard(ctx context.Context, intent *limitsv1.LimitIntent, verdicts []*limitsv1.PolicyVerdict, reason string) {
	if a == nil || a.writer == nil {
		return
	}
	primaryPolicyID := ""
	if len(verdicts) > 0 {
		primaryPolicyID = verdicts[0].GetPolicyId()
	}
	a.writer.RecordOrLog(ctx, audit.Record{
		EntityType: "policy",
		EntityID:   primaryPolicyID,
		Action:     VerbBreachHard,
		ActorID:    intent.GetMakerId(),
		ActorType:  "user",
		Reason:     reason,
		Metadata:   intentMetadata(intent, verdicts),
	}, logFailure(ctx))
}

// RecordBreachShadow records a shadow-mode would-have-blocked verdict.
func (a *Auditing) RecordBreachShadow(ctx context.Context, intent *limitsv1.LimitIntent, v *limitsv1.PolicyVerdict) {
	if a == nil || a.writer == nil {
		return
	}
	a.writer.RecordOrLog(ctx, audit.Record{
		EntityType: "policy",
		EntityID:   v.GetPolicyId(),
		Action:     VerbBreachShadow,
		ActorID:    intent.GetMakerId(),
		ActorType:  "user",
		Reason:     v.GetReason(),
		Metadata:   intentMetadata(intent, []*limitsv1.PolicyVerdict{v}),
	}, logFailure(ctx))
}

// RecordReservationCommitted, RecordReservationReleased, RecordReservationReversed,
// RecordReservationExpiredTTL — same shape, different verbs.
func (a *Auditing) RecordReservationCommitted(ctx context.Context, r *models.Reservation) {
	a.recordReservation(ctx, r, VerbReservationCommitted, "committed", "")
}
func (a *Auditing) RecordReservationReleased(ctx context.Context, r *models.Reservation, reason string) {
	a.recordReservation(ctx, r, VerbReservationReleased, "released", reason)
}
func (a *Auditing) RecordReservationReversed(ctx context.Context, r *models.Reservation, reason string) {
	a.recordReservation(ctx, r, VerbReservationReversed, "reversed", reason)
}
func (a *Auditing) RecordReservationExpiredTTL(ctx context.Context, r *models.Reservation) {
	a.recordReservation(ctx, r, VerbReservationExpiredTTL, "expired by TTL reaper", "")
}

func (a *Auditing) recordReservation(ctx context.Context, r *models.Reservation, verb, defaultReason, callerReason string) {
	if a == nil || a.writer == nil {
		return
	}
	reason := callerReason
	if reason == "" {
		reason = defaultReason
	}
	a.writer.RecordOrLog(ctx, audit.Record{
		EntityType: "reservation",
		EntityID:   r.ID,
		Action:     verb,
		ActorID:    r.MakerID,
		ActorType:  "user",
		Reason:     reason,
		Metadata:   reservationMetadata(r),
	}, logFailure(ctx))
}

// RecordApprovalRequired, RecordApprovalApproved, RecordApprovalRejected,
// RecordApprovalAutoRejected, RecordApprovalExpired — one per state transition.
func (a *Auditing) RecordApprovalRequired(ctx context.Context, ar *models.ApprovalRequest) {
	a.recordApproval(ctx, ar, VerbApprovalRequired, "approval required", "")
}
func (a *Auditing) RecordApprovalApproved(ctx context.Context, ar *models.ApprovalRequest, approverID string) {
	a.recordApproval(ctx, ar, VerbApprovalApproved, "approved", approverID)
}
func (a *Auditing) RecordApprovalRejected(ctx context.Context, ar *models.ApprovalRequest, approverID, note string) {
	a.recordApproval(ctx, ar, VerbApprovalRejected, "rejected: "+note, approverID)
}
func (a *Auditing) RecordApprovalAutoRejected(ctx context.Context, ar *models.ApprovalRequest, reason string) {
	a.recordApproval(ctx, ar, VerbApprovalAutoRejected, "auto-rejected on recheck: "+reason, "")
}
func (a *Auditing) RecordApprovalExpired(ctx context.Context, ar *models.ApprovalRequest) {
	a.recordApproval(ctx, ar, VerbApprovalExpired, "expired pending decision", "")
}

func (a *Auditing) recordApproval(ctx context.Context, ar *models.ApprovalRequest, verb, reason, approverID string) {
	if a == nil || a.writer == nil {
		return
	}
	md := approvalMetadata(ar)
	if approverID != "" {
		md["approver_id"] = approverID
	}
	a.writer.RecordOrLog(ctx, audit.Record{
		EntityType: "approval_request",
		EntityID:   ar.ID,
		Action:     verb,
		ActorID:    approverID,
		ActorType:  "user",
		Reason:     reason,
		Metadata:   md,
	}, logFailure(ctx))
}

// ─── Metadata builders ──────────────────────────────────────────────

func intentMetadata(intent *limitsv1.LimitIntent, verdicts []*limitsv1.PolicyVerdict) data.JSONMap {
	md := data.JSONMap{
		"action_kind":   intent.GetAction().String(),
		"amount_minor":  intent.GetAmount().GetUnits()*100 + int64(intent.GetAmount().GetNanos())/10_000_000,
		"currency":      intent.GetAmount().GetCurrencyCode(),
		"subjects":      subjectsAsMaps(intent.GetSubjects()),
		"org_unit_id":   intent.GetOrgUnitId(),
	}
	if len(verdicts) > 0 {
		md["verdicts"] = verdictsAsMaps(verdicts)
	}
	return md
}

func reservationMetadata(r *models.Reservation) data.JSONMap {
	return data.JSONMap{
		"action_kind":  string(r.Action),
		"amount_minor": r.Amount,
		"currency":     r.CurrencyCode,
		"org_unit_id":  r.OrgUnitID,
		"reservation_status": string(r.Status),
	}
}

func approvalMetadata(ar *models.ApprovalRequest) data.JSONMap {
	return data.JSONMap{
		"reservation_id":      ar.ReservationID,
		"action_kind":         string(ar.Action),
		"amount_minor":        ar.Amount,
		"currency":            ar.CurrencyCode,
		"triggering_policy_id": ar.TriggeringPolicyID,
		"policy_version":      ar.PolicyVersion,
		"required_role":       ar.RequiredRole,
		"required_count":      ar.RequiredCount,
	}
}

func subjectsAsMaps(refs []*limitsv1.SubjectRef) []map[string]string {
	out := make([]map[string]string, len(refs))
	for i, r := range refs {
		out[i] = map[string]string{"type": subjectTypeJSON(r.GetType()), "id": r.GetId()}
	}
	return out
}

func subjectTypeJSON(t limitsv1.SubjectType) string {
	// Local mirror of models.subjectTypeJSON; kept here to avoid cross-package import cycles.
	switch t {
	case limitsv1.SubjectType_SUBJECT_TYPE_CLIENT:
		return "client"
	case limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT:
		return "account"
	case limitsv1.SubjectType_SUBJECT_TYPE_PRODUCT:
		return "product"
	case limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION:
		return "organization"
	case limitsv1.SubjectType_SUBJECT_TYPE_ORG_UNIT:
		return "org_unit"
	case limitsv1.SubjectType_SUBJECT_TYPE_WORKFORCE_MEMBER:
		return "workforce_member"
	default:
		return ""
	}
}

func verdictsAsMaps(vs []*limitsv1.PolicyVerdict) []map[string]any {
	out := make([]map[string]any, len(vs))
	for i, v := range vs {
		m := map[string]any{
			"policy_id":      v.GetPolicyId(),
			"policy_version": v.GetPolicyVersion(),
			"matched":        v.GetMatched(),
			"breached":       v.GetBreached(),
			"would_require_approval": v.GetWouldRequireApproval(),
			"mode":           v.GetMode().String(),
			"reason":         v.GetReason(),
		}
		if v.GetCurrentUsage() != nil {
			m["current_usage_minor"] = strconv.FormatInt(v.GetCurrentUsage().GetUnits()*100+int64(v.GetCurrentUsage().GetNanos())/10_000_000, 10)
		}
		if v.GetCapAmount() != nil {
			m["cap_minor"] = strconv.FormatInt(v.GetCapAmount().GetUnits()*100+int64(v.GetCapAmount().GetNanos())/10_000_000, 10)
		}
		if v.GetCapCount() > 0 {
			m["cap_count"] = v.GetCapCount()
			m["current_count"] = v.GetCurrentCount()
		}
		out[i] = m
	}
	return out
}

func logFailure(ctx context.Context) func(error) {
	return func(err error) {
		util.Log(ctx).WithError(err).Error("audit emit failed (limits gate)")
	}
}

// FormatBreachReason builds a one-line reason string for a hard breach.
func FormatBreachReason(v *limitsv1.PolicyVerdict, intentMinor int64) string {
	if v.GetCapCount() > 0 {
		return "policy=" + v.GetPolicyId() + " count=" + strconv.FormatInt(v.GetCurrentCount()+1, 10) + ">cap=" + strconv.FormatInt(v.GetCapCount(), 10)
	}
	cap := int64(0)
	if c := v.GetCapAmount(); c != nil {
		cap = c.GetUnits()*100 + int64(c.GetNanos())/10_000_000
	}
	curr := int64(0)
	if u := v.GetCurrentUsage(); u != nil {
		curr = u.GetUnits()*100 + int64(u.GetNanos())/10_000_000
	}
	return "policy=" + v.GetPolicyId() + " usage+amount=" +
		strconv.FormatInt(curr+intentMinor, 10) + ">cap=" + strconv.FormatInt(cap, 10)
}

// silence-of-time-pkg-import for go vet
var _ = time.Now
```

- [ ] **Step 10.2: Test the helpers via a small unit test.**

```go
// apps/limits/service/business/auditing_test.go
package business

import (
	"testing"
	"github.com/stretchr/testify/assert"
)

func TestAuditingNilSafe(t *testing.T) {
	var a *Auditing
	a.RecordBreachHard(nil, nil, nil, "")            // must not panic on nil
	a.RecordReservationCommitted(nil, nil)            // same
	a.RecordApprovalRequired(nil, nil)                // same
	assert.True(t, true)
}
```

- [ ] **Step 10.3: Run tests, commit.**

```bash
git add apps/limits/service/business/auditing.go apps/limits/service/business/auditing_test.go
git commit -m "feat(limits): add Auditing wrapper with limits.* verbs and metadata builders

Centralises every gating-event audit emission so each business path
stays terse. Built on top of pkg/audit's existing Writer/RecordOrLog
infrastructure — no new tables."
```

---

## Task 11: Advisory-lock helper

**Files:**
- Create: `apps/limits/service/business/advisory_lock.go`

Per spec §4.3, Reserve serialises per-`(subject_type, subject_id, action, currency)` via `pg_advisory_xact_lock` to prevent the read-modify-write race on the rolling-window sum.

- [ ] **Step 11.1: Implement**

```go
// (Apache 2.0 header)
package business

import (
	"context"
	"hash/fnv"
	"sort"
	"strings"

	"github.com/pitabwire/frame/datastore/pool"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

// LockKeys derives stable int64 advisory-lock keys from a set of subject
// filters. Keys are sorted to enforce a deterministic acquisition order
// across concurrent transactions, eliminating the deadlock potential.
func LockKeys(action models.Action, currency string, subjects []repository.SubjectFilter) []int64 {
	keys := make([]int64, 0, len(subjects))
	for _, s := range subjects {
		h := fnv.New64a()
		_, _ = h.Write([]byte(strings.Join([]string{string(s.Type), s.ID, string(action), currency}, "|")))
		keys = append(keys, int64(h.Sum64()))
	}
	sort.Slice(keys, func(i, j int) bool { return keys[i] < keys[j] })
	return keys
}

// AcquireAdvisoryLocks calls pg_advisory_xact_lock for each key in order.
// Must be called inside a transaction; locks release at COMMIT/ROLLBACK.
func AcquireAdvisoryLocks(ctx context.Context, p pool.Pool, keys []int64) error {
	db := p.DB(ctx, false)
	for _, k := range keys {
		if err := db.Exec("SELECT pg_advisory_xact_lock(?)", k).Error; err != nil {
			return err
		}
	}
	return nil
}
```

- [ ] **Step 11.2: Build, commit.**

```bash
git add apps/limits/service/business/advisory_lock.go
git commit -m "feat(limits): add per-subject advisory-lock helpers"
```

---

## Task 12: Per-policy evaluator

**Files:**
- Create: `apps/limits/service/business/evaluator.go`
- Create: `apps/limits/service/business/evaluator_test.go`

Implements the per-policy verdict computation from spec §7.2. Pure function modulo repository reads (PendingSum/WindowSum/WindowCount).

- [ ] **Step 12.1: Write the failing test**

Cases:
- `PerTxnMin` — amount below value → breach.
- `PerTxnMax` — amount above value, no approver tiers → breach.
- `PerTxnMax` with approver tiers covering amount → `wouldRequireApproval=true`, breach=false.
- `RollingWindowAmount` — committed sum + pending + amount > cap → breach. With approver tiers covering, becomes wouldRequireApproval.
- `RollingWindowCount` — count + 1 > cap → breach.
- `Shadow` mode — same logic but verdict.mode == SHADOW (the aggregator uses this to decide block vs no-block).

```go
// apps/limits/service/business/evaluator_test.go
// Use a stub LedgerRepository / ReservationRepository implementing only the
// methods the evaluator calls; assert verdict fields exactly.
```

- [ ] **Step 12.2: Implement**

```go
// (Apache 2.0 header)
package business

import (
	"context"
	"time"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	moneyx "github.com/pitabwire/util/money"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

// Evaluator computes per-policy verdicts. Pure logic on top of repo reads.
type Evaluator struct {
	resvRepo   repository.ReservationRepository
	ledgerRepo repository.LedgerRepository
}

func NewEvaluator(resvRepo repository.ReservationRepository, ledgerRepo repository.LedgerRepository) *Evaluator {
	return &Evaluator{resvRepo: resvRepo, ledgerRepo: ledgerRepo}
}

// Evaluate returns the verdict for the given policy applied to the intent.
func (e *Evaluator) Evaluate(ctx context.Context, p *models.Policy, subject repository.SubjectFilter, intent *limitsv1.LimitIntent, intentMinor int64) (*limitsv1.PolicyVerdict, error) {
	v := &limitsv1.PolicyVerdict{
		PolicyId:      p.ID,
		PolicyVersion: int32(p.Version),
		Matched:       true,
		Mode:          policyModeToAPI(p.Mode),
	}

	switch p.LimitKind {
	case models.KindPerTxnMin:
		if intentMinor < p.Value {
			v.Breached = true
			v.Reason = "amount below per_txn_min"
		}
	case models.KindPerTxnMax:
		if intentMinor > p.Value {
			if approverTiersCover(p, intentMinor) {
				v.WouldRequireApproval = true
			} else {
				v.Breached = true
			}
			v.Reason = "amount above per_txn_max"
		}
	case models.KindRollingWindowAmount:
		since := time.Now().Add(-time.Duration(p.WindowSeconds) * time.Second)
		committed, err := e.ledgerRepo.WindowSum(ctx, p.Action, p.CurrencyCode, subject, since)
		if err != nil {
			return nil, err
		}
		pending, err := e.resvRepo.PendingSum(ctx, p.Action, p.CurrencyCode, subject)
		if err != nil {
			return nil, err
		}
		usage := committed + pending
		v.CurrentUsage = moneyx.FromMinorUnitsByCurrency(p.CurrencyCode, usage)
		v.CapAmount = moneyx.FromMinorUnitsByCurrency(p.CurrencyCode, p.Value)
		if usage+intentMinor > p.Value {
			if approverTiersCover(p, intentMinor) {
				v.WouldRequireApproval = true
			} else {
				v.Breached = true
			}
			v.Reason = "rolling window amount exceeded"
		}
	case models.KindRollingWindowCount:
		since := time.Now().Add(-time.Duration(p.WindowSeconds) * time.Second)
		committed, err := e.ledgerRepo.WindowCount(ctx, p.Action, p.CurrencyCode, subject, since)
		if err != nil {
			return nil, err
		}
		pending, err := e.resvRepo.PendingCount(ctx, p.Action, p.CurrencyCode, subject, since)
		if err != nil {
			return nil, err
		}
		count := committed + pending
		v.CurrentCount = count
		v.CapCount = p.Value
		if count+1 > p.Value {
			if approverTiersCover(p, intentMinor) {
				v.WouldRequireApproval = true
			} else {
				v.Breached = true
			}
			v.Reason = "rolling window count exceeded"
		}
	}

	return v, nil
}

func approverTiersCover(p *models.Policy, intentMinor int64) bool {
	tiers, err := unmarshalPolicyApproverTiers(p)
	if err != nil || len(tiers) == 0 {
		return false
	}
	for _, t := range tiers {
		if t.UpTo == 0 || intentMinor <= t.UpTo {
			return true
		}
	}
	return false
}

type approverTier struct {
	UpTo      int64
	Role      string
	Approvers int32
}

func unmarshalPolicyApproverTiers(p *models.Policy) ([]approverTier, error) {
	if len(p.ApproverTiers) == 0 {
		return nil, nil
	}
	type raw struct {
		UpTo      int64  `json:"up_to"`
		Role      string `json:"role"`
		Approvers int32  `json:"approvers"`
	}
	var rs []raw
	if err := jsonUnmarshal(p.ApproverTiers, &rs); err != nil {
		return nil, err
	}
	out := make([]approverTier, len(rs))
	for i, r := range rs {
		out[i] = approverTier{UpTo: r.UpTo, Role: r.Role, Approvers: r.Approvers}
	}
	return out, nil
}

// PickTier finds the first approver tier whose up_to covers intentMinor.
func PickTier(p *models.Policy, intentMinor int64) (approverTier, bool) {
	tiers, _ := unmarshalPolicyApproverTiers(p)
	for _, t := range tiers {
		if t.UpTo == 0 || intentMinor <= t.UpTo {
			return t, true
		}
	}
	return approverTier{}, false
}

func policyModeToAPI(m models.Mode) limitsv1.PolicyMode {
	switch m {
	case models.ModeOff:
		return limitsv1.PolicyMode_POLICY_MODE_OFF
	case models.ModeShadow:
		return limitsv1.PolicyMode_POLICY_MODE_SHADOW
	case models.ModeEnforce:
		return limitsv1.PolicyMode_POLICY_MODE_ENFORCE
	default:
		return limitsv1.PolicyMode_POLICY_MODE_UNSPECIFIED
	}
}
```

(`jsonUnmarshal` is a small wrapper around `encoding/json.Unmarshal` to keep imports tidy — declare in the same file or in a utility location.)

- [ ] **Step 12.3: Run tests — expect PASS**

- [ ] **Step 12.4: Commit**

```bash
git add apps/limits/service/business/evaluator.go apps/limits/service/business/evaluator_test.go
git commit -m "feat(limits): implement per-policy verdict evaluator

Pure logic over repo reads. Handles per_txn_min/max + rolling-window-amount
+ rolling-window-count. Approver-tier coverage downgrades a breach to a
'would require approval' verdict per spec §7.2."
```

---

## Task 13: Subject attribute resolver (read-through cache + identity client)

**Files:**
- Create: `apps/limits/service/business/attribute_resolver.go`
- Create: `apps/limits/service/business/attribute_resolver_test.go`

Wraps the `SubjectAttributeRepository` with an in-process LRU cache (60s TTL by default, configurable). On cache miss, calls the identity service via Connect to fetch the subject's attributes, persists the snapshot, returns. The resolver is the only thing that knows about identity client; the evaluator calls into it.

- [ ] **Step 13.1: Define the interface**

```go
// AttributeResolver fetches a subject's attributes (KYC tier, region, etc.)
// for predicate evaluation. Read-through cache backed by repository + identity.
type AttributeResolver interface {
	Get(ctx context.Context, subjectType models.Subject, subjectID string) (map[string]any, error)
	Invalidate(subjectType models.Subject, subjectID string)
}
```

- [ ] **Step 13.2: Implement using `lru.Cache` from `github.com/hashicorp/golang-lru/v2`** (already in go.sum from other services) plus an injected identity client. For client subjects, call `identityv1connect.IdentityServiceClient.GetClient` and project the relevant fields (`kyc_tier`, `country_code`, `risk_score`) into the attribute map. For non-client subjects (organization, account, etc.), the resolver returns an empty map for now — future iterations can extend.

- [ ] **Step 13.3: Test via a stub identity client**

```go
// Stub returns a deterministic kyc_tier per client_id; resolver caches.
// Test that two consecutive Get calls produce one identity call (cache hit).
// Test invalidation drops the cache entry.
```

- [ ] **Step 13.4: Commit**

```bash
git add apps/limits/service/business/attribute_resolver.go apps/limits/service/business/attribute_resolver_test.go
git commit -m "feat(limits): add subject attribute resolver with read-through cache"
```

---

## Task 14: Reserve handler

**Files:**
- Create: `apps/limits/service/business/reservation.go`
- Create: `apps/limits/service/business/reservation_test.go`

This is the algorithm core. It composes the candidate-policy lookup, advisory locks, the evaluator, and audit emission into a single `Reserve(ctx, intent, idempotencyKey, ttl)` method.

- [ ] **Step 14.1: Define the `ReservationBusiness` interface**

```go
type ReservationBusiness interface {
	Check(ctx context.Context, intent *limitsv1.LimitIntent) (*limitsv1.CheckResponse, error)
	Reserve(ctx context.Context, intent *limitsv1.LimitIntent, idempotencyKey string, ttl time.Duration) (*limitsv1.ReserveResponse, error)
	Commit(ctx context.Context, reservationID string) (*limitsv1.CommitResponse, error)
	Release(ctx context.Context, reservationID, reason string) (*limitsv1.ReleaseResponse, error)
	Reverse(ctx context.Context, reservationID, idempotencyKey, reason string) (*limitsv1.ReverseResponse, error)
}
```

- [ ] **Step 14.2: Write the failing tests**

Cases (each as a separate test function):
- **Reserve happy path** — single per_txn_max policy under cap → status ACTIVE, audit row absent (no breach).
- **Reserve per_txn_max breach (enforce)** — verdict denied, FailedPrecondition, no reservation row, audit row written with verb `limits.breach.hard`.
- **Reserve per_txn_max breach (shadow)** — verdict allowed but is_shadow=true, audit row written with `limits.breach.shadow`.
- **Reserve rolling-window amount under cap** — committed=200 + pending=300 + intent=400 ≤ cap=1000 → ACTIVE.
- **Reserve rolling-window amount over cap** — same setup but intent=600 → breach, FailedPrecondition.
- **Reserve idempotency replay** — second Reserve with same idempotency_key returns the same reservation ID (and the same status).
- **Reserve idempotency conflict different intent** — second Reserve with same key but different action → AlreadyExists.
- **Reserve approval required (per_txn_max with tiers)** — single policy that should trigger approval → status PENDING_APPROVAL, ApprovalRequest row, audit `limits.approval.required`.

(Each test uses an in-memory pool via `WithDatastoreConnection` to a testcontainer, runs `Migrate`, seeds policies, then exercises the business method directly.)

- [ ] **Step 14.3: Implement Reserve**

The full implementation lives in `reservation.go`. Skeleton:

```go
type reservationBusiness struct {
	resvRepo      repository.ReservationRepository
	ledgerRepo    repository.LedgerRepository
	candidateRepo repository.CandidatePolicyRepository
	approvalRepo  repository.ApprovalRequestRepository
	subjAttrRepo  repository.SubjectAttributeRepository
	policyRepo    repository.PolicyRepository
	evaluator     *Evaluator
	resolver      AttributeResolver
	auditing      *Auditing
	dbPool        pool.Pool
}

func (b *reservationBusiness) Reserve(ctx context.Context, intent *limitsv1.LimitIntent, idempotencyKey string, ttl time.Duration) (*limitsv1.ReserveResponse, error) {
	// 0. validate intent (action enum, subjects, currency on Money matches Money currency)
	if err := validateIntent(intent); err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	// 1. Idempotency short-circuit.
	if existing, err := b.resvRepo.GetByIdempotencyKey(ctx, idempotencyKey); err == nil && existing != nil {
		if !sameIntent(existing, intent, idempotencyKey) {
			return nil, connect.NewError(connect.CodeAlreadyExists, fmt.Errorf("idempotency-key collision with different intent: %s", existing.ID))
		}
		return reserveResponseFromRow(existing, nil), nil
	}
	// 2. Subject schema validation.
	if err := validateRequiredSubjects(intent); err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	// 3. Candidate policies.
	intentMinor, _ := moneyx.ToMinorUnitsByCurrency(intent.GetAmount(), intent.GetAmount().GetCurrencyCode())
	cands, err := b.candidateRepo.FindCandidates(ctx, repository.CandidateQuery{
		Action: models.ActionFromAPI_unsafe(intent.GetAction()), CurrencyCode: intent.GetAmount().GetCurrencyCode(),
		TenantID: intent.GetTenantId(), OrgUnitID: intent.GetOrgUnitId(),
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	// 4. Filter by subject_type and attribute predicate.
	type pair struct { policy *models.Policy; subject repository.SubjectFilter }
	var applicable []pair
	for _, p := range cands {
		s, ok := findSubject(intent.GetSubjects(), p.SubjectType)
		if !ok { continue }
		if len(p.AttributeFilter) > 0 {
			attrs, err := b.resolver.Get(ctx, p.SubjectType, s.GetId())
			if err != nil { return nil, connect.NewError(connect.CodeInternal, err) }
			if !evaluatePredicate(p.AttributeFilter, attrs) { continue }
		}
		applicable = append(applicable, pair{policy: p, subject: repository.SubjectFilter{Type: p.SubjectType, ID: s.GetId()}})
	}
	// 5. Open transaction; acquire advisory locks for rolling-window subjects.
	db := b.dbPool.DB(ctx, false)
	tx := db.Begin()
	defer tx.Rollback()
	rollingSubjects := []repository.SubjectFilter{}
	for _, ap := range applicable {
		if ap.policy.LimitKind == models.KindRollingWindowAmount || ap.policy.LimitKind == models.KindRollingWindowCount {
			rollingSubjects = append(rollingSubjects, ap.subject)
		}
	}
	keys := LockKeys(models.ActionFromAPI_unsafe(intent.GetAction()), intent.GetAmount().GetCurrencyCode(), rollingSubjects)
	for _, k := range keys {
		if err := tx.Exec("SELECT pg_advisory_xact_lock(?)", k).Error; err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
	}
	// 6. Per-policy evaluation.
	var verdicts []*limitsv1.PolicyVerdict
	var hardBreaches, shadowBreaches, approvalNeeded []*limitsv1.PolicyVerdict
	var approvalPolicies []*models.Policy
	for _, ap := range applicable {
		v, err := b.evaluator.Evaluate(ctx, ap.policy, ap.subject, intent, intentMinor)
		if err != nil { return nil, connect.NewError(connect.CodeInternal, err) }
		verdicts = append(verdicts, v)
		switch ap.policy.Mode {
		case models.ModeEnforce:
			if v.GetBreached() { hardBreaches = append(hardBreaches, v) }
			if v.GetWouldRequireApproval() {
				approvalNeeded = append(approvalNeeded, v)
				approvalPolicies = append(approvalPolicies, ap.policy)
			}
		case models.ModeShadow:
			if v.GetBreached() || v.GetWouldRequireApproval() { shadowBreaches = append(shadowBreaches, v) }
		}
	}
	// 7. Hard breaches → deny.
	if len(hardBreaches) > 0 {
		// Emit one audit row per breach.
		for _, v := range hardBreaches {
			b.auditing.RecordBreachHard(ctx, intent, []*limitsv1.PolicyVerdict{v}, FormatBreachReason(v, intentMinor))
		}
		// Shadow breaches still flagged for risk visibility.
		for _, v := range shadowBreaches {
			b.auditing.RecordBreachShadow(ctx, intent, v)
		}
		return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("limits cap breached"))
	}
	// 8. Persist reservation.
	resv, err := models.ReservationFromIntent(intent, idempotencyKey)
	if err != nil { return nil, connect.NewError(connect.CodeInvalidArgument, err) }
	if len(approvalNeeded) > 0 {
		resv.Status = models.ReservationStatusPendingApproval
		resv.TTLAt = time.Now().Add(approvalTTL(approvalPolicies)).UTC()
	} else {
		resv.TTLAt = time.Now().Add(ttl).UTC()
	}
	if len(shadowBreaches) > 0 && len(approvalNeeded) == 0 {
		resv.IsShadow = true
	}
	resv.PoliciesEvaluated = verdictsJSON(verdicts)
	resv.ID = util.IDString()
	if err := tx.Create(resv).Error; err != nil { return nil, connect.NewError(connect.CodeInternal, err) }
	// 9. Persist approval requests.
	for _, p := range approvalPolicies {
		tier, _ := PickTier(p, intentMinor)
		ar := &models.ApprovalRequest{
			ReservationID: resv.ID, OrgUnitID: resv.OrgUnitID,
			Action: resv.Action, CurrencyCode: resv.CurrencyCode, Amount: resv.Amount,
			TriggeringPolicyID: p.ID, PolicyVersion: int32(p.Version),
			RequiredRole: tier.Role, RequiredCount: tier.Approvers,
			MakerID: resv.MakerID, Status: models.ApprovalStatusPending,
			SubmittedAt: time.Now().UTC(),
			ExpiresAt:   time.Now().Add(time.Duration(p.ApprovalTTLSec) * time.Second).UTC(),
		}
		ar.ID = util.IDString()
		if err := tx.Create(ar).Error; err != nil { return nil, connect.NewError(connect.CodeInternal, err) }
		b.auditing.RecordApprovalRequired(ctx, ar)
	}
	// 10. Commit transaction.
	if err := tx.Commit().Error; err != nil { return nil, connect.NewError(connect.CodeInternal, err) }
	// 11. Shadow audit (post-commit, no rollback risk).
	for _, v := range shadowBreaches {
		b.auditing.RecordBreachShadow(ctx, intent, v)
	}
	return reserveResponseFromRow(resv, verdicts), nil
}
```

(Helpers `validateIntent`, `validateRequiredSubjects`, `findSubject`, `evaluatePredicate`, `sameIntent`, `verdictsJSON`, `approvalTTL`, `reserveResponseFromRow` live in `reservation.go` alongside `Reserve`.)

- [ ] **Step 14.4: Run tests**

`go test -race -timeout=240s ./apps/limits/service/business/...`
Expected: PASS. The reservation tests are the longest-running because they exercise advisory locks + transactions.

- [ ] **Step 14.5: Commit**

```bash
git add apps/limits/service/business/reservation.go apps/limits/service/business/reservation_test.go
git commit -m "feat(limits): implement Reserve with full evaluation algorithm

Per spec §7. Composes candidate lookup, advisory locks, per-policy
evaluation, hard-breach denial, approval-required spawning, shadow-
breach flagging, and audit emission into a single transactional call."
```

---

## Task 15: Commit / Release / Reverse / Check

**Files:**
- Modify: `apps/limits/service/business/reservation.go`
- Modify: `apps/limits/service/business/reservation_test.go`

These are smaller than Reserve.

- [ ] **Step 15.1: Add `Commit`**

```go
func (b *reservationBusiness) Commit(ctx context.Context, id string) (*limitsv1.CommitResponse, error) {
	r, err := b.resvRepo.GetByID(ctx, id)
	if err != nil { return nil, connect.NewError(connect.CodeNotFound, err) }
	if r.Status == models.ReservationStatusCommitted {
		return &limitsv1.CommitResponse{Reservation: r.ToAPI()}, nil // idempotent
	}
	if r.Status == models.ReservationStatusPendingApproval {
		return nil, connect.NewError(connect.CodeFailedPrecondition,
			fmt.Errorf("reservation %s pending approval", id))
	}
	if r.Status != models.ReservationStatusActive {
		return nil, connect.NewError(connect.CodeFailedPrecondition,
			fmt.Errorf("reservation %s not active (status=%s)", id, r.Status))
	}
	// Open tx: flip status + write per-subject ledger entries atomically.
	db := b.dbPool.DB(ctx, false)
	now := time.Now().UTC()
	tx := db.Begin()
	defer tx.Rollback()
	if err := tx.Model(&models.Reservation{}).Where("id = ?", id).
		Updates(map[string]any{"status": string(models.ReservationStatusCommitted),
			"committed_at": now, "modified_at": now}).Error; err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	subjects, _ := unmarshalSubjectRefs(r.SubjectRefs)
	entries := make([]*models.LedgerEntry, 0, len(subjects))
	for _, s := range subjects {
		entries = append(entries, &models.LedgerEntry{
			ReservationID: r.ID, OrgUnitID: r.OrgUnitID,
			Action: r.Action, SubjectType: subjectFromAPI_unsafe(s.GetType()),
			SubjectID: s.GetId(), CurrencyCode: r.CurrencyCode,
			Amount: r.Amount, CommittedAt: now,
		})
		entries[len(entries)-1].ID = util.IDString()
	}
	if r.IsShadow {
		// Shadow reservations don't materialise ledger entries: they record
		// what would have happened but never count toward future caps.
	} else {
		if err := tx.Create(&entries).Error; err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
	}
	if err := tx.Commit().Error; err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	r.Status = models.ReservationStatusCommitted
	r.CommittedAt = &now
	b.auditing.RecordReservationCommitted(ctx, r)
	return &limitsv1.CommitResponse{Reservation: r.ToAPI()}, nil
}
```

- [ ] **Step 15.2: Add `Release`**

Idempotent. `active | pending_approval` → `released`. Closes any open `ApprovalRequest` rows as `rejected` with reason `released_by_caller`. Emits `limits.reservation.released` audit. (Code structure mirrors Commit; uses `b.resvRepo.SetReleased` and `b.approvalRepo.SetStatus`.)

- [ ] **Step 15.3: Add `Reverse`**

Idempotent on its own `idempotencyKey`. Marks `LedgerEntry.reversed_at` for all rows of the original reservation; creates a traceability `Reservation` of `status=REVERSED` with `reverses_reservation_id = original.id`; emits `limits.reservation.reversed`.

- [ ] **Step 15.4: Add `Check`**

Pure read. Runs the same candidate-lookup + evaluation as Reserve but writes nothing. Returns `CheckResponse{ allowed, requires_approval, required_approvers, required_role, verdicts }`. Used by UI affordance ("would this go through?").

- [ ] **Step 15.5: Tests for each**

For `Commit`: reservation must be `active` first; ledger entries materialise; double-commit is idempotent; shadow reservations don't write ledger.

For `Release`: works on `active` and `pending_approval`; closes pending approvals; double-release is idempotent.

For `Reverse`: ledger rows excluded from subsequent `WindowSum`; double-reverse is idempotent on idempotency key.

For `Check`: produces verdicts without state change.

- [ ] **Step 15.6: Run, commit.**

```bash
git add apps/limits/service/business/reservation.go apps/limits/service/business/reservation_test.go
git commit -m "feat(limits): implement Commit / Release / Reverse / Check

Commit materialises per-subject ledger entries from a reserved row.
Release returns the budget. Reverse marks ledger entries reversed
without retroactively unblocking past breaches. Check is the read-
only verdict preview for UI."
```

---

## Task 16: Approval workflow business

**Files:**
- Create: `apps/limits/service/business/approval.go`
- Create: `apps/limits/service/business/approval_test.go`

Implements the admin-side approval flow: list, get, decide.

- [ ] **Step 16.1: Define `ApprovalBusiness` interface**

```go
type ApprovalBusiness interface {
	List(ctx context.Context, req *limitsv1.ApprovalRequestListRequest, batch func(ctx context.Context, items []*limitsv1.ApprovalRequestObject) error) error
	Get(ctx context.Context, id string) (*limitsv1.ApprovalRequestObject, error)
	Decide(ctx context.Context, req *limitsv1.ApprovalRequestDecideRequest) (*limitsv1.ApprovalRequestObject, error)
}
```

- [ ] **Step 16.2: Test cases**

- `List` filters by tenant + status + role; pagination works.
- `Get` returns the request with all decisions.
- `Decide` (approve, single-required) → `ApprovalStatus.APPROVED` + reservation transitions `PENDING_APPROVAL` → `ACTIVE`; audit `limits.approval.approved` written.
- `Decide` (approve, multi-required, partial) → status remains pending until last approver lands.
- `Decide` (reject) → request `rejected`, reservation `released`, audit `limits.approval.rejected` written.
- `Decide` (re-eval fails) — a previously-passing rolling-window policy now breaches because new committed entries landed → `auto_rejected_on_recheck`, audit verb `limits.approval.auto_rejected`.
- `Decide` (caller is the maker) → `PermissionDenied`.
- `Decide` (caller already voted) → `AlreadyExists`.
- `Decide` (request expired) → `FailedPrecondition`.

- [ ] **Step 16.3: Implement `Decide`**

```go
func (b *approvalBusiness) Decide(ctx context.Context, req *limitsv1.ApprovalRequestDecideRequest) (*limitsv1.ApprovalRequestObject, error) {
	ar, err := b.approvalRepo.GetByID(ctx, req.GetId())
	if err != nil { return nil, connect.NewError(connect.CodeNotFound, err) }
	caller := security.ClaimsFromContext(ctx).GetSubject()
	if caller == ar.MakerID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("maker cannot approve own request"))
	}
	if ar.Status != models.ApprovalStatusPending {
		return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("approval %s not pending", ar.ID))
	}
	if time.Now().UTC().After(ar.ExpiresAt) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("approval request expired"))
	}
	// Verify the caller has the required role for this org.
	if !hasRole(ctx, ar.RequiredRole, ar.TenantID) {
		return nil, connect.NewError(connect.CodePermissionDenied,
			fmt.Errorf("caller does not have role %s for tenant %s", ar.RequiredRole, ar.TenantID))
	}
	// Persist the decision (unique constraint blocks double-vote).
	d := &models.ApprovalDecision{
		ApprovalRequestID: ar.ID, ApproverID: caller,
		Decision: req.GetDecision(), Note: req.GetNote(),
		DecidedAt: time.Now().UTC(),
	}
	d.ID = util.IDString()
	if err := b.decisionRepo.RecordDecision(ctx, d); err != nil {
		return nil, connect.NewError(connect.CodeAlreadyExists, fmt.Errorf("approver %s already decided", caller))
	}
	// Reject path: mark approval rejected + reservation released.
	if req.GetDecision() == "reject" {
		now := time.Now().UTC()
		if err := b.approvalRepo.SetStatus(ctx, ar.ID, models.ApprovalStatusRejected, &now); err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		_ = b.resvRepo.SetReleased(ctx, ar.ReservationID, "approval rejected: "+req.GetNote(), now)
		ar.Status = models.ApprovalStatusRejected
		b.auditing.RecordApprovalRejected(ctx, ar, caller, req.GetNote())
		return ar.ToAPI([]*models.ApprovalDecision{d}), nil
	}
	// Approve path: count decisions; if last required, re-evaluate and transition.
	decisions, err := b.decisionRepo.ListDecisions(ctx, ar.ID)
	if err != nil { return nil, connect.NewError(connect.CodeInternal, err) }
	approveCount := int32(0)
	for _, dd := range decisions {
		if dd.Decision == "approve" { approveCount++ }
	}
	if approveCount < ar.RequiredCount {
		return ar.ToAPI(decisions), nil // still pending
	}
	// Last required approver landed: re-run the verdicts on the original intent.
	resv, err := b.resvRepo.GetByID(ctx, ar.ReservationID)
	if err != nil { return nil, connect.NewError(connect.CodeInternal, err) }
	intent, _ := intentFromReservation(resv) // helper that reconstructs LimitIntent
	// Re-run the evaluator over the triggering policy (and other approval-required peers for the same reservation).
	peers, err := b.approvalRepo.ListByReservation(ctx, ar.ReservationID)
	if err != nil { return nil, connect.NewError(connect.CodeInternal, err) }
	allClear := true
	for _, peer := range peers {
		policy, err := b.policyRepo.Get(ctx, peer.TriggeringPolicyID)
		if err != nil { allClear = false; break }
		s := repository.SubjectFilter{Type: peer.subjectFromIntent(intent), ID: peer.subjectIDFromIntent(intent)}
		v, err := b.evaluator.Evaluate(ctx, policy, s, intent, resv.Amount)
		if err != nil { allClear = false; break }
		if v.GetBreached() { allClear = false; break } // a previously-passing policy now breaches
	}
	if !allClear {
		now := time.Now().UTC()
		_ = b.approvalRepo.SetStatus(ctx, ar.ID, models.ApprovalStatusAutoRejectedRecheck, &now)
		_ = b.resvRepo.SetReleased(ctx, resv.ID, "auto-rejected: re-evaluation failed", now)
		ar.Status = models.ApprovalStatusAutoRejectedRecheck
		b.auditing.RecordApprovalAutoRejected(ctx, ar, "policy now breaches at decide time")
		return ar.ToAPI(decisions), nil
	}
	now := time.Now().UTC()
	_ = b.approvalRepo.SetStatus(ctx, ar.ID, models.ApprovalStatusApproved, &now)
	// If all peers are now approved, transition the reservation to ACTIVE.
	allApproved := true
	for _, peer := range peers {
		if peer.ID == ar.ID { continue }
		if peer.Status != models.ApprovalStatusApproved {
			allApproved = false
			break
		}
	}
	if allApproved {
		_ = b.resvRepo.SetActive(ctx, resv.ID)
	}
	ar.Status = models.ApprovalStatusApproved
	b.auditing.RecordApprovalApproved(ctx, ar, caller)
	return ar.ToAPI(decisions), nil
}
```

- [ ] **Step 16.4: Run tests, commit.**

```bash
git add apps/limits/service/business/approval.go apps/limits/service/business/approval_test.go
git commit -m "feat(limits): implement approval workflow with re-evaluation on decide

Decide enforces maker-cannot-approve, role check, double-vote
uniqueness, and re-runs the per-policy evaluator at the moment the
last required approver lands so previously-passing rolling-window
policies that have now tipped over auto-reject. Audit verb fanout
covers required / approved / rejected / auto_rejected paths."
```

---

## Task 17: Reapers (TTL + approval expiry)

**Files:**
- Create: `apps/limits/service/business/reaper_reservation.go`
- Create: `apps/limits/service/business/reaper_approval.go`
- Create: `apps/limits/service/business/reaper_reservation_test.go`
- Create: `apps/limits/service/business/reaper_approval_test.go`

- [ ] **Step 17.1: `ReservationReaper`**

```go
type ReservationReaper struct {
	repo     repository.ReservationRepository
	auditing *Auditing
	batchSize int
}

// Run scans for expired-active reservations and transitions them to expired.
// Called every 30s by a Frame Queue subscriber.
func (r *ReservationReaper) Run(ctx context.Context) error {
	now := time.Now().UTC()
	rows, err := r.repo.ListExpiredActive(ctx, now, r.batchSize)
	if err != nil { return err }
	for _, row := range rows {
		if err := r.repo.SetExpired(ctx, row.ID, now); err != nil {
			util.Log(ctx).WithError(err).Error("reservation reaper: failed to expire", "id", row.ID)
			continue
		}
		r.auditing.RecordReservationExpiredTTL(ctx, row)
	}
	return nil
}
```

- [ ] **Step 17.2: `ApprovalReaper`**

Mirrors ReservationReaper but on `approval_requests WHERE status = 'pending' AND expires_at < now()`. Transitions to `expired`, releases the underlying reservation, emits `limits.approval.expired` audit.

- [ ] **Step 17.3: Tests with manipulated `time.Now`**

Inject a time provider; assert that a row past TTL gets expired and no row before TTL gets touched.

- [ ] **Step 17.4: Commit.**

```bash
git add apps/limits/service/business/reaper_*.go
git commit -m "feat(limits): add reservation TTL and approval expiry reapers"
```

---

## Task 18: `LimitsService` Connect handler (runtime)

**Files:**
- Create: `apps/limits/service/handlers/runtime_service.go`
- Create: `apps/limits/service/handlers/runtime_service_test.go`

Wraps the `ReservationBusiness` in a Connect handler implementing `limitsv1connect.LimitsServiceHandler`.

- [ ] **Step 18.1: Implement**

```go
type RuntimeService struct {
	limitsv1connect.UnimplementedLimitsServiceHandler
	biz business.ReservationBusiness
}

func NewRuntimeService(biz business.ReservationBusiness) *RuntimeService {
	return &RuntimeService{biz: biz}
}

func (s *RuntimeService) Check(ctx context.Context, req *connect.Request[limitsv1.CheckRequest]) (*connect.Response[limitsv1.CheckResponse], error) {
	out, err := s.biz.Check(ctx, req.Msg.GetIntent())
	if err != nil { return nil, err }
	return connect.NewResponse(out), nil
}

func (s *RuntimeService) Reserve(ctx context.Context, req *connect.Request[limitsv1.ReserveRequest]) (*connect.Response[limitsv1.ReserveResponse], error) {
	ttl := req.Msg.GetTtl().AsDuration()
	if ttl == 0 { ttl = 5 * time.Minute }
	out, err := s.biz.Reserve(ctx, req.Msg.GetIntent(), req.Msg.GetIdempotencyKey(), ttl)
	if err != nil { return nil, err }
	return connect.NewResponse(out), nil
}

// Commit / Release / Reverse: similar one-line wrappers.
```

- [ ] **Step 18.2: Tests via in-process direct invocation**

Mirror `admin_service_test.go` from Plan 1 — direct handler call, no HTTP. The HTTP-layer test lives in the integration test file (Task 22).

- [ ] **Step 18.3: Commit.**

```bash
git add apps/limits/service/handlers/runtime_service.go apps/limits/service/handlers/runtime_service_test.go
git commit -m "feat(limits): wire LimitsService Connect handler"
```

---

## Task 19: Approval / Ledger / Audit admin handlers

**Files:**
- Create: `apps/limits/service/handlers/admin_service_runtime.go`
- Modify: `apps/limits/service/handlers/admin_service.go` (split or extend so all admin RPCs share the struct)
- Create: `apps/limits/service/handlers/admin_service_runtime_test.go`

Adds `ApprovalRequestList/Get/Decide`, `LedgerSearch`, `LimitsAuditSearch` to the existing `AdminService` struct.

- [ ] **Step 19.1: Extend `AdminService`** to take additional dependencies (`approvalBiz`, `ledgerSearchBiz`, `auditSearchBiz`) in the constructor. Each method delegates to the corresponding business interface.

- [ ] **Step 19.2: Implement `LedgerSearch`** as a streaming search wrapper around `LedgerRepository.Search`.

- [ ] **Step 19.3: Implement `LimitsAuditSearch`** as a streaming search over the `audit_events` table filtered to `action LIKE 'limits.%'` (or matching the request's specific verbs). Reads through a new business `AuditSearch` that wraps `audit.Repository`.

- [ ] **Step 19.4: Tests** — direct invocation per Plan 1's pattern.

- [ ] **Step 19.5: Commit.**

```bash
git add apps/limits/service/handlers/ apps/limits/service/business/ledger_search.go apps/limits/service/business/audit_search.go
git commit -m "feat(limits): wire approval, ledger search, and audit search admin handlers"
```

---

## Task 20: Wire main.go end-to-end

**Files:**
- Modify: `apps/limits/cmd/main.go`

- [ ] **Step 20.1: Construct all the new repositories, businesses, handlers, reapers, and the Auditing wrapper.** Mount the runtime + admin handlers on the HTTP mux. Register the `EventSave` handler for `audit_event.save`. Schedule the reapers via Frame Queue or `WorkerPool`.

- [ ] **Step 20.2: Build, manual-smoke against a Postgres testcontainer.**

- [ ] **Step 20.3: Commit.**

```bash
git add apps/limits/cmd/main.go
git commit -m "feat(limits): wire runtime + approval + audit-search handlers and reapers in main"
```

---

## Task 21: Frame events for approval lifecycle

**Files:**
- Create: `apps/limits/service/events/events.go`
- Create: `apps/limits/service/events/policy_invalidation_publisher.go`

Per spec §8.1, policy save/delete publishes `limits.policy.invalidate.v1` so all replicas drop their LRU cache entry. Approval transitions publish `limits.approval.{requested,approved,rejected,expired,auto_rejected}.v1` for downstream consumers (the per-service approval-resume subscribers in Plan 4).

- [ ] **Step 21.1: Define event names + payloads as Go types.**

- [ ] **Step 21.2: Wire the `policy.invalidate` event into `PolicyBusiness.Save/Delete`.**

- [ ] **Step 21.3: Wire the `approval.*` events into `approval.Decide`, `approvalReaper.Run`, and `reservation.Reserve` (for `approval.requested`).**

- [ ] **Step 21.4: Tests assert the event was emitted — use a stub events manager.**

- [ ] **Step 21.5: Commit.**

```bash
git add apps/limits/service/events/
git commit -m "feat(limits): emit Frame events for policy invalidation and approval lifecycle"
```

---

## Task 22: End-to-end integration suite

**Files:**
- Create: `apps/limits/tests/integration/runtime_test.go`
- Create: `apps/limits/tests/integration/approval_test.go`
- Create: `apps/limits/tests/integration/audit_test.go`
- Create: `apps/limits/tests/integration/reapers_test.go`
- Create: `apps/limits/tests/integration/ledger_search_test.go`

Real Postgres testcontainer + httptest.Server + the actual Connect handlers. Each file covers one slice end-to-end.

**Coverage matrix** (each row = one integration test):

`runtime_test.go`:
- Reserve (ACTIVE) → Commit → ledger row visible via WindowSum.
- Reserve (ACTIVE) → Release → no ledger.
- Reserve denied (hard breach) → no row, FailedPrecondition.
- Reserve idempotency (replay returns same id).
- Reserve in shadow mode (allowed but is_shadow=true, no ledger after Commit).
- Reverse → ledger marked reversed → next WindowSum excludes.

`approval_test.go`:
- Reserve triggers approval → admin lists pending → approver decides → reservation transitions ACTIVE → Commit succeeds.
- Approver rejects → reservation released.
- Maker tries to approve own → PermissionDenied.
- Approver double-votes → AlreadyExists.
- Re-evaluation fails at decide time → auto_rejected_on_recheck.

`audit_test.go`:
- Every gating verb produces exactly one audit row with correct action + entity_type + metadata fields populated.
- LimitsAuditSearch returns the rows; cursor pagination works.

`reapers_test.go`:
- Reservation past TTL → reaper expires it.
- Approval past expires_at → reaper marks expired and releases the reservation.

`ledger_search_test.go`:
- LedgerSearch streams entries filtered by action / subject / time range.

- [ ] **Step 22.1-22.5: Write each test file (TDD: write, run, see failures from missing wiring, fix wiring, see green).**

- [ ] **Step 22.6: Run the full suite**

```
go test -race -timeout=15m ./apps/limits/...
```
Expected: all green.

- [ ] **Step 22.7: Commit.**

```bash
git add apps/limits/tests/integration/
git commit -m "test(limits): end-to-end integration suite for runtime, approvals, audit, ledger, reapers"
```

---

## Task 23: End-of-plan verification

- [ ] **Step 23.1:** `go build ./...` clean.
- [ ] **Step 23.2:** `go vet ./...` clean.
- [ ] **Step 23.3:** `go test -race -timeout=20m ./...` green.
- [ ] **Step 23.4:** Tag `milestone/limits-runtime-and-approvals`.

```
git tag milestone/limits-runtime-and-approvals
```

---

## Summary

After this plan:

- `LimitsService` runtime path is fully implemented and tested. Every gating decision lands an audit row via the existing `pkg/audit` infrastructure with a `limits.*` action verb and structured metadata.
- `ApprovalRequestList/Get/Decide` admin RPCs work end-to-end with re-evaluation, role gating, maker exclusion, and double-vote prevention.
- `LedgerSearch` and `LimitsAuditSearch` admin RPCs return real data over the wire.
- TTL reaper and approval expiry reaper land terminal transitions and emit the corresponding audit verbs.
- Frame events fire for policy invalidation and approval lifecycle, ready for consumer-service approval-resume subscribers in Plan 4.

The follow-on plans:

- **Plan 4 — Consumer integration:** wires `loans.DisbursementCreate`, `savings.WithdrawalCreate`, etc. to `pkg/limits.Gate` behind per-action env flags. Adds the consumer-side outbox worker. One PR per consumer service.
- **Plan 5 — Shadow → Enforce:** flips policies from `SHADOW` to `ENFORCE` action by action, removes legacy in-process caps once steady.
- **Plan 6 — UI:** the `ui/limits/` Flutter package with the full operator surface specified in §11 of the design doc.

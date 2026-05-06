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

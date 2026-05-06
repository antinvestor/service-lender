// Copyright 2023-2026 Ant Investor Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Package business holds the limits service domain logic.
//
// auditing.go centralises emission of gating-decision audit events
// using the platform's pkg/audit infrastructure with limits.* action
// verbs. Every business path that produces a gating outcome calls
// into this file so the verb namespace and metadata schema stay
// uniform across the service.
package business

import (
	"context"
	"strconv"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"
	moneyx "github.com/pitabwire/util/money"

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

// NewAuditing constructs an Auditing wrapper. A nil writer turns the
// helper into a no-op.
func NewAuditing(w *audit.Writer) *Auditing { return &Auditing{writer: w} }

// RecordBreachHard records that a Reserve was denied because at least
// one enforce-mode policy was breached and not approval-eligible.
func (a *Auditing) RecordBreachHard(
	ctx context.Context,
	intent *limitsv1.LimitIntent,
	verdicts []*limitsv1.PolicyVerdict,
	reason string,
) {
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

// RecordReservationCommitted records that a reservation was committed.
func (a *Auditing) RecordReservationCommitted(ctx context.Context, r *models.Reservation) {
	a.recordReservation(ctx, r, VerbReservationCommitted, "committed", "")
}

// RecordReservationReleased records that a reservation was released.
func (a *Auditing) RecordReservationReleased(ctx context.Context, r *models.Reservation, reason string) {
	a.recordReservation(ctx, r, VerbReservationReleased, "released", reason)
}

// RecordReservationReversed records that a reservation was reversed.
func (a *Auditing) RecordReservationReversed(ctx context.Context, r *models.Reservation, reason string) {
	a.recordReservation(ctx, r, VerbReservationReversed, "reversed", reason)
}

// RecordReservationExpiredTTL records that a reservation was expired by the TTL reaper.
func (a *Auditing) RecordReservationExpiredTTL(ctx context.Context, r *models.Reservation) {
	a.recordReservation(ctx, r, VerbReservationExpiredTTL, "expired by TTL reaper", "")
}

func (a *Auditing) recordReservation(
	ctx context.Context,
	r *models.Reservation,
	verb, defaultReason, callerReason string,
) {
	if a == nil || a.writer == nil || r == nil {
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

// RecordApprovalRequired records that an approval request was created.
func (a *Auditing) RecordApprovalRequired(ctx context.Context, ar *models.ApprovalRequest) {
	a.recordApproval(ctx, ar, VerbApprovalRequired, "approval required", "")
}

// RecordApprovalApproved records that an approval request was approved.
func (a *Auditing) RecordApprovalApproved(ctx context.Context, ar *models.ApprovalRequest, approverID string) {
	a.recordApproval(ctx, ar, VerbApprovalApproved, "approved", approverID)
}

// RecordApprovalRejected records that an approval request was rejected.
func (a *Auditing) RecordApprovalRejected(ctx context.Context, ar *models.ApprovalRequest, approverID, note string) {
	a.recordApproval(ctx, ar, VerbApprovalRejected, "rejected: "+note, approverID)
}

// RecordApprovalAutoRejected records that an approval request was auto-rejected on recheck.
func (a *Auditing) RecordApprovalAutoRejected(ctx context.Context, ar *models.ApprovalRequest, reason string) {
	a.recordApproval(ctx, ar, VerbApprovalAutoRejected, "auto-rejected on recheck: "+reason, "")
}

// RecordApprovalExpired records that an approval request expired pending decision.
func (a *Auditing) RecordApprovalExpired(ctx context.Context, ar *models.ApprovalRequest) {
	a.recordApproval(ctx, ar, VerbApprovalExpired, "expired pending decision", "")
}

func (a *Auditing) recordApproval(ctx context.Context, ar *models.ApprovalRequest, verb, reason, approverID string) {
	if a == nil || a.writer == nil || ar == nil {
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
	if intent == nil {
		return data.JSONMap{}
	}
	currency := intent.GetAmount().GetCurrencyCode()
	amountMinor, _ := moneyx.ToMinorUnitsByCurrency(intent.GetAmount(), currency)
	md := data.JSONMap{
		"action_kind":  intent.GetAction().String(),
		"amount_minor": amountMinor,
		"currency":     currency,
		"subjects":     subjectsAsMaps(intent.GetSubjects()),
		"org_unit_id":  intent.GetOrgUnitId(),
	}
	if len(verdicts) > 0 {
		md["verdicts"] = verdictsAsMaps(verdicts)
	}
	return md
}

func reservationMetadata(r *models.Reservation) data.JSONMap {
	return data.JSONMap{
		"action_kind":        string(r.Action),
		"amount_minor":       r.Amount,
		"currency":           r.CurrencyCode,
		"org_unit_id":        r.OrgUnitID,
		"reservation_status": string(r.Status),
	}
}

func approvalMetadata(ar *models.ApprovalRequest) data.JSONMap {
	return data.JSONMap{
		"reservation_id":       ar.ReservationID,
		"action_kind":          string(ar.Action),
		"amount_minor":         ar.Amount,
		"currency":             ar.CurrencyCode,
		"triggering_policy_id": ar.TriggeringPolicyID,
		"policy_version":       ar.PolicyVersion,
		"required_role":        ar.RequiredRole,
		"required_count":       ar.RequiredCount,
	}
}

func subjectsAsMaps(refs []*limitsv1.SubjectRef) []map[string]string {
	out := make([]map[string]string, len(refs))
	for i, r := range refs {
		out[i] = map[string]string{"type": subjectTypeJSONStr(r.GetType()), "id": r.GetId()}
	}
	return out
}

// subjectTypeJSONStr is a local mirror of the (package-private)
// helper in models — we duplicate the few cases here to avoid a
// cross-package dependency on an internal models helper.
func subjectTypeJSONStr(t limitsv1.SubjectType) string {
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
			"policy_id":              v.GetPolicyId(),
			"policy_version":         v.GetPolicyVersion(),
			"matched":                v.GetMatched(),
			"breached":               v.GetBreached(),
			"would_require_approval": v.GetWouldRequireApproval(),
			"mode":                   v.GetMode().String(),
			"reason":                 v.GetReason(),
		}
		if v.GetCurrentUsage() != nil {
			cu, _ := moneyx.ToMinorUnitsByCurrency(v.GetCurrentUsage(), v.GetCurrentUsage().GetCurrencyCode())
			m["current_usage_minor"] = cu
		}
		if v.GetCapAmount() != nil {
			ca, _ := moneyx.ToMinorUnitsByCurrency(v.GetCapAmount(), v.GetCapAmount().GetCurrencyCode())
			m["cap_minor"] = ca
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

// FormatBreachReason builds a one-line reason string for a hard breach,
// suitable for the Reason field of an audit.Record.
func FormatBreachReason(v *limitsv1.PolicyVerdict, intentMinor int64) string {
	if v.GetCapCount() > 0 {
		return "policy=" + v.GetPolicyId() + " count=" + strconv.FormatInt(v.GetCurrentCount()+1, 10) +
			">cap=" + strconv.FormatInt(v.GetCapCount(), 10)
	}
	cap := int64(0)
	if c := v.GetCapAmount(); c != nil {
		cap, _ = moneyx.ToMinorUnitsByCurrency(c, c.GetCurrencyCode())
	}
	curr := int64(0)
	if u := v.GetCurrentUsage(); u != nil {
		curr, _ = moneyx.ToMinorUnitsByCurrency(u, u.GetCurrencyCode())
	}
	return "policy=" + v.GetPolicyId() + " usage+amount=" +
		strconv.FormatInt(curr+intentMinor, 10) + ">cap=" + strconv.FormatInt(cap, 10)
}

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
// reservation.go implements the Reserve method on ReservationBusiness,
// which is the algorithmic core of the runtime path (spec §7).
package business

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/util"
	moneyx "github.com/pitabwire/util/money"
	"gorm.io/datatypes"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

// approvalSpec pairs a candidate policy with the verdict that triggered an
// approval requirement. Used throughout Reserve to carry the two together.
type approvalSpec struct {
	policy  *models.Policy
	verdict *limitsv1.PolicyVerdict
}

// ReservationBusiness implements the runtime path: Check, Reserve, Commit,
// Release, Reverse. This file holds Reserve plus shared helpers; Commit,
// Release, Reverse, Check land in Task 15 (added to this same file).
type ReservationBusiness interface {
	Reserve(
		ctx context.Context,
		intent *limitsv1.LimitIntent,
		idempotencyKey string,
		ttl time.Duration,
	) (*limitsv1.ReserveResponse, error)
	// Commit/Release/Reverse/Check land in Task 15.
}

type reservationBusiness struct {
	resvRepo      repository.ReservationRepository
	ledgerRepo    repository.LedgerRepository
	candidateRepo repository.CandidatePolicyRepository
	approvalRepo  repository.ApprovalRequestRepository
	policyRepo    repository.PolicyRepository
	evaluator     *Evaluator
	resolver      AttributeResolver
	auditing      *Auditing
	dbPool        pool.Pool
}

// NewReservationBusiness wires up dependencies.
func NewReservationBusiness(
	resvRepo repository.ReservationRepository,
	ledgerRepo repository.LedgerRepository,
	candidateRepo repository.CandidatePolicyRepository,
	approvalRepo repository.ApprovalRequestRepository,
	policyRepo repository.PolicyRepository,
	evaluator *Evaluator,
	resolver AttributeResolver,
	auditing *Auditing,
	dbPool pool.Pool,
) ReservationBusiness {
	return &reservationBusiness{
		resvRepo: resvRepo, ledgerRepo: ledgerRepo, candidateRepo: candidateRepo,
		approvalRepo: approvalRepo, policyRepo: policyRepo,
		evaluator: evaluator, resolver: resolver, auditing: auditing, dbPool: dbPool,
	}
}

func (b *reservationBusiness) Reserve(
	ctx context.Context,
	intent *limitsv1.LimitIntent,
	idempotencyKey string,
	ttl time.Duration,
) (*limitsv1.ReserveResponse, error) {
	// 1. Validate intent.
	if err := validateIntent(intent); err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	if idempotencyKey == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("idempotency_key required"))
	}

	// 2. Idempotency short-circuit.
	if existing, _ := b.resvRepo.GetByIdempotencyKey(ctx, idempotencyKey); existing != nil {
		if intentHash(intent, idempotencyKey) != reservationIntentHash(existing) {
			return nil, connect.NewError(connect.CodeAlreadyExists,
				fmt.Errorf("idempotency-key collision with different intent: %s", existing.ID))
		}
		return &limitsv1.ReserveResponse{Reservation: existing.ToAPI()}, nil
	}

	// 3. Subject schema validation.
	if err := validateRequiredSubjects(intent); err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	// 4. Compute minor units.
	currency := intent.GetAmount().GetCurrencyCode()
	intentMinor, err := moneyx.ToMinorUnitsByCurrency(intent.GetAmount(), currency)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	// 5. Candidate policies.
	action, err := models.ActionFromAPISafe(intent.GetAction())
	if err != nil || action == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid action"))
	}
	cands, err := b.candidateRepo.FindCandidates(ctx, repository.CandidateQuery{
		Action:       action,
		CurrencyCode: currency,
		TenantID:     intent.GetTenantId(),
		OrgUnitID:    intent.GetOrgUnitId(),
	})
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// 6. Filter by subject_type + attribute predicate.
	type candidatePair struct {
		policy  *models.Policy
		subject repository.SubjectFilter
	}
	var applicable []candidatePair
	for _, p := range cands {
		s, ok := findSubjectByType(intent.GetSubjects(), p.SubjectType)
		if !ok {
			continue
		}
		if len(p.AttributeFilter) > 0 {
			attrs, attrErr := b.resolver.Get(ctx, p.SubjectType, s.GetId())
			if attrErr != nil {
				util.Log(ctx).WithError(attrErr).Warn("attribute resolver failed; skipping policy")
				continue
			}
			if !evaluatePredicate(p.AttributeFilter, attrs) {
				continue
			}
		}
		applicable = append(applicable, candidatePair{
			policy:  p,
			subject: repository.SubjectFilter{Type: p.SubjectType, ID: s.GetId()},
		})
	}

	// 7. Open transaction; acquire advisory locks for rolling-window subjects.
	db := b.dbPool.DB(ctx, false)
	tx := db.Begin()
	if tx.Error != nil {
		return nil, connect.NewError(connect.CodeInternal, tx.Error)
	}
	committed := false
	defer func() {
		if !committed {
			_ = tx.Rollback()
		}
	}()

	var rollingSubjects []repository.SubjectFilter
	for _, ap := range applicable {
		if ap.policy.LimitKind == models.KindRollingWindowAmount ||
			ap.policy.LimitKind == models.KindRollingWindowCount {
			rollingSubjects = append(rollingSubjects, ap.subject)
		}
	}
	keys := LockKeys(action, currency, rollingSubjects)
	for _, k := range keys {
		if err := tx.Exec("SELECT pg_advisory_xact_lock(?)", k).Error; err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
	}

	// 8. Per-policy evaluation.
	var verdicts []*limitsv1.PolicyVerdict
	var hardBreaches, shadowBreaches []*limitsv1.PolicyVerdict
	var approvalNeeded []approvalSpec
	for _, ap := range applicable {
		v, evErr := b.evaluator.Evaluate(ctx, ap.policy, ap.subject, intent, intentMinor)
		if evErr != nil {
			return nil, connect.NewError(connect.CodeInternal, evErr)
		}
		verdicts = append(verdicts, v)

		// 9. Aggregate.
		switch ap.policy.Mode {
		case models.ModeEnforce:
			if v.GetBreached() && !v.GetWouldRequireApproval() {
				hardBreaches = append(hardBreaches, v)
			}
			if v.GetWouldRequireApproval() {
				approvalNeeded = append(approvalNeeded, approvalSpec{policy: ap.policy, verdict: v})
			}
		case models.ModeShadow:
			if v.GetBreached() || v.GetWouldRequireApproval() {
				shadowBreaches = append(shadowBreaches, v)
			}
		}
	}

	// 10. Hard breaches → deny.
	if len(hardBreaches) > 0 {
		_ = tx.Rollback()
		committed = true // prevent double-rollback in defer
		for _, v := range hardBreaches {
			b.auditing.RecordBreachHard(ctx, intent, []*limitsv1.PolicyVerdict{v}, FormatBreachReason(v, intentMinor))
		}
		for _, v := range shadowBreaches {
			b.auditing.RecordBreachShadow(ctx, intent, v)
		}
		return nil, connect.NewError(connect.CodeFailedPrecondition,
			fmt.Errorf("limits cap breached"))
	}

	// 11. Persist reservation.
	resv, err := models.ReservationFromIntent(intent, idempotencyKey)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	resv.ID = util.IDString()
	if len(approvalNeeded) > 0 {
		resv.Status = models.ReservationStatusPendingApproval
		resv.TTLAt = time.Now().Add(approvalTTLForPolicies(approvalNeeded)).UTC()
	} else {
		resv.TTLAt = time.Now().Add(ttl).UTC()
	}
	// Pure-shadow: no enforce-mode verdicts but at least one shadow policy
	// would have blocked. Shadow reservations do not materialise ledger entries
	// on Commit and don't count toward future caps.
	if len(approvalNeeded) == 0 && len(shadowBreaches) > 0 {
		resv.IsShadow = true
	}
	resv.PoliciesEvaluated = verdictsJSON(verdicts)
	if err := tx.Create(resv).Error; err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// 12. Persist approval requests.
	approvalRows := make([]*models.ApprovalRequest, 0, len(approvalNeeded))
	for _, ap := range approvalNeeded {
		tier, ok := PickTier(ap.policy, intentMinor)
		if !ok {
			return nil, connect.NewError(connect.CodeInternal,
				fmt.Errorf("policy %s flagged for approval but no tier covers amount", ap.policy.ID))
		}
		ar := &models.ApprovalRequest{
			ReservationID:      resv.ID,
			OrgUnitID:          resv.OrgUnitID,
			Action:             resv.Action,
			CurrencyCode:       resv.CurrencyCode,
			Amount:             resv.Amount,
			TriggeringPolicyID: ap.policy.ID,
			PolicyVersion:      int32(ap.policy.Version),
			RequiredRole:       tier.Role,
			RequiredCount:      tier.Approvers,
			MakerID:            resv.MakerID,
			Status:             models.ApprovalStatusPending,
			SubmittedAt:        time.Now().UTC(),
			ExpiresAt:          time.Now().Add(time.Duration(ap.policy.ApprovalTTLSec) * time.Second).UTC(),
		}
		ar.ID = util.IDString()
		if err := tx.Create(ar).Error; err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		approvalRows = append(approvalRows, ar)
	}

	// 13. Commit transaction.
	if err := tx.Commit().Error; err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	committed = true

	// 14. Post-commit audit emission.
	for _, v := range shadowBreaches {
		b.auditing.RecordBreachShadow(ctx, intent, v)
	}
	for _, ar := range approvalRows {
		b.auditing.RecordApprovalRequired(ctx, ar)
	}

	// 15. Build response.
	return &limitsv1.ReserveResponse{
		Reservation: resv.ToAPI(),
		Check: &limitsv1.CheckResponse{
			Allowed:           len(approvalNeeded) == 0,
			RequiresApproval:  len(approvalNeeded) > 0,
			RequiredApprovers: requiredApproverCount(approvalRows),
			Verdicts:          verdicts,
		},
	}, nil
}

// ─── Helpers ───────────────────────────────────────────────────────────

func validateIntent(intent *limitsv1.LimitIntent) error {
	if intent == nil {
		return errors.New("intent: nil")
	}
	if intent.GetTenantId() == "" {
		return errors.New("intent: tenant_id required")
	}
	if intent.GetAmount() == nil {
		return errors.New("intent: amount required")
	}
	if intent.GetAction() == limitsv1.LimitAction_LIMIT_ACTION_UNSPECIFIED {
		return errors.New("intent: action required")
	}
	if len(intent.GetSubjects()) == 0 {
		return errors.New("intent: at least one subject required")
	}
	return nil
}

// actionSubjectRequirements declares the minimum subject set per action.
// Reserve refuses intents missing any required subject type.
var actionSubjectRequirements = map[limitsv1.LimitAction][]limitsv1.SubjectType{
	limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT: {
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
		limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION,
	},
	limitsv1.LimitAction_LIMIT_ACTION_LOAN_REQUEST: {
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
		limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION,
	},
	limitsv1.LimitAction_LIMIT_ACTION_LOAN_REPAYMENT: {
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
		limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION,
	},
	limitsv1.LimitAction_LIMIT_ACTION_SAVINGS_DEPOSIT: {
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
		limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT,
	},
	limitsv1.LimitAction_LIMIT_ACTION_SAVINGS_WITHDRAWAL: {
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
		limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT,
	},
	limitsv1.LimitAction_LIMIT_ACTION_TRANSFER_ORDER_EXECUTE: {limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT},
	limitsv1.LimitAction_LIMIT_ACTION_INCOMING_PAYMENT:       {limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT},
	limitsv1.LimitAction_LIMIT_ACTION_FUNDING_INFLOW:         {limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION},
	limitsv1.LimitAction_LIMIT_ACTION_FUNDING_OUTFLOW:        {limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION},
	limitsv1.LimitAction_LIMIT_ACTION_STAWI_CONTRIBUTION:     {limitsv1.SubjectType_SUBJECT_TYPE_CLIENT},
	limitsv1.LimitAction_LIMIT_ACTION_STAWI_PAYOUT:           {limitsv1.SubjectType_SUBJECT_TYPE_CLIENT},
}

func validateRequiredSubjects(intent *limitsv1.LimitIntent) error {
	required, ok := actionSubjectRequirements[intent.GetAction()]
	if !ok {
		return nil // unknown action: caller already validated
	}
	have := map[limitsv1.SubjectType]bool{}
	for _, s := range intent.GetSubjects() {
		have[s.GetType()] = true
	}
	for _, r := range required {
		if !have[r] {
			return fmt.Errorf("intent: action %s requires subject_type %s",
				intent.GetAction().String(), r.String())
		}
	}
	return nil
}

// findSubjectByType returns the first SubjectRef whose type maps to the given
// models.Subject value.
func findSubjectByType(subjects []*limitsv1.SubjectRef, t models.Subject) (*limitsv1.SubjectRef, bool) {
	target := subjectToAPILocal(t)
	for _, s := range subjects {
		if s.GetType() == target {
			return s, true
		}
	}
	return nil, false
}

// subjectToAPILocal mirrors models.subjectToAPI (package-private) without
// importing a non-exported symbol.
func subjectToAPILocal(t models.Subject) limitsv1.SubjectType {
	switch t {
	case models.SubjectClient:
		return limitsv1.SubjectType_SUBJECT_TYPE_CLIENT
	case models.SubjectAccount:
		return limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT
	case models.SubjectProduct:
		return limitsv1.SubjectType_SUBJECT_TYPE_PRODUCT
	case models.SubjectOrganization:
		return limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION
	case models.SubjectOrgUnit:
		return limitsv1.SubjectType_SUBJECT_TYPE_ORG_UNIT
	case models.SubjectWorkforceMember:
		return limitsv1.SubjectType_SUBJECT_TYPE_WORKFORCE_MEMBER
	default:
		return limitsv1.SubjectType_SUBJECT_TYPE_UNSPECIFIED
	}
}

// evaluatePredicate evaluates a Policy.AttributeFilter (a jsonb field) against
// the given attribute map. Supported operators in v1: "in" (array), "eq" (literal).
// Unknown operators or malformed filter → false (predicate denies).
func evaluatePredicate(filter datatypes.JSON, attrs map[string]any) bool {
	if len(filter) == 0 {
		return true
	}
	var spec map[string]any
	if err := json.Unmarshal(filter, &spec); err != nil {
		return false
	}
	if attrs == nil {
		return false
	}
	for key, want := range spec {
		got, ok := attrs[key]
		if !ok {
			return false
		}
		switch w := want.(type) {
		case map[string]any:
			if inList, has := w["in"].([]any); has {
				match := false
				for _, e := range inList {
					if fmt.Sprint(e) == fmt.Sprint(got) {
						match = true
						break
					}
				}
				if !match {
					return false
				}
			} else if eqVal, has := w["eq"]; has {
				if fmt.Sprint(eqVal) != fmt.Sprint(got) {
					return false
				}
			} else {
				return false
			}
		default:
			if fmt.Sprint(want) != fmt.Sprint(got) {
				return false
			}
		}
	}
	return true
}

func intentHash(intent *limitsv1.LimitIntent, idempotencyKey string) string {
	currency := intent.GetAmount().GetCurrencyCode()
	amountMinor, _ := moneyx.ToMinorUnitsByCurrency(intent.GetAmount(), currency)
	subjects := ""
	for _, s := range intent.GetSubjects() {
		subjects += s.GetType().String() + ":" + s.GetId() + ";"
	}
	raw := fmt.Sprintf("%s|%s|%s|%d|%s|%s|%s|%s",
		idempotencyKey,
		intent.GetAction().String(),
		intent.GetTenantId(),
		amountMinor,
		currency,
		intent.GetOrgUnitId(),
		intent.GetMakerId(),
		subjects,
	)
	h := sha256.Sum256([]byte(raw))
	return hex.EncodeToString(h[:])
}

func reservationIntentHash(r *models.Reservation) string {
	subjects := ""
	if refs, err := unmarshalReservationSubjects(r.SubjectRefs); err == nil {
		for _, s := range refs {
			subjects += s.GetType().String() + ":" + s.GetId() + ";"
		}
	}
	raw := fmt.Sprintf("%s|%s|%s|%d|%s|%s|%s|%s",
		r.IdempotencyKey,
		models.ActionToAPISafe(r.Action).String(),
		r.TenantID,
		r.Amount,
		r.CurrencyCode,
		r.OrgUnitID,
		r.MakerID,
		subjects,
	)
	h := sha256.Sum256([]byte(raw))
	return hex.EncodeToString(h[:])
}

// unmarshalReservationSubjects pulls subject_refs JSON back into proto SubjectRefs.
// The JSON shape is [{"type":"client","id":"..."},...] as written by models.marshalSubjectRefs.
func unmarshalReservationSubjects(j datatypes.JSON) ([]*limitsv1.SubjectRef, error) {
	if len(j) == 0 {
		return nil, nil
	}
	type sr struct {
		Type string `json:"type"`
		ID   string `json:"id"`
	}
	var raw []sr
	if err := json.Unmarshal(j, &raw); err != nil {
		return nil, err
	}
	out := make([]*limitsv1.SubjectRef, len(raw))
	for i, r := range raw {
		out[i] = &limitsv1.SubjectRef{
			Type: subjectToAPILocal(models.Subject(r.Type)),
			Id:   r.ID,
		}
	}
	return out, nil
}

func verdictsJSON(verdicts []*limitsv1.PolicyVerdict) datatypes.JSON {
	type vr struct {
		PolicyID             string `json:"policy_id"`
		PolicyVersion        int32  `json:"policy_version"`
		Matched              bool   `json:"matched"`
		Breached             bool   `json:"breached"`
		WouldRequireApproval bool   `json:"would_require_approval"`
		Mode                 string `json:"mode"`
		Reason               string `json:"reason"`
	}
	out := make([]vr, len(verdicts))
	for i, v := range verdicts {
		out[i] = vr{
			PolicyID:             v.GetPolicyId(),
			PolicyVersion:        v.GetPolicyVersion(),
			Matched:              v.GetMatched(),
			Breached:             v.GetBreached(),
			WouldRequireApproval: v.GetWouldRequireApproval(),
			Mode:                 v.GetMode().String(),
			Reason:               v.GetReason(),
		}
	}
	b, _ := json.Marshal(out)
	return datatypes.JSON(b)
}

func approvalTTLForPolicies(specs []approvalSpec) time.Duration {
	// Take the SHORTEST approval TTL across involved policies —
	// conservative on stale approval risk.
	min := time.Duration(0)
	for _, s := range specs {
		d := time.Duration(s.policy.ApprovalTTLSec) * time.Second
		if min == 0 || d < min {
			min = d
		}
	}
	if min == 0 {
		return 72 * time.Hour
	}
	return min
}

func requiredApproverCount(rows []*models.ApprovalRequest) int32 {
	max := int32(0)
	for _, r := range rows {
		if r.RequiredCount > max {
			max = r.RequiredCount
		}
	}
	return max
}

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

package models

import (
	"encoding/json"
	"errors"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/types/known/structpb"
)

// ─── Enum mappers (proto ↔ string typed alias) ────────────────────────

func scopeFromAPI(s limitsv1.PolicyScope) (Scope, error) {
	switch s {
	case limitsv1.PolicyScope_POLICY_SCOPE_PLATFORM:
		return ScopePlatform, nil
	case limitsv1.PolicyScope_POLICY_SCOPE_ORG:
		return ScopeOrg, nil
	case limitsv1.PolicyScope_POLICY_SCOPE_ORG_UNIT:
		return ScopeOrgUnit, nil
	default:
		return "", errors.New("policy: invalid scope")
	}
}

func scopeToAPI(s Scope) limitsv1.PolicyScope {
	switch s {
	case ScopePlatform:
		return limitsv1.PolicyScope_POLICY_SCOPE_PLATFORM
	case ScopeOrg:
		return limitsv1.PolicyScope_POLICY_SCOPE_ORG
	case ScopeOrgUnit:
		return limitsv1.PolicyScope_POLICY_SCOPE_ORG_UNIT
	default:
		return limitsv1.PolicyScope_POLICY_SCOPE_UNSPECIFIED
	}
}

func subjectFromAPI(s limitsv1.SubjectType) (Subject, error) {
	switch s {
	case limitsv1.SubjectType_SUBJECT_TYPE_CLIENT:
		return SubjectClient, nil
	case limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT:
		return SubjectAccount, nil
	case limitsv1.SubjectType_SUBJECT_TYPE_PRODUCT:
		return SubjectProduct, nil
	case limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION:
		return SubjectOrganization, nil
	case limitsv1.SubjectType_SUBJECT_TYPE_ORG_UNIT:
		return SubjectOrgUnit, nil
	case limitsv1.SubjectType_SUBJECT_TYPE_WORKFORCE_MEMBER:
		return SubjectWorkforceMember, nil
	default:
		return "", errors.New("policy: invalid subject type")
	}
}

func subjectToAPI(s Subject) limitsv1.SubjectType {
	switch s {
	case SubjectClient:
		return limitsv1.SubjectType_SUBJECT_TYPE_CLIENT
	case SubjectAccount:
		return limitsv1.SubjectType_SUBJECT_TYPE_ACCOUNT
	case SubjectProduct:
		return limitsv1.SubjectType_SUBJECT_TYPE_PRODUCT
	case SubjectOrganization:
		return limitsv1.SubjectType_SUBJECT_TYPE_ORGANIZATION
	case SubjectOrgUnit:
		return limitsv1.SubjectType_SUBJECT_TYPE_ORG_UNIT
	case SubjectWorkforceMember:
		return limitsv1.SubjectType_SUBJECT_TYPE_WORKFORCE_MEMBER
	default:
		return limitsv1.SubjectType_SUBJECT_TYPE_UNSPECIFIED
	}
}

func actionFromAPI(a limitsv1.LimitAction) (Action, error) {
	switch a {
	case limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT:
		return ActionLoanDisbursement, nil
	case limitsv1.LimitAction_LIMIT_ACTION_LOAN_REQUEST:
		return ActionLoanRequest, nil
	case limitsv1.LimitAction_LIMIT_ACTION_LOAN_REPAYMENT:
		return ActionLoanRepayment, nil
	case limitsv1.LimitAction_LIMIT_ACTION_SAVINGS_DEPOSIT:
		return ActionSavingsDeposit, nil
	case limitsv1.LimitAction_LIMIT_ACTION_SAVINGS_WITHDRAWAL:
		return ActionSavingsWithdrawal, nil
	case limitsv1.LimitAction_LIMIT_ACTION_TRANSFER_ORDER_EXECUTE:
		return ActionTransferOrderExecute, nil
	case limitsv1.LimitAction_LIMIT_ACTION_INCOMING_PAYMENT:
		return ActionIncomingPayment, nil
	case limitsv1.LimitAction_LIMIT_ACTION_FUNDING_INFLOW:
		return ActionFundingInflow, nil
	case limitsv1.LimitAction_LIMIT_ACTION_FUNDING_OUTFLOW:
		return ActionFundingOutflow, nil
	case limitsv1.LimitAction_LIMIT_ACTION_STAWI_CONTRIBUTION:
		return ActionStawiContribution, nil
	case limitsv1.LimitAction_LIMIT_ACTION_STAWI_PAYOUT:
		return ActionStawiPayout, nil
	default:
		return "", errors.New("policy: invalid action")
	}
}

func actionToAPI(a Action) limitsv1.LimitAction {
	switch a {
	case ActionLoanDisbursement:
		return limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT
	case ActionLoanRequest:
		return limitsv1.LimitAction_LIMIT_ACTION_LOAN_REQUEST
	case ActionLoanRepayment:
		return limitsv1.LimitAction_LIMIT_ACTION_LOAN_REPAYMENT
	case ActionSavingsDeposit:
		return limitsv1.LimitAction_LIMIT_ACTION_SAVINGS_DEPOSIT
	case ActionSavingsWithdrawal:
		return limitsv1.LimitAction_LIMIT_ACTION_SAVINGS_WITHDRAWAL
	case ActionTransferOrderExecute:
		return limitsv1.LimitAction_LIMIT_ACTION_TRANSFER_ORDER_EXECUTE
	case ActionIncomingPayment:
		return limitsv1.LimitAction_LIMIT_ACTION_INCOMING_PAYMENT
	case ActionFundingInflow:
		return limitsv1.LimitAction_LIMIT_ACTION_FUNDING_INFLOW
	case ActionFundingOutflow:
		return limitsv1.LimitAction_LIMIT_ACTION_FUNDING_OUTFLOW
	case ActionStawiContribution:
		return limitsv1.LimitAction_LIMIT_ACTION_STAWI_CONTRIBUTION
	case ActionStawiPayout:
		return limitsv1.LimitAction_LIMIT_ACTION_STAWI_PAYOUT
	default:
		return limitsv1.LimitAction_LIMIT_ACTION_UNSPECIFIED
	}
}

func kindFromAPI(k limitsv1.LimitKind) (Kind, error) {
	switch k {
	case limitsv1.LimitKind_LIMIT_KIND_PER_TXN_MIN:
		return KindPerTxnMin, nil
	case limitsv1.LimitKind_LIMIT_KIND_PER_TXN_MAX:
		return KindPerTxnMax, nil
	case limitsv1.LimitKind_LIMIT_KIND_ROLLING_WINDOW_AMOUNT:
		return KindRollingWindowAmount, nil
	case limitsv1.LimitKind_LIMIT_KIND_ROLLING_WINDOW_COUNT:
		return KindRollingWindowCount, nil
	default:
		return "", errors.New("policy: invalid kind")
	}
}

func kindToAPI(k Kind) limitsv1.LimitKind {
	switch k {
	case KindPerTxnMin:
		return limitsv1.LimitKind_LIMIT_KIND_PER_TXN_MIN
	case KindPerTxnMax:
		return limitsv1.LimitKind_LIMIT_KIND_PER_TXN_MAX
	case KindRollingWindowAmount:
		return limitsv1.LimitKind_LIMIT_KIND_ROLLING_WINDOW_AMOUNT
	case KindRollingWindowCount:
		return limitsv1.LimitKind_LIMIT_KIND_ROLLING_WINDOW_COUNT
	default:
		return limitsv1.LimitKind_LIMIT_KIND_UNSPECIFIED
	}
}

func modeFromAPI(m limitsv1.PolicyMode) (Mode, error) {
	switch m {
	case limitsv1.PolicyMode_POLICY_MODE_OFF:
		return ModeOff, nil
	case limitsv1.PolicyMode_POLICY_MODE_SHADOW:
		return ModeShadow, nil
	case limitsv1.PolicyMode_POLICY_MODE_ENFORCE:
		return ModeEnforce, nil
	default:
		return "", errors.New("policy: invalid mode")
	}
}

func modeToAPI(m Mode) limitsv1.PolicyMode {
	switch m {
	case ModeOff:
		return limitsv1.PolicyMode_POLICY_MODE_OFF
	case ModeShadow:
		return limitsv1.PolicyMode_POLICY_MODE_SHADOW
	case ModeEnforce:
		return limitsv1.PolicyMode_POLICY_MODE_ENFORCE
	default:
		return limitsv1.PolicyMode_POLICY_MODE_UNSPECIFIED
	}
}

// ─── JSON helpers for AttributeFilter (Struct) and ApproverTiers ─────

func marshalStruct(s *structpb.Struct) ([]byte, error) {
	if s == nil {
		return nil, nil
	}
	return protojson.Marshal(s)
}

func unmarshalStruct(b []byte) (*structpb.Struct, error) {
	if len(b) == 0 {
		return nil, nil
	}
	out := &structpb.Struct{}
	if err := protojson.Unmarshal(b, out); err != nil {
		return nil, err
	}
	return out, nil
}

func marshalApproverTiers(tiers []*limitsv1.ApproverTier) ([]byte, error) {
	type tierJSON struct {
		UpTo      int64  `json:"up_to"`
		Role      string `json:"role"`
		Approvers int32  `json:"approvers"`
	}
	out := make([]tierJSON, len(tiers))
	for i, t := range tiers {
		out[i] = tierJSON{UpTo: t.GetUpTo(), Role: t.GetRole(), Approvers: t.GetApprovers()}
	}
	return json.Marshal(out)
}

func unmarshalApproverTiers(b []byte) ([]*limitsv1.ApproverTier, error) {
	if len(b) == 0 {
		return nil, nil
	}
	type tierJSON struct {
		UpTo      int64  `json:"up_to"`
		Role      string `json:"role"`
		Approvers int32  `json:"approvers"`
	}
	var raw []tierJSON
	if err := json.Unmarshal(b, &raw); err != nil {
		return nil, err
	}
	out := make([]*limitsv1.ApproverTier, len(raw))
	for i, t := range raw {
		out[i] = &limitsv1.ApproverTier{UpTo: t.UpTo, Role: t.Role, Approvers: t.Approvers}
	}
	return out, nil
}

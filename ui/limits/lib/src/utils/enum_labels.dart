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

import 'package:antinvestor_api_limits/antinvestor_api_limits.dart';

String limitActionLabel(LimitAction a) {
  switch (a) {
    case LimitAction.LIMIT_ACTION_LOAN_DISBURSEMENT:
      return 'Loan disbursement';
    case LimitAction.LIMIT_ACTION_LOAN_REQUEST:
      return 'Loan request';
    case LimitAction.LIMIT_ACTION_LOAN_REPAYMENT:
      return 'Loan repayment';
    case LimitAction.LIMIT_ACTION_SAVINGS_DEPOSIT:
      return 'Savings deposit';
    case LimitAction.LIMIT_ACTION_SAVINGS_WITHDRAWAL:
      return 'Savings withdrawal';
    case LimitAction.LIMIT_ACTION_TRANSFER_ORDER_EXECUTE:
      return 'Transfer order';
    case LimitAction.LIMIT_ACTION_INCOMING_PAYMENT:
      return 'Incoming payment';
    case LimitAction.LIMIT_ACTION_FUNDING_INFLOW:
      return 'Funding inflow';
    case LimitAction.LIMIT_ACTION_FUNDING_OUTFLOW:
      return 'Funding outflow';
    case LimitAction.LIMIT_ACTION_STAWI_CONTRIBUTION:
      return 'Stawi contribution';
    case LimitAction.LIMIT_ACTION_STAWI_PAYOUT:
      return 'Stawi payout';
    default:
      return 'Any';
  }
}

String subjectTypeLabel(SubjectType s) {
  switch (s) {
    case SubjectType.SUBJECT_TYPE_CLIENT:
      return 'Client';
    case SubjectType.SUBJECT_TYPE_ACCOUNT:
      return 'Account';
    case SubjectType.SUBJECT_TYPE_PRODUCT:
      return 'Product';
    case SubjectType.SUBJECT_TYPE_ORGANIZATION:
      return 'Organization';
    case SubjectType.SUBJECT_TYPE_ORG_UNIT:
      return 'Org unit';
    case SubjectType.SUBJECT_TYPE_WORKFORCE_MEMBER:
      return 'Workforce member';
    default:
      return 'Any';
  }
}

String limitKindLabel(LimitKind k) {
  switch (k) {
    case LimitKind.LIMIT_KIND_PER_TXN_MIN:
      return 'Per-transaction min';
    case LimitKind.LIMIT_KIND_PER_TXN_MAX:
      return 'Per-transaction max';
    case LimitKind.LIMIT_KIND_ROLLING_WINDOW_AMOUNT:
      return 'Rolling-window amount';
    case LimitKind.LIMIT_KIND_ROLLING_WINDOW_COUNT:
      return 'Rolling-window count';
    default:
      return 'Unspecified';
  }
}

String policyModeLabel(PolicyMode m) {
  switch (m) {
    case PolicyMode.POLICY_MODE_OFF:
      return 'Off';
    case PolicyMode.POLICY_MODE_SHADOW:
      return 'Shadow';
    case PolicyMode.POLICY_MODE_ENFORCE:
      return 'Enforce';
    default:
      return 'Unspecified';
  }
}

String policyScopeLabel(PolicyScope s) {
  switch (s) {
    case PolicyScope.POLICY_SCOPE_PLATFORM:
      return 'Platform';
    case PolicyScope.POLICY_SCOPE_ORG:
      return 'Org';
    case PolicyScope.POLICY_SCOPE_ORG_UNIT:
      return 'Branch';
    default:
      return 'Unspecified';
  }
}

String approvalStatusLabel(ApprovalStatus s) {
  switch (s) {
    case ApprovalStatus.APPROVAL_STATUS_PENDING:
      return 'Pending';
    case ApprovalStatus.APPROVAL_STATUS_APPROVED:
      return 'Approved';
    case ApprovalStatus.APPROVAL_STATUS_REJECTED:
      return 'Rejected';
    case ApprovalStatus.APPROVAL_STATUS_EXPIRED:
      return 'Expired';
    case ApprovalStatus.APPROVAL_STATUS_AUTO_REJECTED_ON_RECHECK:
      return 'Auto-rejected (recheck)';
    default:
      return 'Unspecified';
  }
}

String reservationStatusLabel(ReservationStatus s) {
  switch (s) {
    case ReservationStatus.RESERVATION_STATUS_ACTIVE:
      return 'Active';
    case ReservationStatus.RESERVATION_STATUS_PENDING_APPROVAL:
      return 'Pending approval';
    case ReservationStatus.RESERVATION_STATUS_COMMITTED:
      return 'Committed';
    case ReservationStatus.RESERVATION_STATUS_RELEASED:
      return 'Released';
    case ReservationStatus.RESERVATION_STATUS_REVERSED:
      return 'Reversed';
    case ReservationStatus.RESERVATION_STATUS_EXPIRED:
      return 'Expired';
    default:
      return 'Unspecified';
  }
}

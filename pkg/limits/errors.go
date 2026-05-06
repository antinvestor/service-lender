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

// Package limits provides a thin helper around the limits.v1 LimitsService
// for consumer services. The Gate helper composes Reserve → handler →
// Commit/Release; the typed errors below let callers distinguish gating
// outcomes from infrastructure errors.
package limits

import (
	"fmt"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
)

// PendingApprovalError is returned by Gate when Reserve produces a
// PENDING_APPROVAL reservation. The caller is expected to persist its
// own local row in a pending state and await the limits.approval.* event.
type PendingApprovalError struct {
	ReservationID string
	Verdicts      []*limitsv1.PolicyVerdict
}

func (e *PendingApprovalError) Error() string {
	return fmt.Sprintf("limits: reservation %s pending approval", e.ReservationID)
}

// LimitBreachedError indicates the gate denied the action because at
// least one enforce-mode policy is breached and not eligible for approval.
type LimitBreachedError struct {
	Verdicts []*limitsv1.PolicyVerdict
}

func (e *LimitBreachedError) Error() string {
	if len(e.Verdicts) == 0 {
		return "limits: cap breached"
	}
	return fmt.Sprintf("limits: cap breached (%d policies)", len(e.Verdicts))
}

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

// Package events declares the Frame event names and payload types
// emitted by the limits service. Consumers (the limits service itself
// for cache invalidation, plus other services for approval round-trip)
// subscribe by name and decode the payload.
package events

const (
	EventPolicyInvalidate     = "limits.policy.invalidate.v1"
	EventApprovalRequested    = "limits.approval.requested.v1"
	EventApprovalApproved     = "limits.approval.approved.v1"
	EventApprovalRejected     = "limits.approval.rejected.v1"
	EventApprovalExpired      = "limits.approval.expired.v1"
	EventApprovalAutoRejected = "limits.approval.auto_rejected.v1"
)

// PolicyInvalidatePayload triggers cache eviction across replicas.
type PolicyInvalidatePayload struct {
	PolicyID    string `json:"policy_id"`
	TenantID    string `json:"tenant_id"`
	Action      string `json:"action"`       // limits.v1.LimitAction enum value as string
	SubjectType string `json:"subject_type"` // limits.v1.SubjectType enum value as string
}

// ApprovalEventPayload carries enough context for downstream subscribers
// (consumer services in Plan 4) to look up their local row and resume.
type ApprovalEventPayload struct {
	ReservationID     string `json:"reservation_id"`
	ApprovalRequestID string `json:"approval_request_id"`
	TenantID          string `json:"tenant_id"`
	Action            string `json:"action"`
	MakerID           string `json:"maker_id"`
	Reason            string `json:"reason,omitempty"` // populated for rejected / auto_rejected
}

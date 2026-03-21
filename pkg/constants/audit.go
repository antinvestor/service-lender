package constants

import (
	"context"

	"github.com/pitabwire/frame/security"
)

// AuditTrail captures the full identity and device context of an authenticated
// action from Frame's JWT claims. Every state-changing operation should embed
// this in its Properties or ExtraData for complete traceability.
type AuditTrail struct {
	ProfileID   string
	ContactID   string
	AccessID    string
	SessionID   string
	DeviceID    string
	TenantID    string
	PartitionID string
	ServiceName string
	Roles       []string
}

// AuditTrailFromContext extracts an AuditTrail from the request context.
// Frame's auth middleware injects AuthenticationClaims into the context
// on every authenticated request.
func AuditTrailFromContext(ctx context.Context) AuditTrail {
	claims := security.ClaimsFromContext(ctx)
	if claims == nil {
		return AuditTrail{}
	}

	return AuditTrail{
		ProfileID:   claims.GetProfileID(),
		ContactID:   claims.GetContactID(),
		AccessID:    claims.GetAccessID(),
		SessionID:   claims.GetSessionID(),
		DeviceID:    claims.GetDeviceID(),
		TenantID:    claims.GetTenantID(),
		PartitionID: claims.GetPartitionID(),
		ServiceName: claims.GetServiceName(),
		Roles:       claims.GetRoles(),
	}
}

// ToMap serializes the audit trail to a flat string map for embedding
// in proto Properties/ExtraData fields.
func (a AuditTrail) ToMap() map[string]interface{} {
	m := map[string]interface{}{
		"profile_id": a.ProfileID,
	}
	if a.ContactID != "" {
		m["contact_id"] = a.ContactID
	}
	if a.AccessID != "" {
		m["access_id"] = a.AccessID
	}
	if a.SessionID != "" {
		m["session_id"] = a.SessionID
	}
	if a.DeviceID != "" {
		m["device_id"] = a.DeviceID
	}
	if a.TenantID != "" {
		m["tenant_id"] = a.TenantID
	}
	if a.PartitionID != "" {
		m["partition_id"] = a.PartitionID
	}
	if a.ServiceName != "" {
		m["service_name"] = a.ServiceName
	}
	return m
}

// DisplayLabel returns a human-readable label for the actor.
func (a AuditTrail) DisplayLabel() string {
	if a.ProfileID == "" {
		return "system"
	}
	return a.ProfileID
}

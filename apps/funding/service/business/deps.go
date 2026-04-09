package business

import (
	"context"

	"github.com/pitabwire/frame/data"
)

// MembershipReader provides read access to group memberships.
// Implemented by adapters in cmd/ that wrap identity repos or SDK clients.
type MembershipReader interface {
	GetByGroupID(ctx context.Context, groupID string, offset, limit int) ([]*MemberInfo, error)
}

// MemberInfo is a lightweight projection of a group membership.
type MemberInfo struct {
	data.BaseModel
	GroupID        string
	ProfileID      string
	Name           string
	MembershipType int32
	State          int32
	Properties     data.JSONMap
}

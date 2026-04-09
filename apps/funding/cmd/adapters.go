package main

import (
	"context"

	identitymodels "github.com/antinvestor/service-fintech/apps/identity/service/models"
	identityrepo "github.com/antinvestor/service-fintech/apps/identity/service/repository"

	"github.com/antinvestor/service-fintech/apps/funding/service/business"
)

// membershipAdapter wraps identity's MembershipRepository to satisfy business.MembershipReader.
type membershipAdapter struct {
	repo identityrepo.MembershipRepository
}

func (a *membershipAdapter) GetByGroupID(
	ctx context.Context,
	groupID string,
	offset, limit int,
) ([]*business.MemberInfo, error) {
	members, err := a.repo.GetByGroupID(ctx, groupID, offset, limit)
	if err != nil {
		return nil, err
	}
	return convertMembers(members), nil
}

func convertMembers(members []*identitymodels.Membership) []*business.MemberInfo {
	result := make([]*business.MemberInfo, len(members))
	for i, m := range members {
		info := &business.MemberInfo{
			GroupID:        m.GroupID,
			ProfileID:      m.ProfileID,
			Name:           m.Name,
			MembershipType: int32(m.MembershipType),
			State:          m.State,
			Properties:     m.Properties,
		}
		info.ID = m.ID
		result[i] = info
	}
	return result
}

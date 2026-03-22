package clients

import (
	"context"
	"errors"
	"fmt"

	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"connectrpc.com/connect"
)

// RegisterGroup registers a customer group as a first-class GroupObject in Identity.
func (pc *PlatformClients) RegisterGroup(
	ctx context.Context,
	agentID, branchID, profileID, name, currency string,
	groupType identityv1.GroupType,
	savingAmount string,
	minMembers, maxMembers int32,
) (string, error) {
	if pc.LenderIdentity == nil {
		return "", errors.New("lender identity client not available")
	}
	resp, err := pc.LenderIdentity.GroupSave(ctx, connect.NewRequest(&identityv1.GroupSaveRequest{
		Data: &identityv1.GroupObject{
			AgentId:      agentID,
			BranchId:     branchID,
			ProfileId:    profileID,
			Name:         name,
			GroupType:    groupType,
			CurrencyCode: currency,
			SavingAmount: savingAmount,
			MinMembers:   minMembers,
			MaxMembers:   maxMembers,
		},
	}))
	if err != nil {
		return "", fmt.Errorf("could not register group: %w", err)
	}
	return resp.Msg.GetData().GetId(), nil
}

// CreateMembership creates a membership linking a profile to a group in Identity.
func (pc *PlatformClients) CreateMembership(
	ctx context.Context,
	groupID, profileID, name string,
	role identityv1.MembershipRole,
	memberType identityv1.MembershipType,
) (string, error) {
	if pc.LenderIdentity == nil {
		return "", errors.New("lender identity client not available")
	}
	resp, err := pc.LenderIdentity.MembershipSave(ctx, connect.NewRequest(&identityv1.MembershipSaveRequest{
		Data: &identityv1.MembershipObject{
			GroupId:        groupID,
			ProfileId:      profileID,
			Name:           name,
			Role:           role,
			MembershipType: memberType,
		},
	}))
	if err != nil {
		return "", fmt.Errorf("could not create membership: %w", err)
	}
	return resp.Msg.GetData().GetId(), nil
}

// RegisterClient registers a client under an agent in Identity.
// Clients always belong to an agent. The product layer links clients
// to memberships where needed (e.g. in the stawi-go Membership model).
func (pc *PlatformClients) RegisterClient(ctx context.Context, agentID, profileID, name string) (string, error) {
	if pc.LenderIdentity == nil {
		return "", errors.New("lender identity client not available")
	}
	resp, err := pc.LenderIdentity.ClientSave(ctx, connect.NewRequest(&identityv1.ClientSaveRequest{
		Data: &identityv1.ClientObject{
			AgentId:   agentID,
			ProfileId: profileID,
			Name:      name,
		},
	}))
	if err != nil {
		return "", fmt.Errorf("could not register client: %w", err)
	}
	return resp.Msg.GetData().GetId(), nil
}

// SearchMemberships searches for memberships in Identity.
func (pc *PlatformClients) SearchMemberships(
	ctx context.Context,
	groupID, profileID string,
	role identityv1.MembershipRole,
	memberType identityv1.MembershipType,
) ([]*identityv1.MembershipObject, error) {
	if pc.LenderIdentity == nil {
		return nil, errors.New("lender identity client not available")
	}
	stream, err := pc.LenderIdentity.MembershipSearch(ctx, connect.NewRequest(&identityv1.MembershipSearchRequest{
		GroupId:        groupID,
		ProfileId:      profileID,
		Role:           role,
		MembershipType: memberType,
	}))
	if err != nil {
		return nil, fmt.Errorf("could not search memberships: %w", err)
	}

	var results []*identityv1.MembershipObject
	for stream.Receive() {
		results = append(results, stream.Msg().GetData()...)
	}
	if err := stream.Err(); err != nil {
		return nil, fmt.Errorf("membership search stream error: %w", err)
	}
	return results, nil
}

package clients

import (
	"context"
	"errors"
	"fmt"

	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	"connectrpc.com/connect"
)

// RegisterBorrower registers a borrower under an agent via the Field service.
func (pc *PlatformClients) RegisterBorrower(ctx context.Context, agentID, profileID, name string) (string, error) {
	if pc.LenderIdentity == nil {
		return "", errors.New("lender field client not available")
	}
	resp, err := pc.LenderIdentity.BorrowerSave(ctx, connect.NewRequest(&fieldv1.BorrowerSaveRequest{
		Data: &fieldv1.BorrowerObject{
			AgentId:   agentID,
			ProfileId: profileID,
			Name:      name,
		},
	}))
	if err != nil {
		return "", fmt.Errorf("could not register borrower: %w", err)
	}
	return resp.Msg.GetData().GetId(), nil
}

// RegisterClient is an alias for RegisterBorrower to maintain backward compatibility.
func (pc *PlatformClients) RegisterClient(ctx context.Context, agentID, profileID, name string) (string, error) {
	return pc.RegisterBorrower(ctx, agentID, profileID, name)
}

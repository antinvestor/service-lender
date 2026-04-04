package clients

import (
	"context"
	"errors"
	"fmt"

	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	"connectrpc.com/connect"
)

// RegisterClient registers a client under an agent via the Field service.
func (pc *PlatformClients) RegisterClient(ctx context.Context, agentID, profileID, name string) (string, error) {
	if pc.LenderIdentity == nil {
		return "", errors.New("lender field client not available")
	}
	resp, err := pc.LenderIdentity.ClientSave(ctx, connect.NewRequest(&fieldv1.ClientSaveRequest{
		Data: &fieldv1.ClientObject{
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

package handlers

import (
	"context"

	"buf.build/gen/go/antinvestor/field/connectrpc/go/field/v1/fieldv1connect"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	"connectrpc.com/connect"

	"github.com/antinvestor/service-fintech/apps/identity/service/business"
	"github.com/antinvestor/service-fintech/pkg/apperrors"
)

// FieldServer implements the FieldService RPC handler.
// Tenant-level permission checks are handled by the FunctionAccessInterceptor.
type FieldServer struct {
	agentBusiness  business.AgentBusiness
	clientBusiness business.ClientBusiness

	fieldv1connect.UnimplementedFieldServiceHandler
}

func NewFieldServer(
	agentBusiness business.AgentBusiness,
	clientBusiness business.ClientBusiness,
) fieldv1connect.FieldServiceHandler {
	return &FieldServer{
		agentBusiness:  agentBusiness,
		clientBusiness: clientBusiness,
	}
}

// --- Agent RPCs ---

func (s *FieldServer) AgentSave(
	ctx context.Context,
	req *connect.Request[fieldv1.AgentSaveRequest],
) (*connect.Response[fieldv1.AgentSaveResponse], error) {
	result, err := s.agentBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&fieldv1.AgentSaveResponse{Data: result}), nil
}

func (s *FieldServer) AgentGet(
	ctx context.Context,
	req *connect.Request[fieldv1.AgentGetRequest],
) (*connect.Response[fieldv1.AgentGetResponse], error) {
	result, err := s.agentBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&fieldv1.AgentGetResponse{Data: result}), nil
}

func (s *FieldServer) AgentSearch(
	ctx context.Context,
	req *connect.Request[fieldv1.AgentSearchRequest],
	stream *connect.ServerStream[fieldv1.AgentSearchResponse],
) error {
	err := s.agentBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*fieldv1.AgentObject) error {
			return stream.Send(&fieldv1.AgentSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *FieldServer) AgentHierarchy(
	ctx context.Context,
	req *connect.Request[fieldv1.AgentHierarchyRequest],
	stream *connect.ServerStream[fieldv1.AgentHierarchyResponse],
) error {
	err := s.agentBusiness.Hierarchy(ctx, req.Msg,
		func(_ context.Context, batch []*fieldv1.AgentObject) error {
			return stream.Send(&fieldv1.AgentHierarchyResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Agent Branch RPCs ---
// NOTE: AgentBranchSave, AgentBranchDelete, AgentBranchList handlers will be
// added after the field proto is pushed to BSR and the Go generated types are
// updated. The business layer (AgentBusiness.SaveBranch, DeleteBranch,
// ListBranchesByAgent, ListBranchesByBranch) is ready.

// --- Client RPCs ---

func (s *FieldServer) ClientSave(
	ctx context.Context,
	req *connect.Request[fieldv1.ClientSaveRequest],
) (*connect.Response[fieldv1.ClientSaveResponse], error) {
	result, err := s.clientBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&fieldv1.ClientSaveResponse{Data: result}), nil
}

func (s *FieldServer) ClientGet(
	ctx context.Context,
	req *connect.Request[fieldv1.ClientGetRequest],
) (*connect.Response[fieldv1.ClientGetResponse], error) {
	result, err := s.clientBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&fieldv1.ClientGetResponse{Data: result}), nil
}

func (s *FieldServer) ClientSearch(
	ctx context.Context,
	req *connect.Request[fieldv1.ClientSearchRequest],
	stream *connect.ServerStream[fieldv1.ClientSearchResponse],
) error {
	err := s.clientBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*fieldv1.ClientObject) error {
			return stream.Send(&fieldv1.ClientSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *FieldServer) ClientReassign(
	ctx context.Context,
	req *connect.Request[fieldv1.ClientReassignRequest],
) (*connect.Response[fieldv1.ClientReassignResponse], error) {
	result, err := s.clientBusiness.Reassign(ctx, req.Msg)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&fieldv1.ClientReassignResponse{Data: result}), nil
}

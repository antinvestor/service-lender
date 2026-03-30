package handlers

import (
	"context"

	"buf.build/gen/go/antinvestor/field/connectrpc/go/field/v1/fieldv1connect"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	"connectrpc.com/connect"

	"github.com/antinvestor/service-lender/apps/identity/service/business"
	"github.com/antinvestor/service-lender/pkg/apperrors"
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

// --- Borrower RPCs ---

func (s *FieldServer) BorrowerSave(
	ctx context.Context,
	req *connect.Request[fieldv1.BorrowerSaveRequest],
) (*connect.Response[fieldv1.BorrowerSaveResponse], error) {
	result, err := s.clientBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&fieldv1.BorrowerSaveResponse{Data: result}), nil
}

func (s *FieldServer) BorrowerGet(
	ctx context.Context,
	req *connect.Request[fieldv1.BorrowerGetRequest],
) (*connect.Response[fieldv1.BorrowerGetResponse], error) {
	result, err := s.clientBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&fieldv1.BorrowerGetResponse{Data: result}), nil
}

func (s *FieldServer) BorrowerSearch(
	ctx context.Context,
	req *connect.Request[fieldv1.BorrowerSearchRequest],
	stream *connect.ServerStream[fieldv1.BorrowerSearchResponse],
) error {
	err := s.clientBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*fieldv1.BorrowerObject) error {
			return stream.Send(&fieldv1.BorrowerSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *FieldServer) BorrowerReassign(
	ctx context.Context,
	req *connect.Request[fieldv1.BorrowerReassignRequest],
) (*connect.Response[fieldv1.BorrowerReassignResponse], error) {
	result, err := s.clientBusiness.Reassign(ctx, req.Msg)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&fieldv1.BorrowerReassignResponse{Data: result}), nil
}

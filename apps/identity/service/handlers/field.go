package handlers

import (
	"context"

	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"connectrpc.com/connect"

	"github.com/antinvestor/service-lender/apps/identity/service/business"
	"github.com/antinvestor/service-lender/pkg/apperrors"
)

// FieldServer implements the FieldService RPC handler.
// Tenant-level permission checks are handled by the FunctionAccessInterceptor.
type FieldServer struct {
	agentBusiness      business.AgentBusiness
	clientBusiness     business.ClientBusiness
	groupBusiness      business.GroupBusiness
	membershipBusiness business.MembershipBusiness

	identityv1connect.UnimplementedFieldServiceHandler
}

func NewFieldServer(
	agentBusiness business.AgentBusiness,
	clientBusiness business.ClientBusiness,
	groupBusiness business.GroupBusiness,
	membershipBusiness business.MembershipBusiness,
) identityv1connect.FieldServiceHandler {
	return &FieldServer{
		agentBusiness:      agentBusiness,
		clientBusiness:     clientBusiness,
		groupBusiness:      groupBusiness,
		membershipBusiness: membershipBusiness,
	}
}

// --- Agent RPCs ---

func (s *FieldServer) AgentSave(
	ctx context.Context,
	req *connect.Request[identityv1.AgentSaveRequest],
) (*connect.Response[identityv1.AgentSaveResponse], error) {
	result, err := s.agentBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.AgentSaveResponse{Data: result}), nil
}

func (s *FieldServer) AgentGet(
	ctx context.Context,
	req *connect.Request[identityv1.AgentGetRequest],
) (*connect.Response[identityv1.AgentGetResponse], error) {
	result, err := s.agentBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.AgentGetResponse{Data: result}), nil
}

func (s *FieldServer) AgentSearch(
	ctx context.Context,
	req *connect.Request[identityv1.AgentSearchRequest],
	stream *connect.ServerStream[identityv1.AgentSearchResponse],
) error {
	err := s.agentBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.AgentObject) error {
			return stream.Send(&identityv1.AgentSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *FieldServer) AgentHierarchy(
	ctx context.Context,
	req *connect.Request[identityv1.AgentHierarchyRequest],
	stream *connect.ServerStream[identityv1.AgentHierarchyResponse],
) error {
	err := s.agentBusiness.Hierarchy(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.AgentObject) error {
			return stream.Send(&identityv1.AgentHierarchyResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Client RPCs ---

func (s *FieldServer) ClientSave(
	ctx context.Context,
	req *connect.Request[identityv1.ClientSaveRequest],
) (*connect.Response[identityv1.ClientSaveResponse], error) {
	result, err := s.clientBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.ClientSaveResponse{Data: result}), nil
}

func (s *FieldServer) ClientGet(
	ctx context.Context,
	req *connect.Request[identityv1.ClientGetRequest],
) (*connect.Response[identityv1.ClientGetResponse], error) {
	result, err := s.clientBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.ClientGetResponse{Data: result}), nil
}

func (s *FieldServer) ClientSearch(
	ctx context.Context,
	req *connect.Request[identityv1.ClientSearchRequest],
	stream *connect.ServerStream[identityv1.ClientSearchResponse],
) error {
	err := s.clientBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.ClientObject) error {
			return stream.Send(&identityv1.ClientSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *FieldServer) ClientReassign(
	ctx context.Context,
	req *connect.Request[identityv1.ClientReassignRequest],
) (*connect.Response[identityv1.ClientReassignResponse], error) {
	result, err := s.clientBusiness.Reassign(ctx, req.Msg)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.ClientReassignResponse{Data: result}), nil
}

// --- Group RPCs ---

func (s *FieldServer) GroupSave(
	ctx context.Context,
	req *connect.Request[identityv1.GroupSaveRequest],
) (*connect.Response[identityv1.GroupSaveResponse], error) {
	result, err := s.groupBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.GroupSaveResponse{Data: result}), nil
}

func (s *FieldServer) GroupGet(
	ctx context.Context,
	req *connect.Request[identityv1.GroupGetRequest],
) (*connect.Response[identityv1.GroupGetResponse], error) {
	result, err := s.groupBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.GroupGetResponse{Data: result}), nil
}

func (s *FieldServer) GroupSearch(
	ctx context.Context,
	req *connect.Request[identityv1.GroupSearchRequest],
	stream *connect.ServerStream[identityv1.GroupSearchResponse],
) error {
	err := s.groupBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.GroupObject) error {
			return stream.Send(&identityv1.GroupSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Membership RPCs ---

func (s *FieldServer) MembershipSave(
	ctx context.Context,
	req *connect.Request[identityv1.MembershipSaveRequest],
) (*connect.Response[identityv1.MembershipSaveResponse], error) {
	result, err := s.membershipBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.MembershipSaveResponse{Data: result}), nil
}

func (s *FieldServer) MembershipGet(
	ctx context.Context,
	req *connect.Request[identityv1.MembershipGetRequest],
) (*connect.Response[identityv1.MembershipGetResponse], error) {
	result, err := s.membershipBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.MembershipGetResponse{Data: result}), nil
}

func (s *FieldServer) MembershipSearch(
	ctx context.Context,
	req *connect.Request[identityv1.MembershipSearchRequest],
	stream *connect.ServerStream[identityv1.MembershipSearchResponse],
) error {
	err := s.membershipBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.MembershipObject) error {
			return stream.Send(&identityv1.MembershipSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

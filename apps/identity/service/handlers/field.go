package handlers

import (
	"context"

	"buf.build/gen/go/antinvestor/lender/connectrpc/go/lender/v1/lenderv1connect"
	lenderv1 "buf.build/gen/go/antinvestor/lender/protocolbuffers/go/lender/v1"
	"connectrpc.com/connect"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/authz"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/business"
	"github.com/antinvestor/service-ant-lender/pkg/apperrors"
	"github.com/pitabwire/frame/security/authorizer"
)

// FieldServer implements the FieldService RPC handler.
type FieldServer struct {
	authz          authz.Middleware
	agentBusiness  business.AgentBusiness
	clientBusiness business.ClientBusiness

	lenderv1connect.UnimplementedFieldServiceHandler
}

func NewFieldServer(
	authzMiddleware authz.Middleware,
	agentBusiness business.AgentBusiness,
	clientBusiness business.ClientBusiness,
) lenderv1connect.FieldServiceHandler {
	return &FieldServer{
		authz:          authzMiddleware,
		agentBusiness:  agentBusiness,
		clientBusiness: clientBusiness,
	}
}

// --- Agent RPCs ---

func (s *FieldServer) AgentSave(ctx context.Context, req *connect.Request[lenderv1.AgentSaveRequest]) (*connect.Response[lenderv1.AgentSaveResponse], error) {
	if err := s.authz.CanAgentCreate(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.agentBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.AgentSaveResponse{Data: result}), nil
}

func (s *FieldServer) AgentGet(ctx context.Context, req *connect.Request[lenderv1.AgentGetRequest]) (*connect.Response[lenderv1.AgentGetResponse], error) {
	if err := s.authz.CanAgentView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.agentBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.AgentGetResponse{Data: result}), nil
}

func (s *FieldServer) AgentSearch(ctx context.Context, req *connect.Request[lenderv1.AgentSearchRequest], stream *connect.ServerStream[lenderv1.AgentSearchResponse]) error {
	if err := s.authz.CanAgentView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.agentBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*lenderv1.AgentObject) error {
			return stream.Send(&lenderv1.AgentSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *FieldServer) AgentHierarchy(ctx context.Context, req *connect.Request[lenderv1.AgentHierarchyRequest], stream *connect.ServerStream[lenderv1.AgentHierarchyResponse]) error {
	if err := s.authz.CanAgentView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.agentBusiness.Hierarchy(ctx, req.Msg,
		func(_ context.Context, batch []*lenderv1.AgentObject) error {
			return stream.Send(&lenderv1.AgentHierarchyResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Client RPCs ---

func (s *FieldServer) ClientSave(ctx context.Context, req *connect.Request[lenderv1.ClientSaveRequest]) (*connect.Response[lenderv1.ClientSaveResponse], error) {
	if err := s.authz.CanClientCreate(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.clientBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.ClientSaveResponse{Data: result}), nil
}

func (s *FieldServer) ClientGet(ctx context.Context, req *connect.Request[lenderv1.ClientGetRequest]) (*connect.Response[lenderv1.ClientGetResponse], error) {
	if err := s.authz.CanClientView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.clientBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.ClientGetResponse{Data: result}), nil
}

func (s *FieldServer) ClientSearch(ctx context.Context, req *connect.Request[lenderv1.ClientSearchRequest], stream *connect.ServerStream[lenderv1.ClientSearchResponse]) error {
	if err := s.authz.CanClientView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.clientBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*lenderv1.ClientObject) error {
			return stream.Send(&lenderv1.ClientSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *FieldServer) ClientReassign(ctx context.Context, req *connect.Request[lenderv1.ClientReassignRequest]) (*connect.Response[lenderv1.ClientReassignResponse], error) {
	if err := s.authz.CanClientReassign(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.clientBusiness.Reassign(ctx, req.Msg)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.ClientReassignResponse{Data: result}), nil
}

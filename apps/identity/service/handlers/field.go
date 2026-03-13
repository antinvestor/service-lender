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
	authz            authz.Middleware
	agentBusiness    business.AgentBusiness
	borrowerBusiness business.BorrowerBusiness

	lenderv1connect.UnimplementedFieldServiceHandler
}

func NewFieldServer(
	authzMiddleware authz.Middleware,
	agentBusiness business.AgentBusiness,
	borrowerBusiness business.BorrowerBusiness,
) lenderv1connect.FieldServiceHandler {
	return &FieldServer{
		authz:            authzMiddleware,
		agentBusiness:    agentBusiness,
		borrowerBusiness: borrowerBusiness,
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

// --- Borrower RPCs ---

func (s *FieldServer) BorrowerSave(ctx context.Context, req *connect.Request[lenderv1.BorrowerSaveRequest]) (*connect.Response[lenderv1.BorrowerSaveResponse], error) {
	if err := s.authz.CanBorrowerCreate(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.borrowerBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.BorrowerSaveResponse{Data: result}), nil
}

func (s *FieldServer) BorrowerGet(ctx context.Context, req *connect.Request[lenderv1.BorrowerGetRequest]) (*connect.Response[lenderv1.BorrowerGetResponse], error) {
	if err := s.authz.CanBorrowerView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.borrowerBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.BorrowerGetResponse{Data: result}), nil
}

func (s *FieldServer) BorrowerSearch(ctx context.Context, req *connect.Request[lenderv1.BorrowerSearchRequest], stream *connect.ServerStream[lenderv1.BorrowerSearchResponse]) error {
	if err := s.authz.CanBorrowerView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.borrowerBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*lenderv1.BorrowerObject) error {
			return stream.Send(&lenderv1.BorrowerSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *FieldServer) BorrowerReassign(ctx context.Context, req *connect.Request[lenderv1.BorrowerReassignRequest]) (*connect.Response[lenderv1.BorrowerReassignResponse], error) {
	if err := s.authz.CanBorrowerReassign(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.borrowerBusiness.Reassign(ctx, req.Msg)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.BorrowerReassignResponse{Data: result}), nil
}

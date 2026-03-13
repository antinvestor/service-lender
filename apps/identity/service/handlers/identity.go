package handlers

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	"buf.build/gen/go/antinvestor/lender/connectrpc/go/lender/v1/lenderv1connect"
	lenderv1 "buf.build/gen/go/antinvestor/lender/protocolbuffers/go/lender/v1"
	"connectrpc.com/connect"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/authz"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/business"
	"github.com/antinvestor/service-ant-lender/pkg/apperrors"
	"github.com/pitabwire/frame/security/authorizer"
)

// IdentityServer implements the IdentityService RPC handler.
type IdentityServer struct {
	authz          authz.Middleware
	bankBusiness   business.BankBusiness
	branchBusiness business.BranchBusiness
	suBusiness     business.SystemUserBusiness

	lenderv1connect.UnimplementedIdentityServiceHandler
}

func NewIdentityServer(
	authzMiddleware authz.Middleware,
	bankBusiness business.BankBusiness,
	branchBusiness business.BranchBusiness,
	suBusiness business.SystemUserBusiness,
) lenderv1connect.IdentityServiceHandler {
	return &IdentityServer{
		authz:          authzMiddleware,
		bankBusiness:   bankBusiness,
		branchBusiness: branchBusiness,
		suBusiness:     suBusiness,
	}
}

// --- Bank RPCs ---

func (s *IdentityServer) BankSave(ctx context.Context, req *connect.Request[lenderv1.BankSaveRequest]) (*connect.Response[lenderv1.BankSaveResponse], error) {
	if err := s.authz.CanBankManage(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.bankBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.BankSaveResponse{Data: result}), nil
}

func (s *IdentityServer) BankGet(ctx context.Context, req *connect.Request[lenderv1.BankGetRequest]) (*connect.Response[lenderv1.BankGetResponse], error) {
	if err := s.authz.CanBankView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.bankBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.BankGetResponse{Data: result}), nil
}

func (s *IdentityServer) BankSearch(ctx context.Context, req *connect.Request[commonv1.SearchRequest], stream *connect.ServerStream[lenderv1.BankSearchResponse]) error {
	if err := s.authz.CanBankView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.bankBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*lenderv1.BankObject) error {
			return stream.Send(&lenderv1.BankSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Branch RPCs ---

func (s *IdentityServer) BranchSave(ctx context.Context, req *connect.Request[lenderv1.BranchSaveRequest]) (*connect.Response[lenderv1.BranchSaveResponse], error) {
	if err := s.authz.CanBranchManage(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.branchBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.BranchSaveResponse{Data: result}), nil
}

func (s *IdentityServer) BranchGet(ctx context.Context, req *connect.Request[lenderv1.BranchGetRequest]) (*connect.Response[lenderv1.BranchGetResponse], error) {
	if err := s.authz.CanBranchView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.branchBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.BranchGetResponse{Data: result}), nil
}

func (s *IdentityServer) BranchSearch(ctx context.Context, req *connect.Request[lenderv1.BranchSearchRequest], stream *connect.ServerStream[lenderv1.BranchSearchResponse]) error {
	if err := s.authz.CanBranchView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.branchBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*lenderv1.BranchObject) error {
			return stream.Send(&lenderv1.BranchSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- SystemUser RPCs ---

func (s *IdentityServer) SystemUserSave(ctx context.Context, req *connect.Request[lenderv1.SystemUserSaveRequest]) (*connect.Response[lenderv1.SystemUserSaveResponse], error) {
	if err := s.authz.CanSystemUserManage(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.suBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.SystemUserSaveResponse{Data: result}), nil
}

func (s *IdentityServer) SystemUserGet(ctx context.Context, req *connect.Request[lenderv1.SystemUserGetRequest]) (*connect.Response[lenderv1.SystemUserGetResponse], error) {
	if err := s.authz.CanSystemUserView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.suBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&lenderv1.SystemUserGetResponse{Data: result}), nil
}

func (s *IdentityServer) SystemUserSearch(ctx context.Context, req *connect.Request[lenderv1.SystemUserSearchRequest], stream *connect.ServerStream[lenderv1.SystemUserSearchResponse]) error {
	if err := s.authz.CanSystemUserView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.suBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*lenderv1.SystemUserObject) error {
			return stream.Send(&lenderv1.SystemUserSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

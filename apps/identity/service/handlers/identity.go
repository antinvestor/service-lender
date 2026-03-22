package handlers

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/security/authorizer"

	"github.com/antinvestor/service-lender/apps/identity/service/authz"
	"github.com/antinvestor/service-lender/apps/identity/service/business"
	"github.com/antinvestor/service-lender/pkg/apperrors"
)

// IdentityServer implements the IdentityService RPC handler.
type IdentityServer struct {
	authz            authz.Middleware
	bankBusiness     business.BankBusiness
	branchBusiness   business.BranchBusiness
	investorBusiness business.InvestorBusiness
	suBusiness       business.SystemUserBusiness

	identityv1connect.UnimplementedIdentityServiceHandler
}

func NewIdentityServer(
	authzMiddleware authz.Middleware,
	bankBusiness business.BankBusiness,
	branchBusiness business.BranchBusiness,
	investorBusiness business.InvestorBusiness,
	suBusiness business.SystemUserBusiness,
) identityv1connect.IdentityServiceHandler {
	return &IdentityServer{
		authz:            authzMiddleware,
		bankBusiness:     bankBusiness,
		branchBusiness:   branchBusiness,
		investorBusiness: investorBusiness,
		suBusiness:       suBusiness,
	}
}

// --- Bank RPCs ---

func (s *IdentityServer) BankSave(
	ctx context.Context,
	req *connect.Request[identityv1.BankSaveRequest],
) (*connect.Response[identityv1.BankSaveResponse], error) {
	if err := s.authz.CanBankManage(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.bankBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.BankSaveResponse{Data: result}), nil
}

func (s *IdentityServer) BankGet(
	ctx context.Context,
	req *connect.Request[identityv1.BankGetRequest],
) (*connect.Response[identityv1.BankGetResponse], error) {
	if err := s.authz.CanBankView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.bankBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.BankGetResponse{Data: result}), nil
}

func (s *IdentityServer) BankSearch(
	ctx context.Context,
	req *connect.Request[commonv1.SearchRequest],
	stream *connect.ServerStream[identityv1.BankSearchResponse],
) error {
	if err := s.authz.CanBankView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.bankBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.BankObject) error {
			return stream.Send(&identityv1.BankSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Branch RPCs ---

func (s *IdentityServer) BranchSave(
	ctx context.Context,
	req *connect.Request[identityv1.BranchSaveRequest],
) (*connect.Response[identityv1.BranchSaveResponse], error) {
	if err := s.authz.CanBranchManage(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.branchBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.BranchSaveResponse{Data: result}), nil
}

func (s *IdentityServer) BranchGet(
	ctx context.Context,
	req *connect.Request[identityv1.BranchGetRequest],
) (*connect.Response[identityv1.BranchGetResponse], error) {
	if err := s.authz.CanBranchView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.branchBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.BranchGetResponse{Data: result}), nil
}

func (s *IdentityServer) BranchSearch(
	ctx context.Context,
	req *connect.Request[identityv1.BranchSearchRequest],
	stream *connect.ServerStream[identityv1.BranchSearchResponse],
) error {
	if err := s.authz.CanBranchView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.branchBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.BranchObject) error {
			return stream.Send(&identityv1.BranchSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Investor RPCs ---

func (s *IdentityServer) InvestorSave(
	ctx context.Context,
	req *connect.Request[identityv1.InvestorSaveRequest],
) (*connect.Response[identityv1.InvestorSaveResponse], error) {
	if req.Msg.GetData().GetId() != "" {
		if err := s.authz.CanInvestorManage(ctx); err != nil {
			return nil, authorizer.ToConnectError(err)
		}
	} else {
		if err := s.authz.CanInvestorCreate(ctx); err != nil {
			return nil, authorizer.ToConnectError(err)
		}
	}

	result, err := s.investorBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.InvestorSaveResponse{Data: result}), nil
}

func (s *IdentityServer) InvestorGet(
	ctx context.Context,
	req *connect.Request[identityv1.InvestorGetRequest],
) (*connect.Response[identityv1.InvestorGetResponse], error) {
	if err := s.authz.CanInvestorView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.investorBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.InvestorGetResponse{Data: result}), nil
}

func (s *IdentityServer) InvestorSearch(
	ctx context.Context,
	req *connect.Request[identityv1.InvestorSearchRequest],
	stream *connect.ServerStream[identityv1.InvestorSearchResponse],
) error {
	if err := s.authz.CanInvestorView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.investorBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.InvestorObject) error {
			return stream.Send(&identityv1.InvestorSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- SystemUser RPCs ---

func (s *IdentityServer) SystemUserSave(
	ctx context.Context,
	req *connect.Request[identityv1.SystemUserSaveRequest],
) (*connect.Response[identityv1.SystemUserSaveResponse], error) {
	if err := s.authz.CanSystemUserManage(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.suBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.SystemUserSaveResponse{Data: result}), nil
}

func (s *IdentityServer) SystemUserGet(
	ctx context.Context,
	req *connect.Request[identityv1.SystemUserGetRequest],
) (*connect.Response[identityv1.SystemUserGetResponse], error) {
	if err := s.authz.CanSystemUserView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.suBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.SystemUserGetResponse{Data: result}), nil
}

func (s *IdentityServer) SystemUserSearch(
	ctx context.Context,
	req *connect.Request[identityv1.SystemUserSearchRequest],
	stream *connect.ServerStream[identityv1.SystemUserSearchResponse],
) error {
	if err := s.authz.CanSystemUserView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.suBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.SystemUserObject) error {
			return stream.Send(&identityv1.SystemUserSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

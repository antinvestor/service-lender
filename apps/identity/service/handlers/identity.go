package handlers

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"connectrpc.com/connect"

	"github.com/antinvestor/service-fintech/apps/identity/service/business"
	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/pkg/apperrors"
)

// IdentityServer implements the IdentityService RPC handler.
// Tenant-level permission checks are handled by the FunctionAccessInterceptor.
type IdentityServer struct {
	organizationBusiness business.OrganizationBusiness
	branchBusiness       business.BranchBusiness
	clientGroupBusiness  business.ClientGroupBusiness
	membershipBusiness   business.MembershipBusiness
	investorBusiness     business.InvestorBusiness
	suBusiness           business.SystemUserBusiness

	identityv1connect.UnimplementedIdentityServiceHandler
}

func NewIdentityServer(
	organizationBusiness business.OrganizationBusiness,
	branchBusiness business.BranchBusiness,
	clientGroupBusiness business.ClientGroupBusiness,
	membershipBusiness business.MembershipBusiness,
	investorBusiness business.InvestorBusiness,
	suBusiness business.SystemUserBusiness,
) identityv1connect.IdentityServiceHandler {
	return &IdentityServer{
		organizationBusiness: organizationBusiness,
		branchBusiness:       branchBusiness,
		clientGroupBusiness:  clientGroupBusiness,
		membershipBusiness:   membershipBusiness,
		investorBusiness:     investorBusiness,
		suBusiness:           suBusiness,
	}
}

// --- Organization RPCs ---

func (s *IdentityServer) OrganizationSave(
	ctx context.Context,
	req *connect.Request[identityv1.OrganizationSaveRequest],
) (*connect.Response[identityv1.OrganizationSaveResponse], error) {
	result, err := s.organizationBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.OrganizationSaveResponse{Data: result}), nil
}

func (s *IdentityServer) OrganizationGet(
	ctx context.Context,
	req *connect.Request[identityv1.OrganizationGetRequest],
) (*connect.Response[identityv1.OrganizationGetResponse], error) {
	result, err := s.organizationBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.OrganizationGetResponse{Data: result}), nil
}

func (s *IdentityServer) OrganizationSearch(
	ctx context.Context,
	req *connect.Request[commonv1.SearchRequest],
	stream *connect.ServerStream[identityv1.OrganizationSearchResponse],
) error {
	err := s.organizationBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.OrganizationObject) error {
			return stream.Send(&identityv1.OrganizationSearchResponse{Data: batch})
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
	err := s.suBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*identityv1.SystemUserObject) error {
			return stream.Send(&identityv1.SystemUserSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- ClientGroup RPCs ---

func (s *IdentityServer) ClientGroupSave(
	ctx context.Context,
	req *connect.Request[identityv1.ClientGroupSaveRequest],
) (*connect.Response[identityv1.ClientGroupSaveResponse], error) {
	group := models.ClientGroupFromAPI(ctx, req.Msg.GetData())
	result, err := s.clientGroupBusiness.Save(ctx, group)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.ClientGroupSaveResponse{Data: result.ToAPI()}), nil
}

func (s *IdentityServer) ClientGroupGet(
	ctx context.Context,
	req *connect.Request[identityv1.ClientGroupGetRequest],
) (*connect.Response[identityv1.ClientGroupGetResponse], error) {
	result, err := s.clientGroupBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.ClientGroupGetResponse{Data: result.ToAPI()}), nil
}

func (s *IdentityServer) ClientGroupSearch(
	ctx context.Context,
	req *connect.Request[identityv1.ClientGroupSearchRequest],
	stream *connect.ServerStream[identityv1.ClientGroupSearchResponse],
) error {
	err := s.clientGroupBusiness.Search(ctx,
		req.Msg.GetQuery(), req.Msg.GetAgentId(), req.Msg.GetBranchId(), 0, nil,
		func(_ context.Context, batch []*models.ClientGroup) error {
			var apiResults []*identityv1.ClientGroupObject
			for _, g := range batch {
				apiResults = append(apiResults, g.ToAPI())
			}
			return stream.Send(&identityv1.ClientGroupSearchResponse{Data: apiResults})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Membership RPCs ---

func (s *IdentityServer) MembershipSave(
	ctx context.Context,
	req *connect.Request[identityv1.MembershipSaveRequest],
) (*connect.Response[identityv1.MembershipSaveResponse], error) {
	membership := models.MembershipFromAPI(ctx, req.Msg.GetData())
	result, err := s.membershipBusiness.Save(ctx, membership)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.MembershipSaveResponse{Data: result.ToAPI()}), nil
}

func (s *IdentityServer) MembershipGet(
	ctx context.Context,
	req *connect.Request[identityv1.MembershipGetRequest],
) (*connect.Response[identityv1.MembershipGetResponse], error) {
	result, err := s.membershipBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&identityv1.MembershipGetResponse{Data: result.ToAPI()}), nil
}

func (s *IdentityServer) MembershipSearch(
	ctx context.Context,
	req *connect.Request[identityv1.MembershipSearchRequest],
	stream *connect.ServerStream[identityv1.MembershipSearchResponse],
) error {
	err := s.membershipBusiness.Search(ctx,
		req.Msg.GetQuery(), req.Msg.GetGroupId(), req.Msg.GetProfileId(), 0, 0,
		func(_ context.Context, batch []*models.Membership) error {
			var apiResults []*identityv1.MembershipObject
			for _, m := range batch {
				apiResults = append(apiResults, m.ToAPI())
			}
			return stream.Send(&identityv1.MembershipSearchResponse{Data: apiResults})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

package handlers

import (
	"context"
	"strconv"

	"buf.build/gen/go/antinvestor/loans/connectrpc/go/loans/v1/loansv1connect"
	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-lender/apps/loans/service/business"
	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
	"github.com/antinvestor/service-lender/pkg/apperrors"
)

// LoanManagementServer implements the LoanManagementService RPC handler.
// Tenant-level permission checks are handled by the FunctionAccessInterceptor.
type LoanManagementServer struct {
	lpBusiness       business.LoanProductBusiness
	laBusiness       business.LoanAccountBusiness
	repBusiness      business.RepaymentBusiness
	scheduleBusiness business.RepaymentScheduleBusiness
	penaltyBusiness  business.PenaltyBusiness
	restructBusiness business.LoanRestructureBusiness
	reconBusiness    business.ReconciliationBusiness
	statusChangeRepo repository.LoanStatusChangeRepository

	loansv1connect.UnimplementedLoanManagementServiceHandler
}

func NewLoanManagementServer(
	lpBusiness business.LoanProductBusiness,
	laBusiness business.LoanAccountBusiness,
	repBusiness business.RepaymentBusiness,
	scheduleBusiness business.RepaymentScheduleBusiness,
	penaltyBusiness business.PenaltyBusiness,
	restructBusiness business.LoanRestructureBusiness,
	reconBusiness business.ReconciliationBusiness,
	statusChangeRepo repository.LoanStatusChangeRepository,
) loansv1connect.LoanManagementServiceHandler {
	return &LoanManagementServer{
		lpBusiness:       lpBusiness,
		laBusiness:       laBusiness,
		repBusiness:      repBusiness,
		scheduleBusiness: scheduleBusiness,
		penaltyBusiness:  penaltyBusiness,
		restructBusiness: restructBusiness,
		reconBusiness:    reconBusiness,
		statusChangeRepo: statusChangeRepo,
	}
}

// --- LoanAccount RPCs ---

func (s *LoanManagementServer) LoanAccountCreate(
	ctx context.Context,
	req *connect.Request[loansv1.LoanAccountCreateRequest],
) (*connect.Response[loansv1.LoanAccountCreateResponse], error) {
	result, err := s.laBusiness.Create(ctx, req.Msg.GetApplicationId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.LoanAccountCreateResponse{Data: result}), nil
}

func (s *LoanManagementServer) LoanAccountGet(
	ctx context.Context,
	req *connect.Request[loansv1.LoanAccountGetRequest],
) (*connect.Response[loansv1.LoanAccountGetResponse], error) {
	result, err := s.laBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.LoanAccountGetResponse{Data: result}), nil
}

func (s *LoanManagementServer) LoanAccountSearch(
	ctx context.Context,
	req *connect.Request[loansv1.LoanAccountSearchRequest],
	stream *connect.ServerStream[loansv1.LoanAccountSearchResponse],
) error {
	err := s.laBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*loansv1.LoanAccountObject) error {
			return stream.Send(&loansv1.LoanAccountSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *LoanManagementServer) LoanBalanceGet(
	ctx context.Context,
	req *connect.Request[loansv1.LoanBalanceGetRequest],
) (*connect.Response[loansv1.LoanBalanceGetResponse], error) {
	result, err := s.laBusiness.GetBalance(ctx, req.Msg.GetLoanAccountId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.LoanBalanceGetResponse{Data: result}), nil
}

func (s *LoanManagementServer) LoanStatement(
	ctx context.Context,
	req *connect.Request[loansv1.LoanStatementRequest],
) (*connect.Response[loansv1.LoanStatementResponse], error) {
	result, err := s.laBusiness.GetStatement(ctx, req.Msg)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(result), nil
}

// --- Repayment RPCs ---

func (s *LoanManagementServer) RepaymentRecord(
	ctx context.Context,
	req *connect.Request[loansv1.RepaymentRecordRequest],
) (*connect.Response[loansv1.RepaymentRecordResponse], error) {
	result, err := s.repBusiness.Record(ctx, req.Msg)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.RepaymentRecordResponse{Data: result}), nil
}

func (s *LoanManagementServer) RepaymentGet(
	ctx context.Context,
	req *connect.Request[loansv1.RepaymentGetRequest],
) (*connect.Response[loansv1.RepaymentGetResponse], error) {
	result, err := s.repBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.RepaymentGetResponse{Data: result}), nil
}

func (s *LoanManagementServer) RepaymentSearch(
	ctx context.Context,
	req *connect.Request[loansv1.RepaymentSearchRequest],
	stream *connect.ServerStream[loansv1.RepaymentSearchResponse],
) error {
	err := s.repBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*loansv1.RepaymentObject) error {
			return stream.Send(&loansv1.RepaymentSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- RepaymentSchedule RPCs ---

func (s *LoanManagementServer) RepaymentScheduleGet(
	ctx context.Context,
	req *connect.Request[loansv1.RepaymentScheduleGetRequest],
) (*connect.Response[loansv1.RepaymentScheduleGetResponse], error) {
	result, err := s.scheduleBusiness.GetActive(ctx, req.Msg.GetLoanAccountId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.RepaymentScheduleGetResponse{Data: result}), nil
}

// --- Penalty RPCs ---

func (s *LoanManagementServer) PenaltySave(
	ctx context.Context,
	req *connect.Request[loansv1.PenaltySaveRequest],
) (*connect.Response[loansv1.PenaltySaveResponse], error) {
	result, err := s.penaltyBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.PenaltySaveResponse{Data: result}), nil
}

func (s *LoanManagementServer) PenaltyWaive(
	ctx context.Context,
	req *connect.Request[loansv1.PenaltyWaiveRequest],
) (*connect.Response[loansv1.PenaltyWaiveResponse], error) {
	result, err := s.penaltyBusiness.Waive(ctx, req.Msg.GetId(), req.Msg.GetReason())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.PenaltyWaiveResponse{Data: result}), nil
}

func (s *LoanManagementServer) PenaltySearch(
	ctx context.Context,
	req *connect.Request[loansv1.PenaltySearchRequest],
	stream *connect.ServerStream[loansv1.PenaltySearchResponse],
) error {
	err := s.penaltyBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*loansv1.PenaltyObject) error {
			return stream.Send(&loansv1.PenaltySearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Restructure RPCs ---

func (s *LoanManagementServer) LoanRestructureCreate(
	ctx context.Context,
	req *connect.Request[loansv1.LoanRestructureCreateRequest],
) (*connect.Response[loansv1.LoanRestructureCreateResponse], error) {
	result, err := s.restructBusiness.Create(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.LoanRestructureCreateResponse{Data: result}), nil
}

func (s *LoanManagementServer) LoanRestructureApprove(
	ctx context.Context,
	req *connect.Request[loansv1.LoanRestructureApproveRequest],
) (*connect.Response[loansv1.LoanRestructureApproveResponse], error) {
	result, err := s.restructBusiness.Approve(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.LoanRestructureApproveResponse{Data: result}), nil
}

func (s *LoanManagementServer) LoanRestructureReject(
	ctx context.Context,
	req *connect.Request[loansv1.LoanRestructureRejectRequest],
) (*connect.Response[loansv1.LoanRestructureRejectResponse], error) {
	result, err := s.restructBusiness.Reject(ctx, req.Msg.GetId(), req.Msg.GetReason())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.LoanRestructureRejectResponse{Data: result}), nil
}

func (s *LoanManagementServer) LoanRestructureSearch(
	ctx context.Context,
	req *connect.Request[loansv1.LoanRestructureSearchRequest],
	stream *connect.ServerStream[loansv1.LoanRestructureSearchResponse],
) error {
	err := s.restructBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*loansv1.LoanRestructureObject) error {
			return stream.Send(&loansv1.LoanRestructureSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Reconciliation RPCs ---

func (s *LoanManagementServer) ReconciliationSave(
	ctx context.Context,
	req *connect.Request[loansv1.ReconciliationSaveRequest],
) (*connect.Response[loansv1.ReconciliationSaveResponse], error) {
	result, err := s.reconBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&loansv1.ReconciliationSaveResponse{Data: result}), nil
}

func (s *LoanManagementServer) ReconciliationSearch(
	ctx context.Context,
	req *connect.Request[loansv1.ReconciliationSearchRequest],
	stream *connect.ServerStream[loansv1.ReconciliationSearchResponse],
) error {
	err := s.reconBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*loansv1.ReconciliationObject) error {
			return stream.Send(&loansv1.ReconciliationSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- LoanStatusChange (Audit) RPCs ---

func (s *LoanManagementServer) LoanStatusChangeSearch(
	ctx context.Context,
	req *connect.Request[loansv1.LoanStatusChangeSearchRequest],
	stream *connect.ServerStream[loansv1.LoanStatusChangeSearchResponse],
) error {
	var searchOpts []data.SearchOption

	cursor := req.Msg.GetCursor()
	if cursor != nil {
		offset, offsetErr := strconv.Atoi(cursor.GetPage())
		if offsetErr != nil {
			offset = 0
		}
		searchOpts = append(searchOpts, data.WithSearchOffset(offset), data.WithSearchLimit(int(cursor.GetLimit())))
	}

	andQueryVal := map[string]any{}
	if req.Msg.GetLoanAccountId() != "" {
		andQueryVal["loan_account_id = ?"] = req.Msg.GetLoanAccountId()
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := s.statusChangeRepo.Search(ctx, query)
	if err != nil {
		return apperrors.CleanErr(err)
	}

	return workerpool.ConsumeResultStream(ctx, results, func(res []*models.LoanStatusChange) error {
		var apiResults []*loansv1.LoanStatusChangeObject
		for _, sc := range res {
			apiResults = append(apiResults, sc.ToAPI())
		}
		return stream.Send(&loansv1.LoanStatusChangeSearchResponse{Data: apiResults})
	})
}

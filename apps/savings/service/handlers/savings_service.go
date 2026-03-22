package handlers

import (
	"context"
	"time"

	"buf.build/gen/go/antinvestor/savings/connectrpc/go/savings/v1/savingsv1connect"
	savingsv1 "buf.build/gen/go/antinvestor/savings/protocolbuffers/go/savings/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/security/authorizer"

	"github.com/antinvestor/service-lender/apps/savings/service/authz"
	"github.com/antinvestor/service-lender/apps/savings/service/business"
	"github.com/antinvestor/service-lender/apps/savings/service/models"
	"github.com/antinvestor/service-lender/pkg/apperrors"
)

// SavingsServer implements the SavingsService RPC handler.
type SavingsServer struct {
	authz       authz.Middleware
	spBusiness  business.SavingsProductBusiness
	saBusiness  business.SavingsAccountBusiness
	depBusiness business.DepositBusiness
	wdBusiness  business.WithdrawalBusiness
	iaBusiness  business.InterestAccrualBusiness

	savingsv1connect.UnimplementedSavingsServiceHandler
}

func NewSavingsServer(
	authzMiddleware authz.Middleware,
	spBusiness business.SavingsProductBusiness,
	saBusiness business.SavingsAccountBusiness,
	depBusiness business.DepositBusiness,
	wdBusiness business.WithdrawalBusiness,
	iaBusiness business.InterestAccrualBusiness,
) savingsv1connect.SavingsServiceHandler {
	return &SavingsServer{
		authz:       authzMiddleware,
		spBusiness:  spBusiness,
		saBusiness:  saBusiness,
		depBusiness: depBusiness,
		wdBusiness:  wdBusiness,
		iaBusiness:  iaBusiness,
	}
}

// --- SavingsProduct RPCs ---

func (s *SavingsServer) SavingsProductSave(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsProductSaveRequest],
) (*connect.Response[savingsv1.SavingsProductSaveResponse], error) {
	if err := s.authz.CanSavingsProductManage(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.spBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.SavingsProductSaveResponse{Data: result}), nil
}

func (s *SavingsServer) SavingsProductGet(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsProductGetRequest],
) (*connect.Response[savingsv1.SavingsProductGetResponse], error) {
	if err := s.authz.CanSavingsProductView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.spBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.SavingsProductGetResponse{Data: result}), nil
}

func (s *SavingsServer) SavingsProductSearch(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsProductSearchRequest],
	stream *connect.ServerStream[savingsv1.SavingsProductSearchResponse],
) error {
	if err := s.authz.CanSavingsProductView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.spBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*savingsv1.SavingsProductObject) error {
			return stream.Send(&savingsv1.SavingsProductSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- SavingsAccount RPCs ---

func (s *SavingsServer) SavingsAccountCreate(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsAccountCreateRequest],
) (*connect.Response[savingsv1.SavingsAccountCreateResponse], error) {
	if err := s.authz.CanSavingsAccountCreate(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.saBusiness.Create(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.SavingsAccountCreateResponse{Data: result}), nil
}

func (s *SavingsServer) SavingsAccountGet(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsAccountGetRequest],
) (*connect.Response[savingsv1.SavingsAccountGetResponse], error) {
	if err := s.authz.CanSavingsAccountView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.saBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.SavingsAccountGetResponse{Data: result}), nil
}

func (s *SavingsServer) SavingsAccountSearch(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsAccountSearchRequest],
	stream *connect.ServerStream[savingsv1.SavingsAccountSearchResponse],
) error {
	if err := s.authz.CanSavingsAccountView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.saBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*savingsv1.SavingsAccountObject) error {
			return stream.Send(&savingsv1.SavingsAccountSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *SavingsServer) SavingsAccountFreeze(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsAccountFreezeRequest],
) (*connect.Response[savingsv1.SavingsAccountFreezeResponse], error) {
	if err := s.authz.CanSavingsAccountManage(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.saBusiness.Freeze(ctx, req.Msg.GetId(), req.Msg.GetReason())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.SavingsAccountFreezeResponse{Data: result}), nil
}

func (s *SavingsServer) SavingsAccountClose(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsAccountCloseRequest],
) (*connect.Response[savingsv1.SavingsAccountCloseResponse], error) {
	if err := s.authz.CanSavingsAccountManage(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.saBusiness.Close(ctx, req.Msg.GetId(), req.Msg.GetReason())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.SavingsAccountCloseResponse{Data: result}), nil
}

// --- Deposit RPCs ---

func (s *SavingsServer) DepositRecord(
	ctx context.Context,
	req *connect.Request[savingsv1.DepositRecordRequest],
) (*connect.Response[savingsv1.DepositRecordResponse], error) {
	if err := s.authz.CanDepositRecord(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.depBusiness.Record(
		ctx,
		req.Msg.GetSavingsAccountId(),
		req.Msg.GetAmount(),
		req.Msg.GetPaymentReference(),
		req.Msg.GetChannel(),
		req.Msg.GetPayerReference(),
		req.Msg.GetIdempotencyKey(),
	)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.DepositRecordResponse{Data: result}), nil
}

func (s *SavingsServer) DepositGet(
	ctx context.Context,
	req *connect.Request[savingsv1.DepositGetRequest],
) (*connect.Response[savingsv1.DepositGetResponse], error) {
	if err := s.authz.CanDepositView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.depBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.DepositGetResponse{Data: result}), nil
}

func (s *SavingsServer) DepositSearch(
	ctx context.Context,
	req *connect.Request[savingsv1.DepositSearchRequest],
	stream *connect.ServerStream[savingsv1.DepositSearchResponse],
) error {
	if err := s.authz.CanDepositView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.depBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*savingsv1.DepositObject) error {
			return stream.Send(&savingsv1.DepositSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Withdrawal RPCs ---

func (s *SavingsServer) WithdrawalRequest(
	ctx context.Context,
	req *connect.Request[savingsv1.WithdrawalRequestRequest],
) (*connect.Response[savingsv1.WithdrawalRequestResponse], error) {
	if err := s.authz.CanWithdrawalRequest(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.wdBusiness.Request(
		ctx,
		req.Msg.GetSavingsAccountId(),
		req.Msg.GetAmount(),
		req.Msg.GetChannel(),
		req.Msg.GetRecipientReference(),
		req.Msg.GetReason(),
		req.Msg.GetIdempotencyKey(),
	)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.WithdrawalRequestResponse{Data: result}), nil
}

func (s *SavingsServer) WithdrawalApprove(
	ctx context.Context,
	req *connect.Request[savingsv1.WithdrawalApproveRequest],
) (*connect.Response[savingsv1.WithdrawalApproveResponse], error) {
	if err := s.authz.CanWithdrawalApprove(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.wdBusiness.Approve(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.WithdrawalApproveResponse{Data: result}), nil
}

func (s *SavingsServer) WithdrawalGet(
	ctx context.Context,
	req *connect.Request[savingsv1.WithdrawalGetRequest],
) (*connect.Response[savingsv1.WithdrawalGetResponse], error) {
	if err := s.authz.CanWithdrawalView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.wdBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.WithdrawalGetResponse{Data: result}), nil
}

func (s *SavingsServer) WithdrawalSearch(
	ctx context.Context,
	req *connect.Request[savingsv1.WithdrawalSearchRequest],
	stream *connect.ServerStream[savingsv1.WithdrawalSearchResponse],
) error {
	if err := s.authz.CanWithdrawalView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.wdBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*savingsv1.WithdrawalObject) error {
			return stream.Send(&savingsv1.WithdrawalSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- InterestAccrual RPCs ---

func (s *SavingsServer) InterestAccrualGet(
	ctx context.Context,
	req *connect.Request[savingsv1.InterestAccrualGetRequest],
) (*connect.Response[savingsv1.InterestAccrualGetResponse], error) {
	if err := s.authz.CanInterestAccrualView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.iaBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.InterestAccrualGetResponse{Data: result}), nil
}

func (s *SavingsServer) InterestAccrualSearch(
	ctx context.Context,
	req *connect.Request[savingsv1.InterestAccrualSearchRequest],
	stream *connect.ServerStream[savingsv1.InterestAccrualSearchResponse],
) error {
	if err := s.authz.CanInterestAccrualView(ctx); err != nil {
		return authorizer.ToConnectError(err)
	}

	err := s.iaBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*savingsv1.InterestAccrualObject) error {
			return stream.Send(&savingsv1.InterestAccrualSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- Balance & Statement RPCs ---

func (s *SavingsServer) SavingsBalanceGet(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsBalanceGetRequest],
) (*connect.Response[savingsv1.SavingsBalanceGetResponse], error) {
	if err := s.authz.CanSavingsAccountView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	result, err := s.saBusiness.GetBalance(ctx, req.Msg.GetSavingsAccountId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&savingsv1.SavingsBalanceGetResponse{Data: result}), nil
}

func (s *SavingsServer) SavingsStatement(
	ctx context.Context,
	req *connect.Request[savingsv1.SavingsStatementRequest],
) (*connect.Response[savingsv1.SavingsStatementResponse], error) {
	if err := s.authz.CanSavingsAccountView(ctx); err != nil {
		return nil, authorizer.ToConnectError(err)
	}

	from := models.StringToTime(req.Msg.GetFromDate())
	to := models.StringToTime(req.Msg.GetToDate())
	var fromTime, toTime time.Time
	if from != nil {
		fromTime = *from
	}
	if to != nil {
		toTime = *to
	}
	result, err := s.saBusiness.GetStatement(ctx, req.Msg.GetSavingsAccountId(), fromTime, toTime)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(result), nil
}

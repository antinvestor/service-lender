package handlers

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	"buf.build/gen/go/antinvestor/funding/connectrpc/go/funding/v1/fundingv1connect"
	fundingv1 "buf.build/gen/go/antinvestor/funding/protocolbuffers/go/funding/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	moneyx "github.com/pitabwire/util/money"

	"github.com/antinvestor/service-fintech/apps/funding/service/business"
	"github.com/antinvestor/service-fintech/apps/funding/service/models"
	"github.com/antinvestor/service-fintech/pkg/apperrors"
)

// FundingServer implements the FundingService RPC handler.
// Tenant-level permission checks are handled by the FunctionAccessInterceptor.
type FundingServer struct {
	iaBusiness business.InvestorAccountBusiness
	faBusiness business.FundingAllocationBusiness

	fundingv1connect.UnimplementedFundingServiceHandler
}

func NewFundingServer(
	iaBusiness business.InvestorAccountBusiness,
	faBusiness business.FundingAllocationBusiness,
) fundingv1connect.FundingServiceHandler {
	return &FundingServer{
		iaBusiness: iaBusiness,
		faBusiness: faBusiness,
	}
}

// --- InvestorAccount RPCs ---

func (s *FundingServer) InvestorAccountSave(
	ctx context.Context,
	req *connect.Request[fundingv1.InvestorAccountSaveRequest],
) (*connect.Response[fundingv1.InvestorAccountSaveResponse], error) {
	account := investorAccountFromAPI(ctx, req.Msg.GetData())

	result, err := s.iaBusiness.Create(ctx, account)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}

	return connect.NewResponse(&fundingv1.InvestorAccountSaveResponse{
		Data: investorAccountToAPI(result),
	}), nil
}

func (s *FundingServer) InvestorAccountGet(
	ctx context.Context,
	req *connect.Request[fundingv1.InvestorAccountGetRequest],
) (*connect.Response[fundingv1.InvestorAccountGetResponse], error) {
	result, err := s.iaBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}

	return connect.NewResponse(&fundingv1.InvestorAccountGetResponse{
		Data: investorAccountToAPI(result),
	}), nil
}

func (s *FundingServer) InvestorAccountSearch(
	ctx context.Context,
	req *connect.Request[fundingv1.InvestorAccountSearchRequest],
	stream *connect.ServerStream[fundingv1.InvestorAccountSearchResponse],
) error {
	investorID := req.Msg.GetInvestorId()
	if investorID == "" {
		return apperrors.CleanErr(apperrors.ErrMissingRequiredData.Extend("investor_id is required"))
	}

	accounts, err := s.iaBusiness.GetByInvestorID(ctx, investorID)
	if err != nil {
		return apperrors.CleanErr(err)
	}

	// Filter by currency if specified.
	currencyCode := req.Msg.GetCurrencyCode()
	var apiResults []*fundingv1.InvestorAccountObject
	for _, acct := range accounts {
		if currencyCode != "" && acct.Currency != currencyCode {
			continue
		}
		apiResults = append(apiResults, investorAccountToAPI(acct))
	}

	return stream.Send(&fundingv1.InvestorAccountSearchResponse{Data: apiResults})
}

// --- Deposit / Withdraw RPCs ---

func (s *FundingServer) InvestorDeposit(
	ctx context.Context,
	req *connect.Request[fundingv1.InvestorDepositRequest],
) (*connect.Response[fundingv1.InvestorDepositResponse], error) {
	amount := moneyx.ToSmallestUnit(req.Msg.GetAmount(), 2)

	err := s.iaBusiness.Deposit(ctx, req.Msg.GetAccountId(), amount)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}

	updated, err := s.iaBusiness.Get(ctx, req.Msg.GetAccountId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}

	return connect.NewResponse(&fundingv1.InvestorDepositResponse{
		Data: investorAccountToAPI(updated),
	}), nil
}

func (s *FundingServer) InvestorWithdraw(
	ctx context.Context,
	req *connect.Request[fundingv1.InvestorWithdrawRequest],
) (*connect.Response[fundingv1.InvestorWithdrawResponse], error) {
	amount := moneyx.ToSmallestUnit(req.Msg.GetAmount(), 2)

	err := s.iaBusiness.Withdraw(ctx, req.Msg.GetAccountId(), amount)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}

	updated, err := s.iaBusiness.Get(ctx, req.Msg.GetAccountId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}

	return connect.NewResponse(&fundingv1.InvestorWithdrawResponse{
		Data: investorAccountToAPI(updated),
	}), nil
}

// --- Funding Allocation RPCs ---

func (s *FundingServer) FundLoan(
	ctx context.Context,
	req *connect.Request[fundingv1.FundLoanRequest],
) (*connect.Response[fundingv1.FundLoanResponse], error) {
	result, err := s.faBusiness.SourceForOffer(ctx, req.Msg.GetLoanOfferId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}

	return connect.NewResponse(fundLoanResultToAPI(result)), nil
}

func (s *FundingServer) AbsorbLoss(
	ctx context.Context,
	req *connect.Request[fundingv1.AbsorbLossRequest],
) (*connect.Response[fundingv1.AbsorbLossResponse], error) {
	amount := moneyx.ToSmallestUnit(req.Msg.GetAmount(), 2)

	err := s.faBusiness.AbsorbLoss(ctx, req.Msg.GetLoanOfferId(), amount)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}

	return connect.NewResponse(&fundingv1.AbsorbLossResponse{
		Absorbed: req.Msg.GetAmount(),
	}), nil
}

// --- Conversion helpers ---

// investorAccountToAPI converts a model InvestorAccount to the proto InvestorAccountObject.
func investorAccountToAPI(m *models.InvestorAccount) *fundingv1.InvestorAccountObject {
	return &fundingv1.InvestorAccountObject{
		Id:                m.GetID(),
		InvestorId:        m.InvestorID,
		AccountName:       m.AccountName,
		AvailableBalance:  moneyx.FromSmallestUnit(m.Currency, m.AvailableBalance, 2),
		ReservedBalance:   moneyx.FromSmallestUnit(m.Currency, m.ReservedBalance, 2),
		TotalDeployed:     moneyx.FromSmallestUnit(m.Currency, m.TotalDeployed, 2),
		TotalReturned:     moneyx.FromSmallestUnit(m.Currency, m.TotalReturned, 2),
		MaxExposure:       moneyx.FromSmallestUnit(m.Currency, m.MaxExposure, 2),
		MinInterestRate:   models.BasisPointsToString(m.MinInterestRate),
		AllowedProducts:   m.AllowedProducts.ToProtoStruct(),
		AllowedRegions:    m.AllowedRegions.ToProtoStruct(),
		GroupAffiliations: m.GroupAffiliations.ToProtoStruct(),
		State:             commonv1.STATE(m.State),
		Properties:        m.Properties.ToProtoStruct(),
	}
}

// investorAccountFromAPI converts a proto InvestorAccountObject to a model InvestorAccount.
func investorAccountFromAPI(ctx context.Context, obj *fundingv1.InvestorAccountObject) *models.InvestorAccount {
	if obj == nil {
		return nil
	}

	availBalance := moneyx.ToSmallestUnit(obj.GetAvailableBalance(), 2)
	currency := obj.GetAvailableBalance().GetCurrencyCode()
	maxExposure := moneyx.ToSmallestUnit(obj.GetMaxExposure(), 2)

	model := &models.InvestorAccount{
		InvestorID:       obj.GetInvestorId(),
		AccountName:      obj.GetAccountName(),
		Currency:         currency,
		AvailableBalance: availBalance,
		MaxExposure:      maxExposure,
		MinInterestRate:  models.StringToBasisPoints(obj.GetMinInterestRate()),
		State:            int32(obj.GetState()),
	}

	if obj.GetAllowedProducts() != nil {
		model.AllowedProducts = (&data.JSONMap{}).FromProtoStruct(obj.GetAllowedProducts())
	}
	if obj.GetAllowedRegions() != nil {
		model.AllowedRegions = (&data.JSONMap{}).FromProtoStruct(obj.GetAllowedRegions())
	}
	if obj.GetGroupAffiliations() != nil {
		model.GroupAffiliations = (&data.JSONMap{}).FromProtoStruct(obj.GetGroupAffiliations())
	}
	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// fundLoanResultToAPI converts the SourceForOffer result map to a FundLoanResponse.
func fundLoanResultToAPI(result map[string]interface{}) *fundingv1.FundLoanResponse {
	resp := &fundingv1.FundLoanResponse{}

	if fullyFunded, ok := result["fully_funded"].(bool); ok {
		resp.FullyFunded = fullyFunded
	}

	if totalAllocated, ok := result["total_allocated"].(int64); ok {
		currency, _ := result["currency"].(string)
		resp.TotalAllocated = moneyx.FromSmallestUnit(currency, totalAllocated, 2)
	}

	if deficit, ok := result["deficit"].(int64); ok {
		currency, _ := result["currency"].(string)
		resp.Deficit = moneyx.FromSmallestUnit(currency, deficit, 2)
	}

	if allocations, ok := result["allocations"].([]map[string]interface{}); ok {
		for _, alloc := range allocations {
			obj := &fundingv1.FundingAllocationObject{}
			if id, ok := alloc["id"].(string); ok {
				obj.Id = id
			}
			if loanOfferID, ok := alloc["loan_offer_id"].(string); ok {
				obj.LoanOfferId = loanOfferID
			}
			if sourceID, ok := alloc["source_id"].(string); ok {
				obj.SourceId = sourceID
			}
			if sourceType, ok := alloc["source_type"].(string); ok {
				obj.SourceType = sourceType
			}
			if trancheLevel, ok := alloc["tranche_level"].(int32); ok {
				obj.TrancheLevel = trancheLevel
			}
			if amount, ok := alloc["amount"].(int64); ok {
				currency, _ := alloc["currency"].(string)
				obj.Amount = moneyx.FromSmallestUnit(currency, amount, 2)
			}
			resp.Allocations = append(resp.Allocations, obj)
		}
	}

	return resp
}

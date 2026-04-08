package handlers

import (
	"context"

	"buf.build/gen/go/antinvestor/origination/connectrpc/go/origination/v1/originationv1connect"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"

	"github.com/antinvestor/service-fintech/apps/origination/service/business"
	"github.com/antinvestor/service-fintech/pkg/apperrors"
)

// OriginationServer implements the OriginationService RPC handler.
// Tenant-level permission checks are handled by the FunctionAccessInterceptor.
type OriginationServer struct {
	appBusiness business.ApplicationBusiness
	docBusiness business.ApplicationDocumentBusiness
	vtBusiness  business.VerificationTaskBusiness
	udBusiness  business.UnderwritingDecisionBusiness

	originationv1connect.UnimplementedOriginationServiceHandler
}

func NewOriginationServer(
	appBusiness business.ApplicationBusiness,
	docBusiness business.ApplicationDocumentBusiness,
	vtBusiness business.VerificationTaskBusiness,
	udBusiness business.UnderwritingDecisionBusiness,
) originationv1connect.OriginationServiceHandler {
	return &OriginationServer{
		appBusiness: appBusiness,
		docBusiness: docBusiness,
		vtBusiness:  vtBusiness,
		udBusiness:  udBusiness,
	}
}

// --- Application RPCs ---

func (s *OriginationServer) ApplicationSave(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationSaveRequest],
) (*connect.Response[originationv1.ApplicationSaveResponse], error) {
	result, err := s.appBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.ApplicationSaveResponse{Data: result}), nil
}

func (s *OriginationServer) ApplicationGet(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationGetRequest],
) (*connect.Response[originationv1.ApplicationGetResponse], error) {
	result, err := s.appBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.ApplicationGetResponse{Data: result}), nil
}

func (s *OriginationServer) ApplicationSearch(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationSearchRequest],
	stream *connect.ServerStream[originationv1.ApplicationSearchResponse],
) error {
	err := s.appBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*originationv1.ApplicationObject) error {
			return stream.Send(&originationv1.ApplicationSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *OriginationServer) ApplicationSubmit(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationSubmitRequest],
) (*connect.Response[originationv1.ApplicationSubmitResponse], error) {
	result, err := s.appBusiness.Submit(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.ApplicationSubmitResponse{Data: result}), nil
}

func (s *OriginationServer) ApplicationCancel(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationCancelRequest],
) (*connect.Response[originationv1.ApplicationCancelResponse], error) {
	result, err := s.appBusiness.Cancel(ctx, req.Msg.GetId(), req.Msg.GetReason())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.ApplicationCancelResponse{Data: result}), nil
}

func (s *OriginationServer) ApplicationAcceptOffer(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationAcceptOfferRequest],
) (*connect.Response[originationv1.ApplicationAcceptOfferResponse], error) {
	result, err := s.appBusiness.AcceptOffer(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.ApplicationAcceptOfferResponse{Data: result}), nil
}

func (s *OriginationServer) ApplicationDeclineOffer(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationDeclineOfferRequest],
) (*connect.Response[originationv1.ApplicationDeclineOfferResponse], error) {
	result, err := s.appBusiness.DeclineOffer(ctx, req.Msg.GetId(), req.Msg.GetReason())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.ApplicationDeclineOfferResponse{Data: result}), nil
}

// --- ApplicationDocument RPCs ---

func (s *OriginationServer) ApplicationDocumentSave(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationDocumentSaveRequest],
) (*connect.Response[originationv1.ApplicationDocumentSaveResponse], error) {
	result, err := s.docBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.ApplicationDocumentSaveResponse{Data: result}), nil
}

func (s *OriginationServer) ApplicationDocumentGet(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationDocumentGetRequest],
) (*connect.Response[originationv1.ApplicationDocumentGetResponse], error) {
	result, err := s.docBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.ApplicationDocumentGetResponse{Data: result}), nil
}

func (s *OriginationServer) ApplicationDocumentSearch(
	ctx context.Context,
	req *connect.Request[originationv1.ApplicationDocumentSearchRequest],
	stream *connect.ServerStream[originationv1.ApplicationDocumentSearchResponse],
) error {
	err := s.docBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*originationv1.ApplicationDocumentObject) error {
			return stream.Send(&originationv1.ApplicationDocumentSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

// --- VerificationTask RPCs ---

func (s *OriginationServer) VerificationTaskSave(
	ctx context.Context,
	req *connect.Request[originationv1.VerificationTaskSaveRequest],
) (*connect.Response[originationv1.VerificationTaskSaveResponse], error) {
	result, err := s.vtBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.VerificationTaskSaveResponse{Data: result}), nil
}

func (s *OriginationServer) VerificationTaskGet(
	ctx context.Context,
	req *connect.Request[originationv1.VerificationTaskGetRequest],
) (*connect.Response[originationv1.VerificationTaskGetResponse], error) {
	result, err := s.vtBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.VerificationTaskGetResponse{Data: result}), nil
}

func (s *OriginationServer) VerificationTaskSearch(
	ctx context.Context,
	req *connect.Request[originationv1.VerificationTaskSearchRequest],
	stream *connect.ServerStream[originationv1.VerificationTaskSearchResponse],
) error {
	err := s.vtBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*originationv1.VerificationTaskObject) error {
			return stream.Send(&originationv1.VerificationTaskSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

func (s *OriginationServer) VerificationTaskComplete(
	ctx context.Context,
	req *connect.Request[originationv1.VerificationTaskCompleteRequest],
) (*connect.Response[originationv1.VerificationTaskCompleteResponse], error) {
	result, err := s.vtBusiness.Complete(ctx, req.Msg)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.VerificationTaskCompleteResponse{Data: result}), nil
}

// --- UnderwritingDecision RPCs ---

func (s *OriginationServer) UnderwritingDecisionSave(
	ctx context.Context,
	req *connect.Request[originationv1.UnderwritingDecisionSaveRequest],
) (*connect.Response[originationv1.UnderwritingDecisionSaveResponse], error) {
	result, err := s.udBusiness.Save(ctx, req.Msg.GetData())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.UnderwritingDecisionSaveResponse{Data: result}), nil
}

func (s *OriginationServer) UnderwritingDecisionGet(
	ctx context.Context,
	req *connect.Request[originationv1.UnderwritingDecisionGetRequest],
) (*connect.Response[originationv1.UnderwritingDecisionGetResponse], error) {
	result, err := s.udBusiness.Get(ctx, req.Msg.GetId())
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}
	return connect.NewResponse(&originationv1.UnderwritingDecisionGetResponse{Data: result}), nil
}

func (s *OriginationServer) UnderwritingDecisionSearch(
	ctx context.Context,
	req *connect.Request[originationv1.UnderwritingDecisionSearchRequest],
	stream *connect.ServerStream[originationv1.UnderwritingDecisionSearchResponse],
) error {
	err := s.udBusiness.Search(ctx, req.Msg,
		func(_ context.Context, batch []*originationv1.UnderwritingDecisionObject) error {
			return stream.Send(&originationv1.UnderwritingDecisionSearchResponse{Data: batch})
		})
	if err != nil {
		return apperrors.CleanErr(err)
	}
	return nil
}

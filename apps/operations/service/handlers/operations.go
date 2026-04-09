package handlers

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	"buf.build/gen/go/antinvestor/operations/connectrpc/go/operations/v1/operationsv1connect"
	operationsv1 "buf.build/gen/go/antinvestor/operations/protocolbuffers/go/operations/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/workerpool"
	moneyx "github.com/pitabwire/util/money"

	"github.com/antinvestor/service-fintech/apps/operations/service/business"
	"github.com/antinvestor/service-fintech/apps/operations/service/models"
	"github.com/antinvestor/service-fintech/apps/operations/service/repository"
	"github.com/antinvestor/service-fintech/pkg/apperrors"
)

// OperationsServer implements the OperationsService RPC handler.
// Tenant-level permission checks are handled by the FunctionAccessInterceptor.
type OperationsServer struct {
	toBusiness business.TransferOrderBusiness
	toRepo     repository.TransferOrderRepository

	operationsv1connect.UnimplementedOperationsServiceHandler
}

func NewOperationsServer(
	toBusiness business.TransferOrderBusiness,
	toRepo repository.TransferOrderRepository,
) operationsv1connect.OperationsServiceHandler {
	return &OperationsServer{
		toBusiness: toBusiness,
		toRepo:     toRepo,
	}
}

func (s *OperationsServer) TransferOrderExecute(
	ctx context.Context,
	req *connect.Request[operationsv1.TransferOrderExecuteRequest],
) (*connect.Response[operationsv1.TransferOrderExecuteResponse], error) {
	obj := req.Msg.GetData()

	// If the order has an ID, execute an existing order.
	// Otherwise create it first, then execute.
	orderID := obj.GetId()
	if orderID == "" {
		order := transferOrderFromAPI(ctx, obj)
		if err := s.toBusiness.Save(ctx, order); err != nil {
			return nil, apperrors.CleanErr(err)
		}
		orderID = order.GetID()
	}

	if err := s.toBusiness.Execute(ctx, orderID); err != nil {
		return nil, apperrors.CleanErr(err)
	}

	result, err := s.toRepo.GetByID(ctx, orderID)
	if err != nil {
		return nil, apperrors.CleanErr(err)
	}

	return connect.NewResponse(&operationsv1.TransferOrderExecuteResponse{
		Data: transferOrderToAPI(result),
	}), nil
}

func (s *OperationsServer) TransferOrderSearch(
	ctx context.Context,
	req *connect.Request[operationsv1.TransferOrderSearchRequest],
	stream *connect.ServerStream[operationsv1.TransferOrderSearchResponse],
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
	if req.Msg.GetOrderType() != 0 {
		andQueryVal["order_type = ?"] = req.Msg.GetOrderType()
	}
	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	if req.Msg.GetQuery() != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{
					"reference ILIKE ?":   "%" + req.Msg.GetQuery() + "%",
					"description ILIKE ?": "%" + req.Msg.GetQuery() + "%",
				},
			),
		)
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := s.toRepo.Search(ctx, query)
	if err != nil {
		return apperrors.CleanErr(err)
	}

	return workerpool.ConsumeResultStream(ctx, results, func(batch []*models.TransferOrder) error {
		var apiResults []*operationsv1.TransferOrderObject
		for _, order := range batch {
			apiResults = append(apiResults, transferOrderToAPI(order))
		}
		return stream.Send(&operationsv1.TransferOrderSearchResponse{Data: apiResults})
	})
}

// transferOrderFromAPI converts a proto TransferOrderObject to a TransferOrder model.
func transferOrderFromAPI(ctx context.Context, obj *operationsv1.TransferOrderObject) *models.TransferOrder {
	amount := moneyx.ToSmallestUnit(obj.GetAmount(), 2)
	currency := obj.GetAmount().GetCurrencyCode()
	m := &models.TransferOrder{
		DebitAccountRef:  obj.GetDebitAccountRef(),
		CreditAccountRef: obj.GetCreditAccountRef(),
		Amount:           amount,
		Currency:         currency,
		OrderType:        obj.GetOrderType(),
		Reference:        obj.GetReference(),
		Description:      obj.GetDescription(),
		State:            int32(obj.GetState()),
	}
	if obj.GetExtraData() != nil {
		m.ExtraData = (&data.JSONMap{}).FromProtoStruct(obj.GetExtraData())
	}
	m.GenID(ctx)
	if obj.GetId() != "" {
		m.ID = obj.GetId()
	}
	return m
}

// transferOrderToAPI converts a TransferOrder model to the proto TransferOrderObject.
func transferOrderToAPI(m *models.TransferOrder) *operationsv1.TransferOrderObject {
	return &operationsv1.TransferOrderObject{
		Id:               m.GetID(),
		DebitAccountRef:  m.DebitAccountRef,
		CreditAccountRef: m.CreditAccountRef,
		Amount:           moneyx.FromSmallestUnit(m.Currency, m.Amount, 2),
		OrderType:        m.OrderType,
		Reference:        m.Reference,
		Description:      m.Description,
		ExtraData:        m.ExtraData.ToProtoStruct(),
		State:            commonv1.STATE(m.State),
	}
}

package business

import (
	"context"
	"strconv"

	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/loans/service/events"
	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
)

type PenaltyBusiness interface {
	Save(ctx context.Context, obj *loansv1.PenaltyObject) (*loansv1.PenaltyObject, error)
	Waive(ctx context.Context, id, reason string) (*loansv1.PenaltyObject, error)
	Search(
		ctx context.Context,
		req *loansv1.PenaltySearchRequest,
		consumer func(ctx context.Context, batch []*loansv1.PenaltyObject) error,
	) error
}

type penaltyBusiness struct {
	eventsMan   fevents.Manager
	penaltyRepo repository.PenaltyRepository
}

func NewPenaltyBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	penaltyRepo repository.PenaltyRepository,
) PenaltyBusiness {
	return &penaltyBusiness{
		eventsMan:   eventsMan,
		penaltyRepo: penaltyRepo,
	}
}

func (b *penaltyBusiness) Save(ctx context.Context, obj *loansv1.PenaltyObject) (*loansv1.PenaltyObject, error) {
	logger := util.Log(ctx).WithField("method", "PenaltyBusiness.Save")

	penalty := models.PenaltyFromAPI(ctx, obj)

	err := b.eventsMan.Emit(ctx, events.PenaltySaveEvent, penalty)
	if err != nil {
		logger.WithError(err).Error("could not emit penalty save event")
		return nil, err
	}

	return penalty.ToAPI(), nil
}

func (b *penaltyBusiness) Waive(ctx context.Context, id, reason string) (*loansv1.PenaltyObject, error) {
	logger := util.Log(ctx).WithField("method", "PenaltyBusiness.Waive")

	penalty, err := b.penaltyRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrPenaltyNotFound
	}

	if penalty.IsWaived {
		return nil, ErrPenaltyAlreadyWaived
	}

	penalty.IsWaived = true
	penalty.WaivedReason = reason
	// TODO: set WaivedBy from the current user context

	err = b.eventsMan.Emit(ctx, events.PenaltySaveEvent, penalty)
	if err != nil {
		logger.WithError(err).Error("could not emit penalty save event")
		return nil, err
	}

	return penalty.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *penaltyBusiness) Search(
	ctx context.Context,
	req *loansv1.PenaltySearchRequest,
	consumer func(ctx context.Context, batch []*loansv1.PenaltyObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "PenaltyBusiness.Search")

	var searchOpts []data.SearchOption

	cursor := req.GetCursor()
	if cursor != nil {
		offset, offsetErr := strconv.Atoi(cursor.GetPage())
		if offsetErr != nil {
			offset = 0
		}
		searchOpts = append(searchOpts, data.WithSearchOffset(offset), data.WithSearchLimit(int(cursor.GetLimit())))
	}

	andQueryVal := map[string]any{}
	if req.GetLoanAccountId() != "" {
		andQueryVal["loan_account_id = ?"] = req.GetLoanAccountId()
	}
	if req.GetPenaltyType() != loansv1.PenaltyType_PENALTY_TYPE_UNSPECIFIED {
		andQueryVal["penalty_type = ?"] = int32(req.GetPenaltyType())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.penaltyRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search penalties")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Penalty) error {
		var apiResults []*loansv1.PenaltyObject
		for _, p := range res {
			apiResults = append(apiResults, p.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

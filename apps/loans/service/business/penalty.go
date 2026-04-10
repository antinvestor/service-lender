package business

import (
	"context"

	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/loans/service/events"
	"github.com/antinvestor/service-fintech/apps/loans/service/models"
	"github.com/antinvestor/service-fintech/apps/loans/service/repository"
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

	err = b.eventsMan.Emit(ctx, events.PenaltySaveEvent, penalty)
	if err != nil {
		logger.WithError(err).Error("could not emit penalty save event")
		return nil, err
	}

	return penalty.ToAPI(), nil
}

func (b *penaltyBusiness) Search(
	ctx context.Context,
	req *loansv1.PenaltySearchRequest,
	consumer func(ctx context.Context, batch []*loansv1.PenaltyObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "PenaltyBusiness.Search")

	andQueryVal := map[string]any{}
	if req.GetLoanAccountId() != "" {
		andQueryVal["loan_account_id = ?"] = req.GetLoanAccountId()
	}
	if req.GetPenaltyType() != loansv1.PenaltyType_PENALTY_TYPE_UNSPECIFIED {
		andQueryVal["penalty_type = ?"] = int32(req.GetPenaltyType())
	}

	return executeSearch(
		ctx,
		logger,
		b.penaltyRepo.Search,
		req.GetCursor(),
		andQueryVal,
		"failed to search penalties",
		func(p *models.Penalty) *loansv1.PenaltyObject {
			return p.ToAPI()
		},
		consumer,
	)
}

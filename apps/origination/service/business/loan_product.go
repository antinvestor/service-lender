package business

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/events"
	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
)

type LoanProductBusiness interface {
	Save(ctx context.Context, obj *originationv1.LoanProductObject) (*originationv1.LoanProductObject, error)
	Get(ctx context.Context, id string) (*originationv1.LoanProductObject, error)
	Search(
		ctx context.Context,
		req *originationv1.LoanProductSearchRequest,
		consumer func(ctx context.Context, batch []*originationv1.LoanProductObject) error,
	) error
}

type loanProductBusiness struct {
	eventsMan fevents.Manager
	lpRepo    repository.LoanProductRepository
}

func NewLoanProductBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	lpRepo repository.LoanProductRepository,
) LoanProductBusiness {
	return &loanProductBusiness{
		eventsMan: eventsMan,
		lpRepo:    lpRepo,
	}
}

func (b *loanProductBusiness) Save(
	ctx context.Context,
	obj *originationv1.LoanProductObject,
) (*originationv1.LoanProductObject, error) {
	logger := util.Log(ctx).WithField("method", "LoanProductBusiness.Save")

	lp := models.LoanProductFromAPI(ctx, obj)

	if obj.GetId() == "" && lp.State == 0 {
		lp.State = int32(commonv1.STATE_ACTIVE)
	}

	err := b.eventsMan.Emit(ctx, events.LoanProductSaveEvent, lp)
	if err != nil {
		logger.WithError(err).Error("could not emit loan product save event")
		return nil, err
	}

	return lp.ToAPI(), nil
}

func (b *loanProductBusiness) Get(ctx context.Context, id string) (*originationv1.LoanProductObject, error) {
	lp, err := b.lpRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrProductNotFound
	}
	return lp.ToAPI(), nil
}

func (b *loanProductBusiness) Search(
	ctx context.Context,
	req *originationv1.LoanProductSearchRequest,
	consumer func(ctx context.Context, batch []*originationv1.LoanProductObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "LoanProductBusiness.Search")

	andQueryVal := map[string]any{}
	if req.GetOrganizationId() != "" {
		andQueryVal["organization_id = ?"] = req.GetOrganizationId()
	}
	if req.GetProductType() != originationv1.LoanProductType_LOAN_PRODUCT_TYPE_UNSPECIFIED {
		andQueryVal["product_type = ?"] = int32(req.GetProductType())
	}

	return executeSearch(
		ctx,
		logger,
		b.lpRepo.Search,
		req.GetCursor(),
		andQueryVal,
		req.GetQuery(),
		"failed to search loan products",
		func(lp *models.LoanProduct) *originationv1.LoanProductObject {
			return lp.ToAPI()
		},
		consumer,
	)
}

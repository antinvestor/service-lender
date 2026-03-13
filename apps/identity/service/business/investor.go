package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	lenderv1 "buf.build/gen/go/antinvestor/lender/protocolbuffers/go/lender/v1"
	"github.com/antinvestor/service-lender/apps/identity/service/events"
	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"
)

type InvestorBusiness interface {
	Save(ctx context.Context, obj *lenderv1.InvestorObject) (*lenderv1.InvestorObject, error)
	Get(ctx context.Context, id string) (*lenderv1.InvestorObject, error)
	Search(ctx context.Context, req *lenderv1.InvestorSearchRequest, consumer func(ctx context.Context, batch []*lenderv1.InvestorObject) error) error
}

type investorBusiness struct {
	eventsMan    fevents.Manager
	investorRepo repository.InvestorRepository
}

func NewInvestorBusiness(_ context.Context, eventsMan fevents.Manager,
	investorRepo repository.InvestorRepository,
) InvestorBusiness {
	return &investorBusiness{
		eventsMan:    eventsMan,
		investorRepo: investorRepo,
	}
}

func (b *investorBusiness) Save(ctx context.Context, obj *lenderv1.InvestorObject) (*lenderv1.InvestorObject, error) {
	logger := util.Log(ctx).WithField("method", "InvestorBusiness.Save")

	investor := models.InvestorFromAPI(ctx, obj)

	if investor.State == 0 {
		investor.State = int32(commonv1.STATE_CREATED.Number())
	}

	err := b.eventsMan.Emit(ctx, events.InvestorSaveEvent, investor)
	if err != nil {
		logger.WithError(err).Error("could not emit investor save event")
		return nil, err
	}

	return investor.ToAPI(), nil
}

func (b *investorBusiness) Get(ctx context.Context, id string) (*lenderv1.InvestorObject, error) {
	investor, err := b.investorRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return investor.ToAPI(), nil
}

func (b *investorBusiness) Search(ctx context.Context, req *lenderv1.InvestorSearchRequest, consumer func(ctx context.Context, batch []*lenderv1.InvestorObject) error) error {
	logger := util.Log(ctx).WithField("method", "InvestorBusiness.Search")

	var searchOpts []data.SearchOption

	cursor := req.GetCursor()
	if cursor != nil {
		offset, offsetErr := strconv.Atoi(cursor.GetPage())
		if offsetErr != nil {
			offset = 0
		}
		searchOpts = append(searchOpts, data.WithSearchOffset(offset), data.WithSearchLimit(int(cursor.GetLimit())))
	}

	if req.GetQuery() != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{"searchable @@ websearch_to_tsquery( 'english', ?) ": req.GetQuery()},
			),
		)
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.investorRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search investors")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Investor) error {
		var apiResults []*lenderv1.InvestorObject
		for _, investor := range res {
			apiResults = append(apiResults, investor.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

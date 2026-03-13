package business

import (
	"context"
	"fmt"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	lenderv1 "buf.build/gen/go/antinvestor/lender/protocolbuffers/go/lender/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/events"
	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

type BankBusiness interface {
	Save(ctx context.Context, obj *lenderv1.BankObject) (*lenderv1.BankObject, error)
	Get(ctx context.Context, id string) (*lenderv1.BankObject, error)
	Search(
		ctx context.Context,
		search *commonv1.SearchRequest,
		consumer func(ctx context.Context, batch []*lenderv1.BankObject) error,
	) error
}

type bankBusiness struct {
	eventsMan fevents.Manager
	bankRepo  repository.BankRepository
}

func NewBankBusiness(_ context.Context, eventsMan fevents.Manager, bankRepo repository.BankRepository) BankBusiness {
	return &bankBusiness{
		eventsMan: eventsMan,
		bankRepo:  bankRepo,
	}
}

func (b *bankBusiness) Save(ctx context.Context, obj *lenderv1.BankObject) (*lenderv1.BankObject, error) {
	logger := util.Log(ctx).WithField("method", "BankBusiness.Save")

	bank := models.BankFromAPI(ctx, obj)

	if bank.State == 0 {
		bank.State = int32(commonv1.STATE_CREATED.Number())
	}

	err := b.eventsMan.Emit(ctx, events.BankSaveEvent, bank)
	if err != nil {
		logger.WithError(err).Error("could not emit bank save event")
		return nil, err
	}

	return bank.ToAPI(), nil
}

func (b *bankBusiness) Get(ctx context.Context, id string) (*lenderv1.BankObject, error) {
	bank, err := b.bankRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return bank.ToAPI(), nil
}

func (b *bankBusiness) Search(
	ctx context.Context,
	searchQuery *commonv1.SearchRequest,
	consumer func(ctx context.Context, batch []*lenderv1.BankObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "BankBusiness.Search")

	var searchOpts []data.SearchOption

	cursor := searchQuery.GetCursor()
	if cursor != nil {
		offset, offsetErr := strconv.Atoi(cursor.GetPage())
		if offsetErr != nil {
			offset = 0
		}
		searchOpts = append(searchOpts, data.WithSearchOffset(offset), data.WithSearchLimit(int(cursor.GetLimit())))
	}

	andQueryVal := map[string]any{}
	for k, v := range searchQuery.GetExtras().AsMap() {
		andQueryVal[fmt.Sprintf("%s = ?", k)] = v
	}

	if searchQuery.GetIdQuery() != "" {
		andQueryVal["id = ?"] = searchQuery.GetIdQuery()
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	if searchQuery.GetQuery() != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{"searchable @@ websearch_to_tsquery( 'english', ?) ": searchQuery.GetQuery()},
			),
		)
		for _, filter := range searchQuery.GetProperties() {
			searchOpts = append(searchOpts,
				data.WithSearchFiltersOrByValue(map[string]any{fmt.Sprintf(" %s = ?", filter): searchQuery.GetQuery()}),
			)
		}
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.bankRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search banks")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Bank) error {
		var apiResults []*lenderv1.BankObject
		for _, bank := range res {
			apiResults = append(apiResults, bank.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

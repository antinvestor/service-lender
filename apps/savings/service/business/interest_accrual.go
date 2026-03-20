package business

import (
	"context"
	"strconv"

	savingsv1 "buf.build/gen/go/antinvestor/savings/protocolbuffers/go/savings/v1"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/savings/service/models"
	"github.com/antinvestor/service-lender/apps/savings/service/repository"
)

type InterestAccrualBusiness interface {
	Get(ctx context.Context, id string) (*savingsv1.InterestAccrualObject, error)
	Search(
		ctx context.Context,
		req *savingsv1.InterestAccrualSearchRequest,
		consumer func(ctx context.Context, batch []*savingsv1.InterestAccrualObject) error,
	) error
}

type interestAccrualBusiness struct {
	iaRepo repository.InterestAccrualRepository
}

func NewInterestAccrualBusiness(
	_ context.Context,
	iaRepo repository.InterestAccrualRepository,
) InterestAccrualBusiness {
	return &interestAccrualBusiness{
		iaRepo: iaRepo,
	}
}

func (b *interestAccrualBusiness) Get(ctx context.Context, id string) (*savingsv1.InterestAccrualObject, error) {
	ia, err := b.iaRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrInterestAccrualNotFound
	}
	return ia.ToAPI(), nil
}

func (b *interestAccrualBusiness) Search(
	ctx context.Context,
	req *savingsv1.InterestAccrualSearchRequest,
	consumer func(ctx context.Context, batch []*savingsv1.InterestAccrualObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "InterestAccrualBusiness.Search")

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
	if req.GetSavingsAccountId() != "" {
		andQueryVal["savings_account_id = ?"] = req.GetSavingsAccountId()
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.iaRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search interest accruals")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.InterestAccrual) error {
		var apiResults []*savingsv1.InterestAccrualObject
		for _, ia := range res {
			apiResults = append(apiResults, ia.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

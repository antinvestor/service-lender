package business

import (
	"context"
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

type BranchBusiness interface {
	Save(ctx context.Context, obj *lenderv1.BranchObject) (*lenderv1.BranchObject, error)
	Get(ctx context.Context, id string) (*lenderv1.BranchObject, error)
	Search(
		ctx context.Context,
		req *lenderv1.BranchSearchRequest,
		consumer func(ctx context.Context, batch []*lenderv1.BranchObject) error,
	) error
}

type branchBusiness struct {
	eventsMan  fevents.Manager
	bankRepo   repository.BankRepository
	branchRepo repository.BranchRepository
}

func NewBranchBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	bankRepo repository.BankRepository,
	branchRepo repository.BranchRepository,
) BranchBusiness {
	return &branchBusiness{
		eventsMan:  eventsMan,
		bankRepo:   bankRepo,
		branchRepo: branchRepo,
	}
}

func (b *branchBusiness) Save(ctx context.Context, obj *lenderv1.BranchObject) (*lenderv1.BranchObject, error) {
	logger := util.Log(ctx).WithField("method", "BranchBusiness.Save")

	// Validate bank exists
	_, err := b.bankRepo.GetByID(ctx, obj.GetBankId())
	if err != nil {
		logger.WithError(err).Warn("bank not found for branch")
		return nil, ErrBankNotFound
	}

	branch := models.BranchFromAPI(ctx, obj)

	if branch.State == 0 {
		branch.State = int32(commonv1.STATE_CREATED.Number())
	}

	err = b.eventsMan.Emit(ctx, events.BranchSaveEvent, branch)
	if err != nil {
		logger.WithError(err).Error("could not emit branch save event")
		return nil, err
	}

	return branch.ToAPI(), nil
}

func (b *branchBusiness) Get(ctx context.Context, id string) (*lenderv1.BranchObject, error) {
	branch, err := b.branchRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return branch.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *branchBusiness) Search(
	ctx context.Context,
	req *lenderv1.BranchSearchRequest,
	consumer func(ctx context.Context, batch []*lenderv1.BranchObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "BranchBusiness.Search")

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
	if req.GetBankId() != "" {
		andQueryVal["bank_id = ?"] = req.GetBankId()
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	if req.GetQuery() != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{"searchable @@ websearch_to_tsquery( 'english', ?) ": req.GetQuery()},
			),
		)
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.branchRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search branches")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Branch) error {
		var apiResults []*lenderv1.BranchObject
		for _, branch := range res {
			apiResults = append(apiResults, branch.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

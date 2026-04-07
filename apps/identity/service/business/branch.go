package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/events"
	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

type BranchBusiness interface {
	Save(ctx context.Context, obj *identityv1.BranchObject) (*identityv1.BranchObject, error)
	Get(ctx context.Context, id string) (*identityv1.BranchObject, error)
	Search(
		ctx context.Context,
		req *identityv1.BranchSearchRequest,
		consumer func(ctx context.Context, batch []*identityv1.BranchObject) error,
	) error
}

type branchBusiness struct {
	eventsMan        fevents.Manager
	organizationRepo repository.OrganizationRepository
	branchRepo       repository.BranchRepository
}

func NewBranchBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	organizationRepo repository.OrganizationRepository,
	branchRepo repository.BranchRepository,
) BranchBusiness {
	return &branchBusiness{
		eventsMan:        eventsMan,
		organizationRepo: organizationRepo,
		branchRepo:       branchRepo,
	}
}

func (b *branchBusiness) Save(ctx context.Context, obj *identityv1.BranchObject) (*identityv1.BranchObject, error) {
	logger := util.Log(ctx).WithField("method", "BranchBusiness.Save")

	// Validate organization exists
	_, err := b.organizationRepo.GetByID(ctx, obj.GetOrganizationId())
	if err != nil {
		logger.WithError(err).Warn("organization not found for branch")
		return nil, ErrOrganizationNotFound
	}

	isNew := obj.GetId() == ""
	branch := models.BranchFromAPI(ctx, obj)

	if isNew && branch.State == 0 {
		branch.State = int32(commonv1.STATE_CREATED.Number())
	}

	err = b.eventsMan.Emit(ctx, events.BranchSaveEvent, branch)
	if err != nil {
		logger.WithError(err).Error("could not emit branch save event")
		return nil, err
	}

	return branch.ToAPI(), nil
}

func (b *branchBusiness) Get(ctx context.Context, id string) (*identityv1.BranchObject, error) {
	branch, err := b.branchRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrBranchNotFound
	}
	return branch.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *branchBusiness) Search(
	ctx context.Context,
	req *identityv1.BranchSearchRequest,
	consumer func(ctx context.Context, batch []*identityv1.BranchObject) error,
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
	if req.GetOrganizationId() != "" {
		andQueryVal["organization_id = ?"] = req.GetOrganizationId()
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
		var apiResults []*identityv1.BranchObject
		for _, branch := range res {
			apiResults = append(apiResults, branch.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

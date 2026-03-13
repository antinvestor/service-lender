package business

import (
	"context"
	"strconv"

	lenderv1 "buf.build/gen/go/antinvestor/lender/protocolbuffers/go/lender/v1"
	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/events"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/models"
	"github.com/antinvestor/service-ant-lender/apps/identity/service/repository"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"
)

type SystemUserBusiness interface {
	Save(ctx context.Context, obj *lenderv1.SystemUserObject) (*lenderv1.SystemUserObject, error)
	Get(ctx context.Context, id string) (*lenderv1.SystemUserObject, error)
	Search(ctx context.Context, req *lenderv1.SystemUserSearchRequest, consumer func(ctx context.Context, batch []*lenderv1.SystemUserObject) error) error
}

type systemUserBusiness struct {
	eventsMan      fevents.Manager
	branchRepo     repository.BranchRepository
	systemUserRepo repository.SystemUserRepository
}

func NewSystemUserBusiness(_ context.Context, eventsMan fevents.Manager, branchRepo repository.BranchRepository, systemUserRepo repository.SystemUserRepository) SystemUserBusiness {
	return &systemUserBusiness{
		eventsMan:      eventsMan,
		branchRepo:     branchRepo,
		systemUserRepo: systemUserRepo,
	}
}

func (b *systemUserBusiness) Save(ctx context.Context, obj *lenderv1.SystemUserObject) (*lenderv1.SystemUserObject, error) {
	logger := util.Log(ctx).WithField("method", "SystemUserBusiness.Save")

	// Validate branch exists
	_, err := b.branchRepo.GetByID(ctx, obj.GetBranchId())
	if err != nil {
		logger.WithError(err).Warn("branch not found for system user")
		return nil, ErrBranchNotFound
	}

	su := models.SystemUserFromAPI(ctx, obj)

	if su.State == 0 {
		su.State = int32(commonv1.STATE_CREATED.Number())
	}

	err = b.eventsMan.Emit(ctx, events.SystemUserSaveEvent, su)
	if err != nil {
		logger.WithError(err).Error("could not emit system user save event")
		return nil, err
	}

	return su.ToAPI(), nil
}

func (b *systemUserBusiness) Get(ctx context.Context, id string) (*lenderv1.SystemUserObject, error) {
	su, err := b.systemUserRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return su.ToAPI(), nil
}

func (b *systemUserBusiness) Search(ctx context.Context, req *lenderv1.SystemUserSearchRequest, consumer func(ctx context.Context, batch []*lenderv1.SystemUserObject) error) error {
	logger := util.Log(ctx).WithField("method", "SystemUserBusiness.Search")

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
	if req.GetRole() != lenderv1.SystemUserRole_SYSTEM_USER_ROLE_UNSPECIFIED {
		andQueryVal["role = ?"] = int32(req.GetRole())
	}
	if req.GetBranchId() != "" {
		andQueryVal["branch_id = ?"] = req.GetBranchId()
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
	results, err := b.systemUserRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search system users")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.SystemUser) error {
		var apiResults []*lenderv1.SystemUserObject
		for _, su := range res {
			apiResults = append(apiResults, su.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

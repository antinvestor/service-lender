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

type GroupBusiness interface {
	Save(ctx context.Context, obj *identityv1.GroupObject) (*identityv1.GroupObject, error)
	Get(ctx context.Context, id string) (*identityv1.GroupObject, error)
	Search(
		ctx context.Context,
		req *identityv1.GroupSearchRequest,
		consumer func(ctx context.Context, batch []*identityv1.GroupObject) error,
	) error
}

type groupBusiness struct {
	eventsMan fevents.Manager
	agentRepo repository.AgentRepository
	groupRepo repository.GroupRepository
}

func NewGroupBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	agentRepo repository.AgentRepository,
	groupRepo repository.GroupRepository,
) GroupBusiness {
	return &groupBusiness{
		eventsMan: eventsMan,
		agentRepo: agentRepo,
		groupRepo: groupRepo,
	}
}

func (b *groupBusiness) Save(ctx context.Context, obj *identityv1.GroupObject) (*identityv1.GroupObject, error) {
	logger := util.Log(ctx).WithField("method", "GroupBusiness.Save")

	// Validate agent exists and is active
	agent, err := b.agentRepo.GetByID(ctx, obj.GetAgentId())
	if err != nil {
		logger.WithError(err).Warn("agent not found for group")
		return nil, ErrAgentNotFound
	}

	if commonv1.STATE(agent.State) != commonv1.STATE_ACTIVE &&
		commonv1.STATE(agent.State) != commonv1.STATE_CREATED {
		return nil, ErrAgentInactive
	}

	isNew := obj.GetId() == ""
	group := models.GroupFromAPI(ctx, obj)

	if isNew && group.State == 0 {
		group.State = int32(commonv1.STATE_CREATED.Number())
	}

	err = b.eventsMan.Emit(ctx, events.GroupSaveEvent, group)
	if err != nil {
		logger.WithError(err).Error("could not emit group save event")
		return nil, err
	}

	return group.ToAPI(), nil
}

func (b *groupBusiness) Get(ctx context.Context, id string) (*identityv1.GroupObject, error) {
	group, err := b.groupRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrGroupNotFound
	}
	return group.ToAPI(), nil
}

func (b *groupBusiness) Search(
	ctx context.Context,
	req *identityv1.GroupSearchRequest,
	consumer func(ctx context.Context, batch []*identityv1.GroupObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "GroupBusiness.Search")

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
	if req.GetAgentId() != "" {
		andQueryVal["agent_id = ?"] = req.GetAgentId()
	}
	if req.GetBranchId() != "" {
		andQueryVal["branch_id = ?"] = req.GetBranchId()
	}
	if req.GetGroupType() != identityv1.GroupType_GROUP_TYPE_UNSPECIFIED {
		andQueryVal["group_type = ?"] = int32(req.GetGroupType())
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
	results, err := b.groupRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search groups")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Group) error {
		var apiResults []*identityv1.GroupObject
		for _, group := range res {
			apiResults = append(apiResults, group.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

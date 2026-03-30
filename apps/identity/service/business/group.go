package business

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/identity/service/events"
	"github.com/antinvestor/service-lender/apps/identity/service/models"
	"github.com/antinvestor/service-lender/apps/identity/service/repository"
)

type GroupBusiness interface {
	Save(ctx context.Context, group *models.Group) (*models.Group, error)
	Get(ctx context.Context, id string) (*models.Group, error)
	Search(
		ctx context.Context,
		query, agentID, branchID string,
		groupType int32,
		cursor *data.SearchQuery,
		consumer func(ctx context.Context, batch []*models.Group) error,
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

func (b *groupBusiness) Save(ctx context.Context, group *models.Group) (*models.Group, error) {
	logger := util.Log(ctx).WithField("method", "GroupBusiness.Save")

	// Validate agent exists and is active
	agent, err := b.agentRepo.GetByID(ctx, group.AgentID)
	if err != nil {
		logger.WithError(err).Warn("agent not found for group")
		return nil, ErrAgentNotFound
	}

	if commonv1.STATE(agent.State) != commonv1.STATE_ACTIVE &&
		commonv1.STATE(agent.State) != commonv1.STATE_CREATED {
		return nil, ErrAgentInactive
	}

	isNew := group.GetID() == ""

	if isNew && group.State == 0 {
		group.State = int32(commonv1.STATE_CREATED.Number())
	}

	if isNew {
		group.GenID(ctx)
	}

	err = b.eventsMan.Emit(ctx, events.GroupSaveEvent, group)
	if err != nil {
		logger.WithError(err).Error("could not emit group save event")
		return nil, err
	}

	return group, nil
}

func (b *groupBusiness) Get(ctx context.Context, id string) (*models.Group, error) {
	group, err := b.groupRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrGroupNotFound
	}
	return group, nil
}

func (b *groupBusiness) Search(
	ctx context.Context,
	query, agentID, branchID string,
	groupType int32,
	_ *data.SearchQuery,
	consumer func(ctx context.Context, batch []*models.Group) error,
) error {
	logger := util.Log(ctx).WithField("method", "GroupBusiness.Search")

	var searchOpts []data.SearchOption

	andQueryVal := map[string]any{}
	if agentID != "" {
		andQueryVal["agent_id = ?"] = agentID
	}
	if branchID != "" {
		andQueryVal["branch_id = ?"] = branchID
	}
	if groupType != 0 {
		andQueryVal["group_type = ?"] = groupType
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	if query != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{"searchable @@ websearch_to_tsquery( 'english', ?) ": query},
			),
		)
	}

	sq := data.NewSearchQuery(searchOpts...)
	results, err := b.groupRepo.Search(ctx, sq)
	if err != nil {
		logger.WithError(err).Error("failed to search groups")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Group) error {
		return consumer(ctx, res)
	})
}

package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/events"
	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type AgentBusiness interface {
	Save(ctx context.Context, obj *fieldv1.AgentObject) (*fieldv1.AgentObject, error)
	Get(ctx context.Context, id string) (*fieldv1.AgentObject, error)
	Search(
		ctx context.Context,
		req *fieldv1.AgentSearchRequest,
		consumer func(ctx context.Context, batch []*fieldv1.AgentObject) error,
	) error
	Hierarchy(
		ctx context.Context,
		req *fieldv1.AgentHierarchyRequest,
		consumer func(ctx context.Context, batch []*fieldv1.AgentObject) error,
	) error
}

type agentBusiness struct {
	eventsMan     fevents.Manager
	maxAgentDepth int
	branchRepo    repository.BranchRepository
	agentRepo     repository.AgentRepository
	notifier      *AgentNotifier
}

func NewAgentBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	maxAgentDepth int,
	branchRepo repository.BranchRepository,
	agentRepo repository.AgentRepository,
	notifier *AgentNotifier,
) AgentBusiness {
	return &agentBusiness{
		eventsMan:     eventsMan,
		maxAgentDepth: maxAgentDepth,
		branchRepo:    branchRepo,
		agentRepo:     agentRepo,
		notifier:      notifier,
	}
}

func (b *agentBusiness) Save(ctx context.Context, obj *fieldv1.AgentObject) (*fieldv1.AgentObject, error) {
	logger := util.Log(ctx).WithField("method", "AgentBusiness.Save")

	agent := models.AgentFromAPI(ctx, obj)

	// If parent agent is set, inherit branch and calculate depth
	if obj.GetParentAgentId() != "" {
		parent, err := b.agentRepo.GetByID(ctx, obj.GetParentAgentId())
		if err != nil {
			logger.WithError(err).Warn("parent agent not found")
			return nil, ErrAgentNotFound.Extend("parent agent not found")
		}

		agent.BranchID = parent.BranchID
		agent.Depth = parent.Depth + 1

		if int(agent.Depth) > b.maxAgentDepth {
			logger.WithField("depth", agent.Depth).Warn("agent depth limit exceeded")
			return nil, ErrAgentDepthExceeded
		}
	} else {
		// Top-level agent, validate branch exists
		_, err := b.branchRepo.GetByID(ctx, obj.GetBranchId())
		if err != nil {
			logger.WithError(err).Warn("branch not found for agent")
			return nil, ErrBranchNotFound
		}
		agent.Depth = 0
	}

	if obj.GetId() == "" && agent.State == 0 {
		agent.State = int32(commonv1.STATE_CREATED.Number())
	}

	isNew := obj.GetId() == ""
	contactDetail := extractProperty(agent.Properties, "contact_detail")

	// For new agents without a profile, create one via the profile service.
	if isNew && agent.ProfileID == "" && contactDetail != "" {
		b.linkProfile(ctx, logger, agent, contactDetail)
	}

	err := b.eventsMan.Emit(ctx, events.AgentSaveEvent, agent)
	if err != nil {
		logger.WithError(err).Error("could not emit agent save event")
		return nil, err
	}

	// Send T&C onboarding notification for newly created agents.
	if isNew && contactDetail != "" {
		b.notifyOnboarding(ctx, agent, contactDetail)
	}

	return agent.ToAPI(), nil
}

func (b *agentBusiness) linkProfile(
	ctx context.Context,
	logger *util.LogEntry,
	agent *models.Agent,
	contactDetail string,
) {
	if b.notifier == nil {
		return
	}
	profileID, err := b.notifier.CreateOrLinkProfile(ctx, agent.Name, contactDetail)
	if err != nil {
		logger.WithError(err).Warn("could not create profile for agent, continuing without")
		return
	}
	if profileID != "" {
		agent.ProfileID = profileID
	}
}

func (b *agentBusiness) notifyOnboarding(
	ctx context.Context,
	agent *models.Agent,
	contactDetail string,
) {
	if b.notifier == nil {
		return
	}
	b.notifier.NotifyAgentOnboarded(ctx, contactDetail, agent.Name, agent.GetID())
}

func extractProperty(props map[string]any, key string) string {
	if props == nil {
		return ""
	}
	v, ok := props[key]
	if !ok {
		return ""
	}
	s, _ := v.(string)
	return s
}

func (b *agentBusiness) Get(ctx context.Context, id string) (*fieldv1.AgentObject, error) {
	agent, err := b.agentRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrAgentNotFound
	}
	return agent.ToAPI(), nil
}

func (b *agentBusiness) Search(
	ctx context.Context,
	req *fieldv1.AgentSearchRequest,
	consumer func(ctx context.Context, batch []*fieldv1.AgentObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "AgentBusiness.Search")

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
	if req.GetBranchId() != "" {
		andQueryVal["branch_id = ?"] = req.GetBranchId()
	}
	if req.GetParentAgentId() != "" {
		andQueryVal["parent_agent_id = ?"] = req.GetParentAgentId()
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
	results, err := b.agentRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search agents")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Agent) error {
		var apiResults []*fieldv1.AgentObject
		for _, agent := range res {
			apiResults = append(apiResults, agent.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

func (b *agentBusiness) Hierarchy(
	ctx context.Context,
	req *fieldv1.AgentHierarchyRequest,
	consumer func(ctx context.Context, batch []*fieldv1.AgentObject) error,
) error {
	descendants, err := b.agentRepo.GetDescendants(ctx, req.GetAgentId(), int(req.GetMaxDepth()))
	if err != nil {
		return err
	}

	var apiResults []*fieldv1.AgentObject
	for _, agent := range descendants {
		apiResults = append(apiResults, agent.ToAPI())
	}

	return consumer(ctx, apiResults)
}

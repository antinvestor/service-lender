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

type AgentBusiness interface {
	Save(ctx context.Context, obj *lenderv1.AgentObject) (*lenderv1.AgentObject, error)
	Get(ctx context.Context, id string) (*lenderv1.AgentObject, error)
	Search(
		ctx context.Context,
		req *lenderv1.AgentSearchRequest,
		consumer func(ctx context.Context, batch []*lenderv1.AgentObject) error,
	) error
	Hierarchy(
		ctx context.Context,
		req *lenderv1.AgentHierarchyRequest,
		consumer func(ctx context.Context, batch []*lenderv1.AgentObject) error,
	) error
}

type agentBusiness struct {
	eventsMan     fevents.Manager
	maxAgentDepth int
	branchRepo    repository.BranchRepository
	agentRepo     repository.AgentRepository
}

func NewAgentBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	maxAgentDepth int,
	branchRepo repository.BranchRepository,
	agentRepo repository.AgentRepository,
) AgentBusiness {
	return &agentBusiness{
		eventsMan:     eventsMan,
		maxAgentDepth: maxAgentDepth,
		branchRepo:    branchRepo,
		agentRepo:     agentRepo,
	}
}

func (b *agentBusiness) Save(ctx context.Context, obj *lenderv1.AgentObject) (*lenderv1.AgentObject, error) {
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

	if agent.State == 0 {
		agent.State = int32(commonv1.STATE_CREATED.Number())
	}

	err := b.eventsMan.Emit(ctx, events.AgentSaveEvent, agent)
	if err != nil {
		logger.WithError(err).Error("could not emit agent save event")
		return nil, err
	}

	return agent.ToAPI(), nil
}

func (b *agentBusiness) Get(ctx context.Context, id string) (*lenderv1.AgentObject, error) {
	agent, err := b.agentRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return agent.ToAPI(), nil
}

func (b *agentBusiness) Search(
	ctx context.Context,
	req *lenderv1.AgentSearchRequest,
	consumer func(ctx context.Context, batch []*lenderv1.AgentObject) error,
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
		var apiResults []*lenderv1.AgentObject
		for _, agent := range res {
			apiResults = append(apiResults, agent.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

func (b *agentBusiness) Hierarchy(
	ctx context.Context,
	req *lenderv1.AgentHierarchyRequest,
	consumer func(ctx context.Context, batch []*lenderv1.AgentObject) error,
) error {
	descendants, err := b.agentRepo.GetDescendants(ctx, req.GetAgentId(), int(req.GetMaxDepth()))
	if err != nil {
		return err
	}

	var apiResults []*lenderv1.AgentObject
	for _, agent := range descendants {
		apiResults = append(apiResults, agent.ToAPI())
	}

	return consumer(ctx, apiResults)
}

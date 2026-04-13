package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
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

	// Branch assignment management
	SaveBranch(ctx context.Context, ab *models.AgentBranch) (*models.AgentBranch, error)
	DeleteBranch(ctx context.Context, id string) error
	ListBranchesByAgent(ctx context.Context, agentID string) ([]*models.AgentBranch, error)
	ListBranchesByBranch(ctx context.Context, branchID string) ([]*models.AgentBranch, error)
	GetBranchIDsForAgent(ctx context.Context, agentID string) ([]string, error)
}

type agentBusiness struct {
	eventsMan        fevents.Manager
	maxAgentDepth    int
	organizationRepo repository.OrganizationRepository
	branchRepo       repository.BranchRepository
	agentRepo        repository.AgentRepository
	agentBranchRepo  repository.AgentBranchRepository
	notifier         *AgentNotifier
}

func NewAgentBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	maxAgentDepth int,
	organizationRepo repository.OrganizationRepository,
	branchRepo repository.BranchRepository,
	agentRepo repository.AgentRepository,
	agentBranchRepo repository.AgentBranchRepository,
	notifier *AgentNotifier,
) AgentBusiness {
	return &agentBusiness{
		eventsMan:        eventsMan,
		maxAgentDepth:    maxAgentDepth,
		organizationRepo: organizationRepo,
		branchRepo:       branchRepo,
		agentRepo:        agentRepo,
		agentBranchRepo:  agentBranchRepo,
		notifier:         notifier,
	}
}

func (b *agentBusiness) Save(ctx context.Context, obj *fieldv1.AgentObject) (*fieldv1.AgentObject, error) {
	logger := util.Log(ctx).WithField("method", "AgentBusiness.Save")

	agent := models.AgentFromAPI(ctx, obj)

	// If parent agent is set, inherit organization and calculate depth
	if obj.GetParentAgentId() != "" {
		parent, err := b.agentRepo.GetByID(ctx, obj.GetParentAgentId())
		if err != nil {
			logger.WithError(err).Warn("parent agent not found")
			return nil, ErrAgentNotFound.Extend("parent agent not found")
		}

		agent.OrganizationID = parent.OrganizationID
		agent.Depth = parent.Depth + 1

		if int(agent.Depth) > b.maxAgentDepth {
			logger.WithField("depth", agent.Depth).Warn("agent depth limit exceeded")
			return nil, ErrAgentDepthExceeded
		}
	} else {
		// Top-level agent — validate organization exists
		if _, err := b.organizationRepo.GetByID(ctx, agent.OrganizationID); err != nil {
			logger.WithError(err).Warn("organization not found for agent")
			return nil, ErrOrganizationNotFound
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
		// Filter agents by branch through the join table
		andQueryVal["id IN (SELECT agent_id FROM agent_branches WHERE branch_id = ?)"] = req.GetBranchId()
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

// --- Agent Branch Assignment ---

func (b *agentBusiness) SaveBranch(ctx context.Context, ab *models.AgentBranch) (*models.AgentBranch, error) {
	logger := util.Log(ctx).WithField("method", "AgentBusiness.SaveBranch")

	// Validate agent exists
	agent, err := b.agentRepo.GetByID(ctx, ab.AgentID)
	if err != nil {
		return nil, ErrAgentNotFound
	}

	// Validate branch exists and belongs to agent's organization
	branch, err := b.branchRepo.GetByID(ctx, ab.BranchID)
	if err != nil {
		return nil, ErrBranchNotFound
	}
	if branch.UnitType != int32(identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH) {
		return nil, ErrBranchNotFound
	}
	if branch.OrganizationID != agent.OrganizationID {
		return nil, ErrBranchNotInOrganization
	}

	// For sub-agents, validate that the parent has this branch assigned
	if agent.ParentAgentID != "" {
		parentBranches, branchErr := b.agentBranchRepo.GetByAgentID(ctx, agent.ParentAgentID)
		if branchErr != nil {
			return nil, branchErr
		}

		parentHasBranch := false
		for _, pb := range parentBranches {
			if pb.BranchID == ab.BranchID {
				parentHasBranch = true
				break
			}
		}
		if !parentHasBranch {
			return nil, ErrAgentBranchNotInParent
		}
	}

	if ab.State == 0 {
		ab.State = int32(commonv1.STATE_ACTIVE.Number())
	}

	ab.GenID(ctx)

	// Check if assignment already exists — update if so
	existing, getErr := b.agentBranchRepo.GetByAgentAndBranch(ctx, ab.AgentID, ab.BranchID)
	if getErr == nil && existing != nil {
		ab.ID = existing.ID
		if _, updateErr := b.agentBranchRepo.Update(ctx, ab); updateErr != nil {
			logger.WithError(updateErr).Error("could not update agent branch assignment")
			return nil, updateErr
		}
		return ab, nil
	}

	if createErr := b.agentBranchRepo.Create(ctx, ab); createErr != nil {
		logger.WithError(createErr).Error("could not create agent branch assignment")
		return nil, createErr
	}

	return ab, nil
}

func (b *agentBusiness) DeleteBranch(ctx context.Context, id string) error {
	return b.agentBranchRepo.DeleteByID(ctx, id)
}

func (b *agentBusiness) ListBranchesByAgent(ctx context.Context, agentID string) ([]*models.AgentBranch, error) {
	return b.agentBranchRepo.GetByAgentID(ctx, agentID)
}

func (b *agentBusiness) ListBranchesByBranch(ctx context.Context, branchID string) ([]*models.AgentBranch, error) {
	return b.agentBranchRepo.GetByBranchID(ctx, branchID)
}

func (b *agentBusiness) GetBranchIDsForAgent(ctx context.Context, agentID string) ([]string, error) {
	branches, err := b.agentBranchRepo.GetByAgentID(ctx, agentID)
	if err != nil {
		return nil, err
	}

	ids := make([]string, 0, len(branches))
	for _, ab := range branches {
		ids = append(ids, ab.BranchID)
	}
	return ids, nil
}

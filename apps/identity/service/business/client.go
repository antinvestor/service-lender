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

type ClientBusiness interface {
	Save(ctx context.Context, obj *lenderv1.ClientObject) (*lenderv1.ClientObject, error)
	Get(ctx context.Context, id string) (*lenderv1.ClientObject, error)
	Search(ctx context.Context, req *lenderv1.ClientSearchRequest, consumer func(ctx context.Context, batch []*lenderv1.ClientObject) error) error
	Reassign(ctx context.Context, req *lenderv1.ClientReassignRequest) (*lenderv1.ClientObject, error)
}

type clientBusiness struct {
	eventsMan  fevents.Manager
	agentRepo  repository.AgentRepository
	clientRepo repository.ClientRepository
	cahRepo    repository.ClientAssignmentHistoryRepository
	branchRepo repository.BranchRepository
}

func NewClientBusiness(_ context.Context, eventsMan fevents.Manager,
	agentRepo repository.AgentRepository, clientRepo repository.ClientRepository,
	cahRepo repository.ClientAssignmentHistoryRepository, branchRepo repository.BranchRepository,
) ClientBusiness {
	return &clientBusiness{
		eventsMan:  eventsMan,
		agentRepo:  agentRepo,
		clientRepo: clientRepo,
		cahRepo:    cahRepo,
		branchRepo: branchRepo,
	}
}

func (b *clientBusiness) Save(ctx context.Context, obj *lenderv1.ClientObject) (*lenderv1.ClientObject, error) {
	logger := util.Log(ctx).WithField("method", "ClientBusiness.Save")

	// Validate agent exists and is active
	agent, err := b.agentRepo.GetByID(ctx, obj.GetAgentId())
	if err != nil {
		logger.WithError(err).Warn("agent not found for client")
		return nil, ErrAgentNotFound
	}

	if commonv1.STATE(agent.State) != commonv1.STATE_ACTIVE &&
		commonv1.STATE(agent.State) != commonv1.STATE_CREATED {
		return nil, ErrAgentInactive
	}

	client := models.ClientFromAPI(ctx, obj)

	if client.State == 0 {
		client.State = int32(commonv1.STATE_CREATED.Number())
	}

	err = b.eventsMan.Emit(ctx, events.ClientSaveEvent, client)
	if err != nil {
		logger.WithError(err).Error("could not emit client save event")
		return nil, err
	}

	return client.ToAPI(), nil
}

func (b *clientBusiness) Get(ctx context.Context, id string) (*lenderv1.ClientObject, error) {
	client, err := b.clientRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return client.ToAPI(), nil
}

func (b *clientBusiness) Search(ctx context.Context, req *lenderv1.ClientSearchRequest, consumer func(ctx context.Context, batch []*lenderv1.ClientObject) error) error {
	logger := util.Log(ctx).WithField("method", "ClientBusiness.Search")

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
	results, err := b.clientRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search clients")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Client) error {
		var apiResults []*lenderv1.ClientObject
		for _, client := range res {
			apiResults = append(apiResults, client.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

func (b *clientBusiness) Reassign(ctx context.Context, req *lenderv1.ClientReassignRequest) (*lenderv1.ClientObject, error) {
	logger := util.Log(ctx).WithField("method", "ClientBusiness.Reassign")

	client, err := b.clientRepo.GetByID(ctx, req.GetClientId())
	if err != nil {
		return nil, ErrClientNotFound
	}

	if client.AgentID == req.GetNewAgentId() {
		return nil, ErrReassignSameAgent
	}

	// Validate new agent exists
	newAgent, err := b.agentRepo.GetByID(ctx, req.GetNewAgentId())
	if err != nil {
		return nil, ErrAgentNotFound.Extend("new agent not found")
	}

	// Validate both agents are in the same bank
	oldAgent, err := b.agentRepo.GetByID(ctx, client.AgentID)
	if err != nil {
		return nil, ErrAgentNotFound.Extend("current agent not found")
	}

	oldBranch, err := b.branchRepo.GetByID(ctx, oldAgent.BranchID)
	if err != nil {
		return nil, ErrBranchNotFound
	}

	newBranch, err := b.branchRepo.GetByID(ctx, newAgent.BranchID)
	if err != nil {
		return nil, ErrBranchNotFound
	}

	if oldBranch.BankID != newBranch.BankID {
		return nil, ErrReassignCrossBank
	}

	// Create assignment history record
	history := &models.ClientAssignmentHistory{
		ClientID:        client.GetID(),
		PreviousAgentID: client.AgentID,
		NewAgentID:      req.GetNewAgentId(),
		Reason:          req.GetReason(),
	}
	history.GenID(ctx)

	err = b.cahRepo.Create(ctx, history)
	if err != nil {
		logger.WithError(err).Error("could not save assignment history")
		return nil, err
	}

	// Update client's agent
	client.AgentID = req.GetNewAgentId()
	err = b.clientRepo.Update(ctx, client, "agent_id")
	if err != nil {
		logger.WithError(err).Error("could not update client agent")
		return nil, err
	}

	logger.WithField("client_id", client.GetID()).
		WithField("old_agent", history.PreviousAgentID).
		WithField("new_agent", history.NewAgentID).
		Info("client reassigned")

	return client.ToAPI(), nil
}

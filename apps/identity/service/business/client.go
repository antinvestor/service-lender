package business

import (
	"context"
	"strconv"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"
	"gorm.io/gorm"

	"github.com/antinvestor/service-fintech/apps/identity/service/events"
	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type ClientBusiness interface {
	Save(ctx context.Context, obj *fieldv1.ClientObject) (*fieldv1.ClientObject, error)
	Get(ctx context.Context, id string) (*fieldv1.ClientObject, error)
	Search(
		ctx context.Context,
		req *fieldv1.ClientSearchRequest,
		consumer func(ctx context.Context, batch []*fieldv1.ClientObject) error,
	) error
	Reassign(ctx context.Context, req *fieldv1.ClientReassignRequest) (*fieldv1.ClientObject, error)
	SetAgentCreditLimit(ctx context.Context, clientID string, amount int64) error
	RequestSystemCreditLimitChange(
		ctx context.Context,
		clientID string,
		newLimit int64,
		reason, requestedBy string,
	) (*models.CreditLimitChangeRequest, error)
	ApproveSystemCreditLimitChange(ctx context.Context, requestID string, reviewedBy, notes string) error
	RejectSystemCreditLimitChange(ctx context.Context, requestID string, reviewedBy, notes string) error
	GetEffectiveCreditLimit(ctx context.Context, clientID string) (int64, string, error)
}

type clientBusiness struct {
	eventsMan  fevents.Manager
	agentRepo  repository.AgentRepository
	clientRepo repository.ClientRepository
	cahRepo    repository.ClientAssignmentHistoryRepository
	branchRepo repository.BranchRepository
	clcrRepo   repository.CreditLimitChangeRequestRepository
}

func NewClientBusiness(_ context.Context, eventsMan fevents.Manager,
	agentRepo repository.AgentRepository, clientRepo repository.ClientRepository,
	cahRepo repository.ClientAssignmentHistoryRepository, branchRepo repository.BranchRepository,
	clcrRepo repository.CreditLimitChangeRequestRepository,
) ClientBusiness {
	return &clientBusiness{
		eventsMan:  eventsMan,
		agentRepo:  agentRepo,
		clientRepo: clientRepo,
		cahRepo:    cahRepo,
		branchRepo: branchRepo,
		clcrRepo:   clcrRepo,
	}
}

func (b *clientBusiness) Save(ctx context.Context, obj *fieldv1.ClientObject) (*fieldv1.ClientObject, error) {
	logger := util.Log(ctx).WithField("method", "ClientBusiness.Save")

	// Validate agent exists and is active (required for all clients)
	agent, err := b.agentRepo.GetByID(ctx, obj.GetAgentId())
	if err != nil {
		logger.WithError(err).Warn("agent not found for client")
		return nil, ErrAgentNotFound
	}

	{
		if commonv1.STATE(agent.State) != commonv1.STATE_ACTIVE &&
			commonv1.STATE(agent.State) != commonv1.STATE_CREATED {
			return nil, ErrAgentInactive
		}
	}

	isNew := obj.GetId() == ""
	client := models.ClientFromAPI(ctx, obj)

	if isNew && client.State == 0 {
		client.State = int32(commonv1.STATE_CREATED.Number())
	}

	if err = b.eventsMan.Emit(ctx, events.ClientSaveEvent, client); err != nil {
		logger.WithError(err).Error("could not emit client save event")
		return nil, err
	}

	return client.ToAPI(), nil
}

func (b *clientBusiness) Get(ctx context.Context, id string) (*fieldv1.ClientObject, error) {
	client, err := b.clientRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return client.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *clientBusiness) Search(
	ctx context.Context,
	req *fieldv1.ClientSearchRequest,
	consumer func(ctx context.Context, batch []*fieldv1.ClientObject) error,
) error {
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
		var apiResults []*fieldv1.ClientObject
		for _, client := range res {
			apiResults = append(apiResults, client.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

func (b *clientBusiness) Reassign(
	ctx context.Context,
	req *fieldv1.ClientReassignRequest,
) (*fieldv1.ClientObject, error) {
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

	// Validate both agents are in the same organization
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

	if oldBranch.OrganizationID != newBranch.OrganizationID {
		return nil, ErrReassignCrossOrganization
	}

	// Create assignment history and update client in a transaction
	history := &models.ClientAssignmentHistory{
		ClientID:        client.GetID(),
		PreviousAgentID: client.AgentID,
		NewAgentID:      req.GetNewAgentId(),
		Reason:          req.GetReason(),
	}
	history.GenID(ctx)

	err = b.clientRepo.Pool().DB(ctx, false).Transaction(func(tx *gorm.DB) error {
		if txErr := tx.Create(history).Error; txErr != nil {
			return txErr
		}

		client.AgentID = req.GetNewAgentId()
		if txErr := tx.Model(client).Update("agent_id", client.AgentID).Error; txErr != nil {
			return txErr
		}

		return nil
	})
	if err != nil {
		logger.WithError(err).Error("could not reassign client")
		return nil, err
	}

	logger.WithField("client_id", client.GetID()).
		WithField("old_agent", history.PreviousAgentID).
		WithField("new_agent", history.NewAgentID).
		Info("client reassigned")

	return client.ToAPI(), nil
}

// SetAgentCreditLimit allows the responsible agent to set the client's
// agent-controlled credit limit. Must be between 0 and the system limit.
func (b *clientBusiness) SetAgentCreditLimit(ctx context.Context, clientID string, amount int64) error {
	logger := util.Log(ctx).WithField("method", "ClientBusiness.SetAgentCreditLimit")

	client, err := b.clientRepo.GetByID(ctx, clientID)
	if err != nil {
		return ErrClientNotFound
	}

	if amount < 0 {
		return ErrCreditLimitNegative
	}

	if client.SystemCreditLimit > 0 && amount > client.SystemCreditLimit {
		return ErrAgentLimitExceedsSystem
	}

	client.AgentCreditLimit = amount

	if err = b.eventsMan.Emit(ctx, events.ClientSaveEvent, client); err != nil {
		logger.WithError(err).Error("could not update agent credit limit")
		return err
	}

	logger.WithField("client_id", clientID).
		WithField("agent_limit", amount).
		Info("agent credit limit updated")

	return nil
}

// RequestSystemCreditLimitChange creates a case to change the system credit limit.
// This initiates a verification and approval process.
func (b *clientBusiness) RequestSystemCreditLimitChange(
	ctx context.Context,
	clientID string,
	newLimit int64,
	reason, requestedBy string,
) (*models.CreditLimitChangeRequest, error) {
	logger := util.Log(ctx).WithField("method", "ClientBusiness.RequestSystemCreditLimitChange")

	client, err := b.clientRepo.GetByID(ctx, clientID)
	if err != nil {
		return nil, ErrClientNotFound
	}

	if newLimit < 0 {
		return nil, ErrCreditLimitNegative
	}

	// Check for existing pending requests
	pending, err := b.clcrRepo.GetPendingByClientID(ctx, clientID)
	if err == nil && len(pending) > 0 {
		return nil, ErrCreditLimitChangePending
	}

	req := &models.CreditLimitChangeRequest{
		ClientID:       clientID,
		CurrentLimit:   client.SystemCreditLimit,
		RequestedLimit: newLimit,
		CurrencyCode:   client.CurrencyCode,
		Reason:         reason,
		RequestedBy:    requestedBy,
		Status:         1, // pending
	}
	req.GenID(ctx)

	if err = b.eventsMan.Emit(ctx, events.CreditLimitChangeRequestSaveEvent, req); err != nil {
		logger.WithError(err).Error("could not create credit limit change request")
		return nil, err
	}

	logger.WithField("client_id", clientID).
		WithField("current", client.SystemCreditLimit).
		WithField("requested", newLimit).
		Info("credit limit change request created")

	return req, nil
}

// ApproveSystemCreditLimitChange approves a pending request and applies the
// new system credit limit to the client. If the agent limit exceeds the new
// system limit, the agent limit is clamped down.
func (b *clientBusiness) ApproveSystemCreditLimitChange(
	ctx context.Context,
	requestID string,
	reviewedBy, notes string,
) error {
	logger := util.Log(ctx).WithField("method", "ClientBusiness.ApproveSystemCreditLimitChange")

	req, err := b.clcrRepo.GetByID(ctx, requestID)
	if err != nil {
		return ErrCreditLimitChangeNotFound
	}

	if req.Status != 1 { // not pending
		return ErrCreditLimitChangeNotPending
	}

	// Apply the new system limit
	client, err := b.clientRepo.GetByID(ctx, req.ClientID)
	if err != nil {
		return ErrClientNotFound
	}

	client.SystemCreditLimit = req.RequestedLimit

	// Clamp agent limit if it exceeds the new system limit
	if client.AgentCreditLimit > client.SystemCreditLimit {
		client.AgentCreditLimit = client.SystemCreditLimit
	}

	if err = b.eventsMan.Emit(ctx, events.ClientSaveEvent, client); err != nil {
		logger.WithError(err).Error("could not update client system credit limit")
		return err
	}

	// Mark the request as approved
	req.Status = 3 // approved
	req.ReviewedBy = reviewedBy
	req.ReviewNotes = notes

	if err = b.eventsMan.Emit(ctx, events.CreditLimitChangeRequestSaveEvent, req); err != nil {
		logger.WithError(err).Error("could not update credit limit change request")
		return err
	}

	logger.WithField("client_id", req.ClientID).
		WithField("new_limit", req.RequestedLimit).
		Info("system credit limit change approved and applied")

	return nil
}

// RejectSystemCreditLimitChange rejects a pending request.
func (b *clientBusiness) RejectSystemCreditLimitChange(
	ctx context.Context,
	requestID string,
	reviewedBy, notes string,
) error {
	logger := util.Log(ctx).WithField("method", "ClientBusiness.RejectSystemCreditLimitChange")

	req, err := b.clcrRepo.GetByID(ctx, requestID)
	if err != nil {
		return ErrCreditLimitChangeNotFound
	}

	if req.Status != 1 { // not pending
		return ErrCreditLimitChangeNotPending
	}

	req.Status = 5 // rejected
	req.ReviewedBy = reviewedBy
	req.ReviewNotes = notes

	if err = b.eventsMan.Emit(ctx, events.CreditLimitChangeRequestSaveEvent, req); err != nil {
		logger.WithError(err).Error("could not update credit limit change request")
		return err
	}

	logger.WithField("client_id", req.ClientID).
		Info("system credit limit change rejected")

	return nil
}

// GetEffectiveCreditLimit returns the effective credit limit and currency
// for a client. This is the lower of their system and agent limits.
func (b *clientBusiness) GetEffectiveCreditLimit(ctx context.Context, clientID string) (int64, string, error) {
	client, err := b.clientRepo.GetByID(ctx, clientID)
	if err != nil {
		return 0, "", ErrClientNotFound
	}
	return client.EffectiveCreditLimit(), client.CurrencyCode, nil
}

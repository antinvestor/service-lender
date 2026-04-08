package business

import (
	"context"
	"fmt"

	ledgerv1 "buf.build/gen/go/antinvestor/ledger/protocolbuffers/go/v1"
	"connectrpc.com/connect"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/group/service/events"
	"github.com/antinvestor/service-fintech/apps/group/service/models"
	"github.com/antinvestor/service-fintech/apps/group/service/repository"
	"github.com/antinvestor/service-fintech/pkg/clients"
	"github.com/antinvestor/service-fintech/pkg/constants"
)

type groupBusiness struct {
	eventsMan fevents.Manager
	grpRepo   repository.CustomerGroupRepository
	memRepo   repository.MembershipRepository
	clients   *clients.PlatformClients
}

func NewGroupBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	grpRepo repository.CustomerGroupRepository,
	memRepo repository.MembershipRepository,
	pc *clients.PlatformClients,
) GroupBusiness {
	return &groupBusiness{eventsMan: eventsMan, grpRepo: grpRepo, memRepo: memRepo, clients: pc}
}

func (b *groupBusiness) Create(ctx context.Context, group *models.CustomerGroup) (*models.CustomerGroup, error) {
	logger := util.Log(ctx).WithField("method", "GroupBusiness.Create")

	if group.State == 0 {
		group.State = int32(constants.StateJustCreated)
	}
	group.GenID(ctx)

	err := b.eventsMan.Emit(ctx, events.CustomerGroupSaveEvent, group)
	if err != nil {
		logger.WithError(err).Error("could not emit group save event")
		return nil, err
	}

	return group, nil
}

func (b *groupBusiness) Get(ctx context.Context, id string) (*models.CustomerGroup, error) {
	return b.grpRepo.GetByID(ctx, id)
}

func (b *groupBusiness) Transition(ctx context.Context, groupID string, newState int32, reason string) error {
	logger := util.Log(ctx).WithFields(map[string]any{
		"method": "GroupBusiness.Transition", "group_id": groupID, "new_state": newState,
	})

	group, err := b.grpRepo.GetByID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("group not found: %w", err)
	}

	// Validate state transitions
	currentState := group.State
	valid := false
	switch newState {
	case int32(constants.StateCheckCreated):
		valid = currentState == int32(constants.StateJustCreated)
	case int32(constants.StateActive):
		valid = currentState == int32(constants.StateCheckCreated) || currentState == int32(constants.StateInactive)
	case int32(constants.StateInactive):
		valid = currentState == int32(constants.StateActive)
	case int32(constants.StateShutdown):
		valid = true // can shutdown from any state
	case int32(constants.StateDeleted):
		valid = currentState == int32(constants.StateShutdown)
	}

	if !valid {
		return fmt.Errorf("invalid state transition from %d to %d", currentState, newState)
	}

	group.State = newState
	err = b.eventsMan.Emit(ctx, events.CustomerGroupSaveEvent, group)
	if err != nil {
		logger.WithError(err).Error("could not emit group save event")
		return err
	}

	logger.WithField("reason", reason).Info("group state transitioned")
	return nil
}

// CheckFormation checks if a group has enough members to proceed.
// Returns formation status with member count.
func (b *groupBusiness) CheckFormation(ctx context.Context, groupID string) (map[string]interface{}, error) {
	logger := util.Log(ctx).WithField("method", "GroupBusiness.CheckFormation")

	group, err := b.grpRepo.GetByID(ctx, groupID)
	if err != nil {
		return nil, fmt.Errorf("group not found: %w", err)
	}

	members, err := b.memRepo.GetByGroupID(ctx, groupID)
	if err != nil {
		logger.WithError(err).Error("could not get members")
		return nil, err
	}

	memberCount := len(members)
	// Default min: 5, get from group properties if set
	minMembers := 5
	if group.Properties != nil {
		if v, ok := group.Properties["min_members"]; ok {
			if minVal, isFloat := v.(float64); isFloat {
				minMembers = int(minVal)
			}
		}
	}

	formed := memberCount >= minMembers
	result := map[string]interface{}{
		"group_id":      groupID,
		"member_count":  memberCount,
		"min_members":   minMembers,
		"formed":        formed,
		"current_state": group.State,
	}

	// Auto-transition to CHECK_CREATED if formed and still JUST_CREATED
	if formed && group.State == int32(constants.StateJustCreated) {
		if transErr := b.Transition(
			ctx,
			groupID,
			int32(constants.StateCheckCreated),
			"formation threshold met",
		); transErr != nil {
			logger.WithError(transErr).Warn("could not auto-transition to CHECK_CREATED")
		} else {
			result["transitioned_to"] = constants.StateCheckCreated
		}
	}

	return result, nil
}

// WelcomeGroup activates a group: transitions to ACTIVE state.
func (b *groupBusiness) WelcomeGroup(ctx context.Context, groupID string) error {
	logger := util.Log(ctx).WithField("method", "GroupBusiness.WelcomeGroup")

	group, err := b.grpRepo.GetByID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("group not found: %w", err)
	}

	if group.State != int32(constants.StateCheckCreated) {
		return fmt.Errorf("group must be in CHECK_CREATED state, currently %d", group.State)
	}

	// Register with Lender
	if regErr := b.RegisterWithLender(ctx, groupID); regErr != nil {
		logger.WithError(regErr).Warn("could not register with lender during welcome")
	}

	// Transition to ACTIVE
	return b.Transition(ctx, groupID, int32(constants.StateActive), "group welcomed and activated")
}

// SetupLedgerAccounts creates the ledger account hierarchy for a group.
func (b *groupBusiness) SetupLedgerAccounts(ctx context.Context, groupID string) error {
	logger := util.Log(ctx).WithField("method", "GroupBusiness.SetupLedgerAccounts")

	if b.clients == nil || b.clients.LedgerClient == nil {
		logger.Warn("ledger client not available, skipping ledger account setup")
		return nil
	}

	group, err := b.grpRepo.GetByID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("group not found: %w", err)
	}

	// Group-level ledger accounts
	accountNames := []string{
		constants.GroupBankAccount(groupID),
		constants.GroupPenaltyIncomeAccount(groupID),
		constants.GroupInterestIncomeAccount(groupID),
		constants.GroupJoiningFeeAccount(groupID),
		constants.GroupTransactionCostsAccount(groupID),
		constants.GroupServiceFeeAccount(groupID),
		constants.GroupSavingsInterestIncomeAccount(groupID),
	}

	for _, acctName := range accountNames {
		req := connect.NewRequest(&ledgerv1.CreateAccountRequest{
			Id:       acctName,
			LedgerId: groupID,
			Currency: group.Currency,
		})

		if _, createErr := b.clients.LedgerClient.CreateAccount(ctx, req); createErr != nil {
			logger.WithError(createErr).WithField("account", acctName).
				Warn("could not create ledger account")
		}
	}

	logger.WithField("group_id", groupID).Info("ledger account setup completed")
	return nil
}

// RegisterWithLender registers the group as a GroupObject and members as
// Memberships + Clients in Identity.
func (b *groupBusiness) RegisterWithLender(ctx context.Context, groupID string) error {
	logger := util.Log(ctx).WithField("method", "GroupBusiness.RegisterWithLender")

	group, err := b.grpRepo.GetByID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("group not found: %w", err)
	}

	if b.clients == nil || b.clients.LenderIdentity == nil {
		logger.Warn("lender field client not available, skipping registration")
		return nil
	}

	members, err := b.memRepo.GetByGroupID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("could not get members: %w", err)
	}

	agentID := groupAgentID(group)
	b.registerMembers(ctx, logger, members, agentID)

	return nil
}

// groupAgentID extracts the agent ID from a group's properties.
func groupAgentID(group *models.CustomerGroup) string {
	if group.Properties == nil {
		return ""
	}
	v, ok := group.Properties["agent_id"]
	if !ok {
		return ""
	}
	s, _ := v.(string)
	return s
}

// registerMembers registers unregistered members as clients in the Field service.
func (b *groupBusiness) registerMembers(
	ctx context.Context,
	logger *util.LogEntry,
	members []*models.Membership,
	agentID string,
) {
	for _, m := range members {
		if m.IdentityClientID != "" {
			continue
		}

		if agentID != "" {
			clientID, cliErr := b.clients.RegisterClient(ctx, agentID, m.ProfileID, m.Name)
			if cliErr != nil {
				logger.WithError(cliErr).WithField("local_membership_id", m.GetID()).Warn("could not register client")
			} else {
				m.IdentityClientID = clientID
			}
		}

		if emitErr := b.eventsMan.Emit(ctx, events.MembershipSaveEvent, m); emitErr != nil {
			logger.WithError(emitErr).Error("could not save identity IDs on membership")
		}
	}
}

package business

import (
	"context"
	"fmt"
	"strconv"

	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	ledgerv1 "buf.build/gen/go/antinvestor/ledger/protocolbuffers/go/ledger/v1"
	"connectrpc.com/connect"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/group/service/events"
	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/apps/group/service/repository"
	"github.com/antinvestor/service-lender/pkg/clients"
	"github.com/antinvestor/service-lender/pkg/constants"
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
	logger := util.Log(ctx).WithField("method", "GroupBusiness.Transition").
		WithField("group_id", groupID).WithField("new_state", newState)

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
			if min, ok := v.(float64); ok {
				minMembers = int(min)
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
		logger.Warn("lender identity client not available, skipping registration")
		return nil
	}

	// Register group as first-class GroupObject in Identity
	if group.LenderGroupID == "" {
		// Map local group type to identity group type
		groupType := identityv1.GroupType(group.GroupType)
		// Convert minor units to decimal string (e.g. 12345 -> "123.45")
		whole := group.SavingAmount / 100
		frac := group.SavingAmount % 100
		if frac < 0 {
			frac = -frac
		}
		savingAmount := strconv.FormatInt(whole, 10) + "." + fmt.Sprintf("%02d", frac)

		// Derive min/max members from group properties if set
		var minMembers, maxMembers int32
		if group.Properties != nil {
			if v, ok := group.Properties["min_members"]; ok {
				if min, ok := v.(float64); ok {
					minMembers = int32(min)
				}
			}
			if v, ok := group.Properties["max_members"]; ok {
				if max, ok := v.(float64); ok {
					maxMembers = int32(max)
				}
			}
		}

		identityGroupID, regErr := b.clients.RegisterGroup(
			ctx, "", "", "", group.Name, group.Currency, groupType, savingAmount, minMembers, maxMembers,
		)
		if regErr != nil {
			return fmt.Errorf("could not register group in identity: %w", regErr)
		}
		group.LenderGroupID = identityGroupID
		if emitErr := b.eventsMan.Emit(ctx, events.CustomerGroupSaveEvent, group); emitErr != nil {
			logger.WithError(emitErr).Error("could not save identity group ID on group")
		}
		logger.WithField("identity_group_id", identityGroupID).Info("group registered in identity")
	}

	// Register members in Identity:
	// 1. Create Membership (profile ↔ group affiliation)
	// 2. Create Client (profile → agent, independent of group)
	// 3. Store both IDs on the local membership model (product-level linking)
	members, err := b.memRepo.GetByGroupID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("could not get members: %w", err)
	}

	// Resolve the agent that manages this group from the identity GroupObject.
	agentID := ""
	if group.LenderGroupID != "" && b.clients.LenderIdentity != nil {
		grpResp, grpErr := b.clients.LenderIdentity.GroupGet(ctx, connect.NewRequest(
			&identityv1.GroupGetRequest{Id: group.LenderGroupID},
		))
		if grpErr == nil && grpResp.Msg.GetData() != nil {
			agentID = grpResp.Msg.GetData().GetAgentId()
		} else if grpErr != nil {
			logger.WithError(grpErr).Warn("could not fetch identity group for agent resolution")
		}
	}

	for _, m := range members {
		if m.IdentityClientID != "" {
			continue // already registered
		}

		// Create membership in Identity (profile ↔ group)
		if m.IdentityMembershipID == "" {
			role := identityv1.MembershipRole(m.Role)
			memberType := identityv1.MembershipType(m.MembershipType)
			membershipID, memErr := b.clients.CreateMembership(
				ctx, group.LenderGroupID, m.ProfileID, m.Name, role, memberType,
			)
			if memErr != nil {
				logger.WithError(memErr).
					WithField("local_membership_id", m.GetID()).
					Warn("could not create identity membership")
				continue
			}
			m.IdentityMembershipID = membershipID
		}

		// Create client in Identity (profile → agent, independent of group)
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

	return nil
}

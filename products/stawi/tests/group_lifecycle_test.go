package tests

import (
	"context"
	"fmt"
	"testing"

	"github.com/antinvestor/service-lender/apps/group/service/models"
	"github.com/antinvestor/service-lender/pkg/constants"
)

// TestGroupFormationFlow tests group creation -> member addition -> formation check -> activation.
func TestGroupFormationFlow(t *testing.T) {
	ctx := context.Background()
	env := setupTestEnv(t)
	defer env.cleanup()

	// 1. Create group
	group := &models.CustomerGroup{
		Name:         "Test Grameen Group",
		GroupType:    int32(models.GroupTypeGrameen),
		SavingAmount: 50000, // 500.00
		Currency:     "KES",
		State:        int32(constants.StateJustCreated),
	}
	created, err := env.grpBusiness.Create(ctx, group)
	if err != nil {
		t.Fatalf("Create group: %v", err)
	}
	if created.GetID() == "" {
		t.Fatal("expected non-empty group ID")
	}
	if created.State != int32(constants.StateJustCreated) {
		t.Fatalf("expected JUST_CREATED state, got %d", created.State)
	}

	// 2. Add members (need 5 minimum for formation)
	for i := range 5 {
		member := &models.Membership{
			GroupID:        created.GetID(),
			Name:           fmt.Sprintf("Member %c", 'A'+i),
			MembershipType: int32(models.MembershipTypeMember),
			Role:           int32(models.MembershipRoleMember),
			State:          int32(constants.StateActive),
		}
		member.GenID(ctx)
		env.memRepo.store(member)
	}

	// 3. Check formation - should auto-transition to CHECK_CREATED
	result, err := env.grpBusiness.CheckFormation(ctx, created.GetID())
	if err != nil {
		t.Fatalf("CheckFormation: %v", err)
	}
	if !result["formed"].(bool) {
		t.Fatal("expected group to be formed with 5 members")
	}
	if result["member_count"].(int) != 5 {
		t.Fatalf("expected member_count 5, got %v", result["member_count"])
	}

	// 4. Verify state transitioned to CHECK_CREATED
	updated, err := env.grpBusiness.Get(ctx, created.GetID())
	if err != nil {
		t.Fatalf("Get group: %v", err)
	}
	if updated.State != int32(constants.StateCheckCreated) {
		t.Fatalf("expected CHECK_CREATED state after formation, got %d", updated.State)
	}

	// 5. Welcome/activate group
	err = env.grpBusiness.WelcomeGroup(ctx, created.GetID())
	if err != nil {
		t.Fatalf("WelcomeGroup: %v", err)
	}

	activated, err := env.grpBusiness.Get(ctx, created.GetID())
	if err != nil {
		t.Fatalf("Get activated group: %v", err)
	}
	if activated.State != int32(constants.StateActive) {
		t.Fatalf("expected ACTIVE state, got %d", activated.State)
	}
}

// TestFormationInsufficientMembers verifies that formation check fails with fewer than 5 members.
func TestFormationInsufficientMembers(t *testing.T) {
	ctx := context.Background()
	env := setupTestEnv(t)
	defer env.cleanup()

	group := &models.CustomerGroup{
		Name:         "Undersized Group",
		GroupType:    int32(models.GroupTypeGrameen),
		SavingAmount: 30000,
		Currency:     "KES",
	}
	created, err := env.grpBusiness.Create(ctx, group)
	if err != nil {
		t.Fatalf("Create: %v", err)
	}

	// Only add 3 members
	for i := range 3 {
		m := &models.Membership{
			GroupID:        created.GetID(),
			Name:           fmt.Sprintf("Member %d", i),
			MembershipType: int32(models.MembershipTypeMember),
			Role:           int32(models.MembershipRoleMember),
			State:          int32(constants.StateActive),
		}
		m.GenID(ctx)
		env.memRepo.store(m)
	}

	result, err := env.grpBusiness.CheckFormation(ctx, created.GetID())
	if err != nil {
		t.Fatalf("CheckFormation: %v", err)
	}
	if result["formed"].(bool) {
		t.Fatal("expected group NOT to be formed with only 3 members")
	}

	// State should remain JUST_CREATED
	g, _ := env.grpBusiness.Get(ctx, created.GetID())
	if g.State != int32(constants.StateJustCreated) {
		t.Fatalf("expected state to remain JUST_CREATED, got %d", g.State)
	}
}

// TestTenurePeriodLifecycle tests tenure creation -> period cycling.
func TestTenurePeriodLifecycle(t *testing.T) {
	ctx := context.Background()
	env := setupTestEnv(t)
	defer env.cleanup()

	// Create and activate a group
	group := createActiveGroup(t, ctx, env)

	// Open tenure
	tenure, err := env.tenBusiness.Open(ctx, group.GetID())
	if err != nil {
		t.Fatalf("Open tenure: %v", err)
	}
	if tenure.Position != 1 {
		t.Fatalf("expected tenure position 1, got %d", tenure.Position)
	}
	if tenure.Duration != 52 {
		t.Fatalf("expected default duration 52, got %d", tenure.Duration)
	}
	if tenure.State != int32(constants.StateActive) {
		t.Fatalf("expected ACTIVE tenure state, got %d", tenure.State)
	}

	// Open first period
	period1, err := env.perBusiness.Open(ctx, group.GetID())
	if err != nil {
		t.Fatalf("Open period 1: %v", err)
	}
	if period1.Position != 1 {
		t.Fatalf("expected period position 1, got %d", period1.Position)
	}
	if period1.TenureID != tenure.GetID() {
		t.Fatalf("expected period linked to tenure %s, got %s", tenure.GetID(), period1.TenureID)
	}

	// Trying to open a second period while the first is active should fail
	_, err = env.perBusiness.Open(ctx, group.GetID())
	if err == nil {
		t.Fatal("expected error when opening period while previous is still active")
	}

	// Close first period
	err = env.perBusiness.Close(ctx, period1.GetID())
	if err != nil {
		t.Fatalf("Close period 1: %v", err)
	}

	// Verify period is shut down
	closedPeriod, _ := env.perRepo.GetByID(ctx, period1.GetID())
	if closedPeriod.State != int32(constants.StateShutdown) {
		t.Fatalf("expected SHUTDOWN state for closed period, got %d", closedPeriod.State)
	}

	// Open second period
	period2, err := env.perBusiness.Open(ctx, group.GetID())
	if err != nil {
		t.Fatalf("Open period 2: %v", err)
	}
	if period2.Position != 2 {
		t.Fatalf("expected period position 2, got %d", period2.Position)
	}
	if period2.ParentPeriodID != period1.GetID() {
		t.Fatalf("expected parent period to be %s, got %s", period1.GetID(), period2.ParentPeriodID)
	}
}

// TestTenureClose tests closing a tenure also closes the active period.
func TestTenureClose(t *testing.T) {
	ctx := context.Background()
	env := setupTestEnv(t)
	defer env.cleanup()

	group := createActiveGroup(t, ctx, env)

	tenure, err := env.tenBusiness.Open(ctx, group.GetID())
	if err != nil {
		t.Fatalf("Open tenure: %v", err)
	}

	// Open a period
	period, err := env.perBusiness.Open(ctx, group.GetID())
	if err != nil {
		t.Fatalf("Open period: %v", err)
	}

	// Close tenure (should also close the active period)
	err = env.tenBusiness.Close(ctx, tenure.GetID())
	if err != nil {
		t.Fatalf("Close tenure: %v", err)
	}

	closedTenure, _ := env.tenRepo.GetByID(ctx, tenure.GetID())
	if closedTenure.State != int32(constants.StateShutdown) {
		t.Fatalf("expected tenure SHUTDOWN, got %d", closedTenure.State)
	}

	closedPeriod, _ := env.perRepo.GetByID(ctx, period.GetID())
	if closedPeriod.State != int32(constants.StateShutdown) {
		t.Fatalf("expected period SHUTDOWN after tenure close, got %d", closedPeriod.State)
	}
}

// TestGroupStateTransitions validates the state machine.
func TestGroupStateTransitions(t *testing.T) {
	ctx := context.Background()
	env := setupTestEnv(t)
	defer env.cleanup()

	group := createActiveGroup(t, ctx, env)

	// ACTIVE -> INACTIVE
	err := env.grpBusiness.Transition(ctx, group.GetID(), int32(constants.StateInactive), "test deactivation")
	if err != nil {
		t.Fatalf("ACTIVE->INACTIVE: %v", err)
	}

	g, _ := env.grpBusiness.Get(ctx, group.GetID())
	if g.State != int32(constants.StateInactive) {
		t.Fatalf("expected INACTIVE, got %d", g.State)
	}

	// INACTIVE -> ACTIVE (restore)
	err = env.grpBusiness.Transition(ctx, group.GetID(), int32(constants.StateActive), "test restoration")
	if err != nil {
		t.Fatalf("INACTIVE->ACTIVE: %v", err)
	}

	g, _ = env.grpBusiness.Get(ctx, group.GetID())
	if g.State != int32(constants.StateActive) {
		t.Fatalf("expected ACTIVE after restore, got %d", g.State)
	}

	// ACTIVE -> SHUTDOWN
	err = env.grpBusiness.Transition(ctx, group.GetID(), int32(constants.StateShutdown), "test shutdown")
	if err != nil {
		t.Fatalf("ACTIVE->SHUTDOWN: %v", err)
	}

	g, _ = env.grpBusiness.Get(ctx, group.GetID())
	if g.State != int32(constants.StateShutdown) {
		t.Fatalf("expected SHUTDOWN, got %d", g.State)
	}

	// Invalid: SHUTDOWN -> ACTIVE (should fail)
	err = env.grpBusiness.Transition(ctx, group.GetID(), int32(constants.StateActive), "invalid")
	if err == nil {
		t.Fatal("expected error for SHUTDOWN->ACTIVE transition")
	}

	// SHUTDOWN -> DELETED (valid)
	err = env.grpBusiness.Transition(ctx, group.GetID(), int32(constants.StateDeleted), "final deletion")
	if err != nil {
		t.Fatalf("SHUTDOWN->DELETED: %v", err)
	}
}

// TestInvalidTransitionFromJustCreated verifies that a freshly created group
// cannot jump directly to ACTIVE without going through CHECK_CREATED.
func TestInvalidTransitionFromJustCreated(t *testing.T) {
	ctx := context.Background()
	env := setupTestEnv(t)
	defer env.cleanup()

	group := &models.CustomerGroup{
		Name:         "Jump Attempt Group",
		GroupType:    int32(models.GroupTypeGrameen),
		SavingAmount: 10000,
		Currency:     "KES",
	}
	created, err := env.grpBusiness.Create(ctx, group)
	if err != nil {
		t.Fatalf("Create: %v", err)
	}

	// JUST_CREATED -> ACTIVE (should fail -- must go through CHECK_CREATED)
	err = env.grpBusiness.Transition(ctx, created.GetID(), int32(constants.StateActive), "skip check")
	if err == nil {
		t.Fatal("expected error for JUST_CREATED->ACTIVE transition")
	}
}

// TestDuplicateTenureOpen verifies that opening a second tenure fails
// while one is already active.
func TestDuplicateTenureOpen(t *testing.T) {
	ctx := context.Background()
	env := setupTestEnv(t)
	defer env.cleanup()

	group := createActiveGroup(t, ctx, env)

	_, err := env.tenBusiness.Open(ctx, group.GetID())
	if err != nil {
		t.Fatalf("First Open: %v", err)
	}

	_, err = env.tenBusiness.Open(ctx, group.GetID())
	if err == nil {
		t.Fatal("expected error when opening a second tenure while first is active")
	}
}

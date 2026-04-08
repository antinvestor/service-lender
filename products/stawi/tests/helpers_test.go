package tests

import (
	"context"
	"errors"
	"fmt"
	"sort"
	"sync"
	"testing"
	"time"

	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/events"
	"github.com/pitabwire/frame/queue"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/group/service/business"
	"github.com/antinvestor/service-fintech/apps/group/service/models"
	"github.com/antinvestor/service-fintech/apps/group/service/repository"
	"github.com/antinvestor/service-fintech/pkg/constants"
)

// ---------------------------------------------------------------------------
// testEnv wires fake repositories and a no-op event manager into the real
// business-logic layer so we can run integration-style tests without a DB.
// ---------------------------------------------------------------------------

type testEnv struct {
	grpBusiness business.GroupBusiness
	memBusiness business.MembershipBusiness
	tenBusiness business.TenureBusiness
	perBusiness business.PeriodBusiness

	// Expose fake repos for direct inspection when needed.
	grpRepo *fakeGroupRepo
	memRepo *fakeMembershipRepo
	tenRepo *fakeTenureRepo
	perRepo *fakePeriodRepo

	cleanup func()
}

func setupTestEnv(t *testing.T) *testEnv {
	t.Helper()
	ctx := context.Background()

	grpRepo := newFakeGroupRepo()
	memRepo := newFakeMembershipRepo()
	tenRepo := newFakeTenureRepo()
	perRepo := newFakePeriodRepo()

	em := &fakeEventsManager{repos: fakeRepos{
		grp: grpRepo,
		mem: memRepo,
		ten: tenRepo,
		per: perRepo,
	}}

	grpBiz := business.NewGroupBusiness(ctx, em, grpRepo, memRepo, nil)
	memBiz := business.NewMembershipBusiness(ctx, em, memRepo, nil)
	tenBiz := business.NewTenureBusiness(ctx, em, grpRepo, tenRepo, perRepo)
	perBiz := business.NewPeriodBusiness(ctx, em, tenRepo, perRepo)

	return &testEnv{
		grpBusiness: grpBiz,
		memBusiness: memBiz,
		tenBusiness: tenBiz,
		perBusiness: perBiz,
		grpRepo:     grpRepo,
		memRepo:     memRepo,
		tenRepo:     tenRepo,
		perRepo:     perRepo,
		cleanup:     func() { /* nothing to tear down */ },
	}
}

// createActiveGroup is a helper that creates a group with 5 members and
// transitions it through formation check to ACTIVE.
func createActiveGroup(ctx context.Context, t *testing.T, env *testEnv) *models.CustomerGroup {
	t.Helper()

	group := &models.CustomerGroup{
		Name:         "Test Active Group",
		GroupType:    int32(models.GroupTypeGrameen),
		SavingAmount: 50000,
		Currency:     "KES",
		State:        int32(constants.StateJustCreated),
	}
	created, err := env.grpBusiness.Create(ctx, group)
	if err != nil {
		t.Fatalf("createActiveGroup: Create: %v", err)
	}

	for i := range 5 {
		m := &models.Membership{
			GroupID:        created.GetID(),
			Name:           fmt.Sprintf("Member %c", 'A'+i),
			MembershipType: int32(models.MembershipTypeMember),
			Role:           int32(models.MembershipRoleMember),
			State:          int32(constants.StateActive),
		}
		m.GenID(ctx)
		env.memRepo.store(m)
	}

	// Formation check transitions JUST_CREATED -> CHECK_CREATED
	_, err = env.grpBusiness.CheckFormation(ctx, created.GetID())
	if err != nil {
		t.Fatalf("createActiveGroup: CheckFormation: %v", err)
	}

	// Welcome transitions CHECK_CREATED -> ACTIVE
	err = env.grpBusiness.WelcomeGroup(ctx, created.GetID())
	if err != nil {
		t.Fatalf("createActiveGroup: WelcomeGroup: %v", err)
	}

	activated, _ := env.grpBusiness.Get(ctx, created.GetID())
	return activated
}

// ===========================================================================
// Fake events.Manager -- persists emitted payloads into fake repos.
// ===========================================================================

type fakeRepos struct {
	grp *fakeGroupRepo
	mem *fakeMembershipRepo
	ten *fakeTenureRepo
	per *fakePeriodRepo
}

type fakeEventsManager struct {
	repos fakeRepos
}

func (f *fakeEventsManager) Add(_ events.EventI) {}
func (f *fakeEventsManager) Get(_ string) (events.EventI, error) {
	return nil, errors.New("not implemented")
}
func (f *fakeEventsManager) Handler() queue.SubscribeWorker { return nil }

// Emit intercepts event payloads and stores them in the corresponding fake
// repository, mimicking what the real event handlers do (persist to DB).
func (f *fakeEventsManager) Emit(_ context.Context, _ string, payload any) error {
	switch p := payload.(type) {
	case *models.CustomerGroup:
		f.repos.grp.store(p)
	case *models.Membership:
		f.repos.mem.store(p)
	case *models.Tenure:
		f.repos.ten.store(p)
	case *models.Period:
		f.repos.per.store(p)
	}
	return nil
}

// ===========================================================================
// Fake group repository
// ===========================================================================

type fakeGroupRepo struct {
	mu   sync.RWMutex
	data map[string]*models.CustomerGroup
}

func newFakeGroupRepo() *fakeGroupRepo {
	return &fakeGroupRepo{data: make(map[string]*models.CustomerGroup)}
}

func (r *fakeGroupRepo) store(g *models.CustomerGroup) {
	r.mu.Lock()
	defer r.mu.Unlock()
	if g.CreatedAt.IsZero() {
		g.CreatedAt = time.Now().UTC()
	}
	g.ModifiedAt = time.Now().UTC()
	r.data[g.GetID()] = g
}

// -- BaseRepository methods --

func (r *fakeGroupRepo) Pool() pool.Pool                 { return nil }
func (r *fakeGroupRepo) WorkManager() workerpool.Manager { return nil }
func (r *fakeGroupRepo) BatchSize() int                  { return 100 }
func (r *fakeGroupRepo) FieldsImmutable() []string       { return nil }
func (r *fakeGroupRepo) FieldsAllowed() map[string]struct{} {
	return map[string]struct{}{"group_id": {}, "state": {}}
}
func (r *fakeGroupRepo) ExtendFieldsAllowed(_ ...string) {}
func (r *fakeGroupRepo) IsFieldAllowed(_ string) error   { return nil }
func (r *fakeGroupRepo) BulkCreate(_ context.Context, _ []*models.CustomerGroup) error {
	return nil
}
func (r *fakeGroupRepo) BulkUpdate(_ context.Context, _ []string, _ map[string]any) (int64, error) {
	return 0, nil
}
func (r *fakeGroupRepo) Delete(_ context.Context, id string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	delete(r.data, id)
	return nil
}
func (r *fakeGroupRepo) DeleteBatch(_ context.Context, ids []string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for _, id := range ids {
		delete(r.data, id)
	}
	return nil
}
func (r *fakeGroupRepo) Count(_ context.Context) (int64, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return int64(len(r.data)), nil
}
func (r *fakeGroupRepo) CountBy(_ context.Context, _ map[string]any) (int64, error) {
	return 0, nil
}

func (r *fakeGroupRepo) Search(
	_ context.Context,
	_ *data.SearchQuery,
) (workerpool.JobResultPipe[[]*models.CustomerGroup], error) {
	return nil, errors.New("not implemented")
}
func (r *fakeGroupRepo) Create(_ context.Context, g *models.CustomerGroup) error {
	r.store(g)
	return nil
}
func (r *fakeGroupRepo) Update(_ context.Context, g *models.CustomerGroup, _ ...string) (int64, error) {
	r.store(g)
	return 1, nil
}
func (r *fakeGroupRepo) GetByID(_ context.Context, id string) (*models.CustomerGroup, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	if g, ok := r.data[id]; ok {
		return g, nil
	}
	return nil, fmt.Errorf("group not found: %s", id)
}
func (r *fakeGroupRepo) GetLastestBy(_ context.Context, props map[string]any) (*models.CustomerGroup, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var latest *models.CustomerGroup
	for _, g := range r.data {
		if matchProps(props, "group_id", g.GetID()) {
			if latest == nil || g.CreatedAt.After(latest.CreatedAt) {
				latest = g
			}
		}
	}
	if latest == nil {
		return nil, errors.New("no group found")
	}
	return latest, nil
}

func (r *fakeGroupRepo) GetAllBy(
	_ context.Context,
	_ map[string]any,
	_, _ int,
) ([]*models.CustomerGroup, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var result []*models.CustomerGroup
	for _, g := range r.data {
		result = append(result, g)
	}
	return result, nil
}

// ===========================================================================
// Fake membership repository
// ===========================================================================

type fakeMembershipRepo struct {
	mu   sync.RWMutex
	data map[string]*models.Membership
}

func newFakeMembershipRepo() *fakeMembershipRepo {
	return &fakeMembershipRepo{data: make(map[string]*models.Membership)}
}

func (r *fakeMembershipRepo) store(m *models.Membership) {
	r.mu.Lock()
	defer r.mu.Unlock()
	if m.CreatedAt.IsZero() {
		m.CreatedAt = time.Now().UTC()
	}
	m.ModifiedAt = time.Now().UTC()
	r.data[m.GetID()] = m
}

func (r *fakeMembershipRepo) Pool() pool.Pool                 { return nil }
func (r *fakeMembershipRepo) WorkManager() workerpool.Manager { return nil }
func (r *fakeMembershipRepo) BatchSize() int                  { return 100 }
func (r *fakeMembershipRepo) FieldsImmutable() []string       { return nil }
func (r *fakeMembershipRepo) FieldsAllowed() map[string]struct{} {
	return map[string]struct{}{"group_id": {}, "state": {}, "profile_id": {}}
}
func (r *fakeMembershipRepo) ExtendFieldsAllowed(_ ...string) {}
func (r *fakeMembershipRepo) IsFieldAllowed(_ string) error   { return nil }
func (r *fakeMembershipRepo) BulkCreate(_ context.Context, _ []*models.Membership) error {
	return nil
}
func (r *fakeMembershipRepo) BulkUpdate(_ context.Context, _ []string, _ map[string]any) (int64, error) {
	return 0, nil
}
func (r *fakeMembershipRepo) Delete(_ context.Context, id string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	delete(r.data, id)
	return nil
}
func (r *fakeMembershipRepo) DeleteBatch(_ context.Context, ids []string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for _, id := range ids {
		delete(r.data, id)
	}
	return nil
}
func (r *fakeMembershipRepo) Count(_ context.Context) (int64, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return int64(len(r.data)), nil
}
func (r *fakeMembershipRepo) CountBy(_ context.Context, _ map[string]any) (int64, error) {
	return 0, nil
}

func (r *fakeMembershipRepo) Search(
	_ context.Context,
	_ *data.SearchQuery,
) (workerpool.JobResultPipe[[]*models.Membership], error) {
	return nil, errors.New("not implemented")
}
func (r *fakeMembershipRepo) Create(_ context.Context, m *models.Membership) error {
	r.store(m)
	return nil
}
func (r *fakeMembershipRepo) Update(_ context.Context, m *models.Membership, _ ...string) (int64, error) {
	r.store(m)
	return 1, nil
}
func (r *fakeMembershipRepo) GetByID(_ context.Context, id string) (*models.Membership, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	if m, ok := r.data[id]; ok {
		return m, nil
	}
	return nil, fmt.Errorf("membership not found: %s", id)
}
func (r *fakeMembershipRepo) GetLastestBy(_ context.Context, _ map[string]any) (*models.Membership, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var latest *models.Membership
	for _, m := range r.data {
		if latest == nil || m.CreatedAt.After(latest.CreatedAt) {
			latest = m
		}
	}
	if latest == nil {
		return nil, errors.New("no membership found")
	}
	return latest, nil
}
func (r *fakeMembershipRepo) GetAllBy(_ context.Context, _ map[string]any, _, _ int) ([]*models.Membership, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var result []*models.Membership
	for _, m := range r.data {
		result = append(result, m)
	}
	return result, nil
}

// GetByGroupID returns all memberships for a given group, excluding deleted.
func (r *fakeMembershipRepo) GetByGroupID(_ context.Context, groupID string) ([]*models.Membership, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var result []*models.Membership
	for _, m := range r.data {
		if m.GroupID == groupID && m.State != int32(constants.StateDeleted) {
			result = append(result, m)
		}
	}
	return result, nil
}

// GetByProfileID returns all memberships for a given profile, excluding deleted.
func (r *fakeMembershipRepo) GetByProfileID(_ context.Context, profileID string) ([]*models.Membership, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var result []*models.Membership
	for _, m := range r.data {
		if m.ProfileID == profileID && m.State != int32(constants.StateDeleted) {
			result = append(result, m)
		}
	}
	return result, nil
}

// ===========================================================================
// Fake tenure repository
// ===========================================================================

type fakeTenureRepo struct {
	mu   sync.RWMutex
	data map[string]*models.Tenure
}

func newFakeTenureRepo() *fakeTenureRepo {
	return &fakeTenureRepo{data: make(map[string]*models.Tenure)}
}

func (r *fakeTenureRepo) store(t *models.Tenure) {
	r.mu.Lock()
	defer r.mu.Unlock()
	if t.CreatedAt.IsZero() {
		t.CreatedAt = time.Now().UTC()
	}
	t.ModifiedAt = time.Now().UTC()
	r.data[t.GetID()] = t
}

func (r *fakeTenureRepo) Pool() pool.Pool                 { return nil }
func (r *fakeTenureRepo) WorkManager() workerpool.Manager { return nil }
func (r *fakeTenureRepo) BatchSize() int                  { return 100 }
func (r *fakeTenureRepo) FieldsImmutable() []string       { return nil }
func (r *fakeTenureRepo) FieldsAllowed() map[string]struct{} {
	return map[string]struct{}{"group_id": {}, "state": {}}
}
func (r *fakeTenureRepo) ExtendFieldsAllowed(_ ...string) {}
func (r *fakeTenureRepo) IsFieldAllowed(_ string) error   { return nil }
func (r *fakeTenureRepo) BulkCreate(_ context.Context, _ []*models.Tenure) error {
	return nil
}
func (r *fakeTenureRepo) BulkUpdate(_ context.Context, _ []string, _ map[string]any) (int64, error) {
	return 0, nil
}
func (r *fakeTenureRepo) Delete(_ context.Context, id string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	delete(r.data, id)
	return nil
}
func (r *fakeTenureRepo) DeleteBatch(_ context.Context, ids []string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for _, id := range ids {
		delete(r.data, id)
	}
	return nil
}
func (r *fakeTenureRepo) Count(_ context.Context) (int64, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return int64(len(r.data)), nil
}
func (r *fakeTenureRepo) CountBy(_ context.Context, _ map[string]any) (int64, error) {
	return 0, nil
}

func (r *fakeTenureRepo) Search(
	_ context.Context,
	_ *data.SearchQuery,
) (workerpool.JobResultPipe[[]*models.Tenure], error) {
	return nil, errors.New("not implemented")
}
func (r *fakeTenureRepo) Create(_ context.Context, t *models.Tenure) error {
	r.store(t)
	return nil
}
func (r *fakeTenureRepo) Update(_ context.Context, t *models.Tenure, _ ...string) (int64, error) {
	r.store(t)
	return 1, nil
}
func (r *fakeTenureRepo) GetByID(_ context.Context, id string) (*models.Tenure, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	if t, ok := r.data[id]; ok {
		return t, nil
	}
	return nil, fmt.Errorf("tenure not found: %s", id)
}
func (r *fakeTenureRepo) GetLastestBy(_ context.Context, props map[string]any) (*models.Tenure, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var latest *models.Tenure
	for _, t := range r.data {
		if matchPropsForTenure(t, props) {
			if latest == nil || t.CreatedAt.After(latest.CreatedAt) {
				latest = t
			}
		}
	}
	if latest == nil {
		return nil, errors.New("no tenure found")
	}
	return latest, nil
}
func (r *fakeTenureRepo) GetAllBy(_ context.Context, _ map[string]any, _, _ int) ([]*models.Tenure, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var result []*models.Tenure
	for _, t := range r.data {
		result = append(result, t)
	}
	return result, nil
}

// GetActiveByGroupID returns the most recent non-deleted tenure for the group.
func (r *fakeTenureRepo) GetActiveByGroupID(_ context.Context, groupID string) (*models.Tenure, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var latest *models.Tenure
	for _, t := range r.data {
		if t.GroupID == groupID && t.State != int32(constants.StateDeleted) {
			if latest == nil || t.CreatedAt.After(latest.CreatedAt) {
				latest = t
			}
		}
	}
	if latest == nil {
		return nil, fmt.Errorf("no active tenure for group: %s", groupID)
	}
	return latest, nil
}

// ===========================================================================
// Fake period repository
// ===========================================================================

type fakePeriodRepo struct {
	mu   sync.RWMutex
	data map[string]*models.Period
}

func newFakePeriodRepo() *fakePeriodRepo {
	return &fakePeriodRepo{data: make(map[string]*models.Period)}
}

func (r *fakePeriodRepo) store(p *models.Period) {
	r.mu.Lock()
	defer r.mu.Unlock()
	if p.CreatedAt.IsZero() {
		p.CreatedAt = time.Now().UTC()
	}
	p.ModifiedAt = time.Now().UTC()
	r.data[p.GetID()] = p
}

func (r *fakePeriodRepo) Pool() pool.Pool                 { return nil }
func (r *fakePeriodRepo) WorkManager() workerpool.Manager { return nil }
func (r *fakePeriodRepo) BatchSize() int                  { return 100 }
func (r *fakePeriodRepo) FieldsImmutable() []string       { return nil }
func (r *fakePeriodRepo) FieldsAllowed() map[string]struct{} {
	return map[string]struct{}{"group_id": {}, "tenure_id": {}, "state": {}}
}
func (r *fakePeriodRepo) ExtendFieldsAllowed(_ ...string) {}
func (r *fakePeriodRepo) IsFieldAllowed(_ string) error   { return nil }
func (r *fakePeriodRepo) BulkCreate(_ context.Context, _ []*models.Period) error {
	return nil
}
func (r *fakePeriodRepo) BulkUpdate(_ context.Context, _ []string, _ map[string]any) (int64, error) {
	return 0, nil
}
func (r *fakePeriodRepo) Delete(_ context.Context, id string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	delete(r.data, id)
	return nil
}
func (r *fakePeriodRepo) DeleteBatch(_ context.Context, ids []string) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	for _, id := range ids {
		delete(r.data, id)
	}
	return nil
}
func (r *fakePeriodRepo) Count(_ context.Context) (int64, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	return int64(len(r.data)), nil
}
func (r *fakePeriodRepo) CountBy(_ context.Context, _ map[string]any) (int64, error) {
	return 0, nil
}

func (r *fakePeriodRepo) Search(
	_ context.Context,
	_ *data.SearchQuery,
) (workerpool.JobResultPipe[[]*models.Period], error) {
	return nil, errors.New("not implemented")
}
func (r *fakePeriodRepo) Create(_ context.Context, p *models.Period) error {
	r.store(p)
	return nil
}
func (r *fakePeriodRepo) Update(_ context.Context, p *models.Period, _ ...string) (int64, error) {
	r.store(p)
	return 1, nil
}
func (r *fakePeriodRepo) GetByID(_ context.Context, id string) (*models.Period, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	if p, ok := r.data[id]; ok {
		return p, nil
	}
	return nil, fmt.Errorf("period not found: %s", id)
}
func (r *fakePeriodRepo) GetLastestBy(_ context.Context, props map[string]any) (*models.Period, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var latest *models.Period
	for _, p := range r.data {
		if matchPropsForPeriod(p, props) {
			if latest == nil || p.CreatedAt.After(latest.CreatedAt) {
				latest = p
			}
		}
	}
	if latest == nil {
		return nil, errors.New("no period found")
	}
	return latest, nil
}
func (r *fakePeriodRepo) GetAllBy(_ context.Context, _ map[string]any, _, _ int) ([]*models.Period, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	var result []*models.Period
	for _, p := range r.data {
		result = append(result, p)
	}
	return result, nil
}

// GetCurrentByGroupID returns the most recent non-deleted period for the group.
func (r *fakePeriodRepo) GetCurrentByGroupID(_ context.Context, groupID string) (*models.Period, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	var candidates []*models.Period
	for _, p := range r.data {
		if p.GroupID == groupID && p.State != int32(constants.StateDeleted) {
			candidates = append(candidates, p)
		}
	}
	if len(candidates) == 0 {
		return nil, fmt.Errorf("no current period for group: %s", groupID)
	}
	sort.Slice(candidates, func(i, j int) bool {
		return candidates[i].CreatedAt.After(candidates[j].CreatedAt)
	})
	return candidates[0], nil
}

// ===========================================================================
// Property matching helpers for fake repos
// ===========================================================================

func matchProps(props map[string]any, key, value string) bool {
	if v, ok := props[key]; ok {
		return fmt.Sprintf("%v", v) == value
	}
	return true // no filter on this key
}

func matchPropsForTenure(t *models.Tenure, props map[string]any) bool {
	for k, v := range props {
		if k == "group_id" {
			if fmt.Sprintf("%v", v) != t.GroupID {
				return false
			}
		}
	}
	return true
}

func matchPropsForPeriod(p *models.Period, props map[string]any) bool {
	for k, v := range props {
		switch k {
		case "group_id":
			if fmt.Sprintf("%v", v) != p.GroupID {
				return false
			}
		case "tenure_id":
			if fmt.Sprintf("%v", v) != p.TenureID {
				return false
			}
		}
	}
	return true
}

// Compile-time interface satisfaction checks.
var _ repository.CustomerGroupRepository = (*fakeGroupRepo)(nil)
var _ repository.MembershipRepository = (*fakeMembershipRepo)(nil)
var _ repository.TenureRepository = (*fakeTenureRepo)(nil)
var _ repository.PeriodRepository = (*fakePeriodRepo)(nil)
var _ events.Manager = (*fakeEventsManager)(nil)

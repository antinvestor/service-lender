// Copyright 2023-2026 Ant Investor Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package business

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"gorm.io/datatypes"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
)

// stubAttrRepo satisfies repository.SubjectAttributeRepository for tests.
type stubAttrRepo struct {
	store       map[string]*models.SubjectAttributeSnapshot
	getCalls    int
	upsertCalls int
}

func newStubAttrRepo() *stubAttrRepo {
	return &stubAttrRepo{store: make(map[string]*models.SubjectAttributeSnapshot)}
}

func (s *stubAttrRepo) Get(
	_ context.Context,
	subjectType models.Subject,
	subjectID string,
) (*models.SubjectAttributeSnapshot, error) {
	s.getCalls++
	return s.store[string(subjectType)+":"+subjectID], nil
}

func (s *stubAttrRepo) Upsert(_ context.Context, snap *models.SubjectAttributeSnapshot) error {
	s.upsertCalls++
	s.store[string(snap.SubjectType)+":"+snap.SubjectID] = snap
	return nil
}

func TestResolver_NonClientReturnsEmpty(t *testing.T) {
	r := NewAttributeResolver(newStubAttrRepo(), nil, 60*time.Second)
	out, err := r.Get(context.Background(), models.SubjectAccount, "a1")
	require.NoError(t, err)
	assert.Equal(t, map[string]any{}, out)
}

func TestResolver_DBSnapshotHit(t *testing.T) {
	repo := newStubAttrRepo()
	repo.store["client:c1"] = &models.SubjectAttributeSnapshot{
		SubjectType: models.SubjectClient,
		SubjectID:   "c1",
		Attributes:  datatypes.JSON([]byte(`{"kyc_tier":"silver"}`)),
		FetchedAt:   time.Now().UTC(),
	}
	r := NewAttributeResolver(repo, nil, 60*time.Second)
	out, err := r.Get(context.Background(), models.SubjectClient, "c1")
	require.NoError(t, err)
	assert.Equal(t, "silver", out["kyc_tier"])
}

func TestResolver_LRUHitNoSecondDBCall(t *testing.T) {
	repo := newStubAttrRepo()
	repo.store["client:c1"] = &models.SubjectAttributeSnapshot{
		SubjectType: models.SubjectClient,
		SubjectID:   "c1",
		Attributes:  datatypes.JSON([]byte(`{"kyc_tier":"silver"}`)),
		FetchedAt:   time.Now().UTC(),
	}
	r := NewAttributeResolver(repo, nil, 60*time.Second)
	_, _ = r.Get(context.Background(), models.SubjectClient, "c1")
	_, _ = r.Get(context.Background(), models.SubjectClient, "c1")
	assert.Equal(t, 1, repo.getCalls, "second call should hit LRU, not DB")
}

func TestResolver_NilIdentityFallsBackToEmpty(t *testing.T) {
	r := NewAttributeResolver(newStubAttrRepo(), nil, 60*time.Second)
	out, err := r.Get(context.Background(), models.SubjectClient, "c1")
	require.NoError(t, err)
	// nil identity client + empty repo → fetchFromIdentity returns (nil, nil)
	// → resolver returns (nil, nil) as documented safe fallback.
	assert.Nil(t, out)
}

func TestResolver_Invalidate(t *testing.T) {
	repo := newStubAttrRepo()
	repo.store["client:c1"] = &models.SubjectAttributeSnapshot{
		SubjectType: models.SubjectClient,
		SubjectID:   "c1",
		Attributes:  datatypes.JSON([]byte(`{"kyc_tier":"silver"}`)),
		FetchedAt:   time.Now().UTC(),
	}
	r := NewAttributeResolver(repo, nil, 60*time.Second)
	_, _ = r.Get(context.Background(), models.SubjectClient, "c1") // warms LRU
	r.Invalidate(models.SubjectClient, "c1")
	_, _ = r.Get(context.Background(), models.SubjectClient, "c1") // must miss LRU, re-hit DB
	assert.GreaterOrEqual(t, repo.getCalls, 2, "after invalidate the next call must re-check DB")
}

func TestResolver_NonClientSubjectsNeverHitRepo(t *testing.T) {
	repo := newStubAttrRepo()
	r := NewAttributeResolver(repo, nil, 60*time.Second)
	for _, st := range []models.Subject{
		models.SubjectAccount,
		models.SubjectProduct,
		models.SubjectOrganization,
		models.SubjectOrgUnit,
		models.SubjectWorkforceMember,
	} {
		out, err := r.Get(context.Background(), st, "x")
		require.NoError(t, err)
		assert.Equal(t, map[string]any{}, out, "subject type %q should return empty attrs", st)
	}
	assert.Equal(t, 0, repo.getCalls, "non-client subjects must not touch the repo")
}

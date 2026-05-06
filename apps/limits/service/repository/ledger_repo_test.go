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

package repository_test

import (
	"context"
	"testing"
	"time"

	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/frametests"
	"github.com/pitabwire/frame/frametests/definition"
	"github.com/pitabwire/frame/frametests/deps/testpostgres"
	"github.com/pitabwire/util"
	"github.com/stretchr/testify/suite"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

type LedgerRepoSuite struct {
	frametests.FrameBaseTestSuite
}

func (s *LedgerRepoSuite) SetupSuite() {
	s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
		return []definition.TestResource{
			testpostgres.NewWithOpts("limits_test", definition.WithUserName("test")),
		}
	}
	s.FrameBaseTestSuite.SetupSuite()
}

func (s *LedgerRepoSuite) newEnv(tenantID, partitionID string) (context.Context, repository.LedgerRepository) {
	s.T().Helper()

	ctx := s.T().Context()
	ctx = s.WithAuthClaims(ctx, tenantID, partitionID, "test-user")

	db := s.ledgerDatabaseResource(ctx)
	dsn, cleanup, err := db.GetRandomisedDS(ctx, util.RandomAlphaNumericString(8))
	s.Require().NoError(err)
	s.T().Cleanup(func() { cleanup(ctx) })

	ctx, svc := frame.NewServiceWithContext(
		ctx,
		frame.WithName("limits-ledger-test"),
		frame.WithDatastore(pool.WithConnection(dsn.String(), false)),
	)
	s.T().Cleanup(func() { svc.Stop(ctx) })
	svc.Init(ctx)

	dbManager := svc.DatastoreManager()
	s.Require().NoError(repository.Migrate(ctx, dbManager, ""))

	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	s.Require().NotNil(dbPool)

	return ctx, repository.NewLedgerRepository(ctx, dbPool, svc.WorkManager())
}

func (s *LedgerRepoSuite) ledgerDatabaseResource(ctx context.Context) definition.DependancyConn {
	s.T().Helper()
	for _, resource := range s.Resources() {
		if resource.Name() == testpostgres.PostgresqlDBImage && resource.GetDS(ctx).IsDB() {
			return resource
		}
	}
	s.T().Fatal("postgres test resource not found")
	return nil
}

func entry(rid string, amt int64, at time.Time) *models.LedgerEntry {
	return &models.LedgerEntry{
		ReservationID: rid,
		Action:        models.ActionLoanDisbursement,
		SubjectType:   models.SubjectClient,
		SubjectID:     "c1",
		CurrencyCode:  "KES",
		Amount:        amt,
		CommittedAt:   at,
	}
}

func (s *LedgerRepoSuite) TestCreateBatchAndWindowSum() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()

	entries := []*models.LedgerEntry{
		entry("rid-1", 100, now.Add(-1*time.Hour)),
		entry("rid-2", 200, now.Add(-30*time.Minute)),
		entry("rid-3", 50, now.Add(-2*time.Hour)),
	}
	s.Require().NoError(repo.CreateBatch(ctx, entries))

	since := now.Add(-90 * time.Minute)
	sum, err := repo.WindowSum(ctx, models.ActionLoanDisbursement, "KES",
		repository.SubjectFilter{Type: models.SubjectClient, ID: "c1"}, since)
	s.Require().NoError(err)
	// 100 (at -1h, in window) + 200 (at -30m, in window) = 300; 50 (at -2h) excluded
	s.Equal(int64(300), sum)
}

func (s *LedgerRepoSuite) TestMarkReversedExcludedFromSum() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()

	entries := []*models.LedgerEntry{
		entry("rid-a", 500, now.Add(-10*time.Minute)),
		entry("rid-b", 300, now.Add(-5*time.Minute)),
	}
	s.Require().NoError(repo.CreateBatch(ctx, entries))

	s.Require().NoError(repo.MarkReversed(ctx, "rid-a", now))

	since := now.Add(-1 * time.Hour)
	sum, err := repo.WindowSum(ctx, models.ActionLoanDisbursement, "KES",
		repository.SubjectFilter{Type: models.SubjectClient, ID: "c1"}, since)
	s.Require().NoError(err)
	// rid-a is reversed, only rid-b (300) should count
	s.Equal(int64(300), sum)
}

func (s *LedgerRepoSuite) TestWindowCount() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()
	since := now.Add(-1 * time.Hour)

	entries := make([]*models.LedgerEntry, 5)
	for i := range entries {
		entries[i] = entry("rid-cnt-"+util.IDString(), 100, now.Add(-30*time.Minute))
	}
	s.Require().NoError(repo.CreateBatch(ctx, entries))

	count, err := repo.WindowCount(ctx, models.ActionLoanDisbursement, "KES",
		repository.SubjectFilter{Type: models.SubjectClient, ID: "c1"}, since)
	s.Require().NoError(err)
	s.Equal(int64(5), count)
}

func (s *LedgerRepoSuite) TestSearchByAction() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()

	entries := []*models.LedgerEntry{
		entry("rid-s1", 100, now.Add(-1*time.Hour)),
		entry("rid-s2", 200, now.Add(-30*time.Minute)),
		entry("rid-s3", 300, now.Add(-10*time.Minute)),
	}
	s.Require().NoError(repo.CreateBatch(ctx, entries))

	result, err := repo.Search(ctx, repository.LedgerSearchFilter{
		Action: models.ActionLoanDisbursement,
	}, 100, "")
	s.Require().NoError(err)
	s.Len(result.Items, 3)
}

func TestLedgerRepoSuite(t *testing.T) {
	suite.Run(t, new(LedgerRepoSuite))
}

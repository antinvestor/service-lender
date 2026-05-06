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

package outbox_test

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

	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

type OutboxRepoSuite struct {
	frametests.FrameBaseTestSuite
}

func (s *OutboxRepoSuite) SetupSuite() {
	s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
		return []definition.TestResource{
			testpostgres.NewWithOpts("outbox_test", definition.WithUserName("test")),
		}
	}
	s.FrameBaseTestSuite.SetupSuite()
}

func (s *OutboxRepoSuite) newEnv(tenantID, partitionID string) (context.Context, outbox.Repository) {
	s.T().Helper()

	ctx := s.T().Context()
	ctx = s.WithAuthClaims(ctx, tenantID, partitionID, "test-user")

	db := s.databaseResource(ctx)
	dsn, cleanup, err := db.GetRandomisedDS(ctx, util.RandomAlphaNumericString(8))
	s.Require().NoError(err)
	s.T().Cleanup(func() { cleanup(ctx) })

	ctx, svc := frame.NewServiceWithContext(
		ctx,
		frame.WithName("outbox-test"),
		frame.WithDatastore(pool.WithConnection(dsn.String(), false)),
	)
	s.T().Cleanup(func() { svc.Stop(ctx) })
	svc.Init(ctx)

	dbManager := svc.DatastoreManager()
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	s.Require().NotNil(dbPool)
	s.Require().NoError(dbManager.Migrate(ctx, dbPool, "", &outbox.Row{}))

	return ctx, outbox.NewRepository(ctx, dbPool, svc.WorkManager())
}

func (s *OutboxRepoSuite) databaseResource(ctx context.Context) definition.DependancyConn {
	s.T().Helper()
	for _, resource := range s.Resources() {
		if resource.Name() == testpostgres.PostgresqlDBImage && resource.GetDS(ctx).IsDB() {
			return resource
		}
	}
	s.T().Fatal("postgres test resource not found")
	return nil
}

func sampleRow(reservationID string, action outbox.Action, due time.Time) *outbox.Row {
	return &outbox.Row{
		ReservationID: reservationID,
		Action:        action,
		Status:        outbox.StatusPending,
		Attempt:       0,
		NextAttemptAt: due,
	}
}

func (s *OutboxRepoSuite) TestClaimDue_DueRowsReturned() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()
	due := sampleRow("res-1", outbox.ActionCommit, now.Add(-1*time.Minute))
	notYet := sampleRow("res-2", outbox.ActionCommit, now.Add(1*time.Minute))
	s.Require().NoError(repo.Insert(ctx, due))
	s.Require().NoError(repo.Insert(ctx, notYet))

	rows, err := repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Len(rows, 1)
	s.Equal(due.ID, rows[0].ID)
}

func (s *OutboxRepoSuite) TestClaimDue_RespectsBatchSize() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()
	for i := 0; i < 5; i++ {
		s.Require().NoError(repo.Insert(ctx, sampleRow("res-x", outbox.ActionCommit, now.Add(-1*time.Minute))))
	}
	rows, err := repo.ClaimDue(ctx, 3)
	s.Require().NoError(err)
	s.Len(rows, 3)
}

func (s *OutboxRepoSuite) TestClaimDue_SkipsTerminal() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()
	row := sampleRow("res-1", outbox.ActionCommit, now.Add(-1*time.Minute))
	row.Status = outbox.StatusDone
	s.Require().NoError(repo.Insert(ctx, row))
	rows, err := repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Empty(rows)
}

func (s *OutboxRepoSuite) TestMarkRetry_DefersFutureClaim() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()
	row := sampleRow("res-1", outbox.ActionCommit, now.Add(-1*time.Minute))
	s.Require().NoError(repo.Insert(ctx, row))
	nextAt := now.Add(30 * time.Second)
	s.Require().NoError(repo.MarkRetry(ctx, row.ID, "transient", nextAt))

	rows, err := repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Empty(rows, "row's NextAttemptAt is in the future after retry mark")
}

func TestOutboxRepoSuite(t *testing.T) { suite.Run(t, new(OutboxRepoSuite)) }

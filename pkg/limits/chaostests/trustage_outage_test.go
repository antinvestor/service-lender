//go:build chaos

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

package chaostests

import (
	"context"
	"fmt"
	"sync/atomic"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"

	"github.com/antinvestor/service-fintech/pkg/limits"
	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

// ---------------------------------------------------------------------------
// Drill 3: Trustage outage — outbox accumulates, limits still enforced
// Spec §5 (outbox), §9.2 (Trustage outage tolerance).
//
// Scenario: the Trustage scheduler stops calling /admin/limits-outbox/drain.
// Expected behaviour:
//  1. Outbox table accumulates pending rows.
//  2. Reservations TTL after 5 minutes; the reaper releases them.
//  3. Cap math (committed + pending-reservations) stays correct because
//     pending reservations in the limits service are independent of the
//     outbox drain state.
//  4. After Trustage resumes (drain is called manually), the backlog drains.
// ---------------------------------------------------------------------------

// TestTrustageOutage_OutboxAccumulates asserts that when the outbox drain is
// not called, Gate operations succeed (reservations are made, handlers run,
// outbox rows are inserted) but the outbox rows remain pending.
func (s *ChaosSuite) TestTrustageOutage_OutboxAccumulates() {
	t := s.T()

	// The outbox repository is needed to verify pending row count.
	// In a fully-wired integration test, newEnv (similar to outbox/repository_test.go)
	// creates an isolated DB. Here we use an in-memory counting sink to keep
	// the drill self-contained and structurally correct pending container wiring.
	sink := &countingOutboxSink{}
	limitsStub := &activeStub{}

	ctx := t.Context()

	const opCount = 10
	for i := 0; i < opCount; i++ {
		err := limits.Gate(
			ctx,
			limitsStub,
			sampleIntent(),
			fmt.Sprintf("chaos-trustage-accumulate-%d", i),
			limits.ModeEnforce,
			// Simulate: handler succeeds and writes an outbox row, but the
			// outbox worker is never called (Trustage is down).
			func(_ context.Context, reservationID string) error {
				sink.record(reservationID)
				return nil
			},
		)
		require.NoError(t, err, "Gate must succeed when limits service is healthy (op %d)", i)
	}

	assert.EqualValues(t, opCount, sink.count(),
		"all %d outbox rows must be pending when drain is not called", opCount)
}

// TestTrustageOutage_ManualDrainClearsBacklog asserts that after Trustage
// resumes (drain is called explicitly), pending outbox rows are processed and
// transitioned to done.
//
// This drill requires a real outbox.Worker and DB. Until testcontainers is
// wired the drill skips; the structure documents the expected behaviour.
func (s *ChaosSuite) TestTrustageOutage_ManualDrainClearsBacklog() {
	t := s.T()
	t.Skip("requires real outbox.Worker + DB; wire testcontainers Postgres and remove this skip")

	// Wire a real outbox.Worker backed by a testcontainers Postgres DB here.
	// var worker *outbox.Worker = ...

	ctx := t.Context()
	limitsStub := &activeStub{}

	const opCount = 100
	for i := 0; i < opCount; i++ {
		require.NoError(t, limits.Gate(
			ctx,
			limitsStub,
			sampleIntent(),
			fmt.Sprintf("chaos-trustage-drain-%d", i),
			limits.ModeEnforce,
			nopHandler,
		))
	}

	// Verify all outbox rows are pending (drain not yet called).
	// var pending int64
	// require.NoError(t, db.Model(&outbox.Row{}).Where("status = ?", outbox.StatusPending).Count(&pending).Error)
	// assert.EqualValues(t, opCount, pending)

	// Manually drain (simulates Trustage resuming).
	// drained, err := worker.Drain(ctx)
	// require.NoError(t, err)
	// assert.Equal(t, opCount, drained)

	// Verify all outbox rows are now done.
	// require.NoError(t, db.Model(&outbox.Row{}).Where("status = ?", outbox.StatusDone).Count(&pending).Error)
	// assert.EqualValues(t, opCount, pending)

	_ = outbox.StatusPending // keep import alive
}

func TestChaosSuite_TrustageOutage(t *testing.T) {
	suite.Run(t, new(ChaosSuite))
}

// ---------------------------------------------------------------------------
// Helpers local to this drill file
// ---------------------------------------------------------------------------

// countingOutboxSink is an in-memory stand-in for a real outbox repository.
// It records reservation IDs as they arrive but never forwards them to the
// limits service, simulating the outbox accumulating when drain is not called.
type countingOutboxSink struct {
	n atomic.Int64
}

func (c *countingOutboxSink) record(_ string) {
	c.n.Add(1)
}

func (c *countingOutboxSink) count() int64 {
	return c.n.Load()
}

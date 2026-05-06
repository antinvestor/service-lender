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
	"errors"
	"testing"
	"time"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"

	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

// stubRPC implements limitsv1connect.LimitsServiceClient exercising only
// Commit and Release — the only methods the worker calls.
type stubRPC struct {
	commitErr  error
	releaseErr error
	commits    []string
	releases   []releaseCall
}

type releaseCall struct {
	id     string
	reason string
}

func (s *stubRPC) Check(
	_ context.Context,
	_ *connect.Request[limitsv1.CheckRequest],
) (*connect.Response[limitsv1.CheckResponse], error) {
	return connect.NewResponse(&limitsv1.CheckResponse{}), nil
}

func (s *stubRPC) Reserve(
	_ context.Context,
	_ *connect.Request[limitsv1.ReserveRequest],
) (*connect.Response[limitsv1.ReserveResponse], error) {
	return connect.NewResponse(&limitsv1.ReserveResponse{}), nil
}

func (s *stubRPC) Commit(
	_ context.Context,
	req *connect.Request[limitsv1.CommitRequest],
) (*connect.Response[limitsv1.CommitResponse], error) {
	if s.commitErr != nil {
		return nil, s.commitErr
	}
	s.commits = append(s.commits, req.Msg.GetReservationId())
	return connect.NewResponse(&limitsv1.CommitResponse{}), nil
}

func (s *stubRPC) Release(
	_ context.Context,
	req *connect.Request[limitsv1.ReleaseRequest],
) (*connect.Response[limitsv1.ReleaseResponse], error) {
	if s.releaseErr != nil {
		return nil, s.releaseErr
	}
	s.releases = append(s.releases, releaseCall{id: req.Msg.GetReservationId(), reason: req.Msg.GetReason()})
	return connect.NewResponse(&limitsv1.ReleaseResponse{}), nil
}

func (s *stubRPC) Reverse(
	_ context.Context,
	_ *connect.Request[limitsv1.ReverseRequest],
) (*connect.Response[limitsv1.ReverseResponse], error) {
	return connect.NewResponse(&limitsv1.ReverseResponse{}), nil
}

var _ limitsv1connect.LimitsServiceClient = (*stubRPC)(nil)

type WorkerSuite struct {
	OutboxRepoSuite
}

func (s *WorkerSuite) TestWorker_DrainsCommitRow() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()
	row := &outbox.Row{
		ReservationID: "res-1", Action: outbox.ActionCommit,
		Status: outbox.StatusPending, NextAttemptAt: now.Add(-1 * time.Minute),
	}
	s.Require().NoError(repo.Insert(ctx, row))

	rpc := &stubRPC{}
	w := outbox.NewWorker(repo, rpc, nil)
	_, err := w.Drain(ctx)
	require.NoError(s.T(), err)
	assert.Equal(s.T(), []string{"res-1"}, rpc.commits)
}

func (s *WorkerSuite) TestWorker_DrainsReleaseRow() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()
	row := &outbox.Row{
		ReservationID: "res-2", Action: outbox.ActionRelease, Reason: "user cancelled",
		Status: outbox.StatusPending, NextAttemptAt: now.Add(-1 * time.Minute),
	}
	s.Require().NoError(repo.Insert(ctx, row))

	rpc := &stubRPC{}
	w := outbox.NewWorker(repo, rpc, nil)
	_, err := w.Drain(ctx)
	require.NoError(s.T(), err)
	require.Len(s.T(), rpc.releases, 1)
	assert.Equal(s.T(), "res-2", rpc.releases[0].id)
	assert.Equal(s.T(), "user cancelled", rpc.releases[0].reason)
}

func (s *WorkerSuite) TestWorker_RetriesOnTransientError() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()
	row := &outbox.Row{
		ReservationID: "res-3", Action: outbox.ActionCommit,
		Status: outbox.StatusPending, NextAttemptAt: now.Add(-1 * time.Minute),
	}
	s.Require().NoError(repo.Insert(ctx, row))

	rpc := &stubRPC{commitErr: errors.New("network blip")}
	w := outbox.NewWorker(repo, rpc, nil)
	_, err := w.Drain(ctx)
	require.NoError(s.T(), err)

	rows, err := repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Empty(rows, "row's next_attempt_at bumped into the future after failure")
}

func (s *WorkerSuite) TestWorker_DeadAfterMaxAttempts() {
	ctx, repo := s.newEnv("t-1", "p-1")
	now := time.Now().UTC()
	row := &outbox.Row{
		ReservationID: "res-4", Action: outbox.ActionCommit,
		Status: outbox.StatusPending, Attempt: 9,
		NextAttemptAt: now.Add(-1 * time.Minute),
	}
	s.Require().NoError(repo.Insert(ctx, row))

	rpc := &stubRPC{commitErr: errors.New("persistently broken")}
	w := outbox.NewWorker(repo, rpc, nil)
	_, err := w.Drain(ctx)
	require.NoError(s.T(), err)

	rows, err := repo.ClaimDue(ctx, 100)
	s.Require().NoError(err)
	s.Empty(rows, "row was dead-lettered after attempt 10")
}

func TestWorkerSuite(t *testing.T) { suite.Run(t, new(WorkerSuite)) }

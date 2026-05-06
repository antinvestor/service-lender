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

package outbox

import (
	"context"
	"errors"
	"time"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/util"
)

const (
	defaultPollInterval = 5 * time.Second
	defaultBatchSize    = 100
	maxAttempts         = 10
)

// Worker drains pending outbox rows and invokes the corresponding limits
// RPC. Wired up in each consumer service's main.go via Frame's WorkerPool
// or via a long-lived goroutine — Run blocks until ctx is cancelled.
type Worker struct {
	repo     Repository
	rpc      limitsv1connect.LimitsServiceClient
	interval time.Duration
	batch    int
}

// NewWorker constructs an outbox Worker backed by the given repo and
// limits RPC client.
func NewWorker(repo Repository, rpc limitsv1connect.LimitsServiceClient) *Worker {
	return &Worker{repo: repo, rpc: rpc, interval: defaultPollInterval, batch: defaultBatchSize}
}

// Run loops every pollInterval until ctx is cancelled, draining one
// batch of due outbox rows per tick.
func (w *Worker) Run(ctx context.Context) error {
	t := time.NewTicker(w.interval)
	defer t.Stop()
	for {
		select {
		case <-ctx.Done():
			if err := ctx.Err(); err != nil && !errors.Is(err, context.Canceled) {
				return err
			}
			return nil
		case <-t.C:
			if err := w.RunOnce(ctx); err != nil {
				util.Log(ctx).WithError(err).Error("limits outbox: drain pass failed")
			}
		}
	}
}

// RunOnce drains a single batch. Exposed for tests and external schedulers.
func (w *Worker) RunOnce(ctx context.Context) error {
	rows, err := w.repo.ClaimDue(ctx, w.batch)
	if err != nil {
		return err
	}
	for _, row := range rows {
		w.processRow(ctx, row)
	}
	return nil
}

func (w *Worker) processRow(ctx context.Context, row *Row) {
	log := util.Log(ctx).
		With("outbox_id", row.ID).
		With("reservation_id", row.ReservationID).
		With("action", string(row.Action))

	var rpcErr error
	switch row.Action {
	case ActionCommit:
		_, rpcErr = w.rpc.Commit(ctx, connect.NewRequest(&limitsv1.CommitRequest{
			ReservationId: row.ReservationID,
		}))
	case ActionRelease:
		_, rpcErr = w.rpc.Release(ctx, connect.NewRequest(&limitsv1.ReleaseRequest{
			ReservationId: row.ReservationID,
			Reason:        row.Reason,
		}))
	default:
		log.Error("limits outbox: unknown action; marking dead")
		_ = w.repo.MarkDead(ctx, row.ID, "unknown action: "+string(row.Action))
		return
	}

	if rpcErr == nil {
		if err := w.repo.MarkDone(ctx, row.ID); err != nil {
			log.WithError(err).Error("limits outbox: MarkDone failed")
		}
		return
	}

	if row.Attempt+1 >= maxAttempts {
		log.WithError(rpcErr).With("attempt", row.Attempt+1).Error("limits outbox: max attempts reached; dead-letter")
		_ = w.repo.MarkDead(ctx, row.ID, rpcErr.Error())
		return
	}

	// Exponential backoff: 30s × 2^attempt, capped at 1h.
	backoff := 30 * time.Second
	for i := 0; i < int(row.Attempt) && backoff < time.Hour; i++ {
		backoff *= 2
	}
	if backoff > time.Hour {
		backoff = time.Hour
	}
	nextAt := time.Now().Add(backoff).UTC()
	if err := w.repo.MarkRetry(ctx, row.ID, rpcErr.Error(), nextAt); err != nil {
		log.WithError(err).Error("limits outbox: MarkRetry failed")
	}
}

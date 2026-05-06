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
	"sync"
	"time"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/workerpool"
	"github.com/pitabwire/util"
)

const (
	defaultBatchSize = 100
	maxAttempts      = 10
)

// Worker drains pending outbox rows. Each invocation of Drain handles
// exactly one batch and returns; periodic invocation is the responsibility
// of an external scheduler (Trustage) calling a Connect handler that
// delegates to Drain. Per-row work is dispatched through Frame's
// WorkerPool so each task acquires and releases a pool slot, keeping
// memory and goroutine usage bounded.
type Worker struct {
	repo    Repository
	rpc     limitsv1connect.LimitsServiceClient
	workMan workerpool.Manager
	batch   int
}

// NewWorker constructs an outbox Worker.
func NewWorker(repo Repository, rpc limitsv1connect.LimitsServiceClient, workMan workerpool.Manager) *Worker {
	return &Worker{repo: repo, rpc: rpc, workMan: workMan, batch: defaultBatchSize}
}

// Drain handles one batch of due outbox rows. Each row is submitted to
// the workerpool for processing; Drain waits for all submitted tasks
// to finish before returning so the caller (e.g. a Connect handler
// invoked by Trustage) sees a deterministic completion. Returns the
// number of rows handled in this pass.
func (w *Worker) Drain(ctx context.Context) (int, error) {
	rows, err := w.repo.ClaimDue(ctx, w.batch)
	if err != nil {
		return 0, err
	}
	if len(rows) == 0 {
		return 0, nil
	}

	var pool workerpool.WorkerPool
	if w.workMan != nil {
		pool, _ = w.workMan.GetPool()
	}

	var wg sync.WaitGroup
	for _, row := range rows {
		row := row
		wg.Add(1)
		task := func() {
			defer wg.Done()
			w.processRow(ctx, row)
		}
		if pool != nil {
			if submitErr := pool.Submit(ctx, task); submitErr != nil {
				// Pool full or shutting down — process inline so the row
				// is not lost. Failure here still respects the per-row
				// retry/dead-letter semantics inside processRow.
				task()
			}
		} else {
			task()
		}
	}
	wg.Wait()
	return len(rows), nil
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

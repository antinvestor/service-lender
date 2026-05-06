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
	"time"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"
)

// Repository persists outbox rows. Backed by Frame's BaseRepository so
// tenancy scoping is applied automatically.
type Repository interface {
	Insert(ctx context.Context, row *Row) error
	ClaimDue(ctx context.Context, batchSize int) ([]*Row, error)
	MarkDone(ctx context.Context, id string) error
	MarkRetry(ctx context.Context, id string, lastErr string, nextAt time.Time) error
	MarkDead(ctx context.Context, id string, lastErr string) error
}

type repository struct {
	datastore.BaseRepository[*Row]
}

// NewRepository constructs an outbox Repository over the given datastore pool.
func NewRepository(ctx context.Context, p pool.Pool, workMan workerpool.Manager) Repository {
	return &repository{
		BaseRepository: datastore.NewBaseRepository[*Row](
			ctx, p, workMan,
			func() *Row { return &Row{} },
		),
	}
}

func (r *repository) Insert(ctx context.Context, row *Row) error {
	if row.Status == "" {
		row.Status = StatusPending
	}
	if row.NextAttemptAt.IsZero() {
		row.NextAttemptAt = time.Now()
	}
	return r.Create(ctx, row)
}

func (r *repository) ClaimDue(ctx context.Context, batchSize int) ([]*Row, error) {
	if batchSize <= 0 {
		batchSize = 100
	}
	db := r.Pool().DB(ctx, false)
	var rows []*Row
	err := db.Raw(
		`SELECT * FROM limits_outbox
		 WHERE status = ? AND next_attempt_at <= ? AND deleted_at IS NULL
		 ORDER BY next_attempt_at ASC
		 LIMIT ?
		 FOR UPDATE SKIP LOCKED`,
		string(StatusPending), time.Now().UTC(), batchSize,
	).Scan(&rows).Error
	return rows, err
}

func (r *repository) MarkDone(ctx context.Context, id string) error {
	row, err := r.GetByID(ctx, id)
	if err != nil {
		return err
	}
	row.Status = StatusDone
	_, err = r.Update(ctx, row)
	return err
}

func (r *repository) MarkRetry(ctx context.Context, id, lastErr string, nextAt time.Time) error {
	row, err := r.GetByID(ctx, id)
	if err != nil {
		return err
	}
	row.Attempt++
	row.LastError = lastErr
	row.NextAttemptAt = nextAt
	_, err = r.Update(ctx, row)
	return err
}

func (r *repository) MarkDead(ctx context.Context, id, lastErr string) error {
	row, err := r.GetByID(ctx, id)
	if err != nil {
		return err
	}
	row.Status = StatusDead
	row.LastError = lastErr
	_, err = r.Update(ctx, row)
	return err
}

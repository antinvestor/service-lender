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
	"time"

	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

// ReservationReaper transitions expired-active reservations to terminal
// 'expired' and emits the corresponding audit verb.
type ReservationReaper struct {
	repo      repository.ReservationRepository
	auditing  *Auditing
	batchSize int
}

// NewReservationReaper constructs a reaper. Default batchSize=1000.
func NewReservationReaper(repo repository.ReservationRepository, auditing *Auditing, batchSize int) *ReservationReaper {
	if batchSize <= 0 {
		batchSize = 1000
	}
	return &ReservationReaper{repo: repo, auditing: auditing, batchSize: batchSize}
}

// Run scans for active reservations past their TTL and expires them.
// Intended to be invoked periodically (e.g. every 30s) by a Frame Queue
// subscriber. Errors on individual rows do not abort the batch — they
// are logged and the next pass will re-attempt.
func (r *ReservationReaper) Run(ctx context.Context) error {
	now := time.Now().UTC()
	rows, err := r.repo.ListExpiredActive(ctx, now, r.batchSize)
	if err != nil {
		return err
	}
	log := util.Log(ctx).With("reaper", "reservation_ttl")

	ids := make([]string, len(rows))
	for i, row := range rows {
		ids[i] = row.ID
	}
	n, err := r.repo.BulkSetExpired(ctx, ids, now)
	if err != nil {
		return err
	}
	if n > 0 {
		log.With("expired_count", n).Info("reaper bulk update")
	}
	// Record audit events for each successfully reaped row. The bulk UPDATE
	// transitions rows atomically; we audit after the fact.
	for _, row := range rows {
		r.auditing.RecordReservationExpiredTTL(ctx, row)
	}
	if len(rows) > 0 {
		log.With("count", len(rows)).Info("reaped expired reservations")
	}
	return nil
}

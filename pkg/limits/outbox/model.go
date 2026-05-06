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

// Package outbox provides the limits Commit/Release outbox shared across
// every consumer service. Each consumer's local DB has a limits_outbox
// table; the worker drains it and calls the corresponding LimitsService
// RPC with at-least-once + idempotent semantics.
package outbox

import (
	"time"

	"github.com/pitabwire/frame/data"
)

// Action is the kind of RPC the outbox row will trigger.
type Action string

const (
	ActionCommit  Action = "commit"
	ActionRelease Action = "release"
)

// Status tracks the outbox row's lifecycle.
type Status string

const (
	StatusPending Status = "pending"
	StatusDone    Status = "done"
	StatusDead    Status = "dead"
)

// Row is the single outbox-table model. Inserted in the same DB transaction
// as the consumer's business row so the invariant "business row exists ⇔
// limits action will eventually be invoked" holds across crashes and retries.
type Row struct {
	data.BaseModel `gorm:"embedded"`

	ReservationID string    `gorm:"column:reservation_id;type:varchar(50);not null;index"`
	Action        Action    `gorm:"column:action;type:varchar(16);not null"`
	Reason        string    `gorm:"column:reason;type:text"` // populated on release
	Status        Status    `gorm:"column:status;type:varchar(16);not null;default:'pending';index:idx_outbox_status,priority:1"`
	Attempt       int32     `gorm:"column:attempt;not null;default:0"`
	NextAttemptAt time.Time `gorm:"column:next_attempt_at;type:timestamptz;not null;index:idx_outbox_status,priority:2"`
	LastError     string    `gorm:"column:last_error;type:text"`
}

func (Row) TableName() string { return "limits_outbox" }

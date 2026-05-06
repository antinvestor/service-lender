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

	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/pkg/limits"
)

// Worker drains pending outbox rows and invokes the corresponding limits
// RPC. Wired up in each consumer service's main.go via Frame's WorkerPool
// or Frame Queue. Stub for now; the runtime-path plan implements the loop.
type Worker struct {
	repo   Repository
	client limits.Client
}

// NewWorker constructs an outbox worker with the given repo and limits client.
func NewWorker(repo Repository, client limits.Client) *Worker {
	return &Worker{repo: repo, client: client}
}

// Run is the worker loop entry point. Stub implementation logs that the
// runtime path is unimplemented; replaced in the next plan.
func (w *Worker) Run(ctx context.Context) error {
	util.Log(ctx).Info("outbox worker started (stub)")
	<-ctx.Done()
	if err := ctx.Err(); err != nil && !errors.Is(err, context.Canceled) {
		return err
	}
	return nil
}

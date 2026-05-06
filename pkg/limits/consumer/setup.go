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

package consumer

import (
	"context"
	"fmt"
	"net/http"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	"github.com/antinvestor/common"
	"github.com/antinvestor/common/connection"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

// SetupClient constructs a LimitsServiceClient from the provided config and target.
// Returns nil, nil when target.Endpoint is empty so callers can opt out of limits
// integration without special-casing.
func SetupClient(
	ctx context.Context,
	cfg any,
	target common.ServiceTarget,
) (limitsv1connect.LimitsServiceClient, error) {
	if target.Endpoint == "" {
		return nil, nil
	}
	cli, err := connection.NewServiceClient(ctx, cfg, target, limitsv1connect.NewLimitsServiceClient)
	if err != nil {
		return nil, fmt.Errorf("limits client: %w", err)
	}
	return cli, nil
}

// SetupOutboxStack wires a limits-outbox Repository, Worker, and drain http.Handler
// from the provided datastore pool, RPC client, and worker manager.
// The returned Worker is ready to drain; the Handler should be mounted at
// /admin/limits-outbox/drain.
func SetupOutboxStack(
	ctx context.Context,
	dbPool pool.Pool,
	workMan workerpool.Manager,
	rpc limitsv1connect.LimitsServiceClient,
) (*outbox.Worker, http.Handler) {
	repo := outbox.NewRepository(ctx, dbPool, workMan)
	w := outbox.NewWorker(repo, rpc, workMan)
	h := newDrainHandler(w)
	return w, h
}

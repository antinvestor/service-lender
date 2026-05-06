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

package limits

import (
	"context"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
)

// Client is the typed wrapper used by consumer services for the Reserve+
// Commit+Release lifecycle around every monetary action. The Gate helper
// is the 80% path; lower-level primitives are exposed for callers that
// need explicit control (e.g. operations.TransferOrderExecute with its
// multi-leg semantics).
type Client interface {
	Gate(ctx context.Context, intent *limitsv1.LimitIntent, idempotencyKey string,
		handler func(ctx context.Context, reservationID string) error) error

	Check(ctx context.Context, intent *limitsv1.LimitIntent) (*limitsv1.CheckResponse, error)
	Reserve(ctx context.Context, intent *limitsv1.LimitIntent, idempotencyKey string) (*limitsv1.ReserveResponse, error)
	Commit(ctx context.Context, reservationID string) (*limitsv1.CommitResponse, error)
	Release(ctx context.Context, reservationID, reason string) (*limitsv1.ReleaseResponse, error)
	Reverse(ctx context.Context, reservationID, idempotencyKey, reason string) (*limitsv1.ReverseResponse, error)
}

// NewClient returns a Client wrapping a generated Connect client. Until
// the runtime path is implemented, every method returns ErrUnimplemented.
func NewClient(rpc limitsv1connect.LimitsServiceClient) Client {
	return &client{rpc: rpc}
}

type client struct {
	rpc limitsv1connect.LimitsServiceClient
}

func (c *client) Gate(ctx context.Context, _ *limitsv1.LimitIntent, _ string,
	_ func(ctx context.Context, reservationID string) error) error {
	return ErrUnimplemented
}

func (c *client) Check(ctx context.Context, _ *limitsv1.LimitIntent) (*limitsv1.CheckResponse, error) {
	return nil, ErrUnimplemented
}

func (c *client) Reserve(ctx context.Context, _ *limitsv1.LimitIntent, _ string) (*limitsv1.ReserveResponse, error) {
	return nil, ErrUnimplemented
}

func (c *client) Commit(ctx context.Context, _ string) (*limitsv1.CommitResponse, error) {
	return nil, ErrUnimplemented
}

func (c *client) Release(ctx context.Context, _, _ string) (*limitsv1.ReleaseResponse, error) {
	return nil, ErrUnimplemented
}

func (c *client) Reverse(ctx context.Context, _, _, _ string) (*limitsv1.ReverseResponse, error) {
	return nil, ErrUnimplemented
}

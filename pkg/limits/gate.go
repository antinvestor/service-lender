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
	"errors"
	"fmt"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/util"
)

// Gate runs the standard Reserve → handler → Commit/Release lifecycle
// against the supplied limits Connect client. The handler is invoked
// only when the reservation is ACTIVE; PENDING_APPROVAL and Reserve
// errors short-circuit before the handler runs.
//
// Behaviour:
//   - Reserve error  → Gate returns the error verbatim. Handler is NOT called.
//   - PENDING_APPROVAL → Gate returns *PendingApprovalError. Handler is NOT called.
//     Caller is expected to persist a local pending row and
//     resume via the limits.approval.* event when approval lands.
//   - ACTIVE → handler is invoked.
//   - Handler success → Gate calls Commit synchronously, returns nil
//     (or returns the Commit error if it fails;
//     reconciliation closes the gap).
//   - Handler error → Gate calls Release synchronously and returns the
//     handler's error. Release errors are logged.
//
// Outbox-driven Commit (see pkg/limits/outbox) is a separate path; callers
// that need durable Commit-after-local-tx should write an outbox row in
// their own transaction and let the outbox.Worker drive Commit. Gate's
// synchronous Commit is the simpler default.
func Gate(
	ctx context.Context,
	rpc limitsv1connect.LimitsServiceClient,
	intent *limitsv1.LimitIntent,
	idempotencyKey string,
	handler func(ctx context.Context, reservationID string) error,
) error {
	if rpc == nil {
		return errors.New("limits.Gate: nil rpc client")
	}
	if handler == nil {
		return errors.New("limits.Gate: nil handler")
	}

	res, err := rpc.Reserve(ctx, connect.NewRequest(&limitsv1.ReserveRequest{
		Intent:         intent,
		IdempotencyKey: idempotencyKey,
	}))
	if err != nil {
		return err
	}

	reservation := res.Msg.GetReservation()
	if reservation == nil {
		return errors.New("limits.Gate: Reserve returned no reservation")
	}

	switch reservation.GetStatus() {
	case limitsv1.ReservationStatus_RESERVATION_STATUS_PENDING_APPROVAL:
		var verdicts []*limitsv1.PolicyVerdict
		if check := res.Msg.GetCheck(); check != nil {
			verdicts = check.GetVerdicts()
		}
		return &PendingApprovalError{ReservationID: reservation.GetId(), Verdicts: verdicts}
	case limitsv1.ReservationStatus_RESERVATION_STATUS_ACTIVE:
		// Continue.
	default:
		return fmt.Errorf("limits.Gate: unexpected reservation status %s", reservation.GetStatus())
	}

	if handlerErr := handler(ctx, reservation.GetId()); handlerErr != nil {
		if _, releaseErr := rpc.Release(ctx, connect.NewRequest(&limitsv1.ReleaseRequest{
			ReservationId: reservation.GetId(),
			Reason:        handlerErr.Error(),
		})); releaseErr != nil {
			util.Log(ctx).WithError(releaseErr).
				With("reservation_id", reservation.GetId()).
				Error("limits.Gate: Release failed after handler error; relying on TTL reaper")
		}
		return handlerErr
	}

	if _, commitErr := rpc.Commit(ctx, connect.NewRequest(&limitsv1.CommitRequest{
		ReservationId: reservation.GetId(),
	})); commitErr != nil {
		util.Log(ctx).WithError(commitErr).
			With("reservation_id", reservation.GetId()).
			Error("limits.Gate: Commit failed after handler success — reconciliation gap")
		return commitErr
	}
	return nil
}

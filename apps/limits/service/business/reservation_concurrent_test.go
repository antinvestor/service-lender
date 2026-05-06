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

package business_test

import (
	"sync"
	"sync/atomic"
	"time"

	limitsv1 "buf.build/gen/go/antinvestor/limits/protocolbuffers/go/limits/v1"
	"github.com/pitabwire/util"
)

// TestReserve_ConcurrentSameSubject_RespectsCap spins 20 goroutines each
// calling Reserve(amount=10 KES) against a rolling-window cap of 100 KES.
// Total intent = 200 KES; cap = 100 KES → at most 10 reservations may succeed.
//
// Before the EvaluateInTx fix, all 20 goroutines could read "below cap"
// because their PendingSum/WindowSum calls bypassed the advisory lock by going
// through the read pool. After the fix, the reads participate in the same
// transaction that holds the lock, so at most ceil(100/10)=10 succeed.
func (s *ReservationBusinessSuite) TestReserve_ConcurrentSameSubject_RespectsCap() {
	// Use tenant-a to match the hardcoded tenant in kesIntent.
	ctx, biz, _, policyRepo, _ := s.resvEnv("tenant-a", "partition-a")

	// rolling_window_amount cap=100 KES over a 24-hour window.
	// KES has 2 decimal places so cap=100 KES = 10000 minor units.
	seedPolicy(s.T(), ctx, policyRepo, rollingWindowPolicy(
		"KES", 100, // 100 KES (units; seedPolicy uses PolicyObject which works in units)
		24,
		limitsv1.PolicyMode_POLICY_MODE_ENFORCE,
		limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT,
		limitsv1.SubjectType_SUBJECT_TYPE_CLIENT,
	))

	const goroutines = 20
	var wg sync.WaitGroup
	var successes atomic.Int64
	var denials atomic.Int64

	for i := 0; i < goroutines; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			// Each goroutine uses a unique idempotency key so there is no
			// idempotency short-circuit; every call goes through full evaluation.
			idemKey := util.IDString()
			resp, err := biz.Reserve(
				ctx,
				kesIntent(limitsv1.LimitAction_LIMIT_ACTION_LOAN_DISBURSEMENT, 10), // 10 KES
				idemKey,
				5*time.Minute,
			)
			if err == nil &&
				resp.GetReservation().GetStatus() == limitsv1.ReservationStatus_RESERVATION_STATUS_ACTIVE {
				successes.Add(1)
			} else {
				denials.Add(1)
			}
		}()
	}
	wg.Wait()

	// cap=100 KES, each intent=10 KES → at most 10 can succeed.
	s.LessOrEqual(successes.Load(), int64(10),
		"rolling-window cap must be respected under 20-way concurrency; successes=%d denials=%d",
		successes.Load(), denials.Load())
	// Sanity: total must equal goroutines.
	s.Equal(int64(goroutines), successes.Load()+denials.Load(),
		"every goroutine must have either succeeded or been denied")
}

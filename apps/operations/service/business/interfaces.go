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

	"github.com/antinvestor/service-fintech/apps/operations/service/models"
)

// PaymentRoutingBusiness handles payment identification and allocation.
type PaymentRoutingBusiness interface {
	IdentifyPayment(ctx context.Context, paymentData map[string]interface{}) (map[string]interface{}, error)
	AllocatePayment(ctx context.Context, paymentID string) (map[string]interface{}, error)
}

// TransferOrderBusiness handles transfer order creation and execution.
type TransferOrderBusiness interface {
	Save(ctx context.Context, order *models.TransferOrder) error
	Execute(ctx context.Context, orderID string) error
}

// ObligationBusiness handles financial obligation management.
type ObligationBusiness interface {
	CalculateForGroup(ctx context.Context, groupID string) error
	CreateLoanObligations(ctx context.Context, loanAccountID string, entries []ScheduleEntryInfo) error
	GetStatus(ctx context.Context, obligationID string) (map[string]interface{}, error)
}

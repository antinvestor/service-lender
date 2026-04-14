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

package handlers

import "context"

// LoanWindowBusiness is the subset of funding business used by workflow callbacks.
type LoanWindowBusiness interface {
	Evaluate(ctx context.Context, groupID string) (map[string]interface{}, error)
}

// LoanOfferBusiness is the subset of funding business used by workflow callbacks.
type LoanOfferBusiness interface {
	GenerateForWindow(ctx context.Context, windowID string) (interface{}, error)
	CreateLoanAccount(ctx context.Context, offerID string) (map[string]interface{}, error)
}

// FundingAllocationBusiness is the subset of funding business used by workflow callbacks.
type FundingAllocationBusiness interface {
	SourceForRequest(ctx context.Context, loanRequestID string) (map[string]interface{}, error)
}

// PaymentRoutingBusiness is the subset of operations business used by workflow callbacks.
type PaymentRoutingBusiness interface {
	IdentifyPayment(ctx context.Context, paymentData map[string]interface{}) (map[string]interface{}, error)
	AllocatePayment(ctx context.Context, paymentID string) (map[string]interface{}, error)
}

// TransferOrderBusiness is the subset of operations business used by workflow callbacks.
type TransferOrderBusiness interface {
	Execute(ctx context.Context, orderID string) error
}

// ObligationBusiness is the subset of operations business used by workflow callbacks.
type ObligationBusiness interface {
	CalculateForGroup(ctx context.Context, groupID string) error
	GetStatus(ctx context.Context, obligationID string) (map[string]interface{}, error)
}

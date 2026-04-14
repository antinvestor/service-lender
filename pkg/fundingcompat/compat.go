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

package fundingcompat

import fundingv1 "buf.build/gen/go/antinvestor/funding/protocolbuffers/go/funding/v1"

// These helpers isolate the external funding contract's generated field names.

func NewFundLoanRequest(loanRequestID string) *fundingv1.FundLoanRequest {
	return &fundingv1.FundLoanRequest{LoanRequestId: loanRequestID}
}

func NewAbsorbLossRequest(loanRequestID string) *fundingv1.AbsorbLossRequest {
	return &fundingv1.AbsorbLossRequest{LoanRequestId: loanRequestID}
}

func LoanRequestIDFromFundLoanRequest(req *fundingv1.FundLoanRequest) string {
	if req == nil {
		return ""
	}
	return req.GetLoanRequestId()
}

func LoanRequestIDFromAbsorbLossRequest(req *fundingv1.AbsorbLossRequest) string {
	if req == nil {
		return ""
	}
	return req.GetLoanRequestId()
}

func SetAllocationLoanRequestID(obj *fundingv1.FundingAllocationObject, loanRequestID string) {
	if obj == nil {
		return
	}
	obj.LoanRequestId = loanRequestID
}

func AllocationLoanRequestID(obj *fundingv1.FundingAllocationObject) string {
	if obj == nil {
		return ""
	}
	return obj.GetLoanRequestId()
}

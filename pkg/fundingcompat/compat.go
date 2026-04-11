package fundingcompat

import fundingv1 "buf.build/gen/go/antinvestor/funding/protocolbuffers/go/funding/v1"

// These helpers isolate the external funding contract's legacy generated field names.
// The owned codebase standardizes on loan request terminology everywhere else.

func NewFundLoanRequest(loanRequestID string) *fundingv1.FundLoanRequest {
	return &fundingv1.FundLoanRequest{LoanOfferId: loanRequestID}
}

func NewAbsorbLossRequest(loanRequestID string) *fundingv1.AbsorbLossRequest {
	return &fundingv1.AbsorbLossRequest{LoanOfferId: loanRequestID}
}

func LoanRequestIDFromFundLoanRequest(req *fundingv1.FundLoanRequest) string {
	if req == nil {
		return ""
	}
	return req.GetLoanOfferId()
}

func LoanRequestIDFromAbsorbLossRequest(req *fundingv1.AbsorbLossRequest) string {
	if req == nil {
		return ""
	}
	return req.GetLoanOfferId()
}

func SetAllocationLoanRequestID(obj *fundingv1.FundingAllocationObject, loanRequestID string) {
	if obj == nil {
		return
	}
	obj.LoanOfferId = loanRequestID
}

func AllocationLoanRequestID(obj *fundingv1.FundingAllocationObject) string {
	if obj == nil {
		return ""
	}
	return obj.GetLoanOfferId()
}

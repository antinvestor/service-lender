package calculation

// ActiveLoanWindowCycle calculates whether a loan window should open.
// This is the critical formula from Java LoanWindow.activeLoanWindowCycle.
//
// completedPeriodCount: number of periods completed in the tenure
// groupMaturityPeriod: number of periods before first loan eligibility
// gracePeriod: loan grace period in periods
// loanTenure: loan repayment duration in periods
// coolOff: cool-off periods between loan windows (typically 0)
//
// Returns the cycle position. If 0, a new loan window should open.
func ActiveLoanWindowCycle(completedPeriodCount, groupMaturityPeriod, gracePeriod, loanTenure, coolOff int32) int32 {
	eligible := completedPeriodCount - groupMaturityPeriod
	if eligible < 0 {
		return -1 // not yet eligible
	}
	cycleLength := gracePeriod + loanTenure + coolOff
	if cycleLength <= 0 {
		return -1 // invalid cycle length
	}
	return eligible % cycleLength
}

// ShouldOpenLoanWindow returns true if a loan window should be opened.
func ShouldOpenLoanWindow(completedPeriodCount, groupMaturityPeriod, gracePeriod, loanTenure, coolOff int32) bool {
	return ActiveLoanWindowCycle(completedPeriodCount, groupMaturityPeriod, gracePeriod, loanTenure, coolOff) == 0
}

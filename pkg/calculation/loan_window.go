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

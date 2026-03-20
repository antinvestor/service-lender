package calculation

// CalculateMaxLoanAmount computes the maximum loan amount a member is eligible for
// based on their savings balance and leverage factor.
// leverageFactor is in basis points (e.g., 190 = 1.90x).
// savingsBalance is in minor units (cents).
// Returns the max loan amount in minor units.
func CalculateMaxLoanAmount(savingsBalance int64, leverageFactor int64) int64 {
	if savingsBalance <= 0 || leverageFactor <= 0 {
		return 0
	}
	// leverageFactor is basis points: 190 = 1.90x
	// maxLoan = savings * leverage / 100
	return savingsBalance * leverageFactor / 100
}

// CalculateLeverageRatio computes the effective leverage ratio.
// Returns basis points (e.g., 190 for 1.90x).
func CalculateLeverageRatio(loanAmount, savingsBalance int64) int64 {
	if savingsBalance <= 0 {
		return 0
	}
	return loanAmount * 100 / savingsBalance
}

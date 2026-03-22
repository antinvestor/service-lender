package calculation

// FlatRateInterest calculates interest using flat-rate method.
// principal is in minor units, annualRate is in basis points.
// termPeriods is the number of payment periods, periodsPerYear is periods in a year.
// Returns total interest in minor units.
func FlatRateInterest(principal int64, annualRateBP int64, termPeriods int32, periodsPerYear int32) int64 {
	if principal <= 0 || annualRateBP <= 0 || termPeriods <= 0 || periodsPerYear <= 0 {
		return 0
	}
	// interest = principal * (rate/10000) * (termPeriods / periodsPerYear)
	// To avoid floating point: principal * rateBP * termPeriods / (10000 * periodsPerYear)
	return principal * annualRateBP * int64(termPeriods) / (10000 * int64(periodsPerYear))
}

// ReducingBalanceInterestForPeriod calculates interest for a single period using reducing balance.
// outstandingPrincipal is in minor units, annualRate is in basis points.
// periodsPerYear is periods in a year (e.g., 52 for weekly).
// Returns interest for this period in minor units.
func ReducingBalanceInterestForPeriod(outstandingPrincipal int64, annualRateBP int64, periodsPerYear int32) int64 {
	if outstandingPrincipal <= 0 || annualRateBP <= 0 || periodsPerYear <= 0 {
		return 0
	}
	// interest = principal * (rate/10000) / periodsPerYear
	return outstandingPrincipal * annualRateBP / (10000 * int64(periodsPerYear))
}

// PeriodsPerYear returns the number of periods in a year for a given period type.
// periodType: 1=WEEKLY(52), 2=BIWEEKLY(26), 3=MONTHLY(12).
func PeriodsPerYear(periodType int32) int32 {
	switch periodType {
	case 1: // WEEKLY
		return 52
	case 2: // BIWEEKLY
		return 26
	case 3: // MONTHLY
		return 12
	default:
		return 52
	}
}

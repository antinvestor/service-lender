package calculation

// DefaultFineRates are the escalating late fine percentages (in basis points).
// 10% = 1000bp, 20% = 2000bp, 30% = 3000bp.
var DefaultFineRates = []int64{1000, 2000, 3000}

// CalculatePenalty computes a late payment penalty.
// outstandingAmount is in minor units, fineRateBP is in basis points.
// Returns penalty amount in minor units.
func CalculatePenalty(outstandingAmount int64, fineRateBP int64) int64 {
	if outstandingAmount <= 0 || fineRateBP <= 0 {
		return 0
	}
	return outstandingAmount * fineRateBP / 10000
}

// EscalatingPenalty computes a penalty using escalating fine tiers.
// periodsLate determines which tier to use (1-indexed).
// fineRates are basis points for each tier [tier1, tier2, tier3].
// outstandingAmount is in minor units.
func EscalatingPenalty(outstandingAmount int64, periodsLate int32, fineRates []int64) int64 {
	if outstandingAmount <= 0 || periodsLate <= 0 || len(fineRates) == 0 {
		return 0
	}
	// Use the tier corresponding to periods late, capped at max tier
	tierIdx := int(periodsLate) - 1
	if tierIdx >= len(fineRates) {
		tierIdx = len(fineRates) - 1
	}
	return CalculatePenalty(outstandingAmount, fineRates[tierIdx])
}

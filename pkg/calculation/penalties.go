package calculation

import "github.com/pitabwire/util/decimalx"

// DefaultFineRates returns the escalating late fine percentages (in basis points).
// 10% = 1000bp, 20% = 2000bp, 30% = 3000bp.
func DefaultFineRates() []int64 {
	return []int64{1000, 2000, 3000}
}

// CalculatePenalty computes a late payment penalty.
// outstandingAmount is a Decimal, fineRateBP is in basis points.
// Returns penalty amount as a Decimal.
func CalculatePenalty(outstandingAmount decimalx.Decimal, fineRateBP int64) decimalx.Decimal {
	if !outstandingAmount.IsPositive() || fineRateBP <= 0 {
		return decimalx.Zero()
	}
	return decimalx.ApplyBasisPoints(outstandingAmount, fineRateBP)
}

// EscalatingPenalty computes a penalty using escalating fine tiers.
// periodsLate determines which tier to use (1-indexed).
// fineRates are basis points for each tier [tier1, tier2, tier3].
// outstandingAmount is a Decimal.
func EscalatingPenalty(outstandingAmount decimalx.Decimal, periodsLate int32, fineRates []int64) decimalx.Decimal {
	if !outstandingAmount.IsPositive() || periodsLate <= 0 || len(fineRates) == 0 {
		return decimalx.Zero()
	}
	// Use the tier corresponding to periods late, capped at max tier
	tierIdx := int(periodsLate) - 1
	if tierIdx >= len(fineRates) {
		tierIdx = len(fineRates) - 1
	}
	return CalculatePenalty(outstandingAmount, fineRates[tierIdx])
}

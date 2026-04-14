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

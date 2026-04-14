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

const (
	// weeksPerYear is the number of weeks in a year.
	weeksPerYear = 52
	// biweeksPerYear is the number of biweekly periods in a year.
	biweeksPerYear = 26
	// monthsPerYear is the number of months in a year.
	monthsPerYear = 12
)

// FlatRateInterest calculates interest using flat-rate method.
// principal is a Decimal amount, annualRate is in basis points.
// termPeriods is the number of payment periods, periodsPerYear is periods in a year.
// Returns total interest as a Decimal.
func FlatRateInterest(
	principal decimalx.Decimal,
	annualRateBP int64,
	termPeriods int32,
	periodsPerYear int32,
) decimalx.Decimal {
	if !principal.IsPositive() || annualRateBP <= 0 || termPeriods <= 0 || periodsPerYear <= 0 {
		return decimalx.Zero()
	}
	// interest = principal * (rate/10000) * (termPeriods / periodsPerYear)
	// = ApplyBasisPoints(principal, rateBP) * termPeriods / periodsPerYear
	periodInterest := decimalx.ApplyBasisPoints(principal, annualRateBP)
	return periodInterest.Mul(decimalx.NewFromInt64(int64(termPeriods))).
		Div(decimalx.NewFromInt64(int64(periodsPerYear)))
}

// ReducingBalanceInterestForPeriod calculates interest for a single period using reducing balance.
// outstandingPrincipal is a Decimal amount, annualRate is in basis points.
// periodsPerYear is periods in a year (e.g., 52 for weekly).
// Returns interest for this period as a Decimal.
func ReducingBalanceInterestForPeriod(
	outstandingPrincipal decimalx.Decimal,
	annualRateBP int64,
	periodsPerYear int32,
) decimalx.Decimal {
	if !outstandingPrincipal.IsPositive() || annualRateBP <= 0 || periodsPerYear <= 0 {
		return decimalx.Zero()
	}
	// interest = principal * (rate/10000) / periodsPerYear
	return decimalx.ApplyBasisPoints(outstandingPrincipal, annualRateBP).
		Div(decimalx.NewFromInt64(int64(periodsPerYear)))
}

// PeriodsPerYear returns the number of periods in a year for a given period type.
// periodType: 1=WEEKLY(52), 2=BIWEEKLY(26), 3=MONTHLY(12).
func PeriodsPerYear(periodType int32) int32 {
	switch periodType {
	case periodTypeWeekly:
		return weeksPerYear
	case periodTypeBiweekly:
		return biweeksPerYear
	case periodTypeMonthly:
		return monthsPerYear
	default:
		return weeksPerYear
	}
}

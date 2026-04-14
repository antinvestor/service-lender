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

import (
	"time"

	"github.com/pitabwire/util/decimalx"
)

const (
	// periodTypeWeekly is the period type code for weekly periods.
	periodTypeWeekly = 1
	// periodTypeBiweekly is the period type code for biweekly periods.
	periodTypeBiweekly = 2
	// periodTypeMonthly is the period type code for monthly periods.
	periodTypeMonthly = 3
	// daysPerWeek is the number of days in a weekly period.
	daysPerWeek = 7
	// daysPerBiweek is the number of days in a biweekly period.
	daysPerBiweek = 14
	// interestMethodReducingBalance is the code for reducing-balance interest calculation.
	interestMethodReducingBalance = 2
)

// ScheduleEntry represents a single installment in an amortization schedule.
type ScheduleEntry struct {
	InstallmentNumber int32
	DueDate           time.Time
	PrincipalDue      decimalx.Decimal
	InterestDue       decimalx.Decimal
	InsuranceDue      decimalx.Decimal
	FeesDue           decimalx.Decimal // processing/origination fees
	TotalDue          decimalx.Decimal
}

// GenerateFlatSchedule generates a flat-rate amortization schedule.
// principal, totalInterest, totalInsurance, totalFees are Decimal amounts.
// installments is the number of payments.
// firstDueDate is when the first payment is due.
// periodType determines the interval (1=WEEKLY, 2=BIWEEKLY, 3=MONTHLY).
func GenerateFlatSchedule(
	principal decimalx.Decimal,
	totalInterest decimalx.Decimal,
	totalInsurance decimalx.Decimal,
	totalFees decimalx.Decimal,
	installments int32,
	firstDueDate time.Time,
	periodType int32,
) []ScheduleEntry {
	if installments <= 0 {
		return nil
	}

	n := decimalx.NewFromInt64(int64(installments))
	entries := make([]ScheduleEntry, installments)
	principalPerPeriod := principal.Div(n)
	interestPerPeriod := totalInterest.Div(n)
	insurancePerPeriod := totalInsurance.Div(n)
	feesPerPeriod := totalFees.Div(n)

	// Dust handling: last installment absorbs rounding remainder
	principalRemainder := principal.Sub(principalPerPeriod.Mul(n))
	interestRemainder := totalInterest.Sub(interestPerPeriod.Mul(n))
	insuranceRemainder := totalInsurance.Sub(insurancePerPeriod.Mul(n))
	feesRemainder := totalFees.Sub(feesPerPeriod.Mul(n))

	dueDate := firstDueDate
	for i := range installments {
		entry := ScheduleEntry{
			InstallmentNumber: i + 1,
			DueDate:           dueDate,
			PrincipalDue:      principalPerPeriod,
			InterestDue:       interestPerPeriod,
			InsuranceDue:      insurancePerPeriod,
			FeesDue:           feesPerPeriod,
		}

		// Last installment absorbs remainder
		if i == installments-1 {
			entry.PrincipalDue = entry.PrincipalDue.Add(principalRemainder)
			entry.InterestDue = entry.InterestDue.Add(interestRemainder)
			entry.InsuranceDue = entry.InsuranceDue.Add(insuranceRemainder)
			entry.FeesDue = entry.FeesDue.Add(feesRemainder)
		}

		entry.TotalDue = entry.PrincipalDue.Add(entry.InterestDue).Add(entry.InsuranceDue).Add(entry.FeesDue)
		entries[i] = entry

		dueDate = advanceByPeriod(dueDate, periodType)
	}

	return entries
}

// GenerateReducingBalanceSchedule generates a reducing-balance amortization schedule.
func GenerateReducingBalanceSchedule(
	principal decimalx.Decimal,
	annualRateBP int64,
	insuranceRateBP int64,
	feeRateBP int64,
	installments int32,
	firstDueDate time.Time,
	periodType int32,
) []ScheduleEntry {
	if installments <= 0 {
		return nil
	}

	ppy := decimalx.NewFromInt64(int64(PeriodsPerYear(periodType)))
	entries := make([]ScheduleEntry, installments)
	remaining := principal
	n := decimalx.NewFromInt64(int64(installments))
	principalPerPeriod := principal.Div(n)
	dueDate := firstDueDate

	for i := range installments {
		pDue := principalPerPeriod
		if i == installments-1 {
			pDue = remaining // last installment gets the remainder
		}

		iDue := decimalx.ApplyBasisPoints(remaining, annualRateBP).Div(ppy)
		insDue := decimalx.ApplyBasisPoints(remaining, insuranceRateBP).Div(ppy)
		fDue := decimalx.ApplyBasisPoints(remaining, feeRateBP).Div(ppy)

		entries[i] = ScheduleEntry{
			InstallmentNumber: i + 1,
			DueDate:           dueDate,
			PrincipalDue:      pDue,
			InterestDue:       iDue,
			InsuranceDue:      insDue,
			FeesDue:           fDue,
			TotalDue:          pDue.Add(iDue).Add(insDue).Add(fDue),
		}

		remaining = remaining.Sub(pDue)
		dueDate = advanceByPeriod(dueDate, periodType)
	}

	return entries
}

// GenerateScheduleFromProduct creates a schedule using loan product parameters.
func GenerateScheduleFromProduct(
	principal decimalx.Decimal,
	annualInterestRateBP int64,
	insuranceFeePercentBP int64,
	processingFeePercentBP int64,
	interestMethod int32, // 1=FLAT, 2=REDUCING_BALANCE
	installments int32,
	firstDueDate time.Time,
	periodType int32,
) []ScheduleEntry {
	periodsPerYear := PeriodsPerYear(periodType)

	if interestMethod == interestMethodReducingBalance {
		return GenerateReducingBalanceSchedule(
			principal, annualInterestRateBP, insuranceFeePercentBP, processingFeePercentBP,
			installments, firstDueDate, periodType,
		)
	}

	// FLAT (default)
	totalInterest := FlatRateInterest(principal, annualInterestRateBP, installments, periodsPerYear)
	totalInsurance := FlatRateInterest(principal, insuranceFeePercentBP, installments, periodsPerYear)
	totalFees := FlatRateInterest(principal, processingFeePercentBP, installments, periodsPerYear)
	return GenerateFlatSchedule(
		principal,
		totalInterest,
		totalInsurance,
		totalFees,
		installments,
		firstDueDate,
		periodType,
	)
}

// advanceByPeriod advances a date by one period.
func advanceByPeriod(t time.Time, periodType int32) time.Time {
	switch periodType {
	case periodTypeWeekly:
		return t.AddDate(0, 0, daysPerWeek)
	case periodTypeBiweekly:
		return t.AddDate(0, 0, daysPerBiweek)
	case periodTypeMonthly:
		return t.AddDate(0, 1, 0)
	default:
		return t.AddDate(0, 0, daysPerWeek)
	}
}

package calculation

import (
	"time"

	"github.com/pitabwire/util/decimalx"
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
	periodsPerYear := int32(PeriodsPerYear(periodType))

	if interestMethod == 2 { // REDUCING_BALANCE
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
	case 1: // WEEKLY
		return t.AddDate(0, 0, 7)
	case 2: // BIWEEKLY
		return t.AddDate(0, 0, 14)
	case 3: // MONTHLY
		return t.AddDate(0, 1, 0)
	default:
		return t.AddDate(0, 0, 7)
	}
}

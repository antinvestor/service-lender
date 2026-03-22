package calculation

import "time"

// ScheduleEntry represents a single installment in an amortization schedule.
type ScheduleEntry struct {
	InstallmentNumber int32
	DueDate           time.Time
	PrincipalDue      int64 // minor units
	InterestDue       int64 // minor units
	InsuranceDue      int64 // minor units
	FeesDue           int64 // processing/origination fees in minor units
	TotalDue          int64 // minor units
}

// GenerateFlatSchedule generates a flat-rate amortization schedule.
// principal, totalInterest, totalInsurance, totalFees are in minor units.
// installments is the number of payments.
// firstDueDate is when the first payment is due.
// periodType determines the interval (1=WEEKLY, 2=BIWEEKLY, 3=MONTHLY).
func GenerateFlatSchedule(
	principal int64,
	totalInterest int64,
	totalInsurance int64,
	totalFees int64,
	installments int32,
	firstDueDate time.Time,
	periodType int32,
) []ScheduleEntry {
	if installments <= 0 {
		return nil
	}

	entries := make([]ScheduleEntry, installments)
	principalPerPeriod := principal / int64(installments)
	interestPerPeriod := totalInterest / int64(installments)
	insurancePerPeriod := totalInsurance / int64(installments)
	feesPerPeriod := totalFees / int64(installments)

	// Dust handling: last installment absorbs rounding remainder
	principalRemainder := principal - (principalPerPeriod * int64(installments))
	interestRemainder := totalInterest - (interestPerPeriod * int64(installments))
	insuranceRemainder := totalInsurance - (insurancePerPeriod * int64(installments))
	feesRemainder := totalFees - (feesPerPeriod * int64(installments))

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
			entry.PrincipalDue += principalRemainder
			entry.InterestDue += interestRemainder
			entry.InsuranceDue += insuranceRemainder
			entry.FeesDue += feesRemainder
		}

		entry.TotalDue = entry.PrincipalDue + entry.InterestDue + entry.InsuranceDue + entry.FeesDue
		entries[i] = entry

		dueDate = advanceByPeriod(dueDate, periodType)
	}

	return entries
}

// GenerateReducingBalanceSchedule generates a reducing-balance amortization schedule.
func GenerateReducingBalanceSchedule(
	principal int64,
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

	ppy := int64(PeriodsPerYear(periodType))
	entries := make([]ScheduleEntry, installments)
	remaining := principal
	principalPerPeriod := principal / int64(installments)
	dueDate := firstDueDate

	for i := range installments {
		pDue := principalPerPeriod
		if i == installments-1 {
			pDue = remaining // last installment gets the remainder
		}

		iDue := remaining * annualRateBP / (10000 * ppy)
		insDue := remaining * insuranceRateBP / (10000 * ppy)
		fDue := remaining * feeRateBP / (10000 * ppy)

		entries[i] = ScheduleEntry{
			InstallmentNumber: i + 1,
			DueDate:           dueDate,
			PrincipalDue:      pDue,
			InterestDue:       iDue,
			InsuranceDue:      insDue,
			FeesDue:           fDue,
			TotalDue:          pDue + iDue + insDue + fDue,
		}

		remaining -= pDue
		dueDate = advanceByPeriod(dueDate, periodType)
	}

	return entries
}

// GenerateScheduleFromProduct creates a schedule using loan product parameters.
func GenerateScheduleFromProduct(
	principal int64,
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

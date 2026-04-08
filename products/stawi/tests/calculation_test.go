package tests

import (
	"testing"
	"time"

	"github.com/pitabwire/util/decimalx"

	"github.com/antinvestor/service-fintech/pkg/calculation"
)

// dec is a helper to create a Decimal from minor units (int64).
func dec(v int64) decimalx.Decimal {
	return decimalx.FromMinorUnits(v, 2)
}

// toMinor converts a Decimal back to int64 minor units.
func toMinor(d decimalx.Decimal) int64 {
	return d.ToMinorUnits(2)
}

// ---------------------------------------------------------------------------
// Leverage
// ---------------------------------------------------------------------------

func TestCalculateMaxLoanAmount(t *testing.T) {
	tests := []struct {
		name           string
		savings        int64
		leverageFactor int64
		want           int64
	}{
		{"1.9x leverage on 10000", 10000, 190, 19000},
		{"3x leverage on 50000", 50000, 300, 150000},
		{"1x leverage", 20000, 100, 20000},
		{"zero savings", 0, 190, 0},
		{"zero leverage", 10000, 0, 0},
		{"negative savings", -5000, 190, 0},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got := toMinor(calculation.CalculateMaxLoanAmount(dec(tc.savings), tc.leverageFactor))
			if got != tc.want {
				t.Errorf("CalculateMaxLoanAmount(%d, %d) = %d, want %d", tc.savings, tc.leverageFactor, got, tc.want)
			}
		})
	}
}

func TestCalculateLeverageRatio(t *testing.T) {
	tests := []struct {
		name    string
		loan    int64
		savings int64
		wantBP  int64
	}{
		{"1.9x", 19000, 10000, 190},
		{"3x", 150000, 50000, 300},
		{"1x", 20000, 20000, 100},
		{"zero savings", 10000, 0, 0},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got := calculation.CalculateLeverageRatio(dec(tc.loan), dec(tc.savings))
			if got != tc.wantBP {
				t.Errorf("CalculateLeverageRatio(%d, %d) = %d, want %d", tc.loan, tc.savings, got, tc.wantBP)
			}
		})
	}
}

// ---------------------------------------------------------------------------
// Interest
// ---------------------------------------------------------------------------

func TestFlatRateInterest(t *testing.T) {
	tests := []struct {
		name           string
		principal      int64
		annualRateBP   int64
		termPeriods    int32
		periodsPerYear int32
		want           int64
	}{
		{
			name:           "10% annual, 12 monthly periods, 100000 principal",
			principal:      100000,
			annualRateBP:   1000, // 10%
			termPeriods:    12,
			periodsPerYear: 12,
			want:           10000, // 100000 * 1000 * 12 / (10000 * 12)
		},
		{
			name:           "15% annual, 26 weekly periods, 50000 principal",
			principal:      50000,
			annualRateBP:   1500,
			termPeriods:    26,
			periodsPerYear: 52,
			want:           3750, // 50000 * 1500 * 26 / (10000 * 52)
		},
		{"zero principal", 0, 1000, 12, 12, 0},
		{"zero rate", 100000, 0, 12, 12, 0},
		{"zero term", 100000, 1000, 0, 12, 0},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got := toMinor(
				calculation.FlatRateInterest(dec(tc.principal), tc.annualRateBP, tc.termPeriods, tc.periodsPerYear),
			)
			if got != tc.want {
				t.Errorf("FlatRateInterest = %d, want %d", got, tc.want)
			}
		})
	}
}

func TestReducingBalanceInterestForPeriod(t *testing.T) {
	tests := []struct {
		name         string
		outstanding  int64
		annualRateBP int64
		periodsPerYr int32
		want         int64
	}{
		{
			name:         "10% annual, weekly, 100000 outstanding",
			outstanding:  100000,
			annualRateBP: 1000,
			periodsPerYr: 52,
			want:         192, // 100000 * 1000 / (10000 * 52) = 192.3 truncated
		},
		{
			name:         "15% annual, monthly, 200000 outstanding",
			outstanding:  200000,
			annualRateBP: 1500,
			periodsPerYr: 12,
			want:         2500, // 200000 * 1500 / (10000 * 12)
		},
		{"zero outstanding", 0, 1500, 12, 0},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got := toMinor(
				calculation.ReducingBalanceInterestForPeriod(dec(tc.outstanding), tc.annualRateBP, tc.periodsPerYr),
			)
			if got != tc.want {
				t.Errorf("ReducingBalanceInterestForPeriod = %d, want %d", got, tc.want)
			}
		})
	}
}

func TestPeriodsPerYear(t *testing.T) {
	tests := []struct {
		periodType int32
		want       int32
	}{
		{1, 52}, // weekly
		{2, 26}, // biweekly
		{3, 12}, // monthly
		{0, 52}, // default
		{9, 52}, // unknown defaults to weekly
	}
	for _, tc := range tests {
		got := calculation.PeriodsPerYear(tc.periodType)
		if got != tc.want {
			t.Errorf("PeriodsPerYear(%d) = %d, want %d", tc.periodType, got, tc.want)
		}
	}
}

// ---------------------------------------------------------------------------
// Penalties
// ---------------------------------------------------------------------------

func TestCalculatePenalty(t *testing.T) {
	tests := []struct {
		name       string
		amount     int64
		fineRateBP int64
		want       int64
	}{
		{"10% of 10000", 10000, 1000, 1000},
		{"20% of 5000", 5000, 2000, 1000},
		{"zero amount", 0, 1000, 0},
		{"zero rate", 10000, 0, 0},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got := toMinor(calculation.CalculatePenalty(dec(tc.amount), tc.fineRateBP))
			if got != tc.want {
				t.Errorf("CalculatePenalty(%d, %d) = %d, want %d", tc.amount, tc.fineRateBP, got, tc.want)
			}
		})
	}
}

func TestEscalatingPenalty(t *testing.T) {
	rates := calculation.DefaultFineRates() // [1000, 2000, 3000] = 10%, 20%, 30%
	amount := int64(10000)

	tests := []struct {
		name        string
		periodsLate int32
		want        int64
	}{
		{"1 period late -> tier 1 (10%)", 1, 1000},
		{"2 periods late -> tier 2 (20%)", 2, 2000},
		{"3 periods late -> tier 3 (30%)", 3, 3000},
		{"5 periods late -> capped at tier 3", 5, 3000},
		{"0 periods late", 0, 0},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			got := toMinor(calculation.EscalatingPenalty(dec(amount), tc.periodsLate, rates))
			if got != tc.want {
				t.Errorf("EscalatingPenalty = %d, want %d", got, tc.want)
			}
		})
	}
}

func TestEscalatingPenaltyEmptyRates(t *testing.T) {
	got := toMinor(calculation.EscalatingPenalty(dec(10000), 1, nil))
	if got != 0 {
		t.Errorf("expected 0 with nil rates, got %d", got)
	}
	got = toMinor(calculation.EscalatingPenalty(dec(10000), 1, []int64{}))
	if got != 0 {
		t.Errorf("expected 0 with empty rates, got %d", got)
	}
}

// ---------------------------------------------------------------------------
// Loan Window Cycle
// ---------------------------------------------------------------------------

func TestActiveLoanWindowCycle(t *testing.T) {
	tests := []struct {
		name           string
		completed      int32
		maturity       int32
		grace          int32
		loanTenure     int32
		coolOff        int32
		wantCycle      int32
		wantShouldOpen bool
	}{
		{
			name: "first eligibility",
			// completed=4, maturity=4 -> eligible=0 -> 0 % (1+3+0)=0 -> should open
			completed: 4, maturity: 4, grace: 1, loanTenure: 3, coolOff: 0,
			wantCycle: 0, wantShouldOpen: true,
		},
		{
			name:      "mid cycle",
			completed: 5, maturity: 4, grace: 1, loanTenure: 3, coolOff: 0,
			wantCycle: 1, wantShouldOpen: false,
		},
		{
			name:      "second window",
			completed: 8, maturity: 4, grace: 1, loanTenure: 3, coolOff: 0,
			wantCycle: 0, wantShouldOpen: true,
		},
		{
			name:      "not yet eligible",
			completed: 2, maturity: 4, grace: 1, loanTenure: 3, coolOff: 0,
			wantCycle: -1, wantShouldOpen: false,
		},
		{
			name:      "with cool-off",
			completed: 10, maturity: 4, grace: 1, loanTenure: 3, coolOff: 2,
			wantCycle: 0, wantShouldOpen: true, // eligible=6, cycle=1+3+2=6, 6%6=0
		},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			cycle := calculation.ActiveLoanWindowCycle(tc.completed, tc.maturity, tc.grace, tc.loanTenure, tc.coolOff)
			if cycle != tc.wantCycle {
				t.Errorf("ActiveLoanWindowCycle = %d, want %d", cycle, tc.wantCycle)
			}
			shouldOpen := calculation.ShouldOpenLoanWindow(
				tc.completed,
				tc.maturity,
				tc.grace,
				tc.loanTenure,
				tc.coolOff,
			)
			if shouldOpen != tc.wantShouldOpen {
				t.Errorf("ShouldOpenLoanWindow = %v, want %v", shouldOpen, tc.wantShouldOpen)
			}
		})
	}
}

func TestLoanWindowInvalidCycleLength(t *testing.T) {
	// grace=0, tenure=0, coolOff=0 -> cycleLength=0 -> returns -1
	cycle := calculation.ActiveLoanWindowCycle(10, 4, 0, 0, 0)
	if cycle != -1 {
		t.Errorf("expected -1 for zero cycle length, got %d", cycle)
	}
}

// ---------------------------------------------------------------------------
// Amortization Schedule
// ---------------------------------------------------------------------------

func TestGenerateFlatSchedule(t *testing.T) {
	principal := int64(120000) // 1200.00
	interest := int64(12000)   // 120.00
	insurance := int64(6000)   // 60.00
	installments := int32(12)
	firstDue := time.Date(2026, 1, 7, 0, 0, 0, 0, time.UTC)

	entries := calculation.GenerateFlatSchedule(
		dec(principal),
		dec(interest),
		dec(insurance),
		dec(0),
		installments,
		firstDue,
		1,
	) // weekly, no fees

	if len(entries) != int(installments) {
		t.Fatalf("expected %d entries, got %d", installments, len(entries))
	}

	// Verify the sum of principal across all installments equals the original principal.
	var totalPrincipal, totalInterest, totalInsurance, totalDue int64
	for _, e := range entries {
		totalPrincipal += toMinor(e.PrincipalDue)
		totalInterest += toMinor(e.InterestDue)
		totalInsurance += toMinor(e.InsuranceDue)
		totalDue += toMinor(e.TotalDue)
	}

	if totalPrincipal != principal {
		t.Errorf("sum of principal installments = %d, want %d", totalPrincipal, principal)
	}
	if totalInterest != interest {
		t.Errorf("sum of interest installments = %d, want %d", totalInterest, interest)
	}
	if totalInsurance != insurance {
		t.Errorf("sum of insurance installments = %d, want %d", totalInsurance, insurance)
	}
	if totalDue != principal+interest+insurance {
		t.Errorf("sum of total due = %d, want %d", totalDue, principal+interest+insurance)
	}

	// Verify dates advance weekly
	for i, e := range entries {
		expectedDate := firstDue.AddDate(0, 0, 7*i)
		if !e.DueDate.Equal(expectedDate) {
			t.Errorf("entry %d: date = %v, want %v", i+1, e.DueDate, expectedDate)
		}
	}
}

func TestGenerateFlatScheduleDustHandling(t *testing.T) {
	// Principal that does not divide evenly: 100003 / 7
	// Dust is handled correctly at the Decimal level; when converting each
	// entry back to int64 minor units the per-entry truncation can cause
	// the sum to differ by up to (N-1) cents. We verify at Decimal level.
	principal := int64(100003)
	interest := int64(10001)
	installments := int32(7)
	firstDue := time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC)

	entries := calculation.GenerateFlatSchedule(
		dec(principal),
		dec(interest),
		dec(0),
		dec(0),
		installments,
		firstDue,
		3,
	) // monthly, no fees

	// Verify dust handling at Decimal precision (exact).
	totalPrincipalDec := decimalx.Zero()
	totalInterestDec := decimalx.Zero()
	for _, e := range entries {
		totalPrincipalDec = totalPrincipalDec.Add(e.PrincipalDue)
		totalInterestDec = totalInterestDec.Add(e.InterestDue)
	}

	if toMinor(totalPrincipalDec) != principal {
		t.Errorf("dust handling: Decimal principal sum = %d, want %d", toMinor(totalPrincipalDec), principal)
	}
	if toMinor(totalInterestDec) != interest {
		t.Errorf("dust handling: Decimal interest sum = %d, want %d", toMinor(totalInterestDec), interest)
	}
}

func TestGenerateReducingBalanceSchedule(t *testing.T) {
	principal := int64(120000)    // 1200.00
	annualRateBP := int64(1200)   // 12%
	insuranceRateBP := int64(100) // 1%
	installments := int32(12)
	firstDue := time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC)

	entries := calculation.GenerateReducingBalanceSchedule(
		dec(principal), annualRateBP, insuranceRateBP, 0, installments, firstDue, 3, // monthly, no fees
	)

	if len(entries) != int(installments) {
		t.Fatalf("expected %d entries, got %d", installments, len(entries))
	}

	// Sum of principal payments must equal the original principal.
	var totalPrincipal int64
	for _, e := range entries {
		totalPrincipal += toMinor(e.PrincipalDue)
	}
	if totalPrincipal != principal {
		t.Errorf("reducing balance: principal sum = %d, want %d", totalPrincipal, principal)
	}

	// Interest should decrease over time (first > last).
	if toMinor(entries[0].InterestDue) <= toMinor(entries[len(entries)-1].InterestDue) {
		t.Error("expected reducing-balance interest to decrease over time")
	}

	// Verify monthly date advancement
	for i, e := range entries {
		expectedDate := firstDue.AddDate(0, i, 0)
		if !e.DueDate.Equal(expectedDate) {
			t.Errorf("entry %d: date = %v, want %v", i+1, e.DueDate, expectedDate)
		}
	}
}

func TestGenerateScheduleZeroInstallments(t *testing.T) {
	entries := calculation.GenerateFlatSchedule(dec(100000), dec(10000), dec(0), dec(0), 0, time.Now(), 1)
	if entries != nil {
		t.Errorf("expected nil for 0 installments, got %d entries", len(entries))
	}
	entries2 := calculation.GenerateReducingBalanceSchedule(dec(100000), 1000, 100, 0, 0, time.Now(), 1)
	if entries2 != nil {
		t.Errorf("expected nil for 0 installments, got %d entries", len(entries2))
	}
}

func TestBiweeklyScheduleDateAdvancement(t *testing.T) {
	firstDue := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	entries := calculation.GenerateFlatSchedule(
		dec(52000),
		dec(5200),
		dec(0),
		dec(0),
		4,
		firstDue,
		2,
	) // biweekly, no fees

	for i, e := range entries {
		expectedDate := firstDue.AddDate(0, 0, 14*i)
		if !e.DueDate.Equal(expectedDate) {
			t.Errorf("biweekly entry %d: date = %v, want %v", i+1, e.DueDate, expectedDate)
		}
	}
}

// ---------------------------------------------------------------------------
// Tranche-Based Funding Allocation
// ---------------------------------------------------------------------------

func TestAllocateLoanFundingGroupLoan(t *testing.T) {
	request := calculation.FundingRequest{
		LoanAmount:  dec(100000),
		Currency:    "KES",
		IsGroupLoan: true,
		GroupID:     "group-1",
	}

	sources := []calculation.FundingSource{
		{SourceID: "group-1", SourceType: 1, TrancheLevel: 1, AvailableAmount: dec(65000)},
		{SourceID: "inv-1", SourceType: 3, TrancheLevel: 2, AvailableAmount: dec(30000)},
		{SourceID: "inv-2", SourceType: 4, TrancheLevel: 3, AvailableAmount: dec(50000)},
	}

	result := calculation.AllocateLoanFunding(request, sources)

	if toMinor(result.TotalAllocated) != 100000 {
		t.Errorf("TotalAllocated = %d, want 100000", toMinor(result.TotalAllocated))
	}
	if !result.Deficit.IsZero() {
		t.Errorf("Deficit = %d, want 0", toMinor(result.Deficit))
	}
	if len(result.Allocations) != 3 {
		t.Errorf("expected 3 allocations, got %d", len(result.Allocations))
	}

	// Tranche 1 (first-loss) should get 65000 from group savings
	if toMinor(result.Allocations[0].Amount) != 65000 {
		t.Errorf("Tranche 1 amount = %d, want 65000", toMinor(result.Allocations[0].Amount))
	}
	if result.Allocations[0].TrancheLevel != 1 {
		t.Errorf("Tranche 1 level = %d, want 1", result.Allocations[0].TrancheLevel)
	}

	if !calculation.VerifyTrancheAllocationInvariant(dec(100000), result) {
		t.Error("tranche allocation invariant violated")
	}
}

func TestAllocateLoanFundingDirectLoan(t *testing.T) {
	request := calculation.FundingRequest{
		LoanAmount:  dec(100000),
		Currency:    "KES",
		IsGroupLoan: false,
	}

	sources := []calculation.FundingSource{
		{SourceID: "platform", SourceType: 5, TrancheLevel: 1, AvailableAmount: dec(20000)},
		{SourceID: "inv-1", SourceType: 4, TrancheLevel: 2, AvailableAmount: dec(60000)},
		{SourceID: "inv-2", SourceType: 4, TrancheLevel: 2, AvailableAmount: dec(50000)},
	}

	result := calculation.AllocateLoanFunding(request, sources)

	if toMinor(result.TotalAllocated) != 100000 {
		t.Errorf("TotalAllocated = %d, want 100000", toMinor(result.TotalAllocated))
	}
	if !result.Deficit.IsZero() {
		t.Errorf("Deficit = %d, want 0", toMinor(result.Deficit))
	}

	// First allocation should be first-loss from platform, capped at 10% = 10000
	if result.Allocations[0].TrancheLevel != 1 {
		t.Errorf("first allocation tranche = %d, want 1", result.Allocations[0].TrancheLevel)
	}
	if toMinor(result.Allocations[0].Amount) != 10000 {
		t.Errorf("platform first-loss = %d, want 10000 (10%% of 100000)", toMinor(result.Allocations[0].Amount))
	}

	// Remaining 90000 should come from tranche 2 investors
	var tranche2Total int64
	for _, a := range result.Allocations {
		if a.TrancheLevel == 2 {
			tranche2Total += toMinor(a.Amount)
		}
	}
	if tranche2Total != 90000 {
		t.Errorf("tranche 2 total = %d, want 90000", tranche2Total)
	}
}

func TestAllocateLoanFundingFirstLossAbsorbsFirst(t *testing.T) {
	request := calculation.FundingRequest{
		LoanAmount:  dec(100000),
		Currency:    "KES",
		IsGroupLoan: true,
		GroupID:     "group-1",
	}

	sources := []calculation.FundingSource{
		{SourceID: "group-1", SourceType: 1, TrancheLevel: 1, AvailableAmount: dec(40000)},
	}

	result := calculation.AllocateLoanFunding(request, sources)

	if toMinor(result.TotalAllocated) != 40000 {
		t.Errorf("TotalAllocated = %d, want 40000", toMinor(result.TotalAllocated))
	}
	if toMinor(result.Deficit) != 60000 {
		t.Errorf("Deficit = %d, want 60000", toMinor(result.Deficit))
	}
}

func TestAllocateLoanFundingInvestorConstraints(t *testing.T) {
	request := calculation.FundingRequest{
		LoanAmount:  dec(100000),
		Currency:    "KES",
		IsGroupLoan: true,
		GroupID:     "group-1",
	}

	sources := []calculation.FundingSource{
		{SourceID: "group-1", SourceType: 1, TrancheLevel: 1, AvailableAmount: dec(60000)},
		{SourceID: "inv-1", SourceType: 3, TrancheLevel: 2, AvailableAmount: dec(50000), MaxForThisLoan: dec(20000)},
		{SourceID: "inv-2", SourceType: 4, TrancheLevel: 3, AvailableAmount: dec(50000)},
	}

	result := calculation.AllocateLoanFunding(request, sources)

	if toMinor(result.TotalAllocated) != 100000 {
		t.Errorf("TotalAllocated = %d, want 100000", toMinor(result.TotalAllocated))
	}

	for _, a := range result.Allocations {
		if a.SourceID == "inv-1" && toMinor(a.Amount) > 20000 {
			t.Errorf("inv-1 allocated %d but max was 20000", toMinor(a.Amount))
		}
	}
}

func TestAllocateLoanFundingZeroAmount(t *testing.T) {
	request := calculation.FundingRequest{LoanAmount: dec(0)}
	result := calculation.AllocateLoanFunding(request, nil)
	if toMinor(result.TotalAllocated) != 0 {
		t.Errorf("expected 0 for zero loan, got %d", toMinor(result.TotalAllocated))
	}
}

func TestAllocateLoanFundingNoSources(t *testing.T) {
	request := calculation.FundingRequest{LoanAmount: dec(100000), IsGroupLoan: true}
	result := calculation.AllocateLoanFunding(request, nil)
	if toMinor(result.Deficit) != 100000 {
		t.Errorf("Deficit = %d, want 100000", toMinor(result.Deficit))
	}
}

// TestAllocateLoanFundingFairRotation verifies that investors with lower
// utilization ratios are prioritized. An investor who has deployed 0 of
// their capital should receive a larger share than one who is 80% utilized.
func TestAllocateLoanFundingFairRotation(t *testing.T) {
	request := calculation.FundingRequest{
		LoanAmount:  dec(50000),
		Currency:    "KES",
		IsGroupLoan: false,
	}

	sources := []calculation.FundingSource{
		{SourceID: "platform", SourceType: 5, TrancheLevel: 1, AvailableAmount: dec(5000)},
		// inv-heavy: 80% utilized (deployed 80000 of 100000 total capital)
		{SourceID: "inv-heavy", SourceType: 4, TrancheLevel: 2, AvailableAmount: dec(20000), TotalDeployed: dec(80000)},
		// inv-fresh: 0% utilized (never deployed, fresh capital)
		{SourceID: "inv-fresh", SourceType: 4, TrancheLevel: 2, AvailableAmount: dec(20000), TotalDeployed: dec(0)},
		// inv-mid: 40% utilized (deployed 40000 of 100000 total capital)
		{SourceID: "inv-mid", SourceType: 4, TrancheLevel: 2, AvailableAmount: dec(60000), TotalDeployed: dec(40000)},
	}

	result := calculation.AllocateLoanFunding(request, sources)

	if toMinor(result.TotalAllocated) != 50000 {
		t.Fatalf("TotalAllocated = %d, want 50000", toMinor(result.TotalAllocated))
	}

	// Build allocation map for tranche 2 investors
	allocMap := make(map[string]int64)
	for _, a := range result.Allocations {
		if a.TrancheLevel == 2 {
			allocMap[a.SourceID] = toMinor(a.Amount)
		}
	}

	// inv-fresh (0% util) should get >= inv-heavy (80% util)
	if allocMap["inv-fresh"] < allocMap["inv-heavy"] {
		t.Errorf("fairness violated: fresh investor got %d but heavy-utilization investor got %d",
			allocMap["inv-fresh"], allocMap["inv-heavy"])
	}
}

// TestAllocateLoanFundingDustHandling verifies that odd amounts are handled
// correctly and the total always equals the loan amount.
func TestAllocateLoanFundingDustHandling(t *testing.T) {
	request := calculation.FundingRequest{
		LoanAmount:       dec(100003),
		Currency:         "KES",
		IsGroupLoan:      false,
		FirstLossPercent: 1000, // 10%
	}

	sources := []calculation.FundingSource{
		{SourceID: "platform", SourceType: 5, TrancheLevel: 1, AvailableAmount: dec(50000)},
		{SourceID: "inv-1", SourceType: 4, TrancheLevel: 2, AvailableAmount: dec(50000)},
		{SourceID: "inv-2", SourceType: 4, TrancheLevel: 2, AvailableAmount: dec(50000)},
	}

	result := calculation.AllocateLoanFunding(request, sources)

	if toMinor(result.TotalAllocated) != 100003 {
		t.Errorf("TotalAllocated = %d, want 100003 (dust not absorbed)", toMinor(result.TotalAllocated))
	}
	if !result.Deficit.IsZero() {
		t.Errorf("Deficit = %d, want 0", toMinor(result.Deficit))
	}
	if !calculation.VerifyTrancheAllocationInvariant(dec(100003), result) {
		t.Error("tranche allocation invariant violated with dust")
	}
}

// ---------------------------------------------------------------------------
// Interest Distribution (Platform Fees + Tax)
// ---------------------------------------------------------------------------

func TestCalculateInterestDistribution(t *testing.T) {
	tests := []struct {
		name          string
		grossInterest int64
		platformFeeBP int64
		taxBP         int64
		wantFee       int64
		wantTax       int64
		wantNet       int64
	}{
		{
			name:          "5% fee + 15% tax on 10000",
			grossInterest: 10000,
			platformFeeBP: 500,
			taxBP:         1500,
			wantFee:       500,
			wantTax:       1500,
			wantNet:       8000,
		},
		{
			name:          "zero interest",
			grossInterest: 0,
			platformFeeBP: 500,
			taxBP:         1500,
			wantFee:       0,
			wantTax:       0,
			wantNet:       0,
		},
		{
			name:          "no fees or tax",
			grossInterest: 10000,
			platformFeeBP: 0,
			taxBP:         0,
			wantFee:       0,
			wantTax:       0,
			wantNet:       10000,
		},
		{
			name:          "10% fee + 20% tax on 50000",
			grossInterest: 50000,
			platformFeeBP: 1000,
			taxBP:         2000,
			wantFee:       5000,
			wantTax:       10000,
			wantNet:       35000,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			dist := calculation.CalculateInterestDistribution(dec(tc.grossInterest), tc.platformFeeBP, tc.taxBP)
			if toMinor(dist.PlatformFee) != tc.wantFee {
				t.Errorf("PlatformFee = %d, want %d", toMinor(dist.PlatformFee), tc.wantFee)
			}
			if toMinor(dist.WithholdingTax) != tc.wantTax {
				t.Errorf("WithholdingTax = %d, want %d", toMinor(dist.WithholdingTax), tc.wantTax)
			}
			if toMinor(dist.NetInterest) != tc.wantNet {
				t.Errorf("NetInterest = %d, want %d", toMinor(dist.NetInterest), tc.wantNet)
			}
			if toMinor(dist.GrossInterest) != tc.grossInterest {
				t.Errorf("GrossInterest = %d, want %d", toMinor(dist.GrossInterest), tc.grossInterest)
			}
		})
	}
}

func TestCalculateInterestDistributionNegativeClamp(t *testing.T) {
	// If fees + tax exceed gross, net should be 0
	dist := calculation.CalculateInterestDistribution(dec(1000), 6000, 6000)
	if toMinor(dist.NetInterest) != 0 {
		t.Errorf("NetInterest = %d, want 0 (clamped)", toMinor(dist.NetInterest))
	}
}

// TestAllocateLoanFundingOldestDeployedFirst verifies that investors whose
// funds have been sitting idle longest (oldest LastDeployedAt) get priority
// over recently-deployed investors, all else being equal.
func TestAllocateLoanFundingOldestDeployedFirst(t *testing.T) {
	now := time.Now()
	longAgo := now.AddDate(0, -6, 0)  // deployed 6 months ago
	recent := now.Add(-1 * time.Hour) // deployed 1 hour ago

	request := calculation.FundingRequest{
		LoanAmount:  dec(60000),
		Currency:    "KES",
		IsGroupLoan: false,
	}

	sources := []calculation.FundingSource{
		{SourceID: "platform", SourceType: 5, TrancheLevel: 1, AvailableAmount: dec(6000)},
		// Both investors have identical utilization (0%) and available amounts
		// but inv-old deployed 6 months ago while inv-recent deployed 1 hour ago.
		{
			SourceID:        "inv-old",
			SourceType:      4,
			TrancheLevel:    2,
			AvailableAmount: dec(40000),
			TotalDeployed:   dec(0),
			LastDeployedAt:  longAgo,
		},
		{
			SourceID:        "inv-recent",
			SourceType:      4,
			TrancheLevel:    2,
			AvailableAmount: dec(40000),
			TotalDeployed:   dec(0),
			LastDeployedAt:  recent,
		},
	}

	result := calculation.AllocateLoanFunding(request, sources)

	if toMinor(result.TotalAllocated) != 60000 {
		t.Fatalf("TotalAllocated = %d, want 60000", toMinor(result.TotalAllocated))
	}

	allocMap := make(map[string]int64)
	for _, a := range result.Allocations {
		if a.TrancheLevel == 2 {
			allocMap[a.SourceID] = toMinor(a.Amount)
		}
	}

	// inv-old (deployed 6 months ago) should get at least as much as inv-recent (1 hour ago)
	// because idle money should be put to work first.
	if allocMap["inv-old"] < allocMap["inv-recent"] {
		t.Errorf("oldest-deployed priority violated: inv-old got %d but inv-recent got %d",
			allocMap["inv-old"], allocMap["inv-recent"])
	}

	// Also verify that a never-deployed investor (zero time) beats both
	neverDeployed := calculation.FundingSource{
		SourceID:        "inv-never",
		SourceType:      4,
		TrancheLevel:    2,
		AvailableAmount: dec(40000),
		TotalDeployed:   dec(0),
		// LastDeployedAt is zero value — never deployed
	}
	sources2 := []calculation.FundingSource{
		{SourceID: "platform", SourceType: 5, TrancheLevel: 1, AvailableAmount: dec(6000)},
		{
			SourceID:        "inv-recent2",
			SourceType:      4,
			TrancheLevel:    2,
			AvailableAmount: dec(40000),
			TotalDeployed:   dec(0),
			LastDeployedAt:  recent,
		},
		neverDeployed,
	}

	result2 := calculation.AllocateLoanFunding(request, sources2)

	allocMap2 := make(map[string]int64)
	for _, a := range result2.Allocations {
		if a.TrancheLevel == 2 {
			allocMap2[a.SourceID] = toMinor(a.Amount)
		}
	}

	if allocMap2["inv-never"] < allocMap2["inv-recent2"] {
		t.Errorf("never-deployed priority violated: inv-never got %d but inv-recent2 got %d",
			allocMap2["inv-never"], allocMap2["inv-recent2"])
	}
}

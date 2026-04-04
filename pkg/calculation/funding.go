package calculation

import (
	"sort"
	"time"

	"github.com/pitabwire/util/decimalx"
)

const (
	// basisPointsDenominator is the multiplier used to convert proportions to basis points.
	basisPointsDenominator = 10000
	// trancheMezzanine is the tranche level for mezzanine (affiliated/general investor) sources.
	trancheMezzanine int32 = 2
	// trancheSenior is the tranche level for senior (general investor) sources.
	trancheSenior int32 = 3
)

// DefaultFirstLossPercent is the default platform first-loss reserve as basis points
// of loan amount for direct-to-client loans (e.g. 1000 = 10%).
const DefaultFirstLossPercent int64 = 1000

// DefaultPlatformFeePercent is the platform fee on investor interest income in basis points (e.g. 500 = 5%).
const DefaultPlatformFeePercent int64 = 500

// DefaultWithholdingTaxPercent is the withholding tax on investor interest income in basis points (e.g. 1500 = 15%).
const DefaultWithholdingTaxPercent int64 = 1500

// FundingRequest describes a loan that needs funding.
type FundingRequest struct {
	LoanAmount       decimalx.Decimal
	Currency         string
	InterestRate     int64 // basis points
	ProductType      string
	Region           string
	GroupID          string // empty for direct-to-client
	IsGroupLoan      bool
	FirstLossPercent int64 // basis points for platform first-loss (0 = use default)
}

// FundingSource describes an available funding source with constraints.
type FundingSource struct {
	SourceID        string
	SourceType      int32 // FundingSource enum value
	TrancheLevel    int32 // 1=first-loss, 2=mezzanine, 3=senior
	AvailableAmount decimalx.Decimal
	MaxForThisLoan  decimalx.Decimal // constrained by investor preferences (zero = no extra constraint)
	TotalDeployed   decimalx.Decimal // lifetime deployed — used for fair rotation
	LastDeployedAt  time.Time        // when this source last had capital deployed
}

// FundingResult is the output of a tranche-based allocation.
type FundingResult struct {
	Allocations    []FundingAllocation
	TotalAllocated decimalx.Decimal
	Deficit        decimalx.Decimal
}

// FundingAllocation is a single allocation from a source.
type FundingAllocation struct {
	SourceID     string
	SourceType   int32
	TrancheLevel int32
	Amount       decimalx.Decimal
}

// InterestDistribution breaks down interest earned into net, platform fee, and tax.
type InterestDistribution struct {
	GrossInterest  decimalx.Decimal // total interest before deductions
	PlatformFee    decimalx.Decimal // platform service fee deducted
	WithholdingTax decimalx.Decimal // withholding tax deducted
	NetInterest    decimalx.Decimal // amount investor actually receives
}

// CalculateInterestDistribution computes the net interest an investor receives
// after platform fees and withholding tax are deducted.
// platformFeeBP and taxBP are in basis points (e.g. 500 = 5%, 1500 = 15%).
// Tax is applied on gross interest (before platform fee deduction).
func CalculateInterestDistribution(
	grossInterest decimalx.Decimal,
	platformFeeBP int64,
	taxBP int64,
) InterestDistribution {
	if !grossInterest.IsPositive() {
		return InterestDistribution{}
	}

	platformFee := decimalx.ApplyBasisPoints(grossInterest, platformFeeBP)
	withholdingTax := decimalx.ApplyBasisPoints(grossInterest, taxBP)
	netInterest := grossInterest.Sub(platformFee).Sub(withholdingTax)

	if netInterest.IsNegative() {
		netInterest = decimalx.Zero()
	}

	return InterestDistribution{
		GrossInterest:  grossInterest,
		PlatformFee:    platformFee,
		WithholdingTax: withholdingTax,
		NetInterest:    netInterest,
	}
}

// AllocateLoanFunding allocates a loan across tranched funding sources.
//
// For group loans:
//   - Tranche 1 (first-loss): group savings/income
//   - Tranche 2 (mezzanine): affiliated investors
//   - Tranche 3 (senior): general investors
//
// For direct loans:
//   - Tranche 1 (first-loss): platform reserve (capped at firstLossPercent of loan)
//   - Tranche 2 (senior): any eligible investors
//
// Within each investor tranche, allocation is spread fairly: investors with
// the lowest utilization ratio (TotalDeployed / AvailableBalance) are filled
// first so that idle capital is put to work before heavily-deployed capital.
func AllocateLoanFunding(request FundingRequest, sources []FundingSource) FundingResult {
	if !request.LoanAmount.IsPositive() || len(sources) == 0 {
		return FundingResult{Deficit: request.LoanAmount}
	}

	// Sort sources: tranche level ASC, then by utilization ratio ASC (least-utilized first),
	// then by LastDeployedAt ASC (oldest deployment first — idle money gets priority),
	// then by available amount DESC as final tiebreaker.
	sorted := make([]FundingSource, len(sources))
	copy(sorted, sources)
	sort.SliceStable(sorted, func(i, j int) bool {
		if sorted[i].TrancheLevel != sorted[j].TrancheLevel {
			return sorted[i].TrancheLevel < sorted[j].TrancheLevel
		}
		// Lower utilization ratio = more idle capital = should be filled first
		ratioI := utilizationRatio(sorted[i])
		ratioJ := utilizationRatio(sorted[j])
		if ratioI != ratioJ {
			return ratioI < ratioJ
		}
		// Older deployment = money sitting idle longer = higher priority
		if !sorted[i].LastDeployedAt.Equal(sorted[j].LastDeployedAt) {
			return sorted[i].LastDeployedAt.Before(sorted[j].LastDeployedAt)
		}
		return sorted[i].AvailableAmount.GreaterThan(sorted[j].AvailableAmount)
	})

	remaining := request.LoanAmount
	var allocations []FundingAllocation

	if request.IsGroupLoan {
		remaining = allocateGroupLoan(sorted, remaining, &allocations)
	} else {
		firstLossPct := request.FirstLossPercent
		if firstLossPct <= 0 {
			firstLossPct = DefaultFirstLossPercent
		}
		remaining = allocateDirectLoan(sorted, remaining, firstLossPct, request.LoanAmount, &allocations)
	}

	totalAllocated := request.LoanAmount.Sub(remaining)
	return FundingResult{
		Allocations:    allocations,
		TotalAllocated: totalAllocated,
		Deficit:        remaining,
	}
}

// utilizationRatio returns TotalDeployed * 10000 / (AvailableAmount + TotalDeployed)
// in basis points. A fresh investor with nothing deployed returns 0.
// Non-investor sources (group, platform) always return 0 since fairness
// only applies to investor selection.
func utilizationRatio(s FundingSource) int64 {
	total := s.AvailableAmount.Add(s.TotalDeployed)
	if !total.IsPositive() {
		return 0
	}
	return s.TotalDeployed.Mul(decimalx.NewFromInt64(basisPointsDenominator)).Div(total).Int64()
}

// allocateGroupLoan fills tranches for a group-cycling loan.
func allocateGroupLoan(
	sources []FundingSource,
	remaining decimalx.Decimal,
	allocations *[]FundingAllocation,
) decimalx.Decimal {
	remaining = allocateFromTranche(sources, 1, remaining, decimalx.Zero(), allocations)
	remaining = allocateFromTranche(sources, trancheMezzanine, remaining, decimalx.Zero(), allocations)
	remaining = allocateFromTranche(sources, trancheSenior, remaining, decimalx.Zero(), allocations)
	return remaining
}

// allocateDirectLoan fills tranches for a direct-to-client loan.
func allocateDirectLoan(
	sources []FundingSource,
	remaining decimalx.Decimal,
	firstLossPct int64,
	loanAmount decimalx.Decimal,
	allocations *[]FundingAllocation,
) decimalx.Decimal {
	firstLossCap := decimalx.ApplyBasisPoints(loanAmount, firstLossPct)
	remaining = allocateFromTranche(sources, 1, remaining, firstLossCap, allocations)
	remaining = allocateFromTranche(sources, trancheMezzanine, remaining, decimalx.Zero(), allocations)
	remaining = allocateFromTranche(sources, trancheSenior, remaining, decimalx.Zero(), allocations)
	return remaining
}

// allocateFromTranche allocates from sources at a given tranche level.
// If cap is positive, the total allocation from this tranche is capped at that amount.
//
// The allocation spreads proportionally by each source's effective available
// amount (respecting MaxForThisLoan constraints). Sources are already sorted
// by utilization ratio so least-utilized investors appear first — when
// rounding dust goes to the last source, this naturally benefits the
// least-utilized investor.
func allocateFromTranche(
	sources []FundingSource,
	trancheLevel int32,
	remaining decimalx.Decimal,
	capVal decimalx.Decimal,
	allocations *[]FundingAllocation,
) decimalx.Decimal {
	if !remaining.IsPositive() {
		return decimalx.Zero()
	}

	var trancheSources []FundingSource
	for _, s := range sources {
		if s.TrancheLevel == trancheLevel && s.AvailableAmount.IsPositive() {
			trancheSources = append(trancheSources, s)
		}
	}

	if len(trancheSources) == 0 {
		return remaining
	}

	trancheTarget := remaining
	if capVal.IsPositive() && capVal.LessThan(trancheTarget) {
		trancheTarget = capVal
	}

	effectiveAvail, totalAvailable := computeEffectiveAvailability(trancheSources)
	if !totalAvailable.IsPositive() {
		return remaining
	}

	toAllocate := trancheTarget
	if totalAvailable.LessThan(toAllocate) {
		toAllocate = totalAvailable
	}

	allocated := spreadProportionally(trancheSources, effectiveAvail, totalAvailable, toAllocate, allocations)
	return remaining.Sub(allocated)
}

// computeEffectiveAvailability returns each source's capped available amount and
// the total across all sources.
func computeEffectiveAvailability(sources []FundingSource) ([]decimalx.Decimal, decimalx.Decimal) {
	avail := make([]decimalx.Decimal, len(sources))
	total := decimalx.Zero()
	for i, s := range sources {
		a := s.AvailableAmount
		if s.MaxForThisLoan.IsPositive() && s.MaxForThisLoan.LessThan(a) {
			a = s.MaxForThisLoan
		}
		avail[i] = a
		total = total.Add(a)
	}
	return avail, total
}

// spreadProportionally distributes toAllocate across sources proportionally by
// their effective availability, with rounding dust going to the last source.
func spreadProportionally(
	sources []FundingSource,
	effectiveAvail []decimalx.Decimal,
	totalAvailable, toAllocate decimalx.Decimal,
	allocations *[]FundingAllocation,
) decimalx.Decimal {
	allocated := decimalx.Zero()
	for i := range sources {
		var share decimalx.Decimal
		if i == len(sources)-1 {
			share = toAllocate.Sub(allocated)
		} else {
			share = toAllocate.Mul(effectiveAvail[i]).Div(totalAvailable)
		}

		if !share.IsPositive() {
			continue
		}
		if share.GreaterThan(effectiveAvail[i]) {
			share = effectiveAvail[i]
		}

		*allocations = append(*allocations, FundingAllocation{
			SourceID:     sources[i].SourceID,
			SourceType:   sources[i].SourceType,
			TrancheLevel: sources[i].TrancheLevel,
			Amount:       share,
		})
		allocated = allocated.Add(share)
	}
	return allocated
}

// VerifyTrancheAllocationInvariant checks that the tranche allocation fully funds the loan.
func VerifyTrancheAllocationInvariant(loanAmount decimalx.Decimal, result FundingResult) bool {
	return result.TotalAllocated.Equal(loanAmount) && result.Deficit.IsZero()
}

package calculation

import (
	"sort"
	"time"
)

// DefaultFirstLossPercent is the default platform first-loss reserve as basis points
// of loan amount for direct-to-borrower loans (e.g. 1000 = 10%).
const DefaultFirstLossPercent int64 = 1000

// DefaultPlatformFeePercent is the platform fee on investor interest income in basis points (e.g. 500 = 5%).
const DefaultPlatformFeePercent int64 = 500

// DefaultWithholdingTaxPercent is the withholding tax on investor interest income in basis points (e.g. 1500 = 15%).
const DefaultWithholdingTaxPercent int64 = 1500

// FundingRequest describes a loan that needs funding.
type FundingRequest struct {
	LoanAmount       int64
	Currency         string
	InterestRate     int64 // basis points
	ProductType      string
	Region           string
	GroupID          string // empty for direct-to-borrower
	IsGroupLoan      bool
	FirstLossPercent int64 // basis points for platform first-loss (0 = use default)
}

// FundingSource describes an available funding source with constraints.
type FundingSource struct {
	SourceID        string
	SourceType      int32 // FundingSource enum value
	TrancheLevel    int32 // 1=first-loss, 2=mezzanine, 3=senior
	AvailableAmount int64
	MaxForThisLoan  int64     // constrained by investor preferences (0 = no extra constraint)
	TotalDeployed   int64     // lifetime deployed — used for fair rotation
	LastDeployedAt  time.Time // when this source last had capital deployed
}

// FundingResult is the output of a tranche-based allocation.
type FundingResult struct {
	Allocations    []FundingAllocation
	TotalAllocated int64
	Deficit        int64
}

// FundingAllocation is a single allocation from a source.
type FundingAllocation struct {
	SourceID     string
	SourceType   int32
	TrancheLevel int32
	Amount       int64
}

// InterestDistribution breaks down interest earned into net, platform fee, and tax.
type InterestDistribution struct {
	GrossInterest  int64 // total interest before deductions
	PlatformFee    int64 // platform service fee deducted
	WithholdingTax int64 // withholding tax deducted
	NetInterest    int64 // amount investor actually receives
}

// CalculateInterestDistribution computes the net interest an investor receives
// after platform fees and withholding tax are deducted.
// platformFeeBP and taxBP are in basis points (e.g. 500 = 5%, 1500 = 15%).
// Tax is applied on gross interest (before platform fee deduction).
func CalculateInterestDistribution(grossInterest int64, platformFeeBP int64, taxBP int64) InterestDistribution {
	if grossInterest <= 0 {
		return InterestDistribution{}
	}

	platformFee := grossInterest * platformFeeBP / 10000
	withholdingTax := grossInterest * taxBP / 10000
	netInterest := grossInterest - platformFee - withholdingTax

	if netInterest < 0 {
		netInterest = 0
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
	if request.LoanAmount <= 0 || len(sources) == 0 {
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
		return sorted[i].AvailableAmount > sorted[j].AvailableAmount
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

	totalAllocated := request.LoanAmount - remaining
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
	total := s.AvailableAmount + s.TotalDeployed
	if total <= 0 {
		return 0
	}
	return s.TotalDeployed * 10000 / total
}

// allocateGroupLoan fills tranches for a group-cycling loan.
func allocateGroupLoan(sources []FundingSource, remaining int64, allocations *[]FundingAllocation) int64 {
	remaining = allocateFromTranche(sources, 1, remaining, 0, allocations)
	remaining = allocateFromTranche(sources, 2, remaining, 0, allocations)
	remaining = allocateFromTranche(sources, 3, remaining, 0, allocations)
	return remaining
}

// allocateDirectLoan fills tranches for a direct-to-borrower loan.
func allocateDirectLoan(
	sources []FundingSource,
	remaining int64,
	firstLossPct int64,
	loanAmount int64,
	allocations *[]FundingAllocation,
) int64 {
	firstLossCap := loanAmount * firstLossPct / 10000
	remaining = allocateFromTranche(sources, 1, remaining, firstLossCap, allocations)
	remaining = allocateFromTranche(sources, 2, remaining, 0, allocations)
	remaining = allocateFromTranche(sources, 3, remaining, 0, allocations)
	return remaining
}

// allocateFromTranche allocates from sources at a given tranche level.
// If cap > 0, the total allocation from this tranche is capped at that amount.
//
// The allocation spreads proportionally by each source's effective available
// amount (respecting MaxForThisLoan constraints). Sources are already sorted
// by utilization ratio so least-utilized investors appear first — when
// rounding dust goes to the last source, this naturally benefits the
// least-utilized investor.
func allocateFromTranche(
	sources []FundingSource,
	trancheLevel int32,
	remaining int64,
	cap int64,
	allocations *[]FundingAllocation,
) int64 {
	if remaining <= 0 {
		return 0
	}

	var trancheSources []FundingSource
	for _, s := range sources {
		if s.TrancheLevel == trancheLevel && s.AvailableAmount > 0 {
			trancheSources = append(trancheSources, s)
		}
	}

	if len(trancheSources) == 0 {
		return remaining
	}

	trancheTarget := remaining
	if cap > 0 && cap < trancheTarget {
		trancheTarget = cap
	}

	// Compute effective available per source (respecting MaxForThisLoan)
	effectiveAvail := make([]int64, len(trancheSources))
	totalAvailable := int64(0)
	for i, s := range trancheSources {
		avail := s.AvailableAmount
		if s.MaxForThisLoan > 0 && s.MaxForThisLoan < avail {
			avail = s.MaxForThisLoan
		}
		effectiveAvail[i] = avail
		totalAvailable += avail
	}

	if totalAvailable <= 0 {
		return remaining
	}

	toAllocate := min64(trancheTarget, totalAvailable)

	allocated := int64(0)
	for i := range trancheSources {
		var share int64
		if i == len(trancheSources)-1 {
			share = toAllocate - allocated
		} else {
			share = toAllocate * effectiveAvail[i] / totalAvailable
		}

		if share <= 0 {
			continue
		}
		share = min64(share, effectiveAvail[i])

		*allocations = append(*allocations, FundingAllocation{
			SourceID:     trancheSources[i].SourceID,
			SourceType:   trancheSources[i].SourceType,
			TrancheLevel: trancheSources[i].TrancheLevel,
			Amount:       share,
		})
		allocated += share
	}

	return remaining - allocated
}

// VerifyTrancheAllocationInvariant checks that the tranche allocation fully funds the loan.
func VerifyTrancheAllocationInvariant(loanAmount int64, result FundingResult) bool {
	return result.TotalAllocated == loanAmount && result.Deficit == 0
}

func min64(a, b int64) int64 {
	if a < b {
		return a
	}
	return b
}

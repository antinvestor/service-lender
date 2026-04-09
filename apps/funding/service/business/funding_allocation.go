package business

import (
	"context"
	"fmt"

	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"
	"github.com/pitabwire/util/decimalx"

	"github.com/antinvestor/service-fintech/apps/funding/service/events"
	"github.com/antinvestor/service-fintech/apps/funding/service/models"
	"github.com/antinvestor/service-fintech/apps/funding/service/repository"
	"github.com/antinvestor/service-fintech/pkg/calculation"
	"github.com/antinvestor/service-fintech/pkg/clients"
	"github.com/antinvestor/service-fintech/pkg/constants"
)

const (
	// decimalPrecision is the number of decimal places for minor unit conversions (cents).
	decimalPrecision = 2
	// basisPointsDenominator is the multiplier used to convert proportions to basis points.
	basisPointsDenominator = 10000
	// trancheMezzanine is the tranche level for mezzanine (affiliated/general investor) sources.
	trancheMezzanine int32 = 2
	// trancheSenior is the tranche level for senior (general investor) sources.
	trancheSenior int32 = 3
)

type fundingAllocationBusiness struct {
	eventsMan fevents.Manager
	lfRepo    repository.LoanFundingRepository
	faRepo    repository.FundingAllocationRepository
	loReader  LoanOfferReader
	iaRepo    repository.InvestorAccountRepository
	ftRepo    repository.FundingTrancheRepository
	clients   *clients.PlatformClients
}

func NewFundingAllocationBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	lfRepo repository.LoanFundingRepository,
	faRepo repository.FundingAllocationRepository,
	loReader LoanOfferReader,
	iaRepo repository.InvestorAccountRepository,
	ftRepo repository.FundingTrancheRepository,
	pc *clients.PlatformClients,
) FundingAllocationBusiness {
	return &fundingAllocationBusiness{
		eventsMan: eventsMan,
		lfRepo:    lfRepo,
		faRepo:    faRepo,
		loReader:  loReader,
		iaRepo:    iaRepo,
		ftRepo:    ftRepo,
		clients:   pc,
	}
}

// SourceForOffer allocates funding sources for a loan offer using the tranche-based system.
func (b *fundingAllocationBusiness) SourceForOffer(
	ctx context.Context,
	offerID string,
) (map[string]interface{}, error) {
	logger := util.Log(ctx).WithField("method", "FundingAllocationBusiness.SourceForOffer")

	// Load the offer to get amount and details
	if b.loReader == nil {
		return nil, fmt.Errorf("loan offer reader not configured")
	}
	offer, err := b.loReader.GetByID(ctx, offerID)
	if err != nil {
		return nil, fmt.Errorf("offer not found: %w", err)
	}

	loanAmount := offer.Amount
	if loanAmount <= 0 {
		return nil, fmt.Errorf("offer has no amount (amount=%d)", loanAmount)
	}

	// Build the funding request from offer properties
	loanAmountDec := decimalx.FromMinorUnits(loanAmount, decimalPrecision)
	request := buildFundingRequest(offer, loanAmountDec)

	// Gather available funding sources
	sources := b.gatherFundingSources(ctx, request)

	// Run the tranche-based allocation
	result := calculation.AllocateLoanFunding(request, sources)

	if !calculation.VerifyTrancheAllocationInvariant(loanAmountDec, result) {
		logger.WithField("total_allocated", result.TotalAllocated).
			WithField("deficit", result.Deficit).
			Warn("loan not fully funded")
	}

	b.persistAllocations(ctx, logger, offerID, offer.Currency, result)

	logger.WithField("offer_id", offerID).
		WithField("loan_amount", loanAmount).
		WithField("total_allocated", result.TotalAllocated).
		WithField("tranches", len(result.Allocations)).
		Info("tranche-based funding allocation completed")

	return map[string]interface{}{
		"offer_id":        offerID,
		"loan_amount":     loanAmount,
		"total_allocated": result.TotalAllocated.ToMinorUnits(decimalPrecision),
		"deficit":         result.Deficit.ToMinorUnits(decimalPrecision),
		"fully_funded":    result.Deficit.IsZero(),
		"tranches":        len(result.Allocations),
		"is_group_loan":   request.IsGroupLoan,
	}, nil
}

// persistAllocations creates LoanFunding and FundingTranche records for each allocation
// and reserves investor balances where applicable.
func (b *fundingAllocationBusiness) persistAllocations(
	ctx context.Context,
	logger *util.LogEntry,
	offerID, currency string,
	result calculation.FundingResult,
) {
	for _, alloc := range result.Allocations {
		if !alloc.Amount.IsPositive() {
			continue
		}

		proportion := computeProportion(alloc.Amount, result.TotalAllocated)
		allocAmount := alloc.Amount.ToMinorUnits(decimalPrecision)

		funding := buildLoanFundingRecord(ctx, offerID, currency, alloc, proportion, allocAmount)
		if emitErr := b.eventsMan.Emit(ctx, events.LoanFundingSaveEvent, funding); emitErr != nil {
			logger.WithError(emitErr).Error("could not create loan funding record")
			continue
		}

		investorAccountID := investorAccountIDForAlloc(alloc)
		tranche := buildFundingTrancheRecord(ctx, funding.GetID(), investorAccountID, alloc, allocAmount, currency)
		if emitErr := b.eventsMan.Emit(ctx, events.FundingTrancheSaveEvent, tranche); emitErr != nil {
			logger.WithError(emitErr).Error("could not create funding tranche record")
			continue
		}

		if investorAccountID != "" {
			if resErr := b.reserveInvestorBalance(ctx, investorAccountID, allocAmount); resErr != nil {
				logger.WithError(resErr).Error("could not reserve investor balance")
			}
		}
	}
}

// computeProportion returns the allocation proportion in basis points.
func computeProportion(amount, totalAllocated decimalx.Decimal) int64 {
	if !totalAllocated.IsPositive() {
		return 0
	}
	return amount.Mul(decimalx.NewFromInt64(basisPointsDenominator)).
		Div(totalAllocated).
		Int64()
}

// investorAccountIDForAlloc returns the source ID if the allocation is investor-backed.
func investorAccountIDForAlloc(alloc calculation.FundingAllocation) string {
	if alloc.SourceType == int32(models.FundingSourceInvestorAffiliated) ||
		alloc.SourceType == int32(models.FundingSourceInvestorGeneral) {
		return alloc.SourceID
	}
	return ""
}

// buildLoanFundingRecord creates a LoanFunding model from an allocation.
func buildLoanFundingRecord(
	ctx context.Context,
	offerID, currency string,
	alloc calculation.FundingAllocation,
	proportion, allocAmount int64,
) *models.LoanFunding {
	funding := &models.LoanFunding{
		LoanOfferID: offerID,
		FundingType: alloc.SourceType,
		Proportion:  proportion,
		Amount:      allocAmount,
		Currency:    currency,
		OwnerID:     alloc.SourceID,
		OwnerType:   fundingSourceOwnerType(alloc.SourceType),
		Description: fmt.Sprintf("Tranche %d funding from %s for offer %s",
			alloc.TrancheLevel, alloc.SourceID, offerID),
		State: int32(constants.StateActive),
	}
	funding.GenID(ctx)
	return funding
}

// buildFundingTrancheRecord creates a FundingTranche model for a funding record.
func buildFundingTrancheRecord(
	ctx context.Context,
	loanFundingID, investorAccountID string,
	alloc calculation.FundingAllocation,
	allocAmount int64,
	currency string,
) *models.FundingTranche {
	tranche := &models.FundingTranche{
		LoanFundingID:     loanFundingID,
		InvestorAccountID: investorAccountID,
		TrancheLevel:      alloc.TrancheLevel,
		Amount:            allocAmount,
		Currency:          currency,
		State:             int32(constants.StateActive),
	}
	tranche.GenID(ctx)
	return tranche
}

// buildFundingRequest extracts loan parameters from offer properties into a FundingRequest.
func buildFundingRequest(offer *LoanOfferInfo, loanAmount decimalx.Decimal) calculation.FundingRequest {
	var (
		isGroupLoan  bool
		groupID      string
		productType  string
		region       string
		interestRate int64
	)

	if offer.Properties != nil {
		if gid, ok := offer.Properties["group_id"].(string); ok && gid != "" {
			isGroupLoan = true
			groupID = gid
		}
		if pt, ok := offer.Properties["product_type"].(string); ok {
			productType = pt
		}
		if r, ok := offer.Properties["region"].(string); ok {
			region = r
		}
		if ir, ok := offer.Properties["interest_rate"].(float64); ok {
			interestRate = int64(ir)
		}
	}

	return calculation.FundingRequest{
		LoanAmount:   loanAmount,
		Currency:     offer.Currency,
		InterestRate: interestRate,
		ProductType:  productType,
		Region:       region,
		GroupID:      groupID,
		IsGroupLoan:  isGroupLoan,
	}
}

// AbsorbLoss distributes a loss across funding tranches in order (first-loss first).
func (b *fundingAllocationBusiness) AbsorbLoss(
	ctx context.Context,
	loanOfferID string,
	lossAmount int64,
) error {
	logger := util.Log(ctx).WithField("method", "FundingAllocationBusiness.AbsorbLoss").
		WithField("loan_offer_id", loanOfferID)

	if lossAmount <= 0 {
		return nil
	}

	// Load all tranches for this loan, sorted by tranche level ASC (first-loss first)
	tranches, err := b.ftRepo.GetByLoanOfferID(ctx, loanOfferID)
	if err != nil {
		return fmt.Errorf("load tranches: %w", err)
	}

	remaining := lossAmount
	for _, tranche := range tranches {
		if remaining <= 0 {
			break
		}

		absorbable := tranche.Amount - tranche.LossAbsorbed
		if absorbable <= 0 {
			continue
		}

		absorbed := absorbable
		if absorbed > remaining {
			absorbed = remaining
		}

		tranche.LossAbsorbed += absorbed
		remaining -= absorbed

		if emitErr := b.eventsMan.Emit(ctx, events.FundingTrancheSaveEvent, tranche); emitErr != nil {
			logger.WithError(emitErr).Error("could not update tranche after loss absorption")
			continue
		}

		// Debit investor accounts; group/platform losses are handled at the ledger level.
		b.debitInvestorLoss(ctx, logger, tranche.InvestorAccountID, absorbed)

		logger.WithField("tranche_id", tranche.GetID()).
			WithField("tranche_level", tranche.TrancheLevel).
			WithField("absorbed", absorbed).
			Info("loss absorbed by tranche")
	}

	if remaining > 0 {
		logger.WithField("unrecoverable", remaining).
			Error("unrecoverable loss: all tranches exhausted")
	}

	return nil
}

// debitInvestorLoss reduces an investor's reserved balance after a loss absorption.
func (b *fundingAllocationBusiness) debitInvestorLoss(
	ctx context.Context,
	logger *util.LogEntry,
	investorAccountID string,
	absorbed int64,
) {
	if investorAccountID == "" {
		return
	}
	account, getErr := b.iaRepo.GetByID(ctx, investorAccountID)
	if getErr != nil {
		logger.WithError(getErr).Error("could not load investor account for loss")
		return
	}
	account.ReservedBalance -= absorbed
	if account.ReservedBalance < 0 {
		account.ReservedBalance = 0
	}
	if emitErr := b.eventsMan.Emit(ctx, events.InvestorAccountSaveEvent, account); emitErr != nil {
		logger.WithError(emitErr).Error("could not update investor account after loss")
	}
}

// gatherFundingSources collects all available funding sources based on the request type.
func (b *fundingAllocationBusiness) gatherFundingSources(
	ctx context.Context,
	request calculation.FundingRequest,
) []calculation.FundingSource {
	var sources []calculation.FundingSource

	loanAmountMinor := request.LoanAmount.ToMinorUnits(decimalPrecision)

	if request.IsGroupLoan {
		// Tranche 1 (first-loss): group savings and income
		// The group savings balance would come from the savings service.
		// During offer generation the member's savings were validated, so the
		// loan amount is a safe proxy here.
		sources = append(sources, calculation.FundingSource{
			SourceID:     request.GroupID,
			SourceType:   int32(models.FundingSourceGroupSavings),
			TrancheLevel: 1,
			// NOTE: Uses loan amount as proxy for group savings. In production,
			// query actual balance from savings or ledger service when available.
			AvailableAmount: request.LoanAmount,
		})

		// Tranche 2 (mezzanine): affiliated investors
		affiliated, err := b.iaRepo.GetAffiliatedForGroup(ctx, request.GroupID, request.Currency, request.InterestRate)
		if err == nil {
			sources = appendInvestorSources(
				sources,
				affiliated,
				int32(models.FundingSourceInvestorAffiliated),
				trancheMezzanine,
				nil,
			)
		}

		// Tranche 3 (senior): general investors (excluding those already affiliated)
		general, err := b.iaRepo.GetEligibleForLoan(
			ctx,
			request.Currency,
			request.InterestRate,
			loanAmountMinor,
			request.ProductType,
			request.Region,
		)
		if err == nil {
			excludeIDs := make(map[string]bool, len(affiliated))
			for _, inv := range affiliated {
				excludeIDs[inv.GetID()] = true
			}
			sources = appendInvestorSources(
				sources,
				general,
				int32(models.FundingSourceInvestorGeneral),
				trancheSenior,
				excludeIDs,
			)
		}
	} else {
		// Direct-to-client loan

		// Tranche 1 (first-loss): platform reserve
		// The platform reserve balance would come from configuration or a dedicated account.
		// We report the full reserve so the allocation algorithm can apply its own cap.
		firstLossTarget := decimalx.ApplyBasisPoints(request.LoanAmount, calculation.DefaultFirstLossPercent)
		sources = append(sources, calculation.FundingSource{
			SourceID:     "platform",
			SourceType:   int32(models.FundingSourcePlatformReserve),
			TrancheLevel: 1,
			// NOTE: Uses loan amount as proxy for platform reserve. In production,
			// query actual balance from savings or ledger service when available.
			AvailableAmount: firstLossTarget,
		})

		// Tranche 2 (senior): all eligible investors
		eligible, err := b.iaRepo.GetEligibleForLoan(
			ctx,
			request.Currency,
			request.InterestRate,
			loanAmountMinor,
			request.ProductType,
			request.Region,
		)
		if err == nil {
			sources = appendInvestorSources(
				sources,
				eligible,
				int32(models.FundingSourceInvestorGeneral),
				trancheMezzanine,
				nil,
			)
		}
	}

	return sources
}

// appendInvestorSources converts investor accounts into FundingSource entries,
// computing available balance and exposure headroom for each.
// Accounts in excludeIDs are skipped. TotalDeployed is passed through so the
// allocation algorithm can sort by utilization ratio for fair rotation.
func appendInvestorSources(
	sources []calculation.FundingSource,
	investors []*models.InvestorAccount,
	sourceType int32,
	trancheLevel int32,
	excludeIDs map[string]bool,
) []calculation.FundingSource {
	for _, inv := range investors {
		if excludeIDs != nil && excludeIDs[inv.GetID()] {
			continue
		}
		available := inv.AvailableBalance - inv.ReservedBalance
		if available <= 0 {
			continue
		}
		maxForLoan := available
		if inv.MaxExposure > 0 {
			headroom := inv.MaxExposure - inv.ReservedBalance
			if headroom < maxForLoan {
				maxForLoan = headroom
			}
			if headroom <= 0 {
				continue // exposure limit already reached
			}
		}
		fs := calculation.FundingSource{
			SourceID:        inv.GetID(),
			SourceType:      sourceType,
			TrancheLevel:    trancheLevel,
			AvailableAmount: decimalx.FromMinorUnits(available, decimalPrecision),
			MaxForThisLoan:  decimalx.FromMinorUnits(maxForLoan, decimalPrecision),
			TotalDeployed:   decimalx.FromMinorUnits(inv.TotalDeployed, decimalPrecision),
		}
		if inv.LastDeployedAt != nil {
			fs.LastDeployedAt = *inv.LastDeployedAt
		}
		sources = append(sources, fs)
	}
	return sources
}

// reserveInvestorBalance increments the reserved balance on an investor account.
func (b *fundingAllocationBusiness) reserveInvestorBalance(
	ctx context.Context,
	investorAccountID string,
	amount int64,
) error {
	account, err := b.iaRepo.GetByID(ctx, investorAccountID)
	if err != nil {
		return fmt.Errorf("investor account not found: %w", err)
	}

	account.ReservedBalance += amount
	account.TotalDeployed += amount

	return b.eventsMan.Emit(ctx, events.InvestorAccountSaveEvent, account)
}

func fundingSourceOwnerType(sourceType int32) string {
	switch models.FundingSource(sourceType) {
	case models.FundingSourceGroupSavings, models.FundingSourceGroupIncome:
		return "group"
	case models.FundingSourceInvestorAffiliated, models.FundingSourceInvestorGeneral:
		return "investor"
	case models.FundingSourcePlatformReserve:
		return "platform"
	case models.FundingSourceUnspecified:
		return "unknown"
	default:
		return "unknown"
	}
}

package business

import (
	"context"
	"fmt"

	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/funding/service/events"
	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/apps/funding/service/repository"
	"github.com/antinvestor/service-lender/pkg/calculation"
	"github.com/antinvestor/service-lender/pkg/clients"
	"github.com/antinvestor/service-lender/pkg/constants"
)

type fundingAllocationBusiness struct {
	eventsMan fevents.Manager
	lfRepo    repository.LoanFundingRepository
	faRepo    repository.FundingAllocationRepository
	loRepo    repository.LoanOfferRepository
	iaRepo    repository.InvestorAccountRepository
	ftRepo    repository.FundingTrancheRepository
	clients   *clients.PlatformClients
}

func NewFundingAllocationBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	lfRepo repository.LoanFundingRepository,
	faRepo repository.FundingAllocationRepository,
	loRepo repository.LoanOfferRepository,
	iaRepo repository.InvestorAccountRepository,
	ftRepo repository.FundingTrancheRepository,
	pc *clients.PlatformClients,
) FundingAllocationBusiness {
	return &fundingAllocationBusiness{
		eventsMan: eventsMan,
		lfRepo:    lfRepo,
		faRepo:    faRepo,
		loRepo:    loRepo,
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
	offer, err := b.loRepo.GetByID(ctx, offerID)
	if err != nil {
		return nil, fmt.Errorf("offer not found: %w", err)
	}

	loanAmount := offer.Amount
	if loanAmount <= 0 {
		return nil, fmt.Errorf("offer has no amount (amount=%d)", loanAmount)
	}

	// Determine if this is a group loan or direct loan from offer properties
	isGroupLoan := false
	groupID := ""
	productType := ""
	region := ""
	interestRate := int64(0)

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

	// Build the funding request
	request := calculation.FundingRequest{
		LoanAmount:   loanAmount,
		Currency:     offer.Currency,
		InterestRate: interestRate,
		ProductType:  productType,
		Region:       region,
		GroupID:      groupID,
		IsGroupLoan:  isGroupLoan,
	}

	// Gather available funding sources
	sources, err := b.gatherFundingSources(ctx, request)
	if err != nil {
		return nil, fmt.Errorf("gather funding sources: %w", err)
	}

	// Run the tranche-based allocation
	result := calculation.AllocateLoanFunding(request, sources)

	if !calculation.VerifyTrancheAllocationInvariant(loanAmount, result) {
		logger.WithField("total_allocated", result.TotalAllocated).
			WithField("deficit", result.Deficit).
			Warn("loan not fully funded")
	}

	// Create LoanFunding + FundingTranche records for each allocation
	for _, alloc := range result.Allocations {
		if alloc.Amount <= 0 {
			continue
		}

		proportion := int64(0)
		if result.TotalAllocated > 0 {
			proportion = alloc.Amount * 10000 / result.TotalAllocated
		}

		funding := &models.LoanFunding{
			LoanOfferID: offerID,
			FundingType: alloc.SourceType,
			Proportion:  proportion,
			Amount:      alloc.Amount,
			Currency:    offer.Currency,
			OwnerID:     alloc.SourceID,
			OwnerType:   fundingSourceOwnerType(alloc.SourceType),
			Description: fmt.Sprintf("Tranche %d funding from %s for offer %s",
				alloc.TrancheLevel, alloc.SourceID, offerID),
			State: int32(constants.StateActive),
		}
		funding.GenID(ctx)

		if emitErr := b.eventsMan.Emit(ctx, events.LoanFundingSaveEvent, funding); emitErr != nil {
			logger.WithError(emitErr).Error("could not create loan funding record")
			continue
		}

		// Create the corresponding tranche record
		investorAccountID := ""
		if alloc.SourceType == int32(models.FundingSourceInvestorAffiliated) ||
			alloc.SourceType == int32(models.FundingSourceInvestorGeneral) {
			investorAccountID = alloc.SourceID
		}

		tranche := &models.FundingTranche{
			LoanFundingID:     funding.GetID(),
			InvestorAccountID: investorAccountID,
			TrancheLevel:      alloc.TrancheLevel,
			Amount:            alloc.Amount,
			Currency:          offer.Currency,
			State:             int32(constants.StateActive),
		}
		tranche.GenID(ctx)

		if emitErr := b.eventsMan.Emit(ctx, events.FundingTrancheSaveEvent, tranche); emitErr != nil {
			logger.WithError(emitErr).Error("could not create funding tranche record")
			continue
		}

		// Reserve balance on investor accounts
		if investorAccountID != "" {
			if resErr := b.reserveInvestorBalance(ctx, investorAccountID, alloc.Amount); resErr != nil {
				logger.WithError(resErr).Error("could not reserve investor balance")
			}
		}
	}

	logger.WithField("offer_id", offerID).
		WithField("loan_amount", loanAmount).
		WithField("total_allocated", result.TotalAllocated).
		WithField("tranches", len(result.Allocations)).
		Info("tranche-based funding allocation completed")

	return map[string]interface{}{
		"offer_id":        offerID,
		"loan_amount":     loanAmount,
		"total_allocated": result.TotalAllocated,
		"deficit":         result.Deficit,
		"fully_funded":    result.Deficit == 0,
		"tranches":        len(result.Allocations),
		"is_group_loan":   isGroupLoan,
	}, nil
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

		// Debit the source account
		if tranche.InvestorAccountID != "" {
			// Investor loss
			account, getErr := b.iaRepo.GetByID(ctx, tranche.InvestorAccountID)
			if getErr != nil {
				logger.WithError(getErr).Error("could not load investor account for loss")
				continue
			}
			account.ReservedBalance -= absorbed
			if account.ReservedBalance < 0 {
				account.ReservedBalance = 0
			}
			if emitErr := b.eventsMan.Emit(ctx, events.InvestorAccountSaveEvent, account); emitErr != nil {
				logger.WithError(emitErr).Error("could not update investor account after loss")
			}
		}
		// For group/platform sources, the loss is absorbed from the respective pool
		// (handled at the ledger level via transfer orders)

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

// gatherFundingSources collects all available funding sources based on the request type.
func (b *fundingAllocationBusiness) gatherFundingSources(
	ctx context.Context,
	request calculation.FundingRequest,
) ([]calculation.FundingSource, error) {
	var sources []calculation.FundingSource

	if request.IsGroupLoan {
		// Tranche 1 (first-loss): group savings and income
		// The group savings balance would come from the savings service.
		// During offer generation the member's savings were validated, so the
		// loan amount is a safe proxy here.
		sources = append(sources, calculation.FundingSource{
			SourceID:        request.GroupID,
			SourceType:      int32(models.FundingSourceGroupSavings),
			TrancheLevel:    1,
			AvailableAmount: request.LoanAmount, // TODO: query actual group savings balance
		})

		// Tranche 2 (mezzanine): affiliated investors
		affiliated, err := b.iaRepo.GetAffiliatedForGroup(ctx, request.GroupID, request.Currency, request.InterestRate)
		if err == nil {
			sources = appendInvestorSources(sources, affiliated, int32(models.FundingSourceInvestorAffiliated), 2, nil)
		}

		// Tranche 3 (senior): general investors (excluding those already affiliated)
		general, err := b.iaRepo.GetEligibleForLoan(
			ctx,
			request.Currency,
			request.InterestRate,
			request.LoanAmount,
			request.ProductType,
			request.Region,
		)
		if err == nil {
			excludeIDs := make(map[string]bool, len(affiliated))
			for _, inv := range affiliated {
				excludeIDs[inv.GetID()] = true
			}
			sources = appendInvestorSources(sources, general, int32(models.FundingSourceInvestorGeneral), 3, excludeIDs)
		}
	} else {
		// Direct-to-borrower loan

		// Tranche 1 (first-loss): platform reserve
		// The platform reserve balance would come from configuration or a dedicated account.
		// We report the full reserve so the allocation algorithm can apply its own cap.
		firstLossTarget := request.LoanAmount * calculation.DefaultFirstLossPercent / 10000
		sources = append(sources, calculation.FundingSource{
			SourceID:        "platform",
			SourceType:      int32(models.FundingSourcePlatformReserve),
			TrancheLevel:    1,
			AvailableAmount: firstLossTarget, // TODO: query actual platform reserve balance
		})

		// Tranche 2 (senior): all eligible investors
		eligible, err := b.iaRepo.GetEligibleForLoan(
			ctx,
			request.Currency,
			request.InterestRate,
			request.LoanAmount,
			request.ProductType,
			request.Region,
		)
		if err == nil {
			sources = appendInvestorSources(sources, eligible, int32(models.FundingSourceInvestorGeneral), 2, nil)
		}
	}

	return sources, nil
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
			AvailableAmount: available,
			MaxForThisLoan:  maxForLoan,
			TotalDeployed:   inv.TotalDeployed,
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
	default:
		return "unknown"
	}
}

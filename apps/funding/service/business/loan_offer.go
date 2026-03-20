package business

import (
	"context"
	"fmt"
	"time"

	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/funding/service/events"
	"github.com/antinvestor/service-lender/apps/funding/service/models"
	"github.com/antinvestor/service-lender/apps/funding/service/repository"
	grouprepo "github.com/antinvestor/service-lender/apps/group/service/repository"
	"github.com/antinvestor/service-lender/pkg/calculation"
	"github.com/antinvestor/service-lender/pkg/clients"
	"github.com/antinvestor/service-lender/pkg/constants"
)

type loanOfferBusiness struct {
	eventsMan fevents.Manager
	loRepo    repository.LoanOfferRepository
	lwRepo    repository.LoanWindowRepository
	memRepo   grouprepo.MembershipRepository
	clients   *clients.PlatformClients
}

func NewLoanOfferBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	loRepo repository.LoanOfferRepository,
	lwRepo repository.LoanWindowRepository,
	memRepo grouprepo.MembershipRepository,
	pc *clients.PlatformClients,
) LoanOfferBusiness {
	return &loanOfferBusiness{
		eventsMan: eventsMan,
		loRepo:    loRepo,
		lwRepo:    lwRepo,
		memRepo:   memRepo,
		clients:   pc,
	}
}

func (b *loanOfferBusiness) GenerateForWindow(ctx context.Context, windowID string) (interface{}, error) {
	logger := util.Log(ctx).WithField("method", "LoanOfferBusiness.GenerateForWindow")

	// Load loan window
	window, err := b.lwRepo.GetByID(ctx, windowID)
	if err != nil {
		return nil, fmt.Errorf("loan window not found: %w", err)
	}

	if window.State != int32(constants.StateActive) {
		return nil, fmt.Errorf("loan window is not active (state=%d)", window.State)
	}

	// Get all active members in the window's group
	members, err := b.memRepo.GetByGroupID(ctx, window.GroupID)
	if err != nil {
		return nil, fmt.Errorf("could not load memberships for group %s: %w", window.GroupID, err)
	}

	// Check for existing offers in this window to avoid duplicates
	existingOffers, err := b.loRepo.GetByLoanWindowID(ctx, windowID)
	if err != nil {
		logger.WithError(err).Warn("could not check existing offers, proceeding")
	}
	existingByMember := make(map[string]bool)
	for _, offer := range existingOffers {
		existingByMember[offer.MembershipID] = true
	}

	var offersGenerated int
	expiryTime := time.Now().Add(72 * time.Hour)

	for _, mem := range members {
		memberID := mem.GetID()

		// Skip non-regular members (agents, registrars)
		if mem.MembershipType != int32(3) { // MembershipTypeMember
			continue
		}

		// Skip if offer already exists for this member in this window
		if existingByMember[memberID] {
			logger.WithField("member_id", memberID).Debug("offer already exists, skipping")
			continue
		}

		// Calculate max loan amount using the window's leverage and periodic amount
		// The periodic amount represents the member's savings balance for the window
		maxLoan := calculation.CalculateMaxLoanAmount(window.PeriodicAmount, window.Leverage)
		if maxLoan <= 0 {
			logger.WithField("member_id", memberID).Debug("max loan is zero, skipping")
			continue
		}

		offer := &models.LoanOffer{
			MembershipID: memberID,
			LoanWindowID: windowID,
			PeriodID:     window.PeriodID,
			Amount:       maxLoan,
			Currency:     window.Currency,
			OfferType:    int32(models.LoanOfferTypeOffered),
			Response:     int32(models.LoanOfferResponseNone),
			ExpiryDate:   &expiryTime,
			Description:  fmt.Sprintf("Loan offer for window %s, max amount %d", windowID, maxLoan),
			State:        int32(constants.StateActive),
		}
		offer.GenID(ctx)

		if emitErr := b.eventsMan.Emit(ctx, events.LoanOfferSaveEvent, offer); emitErr != nil {
			logger.WithError(emitErr).WithField("member_id", memberID).
				Error("could not create loan offer")
			continue
		}

		offersGenerated++
	}

	logger.WithField("window_id", windowID).
		WithField("offers_generated", offersGenerated).
		WithField("members_processed", len(members)).
		Info("loan offer generation completed")

	return map[string]interface{}{
		"window_id":        windowID,
		"offers_generated": offersGenerated,
	}, nil
}

func (b *loanOfferBusiness) Respond(ctx context.Context, offerID string, response int32) error {
	logger := util.Log(ctx).WithField("method", "LoanOfferBusiness.Respond")

	offer, err := b.loRepo.GetByID(ctx, offerID)
	if err != nil {
		return fmt.Errorf("offer not found: %w", err)
	}

	if offer.State != int32(constants.StateActive) {
		return fmt.Errorf("offer is not active (state=%d)", offer.State)
	}

	offer.Response = response

	// If accepted, keep active for funding. If rejected/expired/blocked, mark inactive
	if response != int32(models.LoanOfferResponseAccept) {
		offer.State = int32(constants.StateInactive)
	}

	logger.WithField("offer_id", offerID).
		WithField("response", response).
		Info("loan offer response recorded")

	return b.eventsMan.Emit(ctx, events.LoanOfferSaveEvent, offer)
}

func (b *loanOfferBusiness) CreateLoanAccount(ctx context.Context, offerID string) (map[string]interface{}, error) {
	logger := util.Log(ctx).WithField("method", "LoanOfferBusiness.CreateLoanAccount")

	offer, err := b.loRepo.GetByID(ctx, offerID)
	if err != nil {
		return nil, fmt.Errorf("offer not found: %w", err)
	}

	if offer.Response != int32(models.LoanOfferResponseAccept) {
		return nil, fmt.Errorf("offer not accepted (response=%d)", offer.Response)
	}

	logger.WithField("offer_id", offerID).
		WithField("amount", offer.Amount).
		WithField("membership_id", offer.MembershipID).
		Info("creating loan account for accepted offer")

	// Build the result with info needed for loan creation
	result := map[string]interface{}{
		"offer_id":      offerID,
		"amount":        offer.Amount,
		"currency":      offer.Currency,
		"membership_id": offer.MembershipID,
	}

	// TODO: Once LenderOrigination and LenderLoanManagement clients are available:
	//   1. Create loan application via origination
	//   2. Create loan account via loans service
	//   3. Store the loan_account_id and application_id on the offer
	//
	// if b.clients.LenderOrigination != nil {
	//     app, err := b.clients.LenderOrigination.CreateApplication(ctx, ...)
	//     if err == nil {
	//         offer.ApplicationID = app.Id
	//         result["application_id"] = app.Id
	//     }
	// }
	// if b.clients.LenderLoanManagement != nil {
	//     loan, err := b.clients.LenderLoanManagement.CreateLoanAccount(ctx, ...)
	//     if err == nil {
	//         offer.LoanAccountID = loan.Id
	//         result["loan_account_id"] = loan.Id
	//     }
	// }

	// Persist any updates to the offer
	if emitErr := b.eventsMan.Emit(ctx, events.LoanOfferSaveEvent, offer); emitErr != nil {
		logger.WithError(emitErr).Warn("could not update offer with loan account details")
	}

	return result, nil
}

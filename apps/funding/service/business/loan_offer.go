package business

import (
	"context"
	"fmt"
	"time"

	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"
	"github.com/pitabwire/util/decimalx"

	"github.com/antinvestor/service-fintech/apps/funding/service/events"
	"github.com/antinvestor/service-fintech/apps/funding/service/models"
	"github.com/antinvestor/service-fintech/apps/funding/service/repository"
	grouprepo "github.com/antinvestor/service-fintech/apps/identity/service/repository"
	"github.com/antinvestor/service-fintech/pkg/calculation"
	"github.com/antinvestor/service-fintech/pkg/clients"
	"github.com/antinvestor/service-fintech/pkg/constants"
)

const (
	// offerExpiryHours is the number of hours before a loan offer expires.
	offerExpiryHours = 72
	// decimalPrecisionOffer is the number of decimal places for minor unit conversions.
	decimalPrecisionOffer = 2
	// membershipTypeMember is the membership type value for regular members.
	membershipTypeMember = int32(3)
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
	members, err := b.memRepo.GetByGroupID(ctx, window.GroupID, 0, 1000)
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
	expiryTime := time.Now().Add(offerExpiryHours * time.Hour)

	for _, mem := range members {
		memberID := mem.GetID()

		// Skip non-regular members (agents, registrars)
		if mem.MembershipType != membershipTypeMember {
			continue
		}

		// Skip if offer already exists for this member in this window
		if existingByMember[memberID] {
			logger.WithField("member_id", memberID).Debug("offer already exists, skipping")
			continue
		}

		// Calculate max loan amount using the window's leverage and periodic amount
		// The periodic amount represents the member's savings balance for the window
		periodicDec := decimalx.FromMinorUnits(window.PeriodicAmount, decimalPrecisionOffer)
		maxLoanDec := calculation.CalculateMaxLoanAmount(periodicDec, window.Leverage)
		maxLoan := maxLoanDec.ToMinorUnits(decimalPrecisionOffer)
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

	// Create loan application and account via platform services
	b.createLoanFromOffer(ctx, logger, offer, offerID, result)

	// Persist any updates to the offer
	if emitErr := b.eventsMan.Emit(ctx, events.LoanOfferSaveEvent, offer); emitErr != nil {
		logger.WithError(emitErr).Warn("could not update offer with loan account details")
	}

	return result, nil
}

// createLoanFromOffer creates a loan application and account via origination and
// loan management services, updating the offer and result map with the IDs.
func (b *loanOfferBusiness) createLoanFromOffer(
	ctx context.Context,
	logger *util.LogEntry,
	offer *models.LoanOffer,
	offerID string,
	result map[string]interface{},
) {
	if b.clients == nil || b.clients.LenderOrigination == nil {
		logger.Warn("origination client not available, skipping loan account creation")
		return
	}

	offerMoney := models.MinorUnitsToMoney(offer.Amount, offer.Currency)
	appObj := &originationv1.ApplicationObject{
		RequestedAmount: offerMoney,
		ApprovedAmount:  offerMoney,
		Purpose:         fmt.Sprintf("Group loan offer %s", offerID),
	}
	appResp, appErr := b.clients.LenderOrigination.ApplicationSave(ctx, connect.NewRequest(
		&originationv1.ApplicationSaveRequest{Data: appObj},
	))
	if appErr != nil {
		logger.WithError(appErr).Warn("could not create loan application via origination")
		return
	}
	if appResp.Msg.GetData() == nil {
		return
	}

	offer.ApplicationID = appResp.Msg.GetData().GetId()
	result["application_id"] = offer.ApplicationID

	if b.clients.LenderLoanMgmt == nil || offer.ApplicationID == "" {
		return
	}

	loanResp, loanErr := b.clients.LenderLoanMgmt.LoanAccountCreate(ctx, connect.NewRequest(
		&loansv1.LoanAccountCreateRequest{ApplicationId: offer.ApplicationID},
	))
	if loanErr != nil {
		logger.WithError(loanErr).Warn("could not create loan account via loan management")
		return
	}
	if loanResp.Msg.GetData() != nil {
		offer.LoanAccountID = loanResp.Msg.GetData().GetId()
		result["loan_account_id"] = offer.LoanAccountID
	}
}

package business

import (
	"context"
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"

	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	groupmodels "github.com/antinvestor/service-lender/apps/group/service/models"
	grouprepo "github.com/antinvestor/service-lender/apps/group/service/repository"
	"github.com/antinvestor/service-lender/apps/operations/service/events"
	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
	"github.com/antinvestor/service-lender/pkg/clients"
	"github.com/antinvestor/service-lender/pkg/constants"
)

type paymentRoutingBusiness struct {
	eventsMan fevents.Manager
	ipRepo    repository.IncomingPaymentRepository
	toRepo    repository.TransferOrderRepository
	obRepo    repository.ObligationRepository
	arRepo    repository.AccountRefRepository
	memRepo   grouprepo.MembershipRepository
	clients   *clients.PlatformClients
}

func NewPaymentRoutingBusiness(_ context.Context, eventsMan fevents.Manager,
	ipRepo repository.IncomingPaymentRepository,
	toRepo repository.TransferOrderRepository,
	obRepo repository.ObligationRepository,
	arRepo repository.AccountRefRepository,
	memRepo grouprepo.MembershipRepository,
	pc *clients.PlatformClients,
) PaymentRoutingBusiness {
	return &paymentRoutingBusiness{
		eventsMan: eventsMan,
		ipRepo:    ipRepo,
		toRepo:    toRepo,
		obRepo:    obRepo,
		arRepo:    arRepo,
		memRepo:   memRepo,
		clients:   pc,
	}
}

// identificationResult holds the outcome of a successful payment identification.
type identificationResult struct {
	Strategy     string
	MembershipID string
	GroupID      string
	ProfileID    string
}

// IdentifyPayment tries to match an incoming payment to a member using 5 strategies.
// The strategies are tried in order -- first match wins.
//
// Strategy 1: Direct membership ID in payment reference
// Strategy 2: Profile ID match with single membership
// Strategy 3: Filter member subscriptions (exclude non-member types like registra, agent, funder)
// Strategy 4: Contact ID match within group members
// Strategy 5: Customer group name match via payer name
//
// If no match is found the payment is routed to the product's unidentified account.
// identificationStrategy defines one step in the payment identification pipeline.
type identificationStrategy struct {
	name    string
	enabled bool
	run     func(ctx context.Context) (*identificationResult, error)
}

func (b *paymentRoutingBusiness) IdentifyPayment(
	ctx context.Context,
	paymentData map[string]interface{},
) (map[string]interface{}, error) {
	logger := util.Log(ctx).WithField("method", "PaymentRoutingBusiness.IdentifyPayment")

	paymentRef, _ := paymentData["reference"].(string)
	payerRef, _ := paymentData["payer_reference"].(string)
	payerName, _ := paymentData["payer_name"].(string)
	productID, _ := paymentData["product_id"].(string)
	groupID, _ := paymentData["group_id"].(string)

	paymentRef = strings.TrimSpace(paymentRef)
	payerRef = strings.TrimSpace(payerRef)
	payerName = strings.TrimSpace(payerName)

	strategies := []identificationStrategy{
		{"direct membership ID", paymentRef != "", func(ctx context.Context) (*identificationResult, error) {
			return b.identifyByMembershipID(ctx, paymentRef)
		}},
		{"profile ID single match", payerRef != "", func(ctx context.Context) (*identificationResult, error) {
			return b.identifyByProfileID(ctx, payerRef)
		}},
		{"filtered membership type", payerRef != "", func(ctx context.Context) (*identificationResult, error) {
			return b.identifyByFilteredMembership(ctx, payerRef, groupID)
		}},
		{"contact ID match", payerRef != "", func(ctx context.Context) (*identificationResult, error) {
			return b.identifyByContactID(ctx, payerRef, groupID)
		}},
		{
			"payer name match",
			payerName != "" && groupID != "",
			func(ctx context.Context) (*identificationResult, error) {
				return b.identifyByPayerName(ctx, payerName, groupID)
			},
		},
	}

	for i, s := range strategies {
		if !s.enabled {
			continue
		}
		result, err := s.run(ctx)
		if err == nil && result != nil {
			logger.WithField("membership_id", result.MembershipID).
				Info(fmt.Sprintf("payment identified via strategy %d: %s", i+1, s.name))
			return b.buildIdentificationResult(result), nil
		}
	}

	logger.Warn("payment could not be identified, routing to unidentified account")
	unidentified := map[string]interface{}{
		"strategy": "unidentified",
		"reason":   "no matching member found across all identification strategies",
	}
	if productID != "" {
		unidentified["unidentified_account"] = constants.ProductUnidentifiedAccount(productID)
	}
	return unidentified, nil
}

// identifyByMembershipID implements Strategy 1.
func (b *paymentRoutingBusiness) identifyByMembershipID(
	ctx context.Context,
	ref string,
) (*identificationResult, error) {
	mem, err := b.memRepo.GetByID(ctx, ref)
	if err != nil {
		return nil, err
	}
	if mem == nil || mem.GetID() == "" {
		return nil, fmt.Errorf("membership not found for reference %s", ref)
	}
	if mem.State == int32(groupmodels.GroupStateDeleted) || mem.State == int32(groupmodels.GroupStateShutdown) {
		return nil, fmt.Errorf("membership %s is not active", ref)
	}
	return &identificationResult{
		Strategy:     "direct_membership_id",
		MembershipID: mem.GetID(),
		GroupID:      mem.GroupID,
		ProfileID:    mem.ProfileID,
	}, nil
}

// identifyByProfileID implements Strategy 2.
func (b *paymentRoutingBusiness) identifyByProfileID(
	ctx context.Context,
	profileID string,
) (*identificationResult, error) {
	members, err := b.memRepo.GetByProfileID(ctx, profileID)
	if err != nil {
		return nil, err
	}

	active := filterActiveMemberships(members)
	if len(active) != 1 {
		return nil, fmt.Errorf("expected exactly 1 active membership for profile %s, got %d", profileID, len(active))
	}

	mem := active[0]
	return &identificationResult{
		Strategy:     "profile_id",
		MembershipID: mem.GetID(),
		GroupID:      mem.GroupID,
		ProfileID:    mem.ProfileID,
	}, nil
}

// identifyByFilteredMembership implements Strategy 3.
func (b *paymentRoutingBusiness) identifyByFilteredMembership(
	ctx context.Context,
	profileID, scopeGroupID string,
) (*identificationResult, error) {
	members, err := b.memRepo.GetByProfileID(ctx, profileID)
	if err != nil {
		return nil, err
	}

	// Filter to MembershipTypeMember only (type 3), excluding registra, agent, funder.
	var filtered []*groupmodels.Membership
	for _, m := range members {
		if m.MembershipType != int32(groupmodels.MembershipTypeMember) {
			continue
		}
		if m.State == int32(groupmodels.GroupStateDeleted) || m.State == int32(groupmodels.GroupStateShutdown) {
			continue
		}
		// If a group scope is provided, further restrict to that group.
		if scopeGroupID != "" && m.GroupID != scopeGroupID {
			continue
		}
		filtered = append(filtered, m)
	}

	if len(filtered) != 1 {
		return nil, fmt.Errorf(
			"filtered membership count for profile %s is %d, need exactly 1",
			profileID,
			len(filtered),
		)
	}

	mem := filtered[0]
	return &identificationResult{
		Strategy:     "filtered_membership_type",
		MembershipID: mem.GetID(),
		GroupID:      mem.GroupID,
		ProfileID:    mem.ProfileID,
	}, nil
}

// identifyByContactID implements Strategy 4.
func (b *paymentRoutingBusiness) identifyByContactID(
	ctx context.Context,
	contactRef, scopeGroupID string,
) (*identificationResult, error) {
	// When a group_id scope is available, search within the group's memberships for a
	// contact_id match. This avoids a broad cross-group search.
	if scopeGroupID != "" {
		groupMembers, err := b.memRepo.GetByGroupID(ctx, scopeGroupID)
		if err != nil {
			return nil, fmt.Errorf("failed to get group members: %w", err)
		}

		var matched []*groupmodels.Membership
		for _, m := range groupMembers {
			if m.ContactID == contactRef && m.State != int32(groupmodels.GroupStateDeleted) {
				matched = append(matched, m)
			}
		}

		if len(matched) == 1 {
			mem := matched[0]
			return &identificationResult{
				Strategy:     "contact_id",
				MembershipID: mem.GetID(),
				GroupID:      mem.GroupID,
				ProfileID:    mem.ProfileID,
			}, nil
		}
	}

	// Without a group scope, fall back to a profile-based contact lookup.
	// Use the contactRef as a profile lookup -- the contact may be stored as a profile reference.
	members, err := b.memRepo.GetByProfileID(ctx, contactRef)
	if err != nil {
		return nil, err
	}

	active := filterActiveMemberships(members)
	if len(active) == 1 {
		mem := active[0]
		return &identificationResult{
			Strategy:     "contact_id",
			MembershipID: mem.GetID(),
			GroupID:      mem.GroupID,
			ProfileID:    mem.ProfileID,
		}, nil
	}

	return nil, fmt.Errorf("contact ID match failed for ref %s", contactRef)
}

// identifyByPayerName implements Strategy 5.
func (b *paymentRoutingBusiness) identifyByPayerName(
	ctx context.Context,
	payerName, groupID string,
) (*identificationResult, error) {
	groupMembers, err := b.memRepo.GetByGroupID(ctx, groupID)
	if err != nil {
		return nil, fmt.Errorf("failed to get group members for name match: %w", err)
	}

	normalizedPayer := normalizeNameForComparison(payerName)
	if normalizedPayer == "" {
		return nil, errors.New("payer name is empty after normalization")
	}

	var matched []*groupmodels.Membership
	for _, m := range groupMembers {
		if m.State == int32(groupmodels.GroupStateDeleted) || m.State == int32(groupmodels.GroupStateShutdown) {
			continue
		}
		normalizedMember := normalizeNameForComparison(m.Name)
		if normalizedMember == "" {
			continue
		}
		// Check for exact normalized match or containment in either direction.
		if normalizedMember == normalizedPayer ||
			strings.Contains(normalizedMember, normalizedPayer) ||
			strings.Contains(normalizedPayer, normalizedMember) {
			matched = append(matched, m)
		}
	}

	if len(matched) != 1 {
		return nil, fmt.Errorf("payer name match yielded %d results for '%s', need exactly 1", len(matched), payerName)
	}

	mem := matched[0]
	return &identificationResult{
		Strategy:     "payer_name",
		MembershipID: mem.GetID(),
		GroupID:      mem.GroupID,
		ProfileID:    mem.ProfileID,
	}, nil
}

// buildIdentificationResult converts an identificationResult into the map returned by the interface.
func (b *paymentRoutingBusiness) buildIdentificationResult(r *identificationResult) map[string]interface{} {
	return map[string]interface{}{
		"strategy":      r.Strategy,
		"membership_id": r.MembershipID,
		"group_id":      r.GroupID,
		"profile_id":    r.ProfileID,
	}
}

// allocationBucket defines a priority bucket for payment allocation.
type allocationBucket struct {
	name      string
	orderType int
	filter    func(o *models.Obligation) bool
}

// AllocatePayment allocates an identified payment to obligations in priority order:
//  1. Overdue loan repayments (oldest first)
//  2. Current loan interest repayment
//  3. Current loan insurance repayment
//  4. Outstanding penalties
//  5. Periodic savings obligation
//  6. Registration fee (if unpaid, one-time)
//  7. Service fee
//
// Any remaining amount after all obligations are satisfied stays in the member's suspense account.
func (b *paymentRoutingBusiness) AllocatePayment(
	ctx context.Context,
	paymentID string,
) (map[string]interface{}, error) {
	logger := util.Log(ctx).WithField("method", "PaymentRoutingBusiness.AllocatePayment")

	// Retrieve the incoming payment.
	payment, err := b.ipRepo.GetByID(ctx, paymentID)
	if err != nil {
		return nil, fmt.Errorf("payment %s not found: %w", paymentID, err)
	}

	// Idempotency + concurrency guard: only allocate payments in initial state.
	if payment.State != int32(constants.StateJustCreated) && payment.State != int32(constants.StateCheckCreated) {
		// Already being processed or completed -- return current state.
		return map[string]interface{}{
			"payment_id": paymentID,
			"status":     "already_processed",
			"state":      payment.State,
		}, nil
	}

	// Claim the payment for processing to prevent concurrent allocation.
	payment.State = int32(constants.StateCheckCreated)
	if err = b.eventsMan.Emit(ctx, events.IncomingPaymentSaveEvent, payment); err != nil {
		return nil, fmt.Errorf("could not claim payment for allocation: %w", err)
	}

	if payment.Amount <= 0 {
		return nil, fmt.Errorf("payment %s has non-positive amount %d", paymentID, payment.Amount)
	}

	membershipID := payment.OwnerID
	if membershipID == "" {
		return nil, fmt.Errorf("payment %s has no owner (membership) assigned -- run identification first", paymentID)
	}

	// Retrieve all obligations for this member.
	obligations, err := b.obRepo.GetByMembershipID(ctx, membershipID)
	if err != nil {
		logger.WithError(err).Warn("could not retrieve obligations for member")
		obligations = nil
	}

	// Sort obligations by deadline (oldest first) so overdue obligations are allocated first
	// within each bucket.
	sort.Slice(obligations, func(i, j int) bool {
		di := obligationDeadline(obligations[i])
		dj := obligationDeadline(obligations[j])
		return di.Before(dj)
	})

	buckets := buildAllocationBuckets()
	remainingAmount, allocations := b.runAllocationBuckets(
		ctx, logger, buckets, obligations, payment, paymentID, membershipID,
	)

	allocatedAmount := payment.Amount - remainingAmount
	paymentState := resolvePaymentState(remainingAmount, allocatedAmount)

	// Update the incoming payment state.
	payment.State = paymentState
	if emitErr := b.eventsMan.Emit(ctx, events.IncomingPaymentSaveEvent, payment); emitErr != nil {
		logger.WithError(emitErr).Error("failed to update payment state after allocation")
	}

	return map[string]interface{}{
		"payment_id":       paymentID,
		"membership_id":    membershipID,
		"total_amount":     payment.Amount,
		"allocated_amount": allocatedAmount,
		"remaining_amount": remainingAmount,
		"allocations":      allocations,
		"payment_state":    paymentState,
	}, nil
}

// buildAllocationBuckets returns the priority-ordered allocation buckets.
func buildAllocationBuckets() []allocationBucket {
	active := int32(constants.StateActive)
	return []allocationBucket{
		{name: "overdue_loan_interest", orderType: constants.TransferTypeLoanInterestRepayment,
			filter: obligationMatcher(active, "loan_interest", true, 0)},
		{name: "overdue_loan_fees", orderType: constants.TransferTypeLoanInsuranceRepayment,
			filter: obligationMatcher(active, "loan_fees", true, 0)},
		{name: "overdue_loan_principal", orderType: constants.TransferTypeLoanRepayment,
			filter: obligationMatcher(active, "loan_principal", true, 0)},
		{name: "loan_interest_repayment", orderType: constants.TransferTypeLoanInterestRepayment,
			filter: obligationMatcherCurrent(active, "loan_interest")},
		{name: "loan_fees_repayment", orderType: constants.TransferTypeLoanInsuranceRepayment,
			filter: obligationMatcherCurrent(active, "loan_fees")},
		{name: "loan_principal_repayment", orderType: constants.TransferTypeLoanRepayment,
			filter: obligationMatcherCurrent(active, "loan_principal")},
		{name: "penalty", orderType: constants.TransferTypePenalty,
			filter: func(o *models.Obligation) bool {
				return o.State == active && o.CauseType == "penalty"
			}},
		{name: "periodic_saving", orderType: constants.TransferTypePeriodicSaving,
			filter: func(o *models.Obligation) bool {
				return o.State == active && o.ObligationType == int32(models.ObligationTypePeriodic) &&
					o.CauseType == "saving"
			}},
		{name: "registration_fee", orderType: constants.TransferTypeRegistrationFee,
			filter: func(o *models.Obligation) bool {
				return o.State == active && o.ObligationType == int32(models.ObligationTypeOneTime) &&
					o.CauseType == "registration_fee"
			}},
		{name: "service_fee", orderType: constants.TransferTypeServiceFee,
			filter: func(o *models.Obligation) bool {
				return o.State == active && o.CauseType == "service_fee"
			}},
	}
}

// obligationMatcher returns a filter for active obligations of a given cause type that are overdue.
func obligationMatcher(activeState int32, causeType string, overdue bool, _ int) func(*models.Obligation) bool {
	return func(o *models.Obligation) bool {
		return o.State == activeState && o.CauseType == causeType && isOverdue(o) == overdue
	}
}

// obligationMatcherCurrent returns a filter for active, non-overdue obligations of a given cause type.
func obligationMatcherCurrent(activeState int32, causeType string) func(*models.Obligation) bool {
	return func(o *models.Obligation) bool {
		return o.State == activeState && o.CauseType == causeType && !isOverdue(o)
	}
}

// runAllocationBuckets walks priority buckets and allocates funds from the payment.
// Returns the remaining amount and all allocation records.
func (b *paymentRoutingBusiness) runAllocationBuckets(
	ctx context.Context,
	logger *util.LogEntry,
	buckets []allocationBucket,
	obligations []*models.Obligation,
	payment *models.IncomingPayment,
	paymentID, membershipID string,
) (int64, []map[string]interface{}) {
	remainingAmount := payment.Amount
	var allocations []map[string]interface{}

	for _, bkt := range buckets {
		if remainingAmount <= 0 {
			break
		}
		var allocated int64
		allocated, allocations = b.allocateBucket(
			ctx, logger, bkt, obligations, payment,
			paymentID, membershipID, remainingAmount, allocations,
		)
		remainingAmount -= allocated
	}

	return remainingAmount, allocations
}

// resolvePaymentState determines the final payment state based on allocation outcome.
func resolvePaymentState(remaining, allocated int64) int32 {
	switch {
	case remaining == 0:
		return int32(constants.StateInactive)
	case allocated > 0:
		return int32(constants.StateActive)
	default:
		return int32(constants.StateCheckCreated)
	}
}

// allocateBucket processes a single priority bucket against obligations, creating
// transfer orders and updating obligation state. Returns total allocated amount
// and the updated allocations slice.
func (b *paymentRoutingBusiness) allocateBucket(
	ctx context.Context,
	logger *util.LogEntry,
	bkt allocationBucket,
	obligations []*models.Obligation,
	payment *models.IncomingPayment,
	paymentID, membershipID string,
	remainingAmount int64,
	allocations []map[string]interface{},
) (int64, []map[string]interface{}) {
	var totalAllocated int64

	for _, obl := range obligations {
		if remainingAmount <= 0 {
			break
		}
		if !bkt.filter(obl) || obl.Amount <= 0 {
			continue
		}

		allocAmount := obl.Amount
		if allocAmount > remainingAmount {
			allocAmount = remainingAmount
		}

		debitAccount := constants.MemberSuspenseAccount(membershipID)
		creditAccount := b.creditAccountForBucket(bkt.name, membershipID, obl)

		to := &models.TransferOrder{
			DebitAccountRef:  debitAccount,
			CreditAccountRef: creditAccount,
			Amount:           allocAmount,
			Currency:         payment.Currency,
			OrderType:        constants.SafeInt32FromInt(bkt.orderType),
			Reference:        fmt.Sprintf("payment:%s:obligation:%s", paymentID, obl.GetID()),
			Description:      fmt.Sprintf("Auto-allocation of %s from payment %s", bkt.name, paymentID),
			State:            int32(constants.StateJustCreated),
		}
		to.GenID(ctx)

		if emitErr := b.eventsMan.Emit(ctx, events.TransferOrderSaveEvent, to); emitErr != nil {
			logger.WithError(emitErr).WithField("bucket", bkt.name).
				Error("failed to create transfer order for allocation")
			continue
		}

		if allocAmount < obl.Amount {
			obl.Amount -= allocAmount
			if emitErr := b.eventsMan.Emit(ctx, events.ObligationSaveEvent, obl); emitErr != nil {
				logger.WithError(emitErr).WithField("obligation_id", obl.GetID()).
					Error("could not update partial obligation")
			}
		} else {
			obl.State = int32(constants.StateInactive)
			if emitErr := b.eventsMan.Emit(ctx, events.ObligationSaveEvent, obl); emitErr != nil {
				logger.WithError(emitErr).WithField("obligation_id", obl.GetID()).
					Error("could not deactivate obligation")
			}
		}

		remainingAmount -= allocAmount
		totalAllocated += allocAmount
		allocations = append(allocations, map[string]interface{}{
			"bucket":            bkt.name,
			"obligation_id":     obl.GetID(),
			"transfer_order_id": to.GetID(),
			"amount":            allocAmount,
			"partial":           allocAmount < obl.Amount,
		})

		logger.WithField("bucket", bkt.name).
			WithField("obligation_id", obl.GetID()).
			WithField("amount", allocAmount).
			Info("allocated payment to obligation")
	}

	return totalAllocated, allocations
}

// creditAccountForBucket returns the appropriate credit account reference for a given
// allocation bucket and obligation. Interest, fees and penalties are routed to
// group-level income accounts while principal goes to the member's loans account.
func (b *paymentRoutingBusiness) creditAccountForBucket(bucket, membershipID string, obl *models.Obligation) string {
	groupID := "" // derive from obligation properties
	if obl.Properties != nil {
		if gid, ok := obl.Properties["group_id"]; ok {
			groupID, _ = gid.(string)
		}
	}

	switch bucket {
	case "overdue_loan_interest", "loan_interest_repayment":
		return constants.GroupInterestIncomeAccount(groupID)
	case "overdue_loan_fees", "loan_fees_repayment":
		return constants.GroupServiceFeeAccount(groupID)
	case "penalty":
		return constants.GroupPenaltyIncomeAccount(groupID)
	case "overdue_loan_principal", "loan_principal_repayment":
		return constants.MemberLoansAccount(membershipID)
	case "periodic_saving":
		return constants.MemberPeriodicSavingsAccount(membershipID)
	case "registration_fee":
		return constants.GroupJoiningFeeAccount(groupID)
	case "service_fee":
		return constants.GroupServiceFeeAccount(groupID)
	default:
		return constants.MemberSuspenseAccount(membershipID)
	}
}

// filterActiveMemberships returns only memberships that are not deleted or shut down.
func filterActiveMemberships(members []*groupmodels.Membership) []*groupmodels.Membership {
	var active []*groupmodels.Membership
	for _, m := range members {
		if m.State == int32(groupmodels.GroupStateDeleted) || m.State == int32(groupmodels.GroupStateShutdown) {
			continue
		}
		active = append(active, m)
	}
	return active
}

// isOverdue returns true when an obligation's deadline has passed.
func isOverdue(o *models.Obligation) bool {
	if o.Deadline == nil {
		return false
	}
	return o.Deadline.Before(time.Now())
}

// obligationDeadline returns the obligation's deadline or a far-future sentinel.
func obligationDeadline(o *models.Obligation) time.Time {
	if o.Deadline != nil {
		return *o.Deadline
	}
	// Obligations without a deadline sort last.
	return time.Date(9999, 12, 31, 23, 59, 59, 0, time.UTC)
}

// normalizeNameForComparison lowercases and collapses whitespace for fuzzy name matching.
func normalizeNameForComparison(name string) string {
	name = strings.ToLower(strings.TrimSpace(name))
	// Collapse consecutive spaces.
	parts := strings.Fields(name)
	return strings.Join(parts, " ")
}

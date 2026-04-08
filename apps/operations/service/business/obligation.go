package business

import (
	"context"
	"fmt"
	"time"

	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	groupmodels "github.com/antinvestor/service-fintech/apps/group/service/models"
	grouprepo "github.com/antinvestor/service-fintech/apps/group/service/repository"
	"github.com/antinvestor/service-fintech/apps/operations/service/events"
	"github.com/antinvestor/service-fintech/apps/operations/service/models"
	"github.com/antinvestor/service-fintech/apps/operations/service/repository"
	"github.com/antinvestor/service-fintech/pkg/constants"
)

// ScheduleEntryInfo carries the info needed to create loan obligations from schedule entries.
type ScheduleEntryInfo struct {
	EntryID      string
	MembershipID string
	GroupID      string
	PeriodID     string
	PrincipalDue int64
	InterestDue  int64
	FeesDue      int64
	Currency     string
	DueDate      *time.Time
}

type obligationBusiness struct {
	eventsMan fevents.Manager
	obRepo    repository.ObligationRepository
	memRepo   grouprepo.MembershipRepository
	grpRepo   grouprepo.CustomerGroupRepository
	perRepo   grouprepo.PeriodRepository
}

func NewObligationBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	obRepo repository.ObligationRepository,
	memRepo grouprepo.MembershipRepository,
	grpRepo grouprepo.CustomerGroupRepository,
	perRepo grouprepo.PeriodRepository,
) ObligationBusiness {
	return &obligationBusiness{
		eventsMan: eventsMan,
		obRepo:    obRepo,
		memRepo:   memRepo,
		grpRepo:   grpRepo,
		perRepo:   perRepo,
	}
}

// CalculateForGroup computes financial obligations for all active members of
// the given group in the current period. For each member, it creates obligation
// records for periodic savings contributions, loan repayments, and any other
// dues based on the group's configuration.
func (b *obligationBusiness) CalculateForGroup(ctx context.Context, groupID string) error {
	logger := util.Log(ctx).WithField("method", "ObligationBusiness.CalculateForGroup").
		WithField("group_id", groupID)

	// Load the group to get saving amount and currency
	group, err := b.grpRepo.GetByID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("group not found: %w", err)
	}

	if group.State != int32(constants.StateActive) {
		logger.Warn("group is not active, skipping obligation calculation")
		return nil
	}

	// Get the current period for the group
	period, err := b.perRepo.GetCurrentByGroupID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("current period not found for group %s: %w", groupID, err)
	}

	logger = logger.WithField("period_id", period.GetID())
	logger.Info("calculating obligations for group")

	// Get all active memberships
	memberships, err := b.memRepo.GetByGroupID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("could not load memberships for group %s: %w", groupID, err)
	}

	if len(memberships) == 0 {
		logger.Warn("no active memberships found, skipping")
		return nil
	}

	// Check for existing obligations in this period to avoid duplicates
	existingObs, err := b.obRepo.GetByPeriodID(ctx, period.GetID())
	if err != nil {
		return fmt.Errorf("could not check existing obligations: %w", err)
	}

	existingByMember := make(map[string]map[string]bool) // memberID -> causeType -> exists
	for _, ob := range existingObs {
		if _, ok := existingByMember[ob.MembershipID]; !ok {
			existingByMember[ob.MembershipID] = make(map[string]bool)
		}
		existingByMember[ob.MembershipID][ob.CauseType] = true
	}

	var created int
	for _, mem := range memberships {
		memberID := mem.GetID()

		// Skip members that are not in a regular member role (agents, registrars)
		if mem.MembershipType != int32(groupmodels.MembershipTypeMember) {
			continue
		}

		// Periodic savings obligation
		if !existingByMember[memberID]["periodic_saving"] && group.SavingAmount > 0 {
			ob := &models.Obligation{
				MembershipID:   memberID,
				CauseType:      "periodic_saving",
				CauseID:        groupID,
				ObligationType: int32(models.ObligationTypePeriodic),
				PeriodID:       period.GetID(),
				Amount:         group.SavingAmount,
				Currency:       group.Currency,
				Deadline:       period.EndDate,
				Description:    fmt.Sprintf("Periodic savings for period %d", period.Position),
				State:          int32(constants.StateActive),
			}
			ob.GenID(ctx)
			ob.CopyPartitionInfo(&mem.BaseModel)

			if emitErr := b.eventsMan.Emit(ctx, events.ObligationSaveEvent, ob); emitErr != nil {
				logger.WithError(emitErr).
					WithField("member_id", memberID).
					Error("could not create savings obligation")
				continue
			}
			created++
		}

		// NOTE: Loan repayment obligations are created separately by
		// CreateLoanObligations when amortization schedule entries become due.
	}

	logger.WithField("obligations_created", created).
		WithField("members_processed", len(memberships)).
		Info("obligation calculation completed")

	return nil
}

// CreateLoanObligations creates obligations for due schedule entries.
// Called periodically (e.g. daily) or when a loan is disbursed and the schedule is generated.
// Each schedule entry produces up to three obligations: principal, interest, and fees.
func (b *obligationBusiness) CreateLoanObligations(
	ctx context.Context,
	loanAccountID string,
	entries []ScheduleEntryInfo,
) error {
	logger := util.Log(ctx).WithField("method", "ObligationBusiness.CreateLoanObligations").
		WithField("loan_account_id", loanAccountID)

	var created int
	for _, entry := range entries {
		// Check if obligations already exist for this entry to avoid duplicates
		existingObs, err := b.obRepo.GetByCauseID(ctx, entry.EntryID)
		if err == nil && len(existingObs) > 0 {
			logger.WithField("entry_id", entry.EntryID).
				Debug("obligations already exist for this schedule entry, skipping")
			continue
		}

		// Build properties map carrying the group_id so that downstream routing
		// (e.g. creditAccountForBucket) can direct funds to the correct group account.
		oblProps := data.JSONMap{"group_id": entry.GroupID}

		// Create principal obligation
		if entry.PrincipalDue > 0 {
			ob := &models.Obligation{
				MembershipID:   entry.MembershipID,
				CauseType:      "loan_principal",
				CauseID:        entry.EntryID,
				ObligationType: int32(models.ObligationTypePeriodic),
				PeriodID:       entry.PeriodID,
				Amount:         entry.PrincipalDue,
				Currency:       entry.Currency,
				Deadline:       entry.DueDate,
				Description:    fmt.Sprintf("Loan principal repayment for entry %s", entry.EntryID),
				State:          int32(constants.StateActive),
				Properties:     oblProps,
			}
			ob.GenID(ctx)

			if emitErr := b.eventsMan.Emit(ctx, events.ObligationSaveEvent, ob); emitErr != nil {
				logger.WithError(emitErr).
					WithField("entry_id", entry.EntryID).
					Error("could not create principal obligation")
				continue
			}
			created++
		}

		// Create interest obligation
		if entry.InterestDue > 0 {
			ob := &models.Obligation{
				MembershipID:   entry.MembershipID,
				CauseType:      "loan_interest",
				CauseID:        entry.EntryID,
				ObligationType: int32(models.ObligationTypePeriodic),
				PeriodID:       entry.PeriodID,
				Amount:         entry.InterestDue,
				Currency:       entry.Currency,
				Deadline:       entry.DueDate,
				Description:    fmt.Sprintf("Loan interest repayment for entry %s", entry.EntryID),
				State:          int32(constants.StateActive),
				Properties:     oblProps,
			}
			ob.GenID(ctx)

			if emitErr := b.eventsMan.Emit(ctx, events.ObligationSaveEvent, ob); emitErr != nil {
				logger.WithError(emitErr).
					WithField("entry_id", entry.EntryID).
					Error("could not create interest obligation")
				continue
			}
			created++
		}

		// Create fees obligation (insurance + processing combined)
		if entry.FeesDue > 0 {
			ob := &models.Obligation{
				MembershipID:   entry.MembershipID,
				CauseType:      "loan_fees",
				CauseID:        entry.EntryID,
				ObligationType: int32(models.ObligationTypePeriodic),
				PeriodID:       entry.PeriodID,
				Amount:         entry.FeesDue,
				Currency:       entry.Currency,
				Deadline:       entry.DueDate,
				Description:    fmt.Sprintf("Loan fees for entry %s", entry.EntryID),
				State:          int32(constants.StateActive),
				Properties:     oblProps,
			}
			ob.GenID(ctx)

			if emitErr := b.eventsMan.Emit(ctx, events.ObligationSaveEvent, ob); emitErr != nil {
				logger.WithError(emitErr).
					WithField("entry_id", entry.EntryID).
					Error("could not create fees obligation")
				continue
			}
			created++
		}
	}

	logger.WithField("obligations_created", created).
		WithField("entries_processed", len(entries)).
		Info("loan obligation creation completed")

	return nil
}

// GetStatus returns the current status of a specific obligation, including
// how much has been paid against it and whether it is fulfilled.
func (b *obligationBusiness) GetStatus(ctx context.Context, obligationID string) (map[string]interface{}, error) {
	logger := util.Log(ctx).WithField("method", "ObligationBusiness.GetStatus").
		WithField("obligation_id", obligationID)

	ob, err := b.obRepo.GetByID(ctx, obligationID)
	if err != nil {
		return nil, fmt.Errorf("obligation not found: %w", err)
	}

	logger.Info("fetching obligation status")

	fulfilled := ob.State == int32(constants.StateInactive)

	status := map[string]interface{}{
		"id":              ob.GetID(),
		"membership_id":   ob.MembershipID,
		"cause_type":      ob.CauseType,
		"cause_id":        ob.CauseID,
		"obligation_type": ob.ObligationType,
		"period_id":       ob.PeriodID,
		"amount":          ob.Amount,
		"currency":        ob.Currency,
		"state":           ob.State,
		"fulfilled":       fulfilled,
		"description":     ob.Description,
	}

	if ob.Deadline != nil {
		status["deadline"] = ob.Deadline.Format("2006-01-02T15:04:05Z")
	}

	if ob.NotificationID != "" {
		status["notification_id"] = ob.NotificationID
	}

	if ob.Properties != nil {
		if paidAmount, ok := ob.Properties["paid_amount"]; ok {
			status["paid_amount"] = paidAmount
		}
		if paidAt, ok := ob.Properties["paid_at"]; ok {
			status["paid_at"] = paidAt
		}
	}

	return status, nil
}

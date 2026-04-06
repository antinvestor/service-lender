package business

import (
	"context"
	"fmt"
	"strconv"
	"time"

	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/loans/service/events"
	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
	opsevents "github.com/antinvestor/service-lender/apps/operations/service/events"
	opsmodels "github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/pkg/constants"
)

type RepaymentBusiness interface {
	Record(ctx context.Context, req *loansv1.RepaymentRecordRequest) (*loansv1.RepaymentObject, error)
	Get(ctx context.Context, id string) (*loansv1.RepaymentObject, error)
	Search(
		ctx context.Context,
		req *loansv1.RepaymentSearchRequest,
		consumer func(ctx context.Context, batch []*loansv1.RepaymentObject) error,
	) error
}

type repaymentBusiness struct {
	eventsMan         fevents.Manager
	loanAccountRepo   repository.LoanAccountRepository
	repaymentRepo     repository.RepaymentRepository
	scheduleRepo      repository.RepaymentScheduleRepository
	scheduleEntryRepo repository.ScheduleEntryRepository
	loanBalanceRepo   repository.LoanBalanceRepository
	notifier          *LoanNotifier
}

func NewRepaymentBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	loanAccountRepo repository.LoanAccountRepository,
	repaymentRepo repository.RepaymentRepository,
	scheduleRepo repository.RepaymentScheduleRepository,
	scheduleEntryRepo repository.ScheduleEntryRepository,
	loanBalanceRepo repository.LoanBalanceRepository,
	notifier *LoanNotifier,
) RepaymentBusiness {
	return &repaymentBusiness{
		eventsMan:         eventsMan,
		loanAccountRepo:   loanAccountRepo,
		repaymentRepo:     repaymentRepo,
		scheduleRepo:      scheduleRepo,
		scheduleEntryRepo: scheduleEntryRepo,
		loanBalanceRepo:   loanBalanceRepo,
		notifier:          notifier,
	}
}

func (b *repaymentBusiness) Record(
	ctx context.Context,
	req *loansv1.RepaymentRecordRequest,
) (*loansv1.RepaymentObject, error) {
	logger := util.Log(ctx).WithField("method", "RepaymentBusiness.Record")

	// Idempotency check
	if req.GetIdempotencyKey() != "" {
		existing, err := b.repaymentRepo.GetByIdempotencyKey(ctx, req.GetIdempotencyKey())
		if err == nil && existing != nil {
			return existing.ToAPI(), nil
		}
	}

	// Validate loan account exists
	la, err := b.loanAccountRepo.GetByID(ctx, req.GetLoanAccountId())
	if err != nil {
		return nil, ErrLoanAccountNotFound
	}

	// Only accept repayments on active, delinquent, or restructured loans
	if la.Status != int32(loansv1.LoanStatus_LOAN_STATUS_ACTIVE) &&
		la.Status != int32(loansv1.LoanStatus_LOAN_STATUS_DELINQUENT) &&
		la.Status != int32(loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED) {
		return nil, fmt.Errorf("loan is not in a repayable state (status=%d)", la.Status)
	}

	receivedAt := models.StringToTime(req.GetReceivedAt())
	if receivedAt == nil {
		now := time.Now().UTC()
		receivedAt = &now
	}

	amount, repCurrencyCode := models.MoneyToMinorUnits(req.GetAmount())
	_ = repCurrencyCode

	if amount <= 0 {
		return nil, fmt.Errorf("repayment amount must be positive, got %d", amount)
	}

	// Load balance once — used for both penalty allocation and balance update.
	// This avoids a race condition where two concurrent repayments could read
	// different balance states between the waterfall and the update.
	balance, balErr := b.loanBalanceRepo.GetByLoanAccountID(ctx, req.GetLoanAccountId())

	// Waterfall allocation: penalties (from balance) -> interest -> fees -> principal (from schedule)
	alloc := b.waterfallAllocate(ctx, logger, req.GetLoanAccountId(), amount, balance)

	r := &models.Repayment{
		LoanAccountID:    req.GetLoanAccountId(),
		Amount:           amount,
		CurrencyCode:     la.CurrencyCode,
		Status:           int32(alloc.status),
		PaymentReference: req.GetPaymentReference(),
		ReceivedAt:       receivedAt,
		Channel:          req.GetChannel(),
		PayerReference:   req.GetPayerReference(),
		PrincipalApplied: alloc.principalApplied,
		InterestApplied:  alloc.interestApplied,
		FeesApplied:      alloc.feesApplied,
		PenaltiesApplied: alloc.penaltiesApplied,
		ExcessAmount:     alloc.excessAmount,
		IdempotencyKey:   req.GetIdempotencyKey(),
	}
	r.GenID(ctx)

	err = b.eventsMan.Emit(ctx, events.RepaymentSaveEvent, r)
	if err != nil {
		logger.WithError(err).Error("could not emit repayment save event")
		return nil, err
	}

	// Emit transfer orders for each allocation component (ledger double-entry)
	b.emitRepaymentTransferOrders(ctx, logger, la, r, alloc)

	// Update loan balance and handle payoff detection
	if balErr == nil && balance != nil {
		b.applyRepaymentToBalance(ctx, logger, la, balance, amount, alloc)
	}

	return r.ToAPI(), nil
}

// applyRepaymentToBalance updates the loan balance after a repayment, emits the
// updated balance, checks for full payoff, and sends notifications.
func (b *repaymentBusiness) applyRepaymentToBalance(
	ctx context.Context,
	logger *util.LogEntry,
	la *models.LoanAccount,
	balance *models.LoanBalance,
	amount int64,
	alloc waterfallResult,
) {
	balance.PrincipalOutstanding -= alloc.principalApplied
	if balance.PrincipalOutstanding < 0 {
		balance.PrincipalOutstanding = 0
	}
	balance.InterestAccrued -= alloc.interestApplied
	if balance.InterestAccrued < 0 {
		balance.InterestAccrued = 0
	}
	balance.FeesOutstanding -= alloc.feesApplied
	if balance.FeesOutstanding < 0 {
		balance.FeesOutstanding = 0
	}
	balance.PenaltiesOutstanding -= alloc.penaltiesApplied
	if balance.PenaltiesOutstanding < 0 {
		balance.PenaltiesOutstanding = 0
	}
	balance.TotalPaid += alloc.principalApplied + alloc.interestApplied +
		alloc.feesApplied + alloc.penaltiesApplied
	balance.TotalOutstanding = balance.PrincipalOutstanding + balance.InterestAccrued +
		balance.FeesOutstanding + balance.PenaltiesOutstanding
	now := time.Now().UTC()
	balance.LastCalculatedAt = &now
	if emitErr := b.eventsMan.Emit(ctx, events.LoanBalanceSaveEvent, balance); emitErr != nil {
		logger.WithError(emitErr).Error("could not update loan balance after repayment")
	}

	// Notify client about repayment received
	if b.notifier != nil {
		b.notifier.NotifyRepaymentReceived(ctx, la.ClientID, "",
			models.MinorUnitsToString(amount),
			la.CurrencyCode,
			models.MinorUnitsToString(balance.TotalOutstanding),
		)
	}

	// Check if loan is fully paid off
	if balance.TotalOutstanding <= 0 {
		la.Status = int32(loansv1.LoanStatus_LOAN_STATUS_PAID_OFF)
		if emitErr := b.eventsMan.Emit(ctx, events.LoanAccountSaveEvent, la); emitErr != nil {
			logger.WithError(emitErr).Error("could not transition loan to PAID_OFF")
		} else {
			logger.WithField("loan_id", la.GetID()).Info("loan fully paid off")
		}

		if b.notifier != nil {
			b.notifier.NotifyLoanFullyPaid(ctx, la.ClientID, "")
		}
	}
}

// waterfallResult holds the outcome of waterfall allocation against schedule entries.
type waterfallResult struct {
	principalApplied int64
	interestApplied  int64
	feesApplied      int64
	penaltiesApplied int64
	excessAmount     int64
	status           loansv1.RepaymentStatus
}

// emitRepaymentTransferOrders creates transfer orders for each allocation
// component of a repayment. This ensures all money movements are captured in
// the ledger via double-entry accounting.
func (b *repaymentBusiness) emitRepaymentTransferOrders(
	ctx context.Context,
	logger *util.LogEntry,
	la *models.LoanAccount,
	repayment *models.Repayment,
	alloc waterfallResult,
) {
	repID := repayment.GetID()
	memberAccount := constants.MemberLoansAccount(la.ClientID)

	// Transfer order for principal repayment
	if alloc.principalApplied > 0 {
		b.emitTransferOrder(ctx, logger,
			memberAccount, la.LedgerAssetAccountID,
			alloc.principalApplied, la.CurrencyCode,
			constants.TransferTypeLoanRepayment,
			fmt.Sprintf("repayment:%s:principal", repID),
			"Principal repayment",
		)
	}

	// Transfer order for interest repayment
	if alloc.interestApplied > 0 {
		b.emitTransferOrder(ctx, logger,
			memberAccount, la.LedgerInterestIncomeAccountID,
			alloc.interestApplied, la.CurrencyCode,
			constants.TransferTypeLoanInterestRepayment,
			fmt.Sprintf("repayment:%s:interest", repID),
			"Interest repayment",
		)
	}

	// Transfer order for fee repayment (insurance + processing)
	if alloc.feesApplied > 0 {
		b.emitTransferOrder(ctx, logger,
			memberAccount, la.LedgerFeeIncomeAccountID,
			alloc.feesApplied, la.CurrencyCode,
			constants.TransferTypeLoanInsuranceRepayment,
			fmt.Sprintf("repayment:%s:fees", repID),
			"Fee repayment",
		)
	}

	// Transfer order for penalty repayment
	if alloc.penaltiesApplied > 0 {
		b.emitTransferOrder(ctx, logger,
			memberAccount, la.LedgerPenaltyIncomeAccountID,
			alloc.penaltiesApplied, la.CurrencyCode,
			constants.TransferTypePenaltyCancel,
			fmt.Sprintf("repayment:%s:penalties", repID),
			"Penalty repayment",
		)
	}
}

// emitTransferOrder creates and emits a single transfer order.
func (b *repaymentBusiness) emitTransferOrder(
	ctx context.Context,
	logger *util.LogEntry,
	debitAccount, creditAccount string,
	amount int64,
	currency string,
	orderType int,
	reference, description string,
) {
	to := &opsmodels.TransferOrder{
		DebitAccountRef:  debitAccount,
		CreditAccountRef: creditAccount,
		Amount:           amount,
		Currency:         currency,
		OrderType:        constants.SafeInt32FromInt(orderType),
		Reference:        reference,
		Description:      description,
		State:            int32(constants.StateJustCreated),
	}
	to.GenID(ctx)

	if emitErr := b.eventsMan.Emit(ctx, opsevents.TransferOrderSaveEvent, to); emitErr != nil {
		logger.WithError(emitErr).
			WithField("reference", reference).
			Error("could not emit transfer order for repayment")
	}
}

// waterfallAllocate applies a payment amount in waterfall order:
// penalties -> interest -> fees -> principal. Penalties are allocated from the
// balance first, then schedule entries are processed for interest, fees,
// and principal. The balance parameter is optional (may be nil).
func (b *repaymentBusiness) waterfallAllocate(
	ctx context.Context,
	logger *util.LogEntry,
	loanAccountID string,
	amount int64,
	balance *models.LoanBalance,
) waterfallResult {
	result := waterfallResult{status: loansv1.RepaymentStatus_REPAYMENT_STATUS_PENDING}
	remaining := amount

	// 1. Allocate to outstanding penalties first (balance-level, not schedule-level)
	if balance != nil && balance.PenaltiesOutstanding > 0 && remaining > 0 {
		penaltyPay := min64(balance.PenaltiesOutstanding, remaining)
		result.penaltiesApplied = penaltyPay
		remaining -= penaltyPay
	}

	// 2. Allocate remaining amount to schedule entries: interest -> fees -> principal
	schedule, schedErr := b.scheduleRepo.GetActivByLoanAccountID(ctx, loanAccountID)
	if schedErr != nil || schedule == nil {
		// No schedule found, fall back to applying full remaining as principal
		result.principalApplied = remaining
		return result
	}

	entries, entryErr := b.scheduleEntryRepo.GetByScheduleID(ctx, schedule.GetID())
	if entryErr != nil {
		result.principalApplied = remaining
		return result
	}

	for _, entry := range entries {
		if remaining <= 0 {
			break
		}
		totalPaid := entry.PrincipalPaid + entry.InterestPaid + entry.FeesPaid
		if totalPaid >= entry.TotalDue {
			continue
		}

		remaining = b.allocateToEntry(ctx, logger, entry, remaining, &result)
	}

	result.excessAmount = remaining
	totalAllocated := result.penaltiesApplied + result.principalApplied +
		result.interestApplied + result.feesApplied
	if remaining == 0 || totalAllocated > 0 {
		result.status = loansv1.RepaymentStatus_REPAYMENT_STATUS_MATCHED
	}

	return result
}

// allocateToEntry applies payment to a single schedule entry in waterfall order
// and emits the updated entry. Returns the remaining amount.
func (b *repaymentBusiness) allocateToEntry(
	ctx context.Context,
	logger *util.LogEntry,
	entry *models.ScheduleEntry,
	remaining int64,
	result *waterfallResult,
) int64 {
	// 1. Interest first
	interestOwed := entry.InterestDue - entry.InterestPaid
	if interestOwed > 0 {
		pay := min64(interestOwed, remaining)
		entry.InterestPaid += pay
		result.interestApplied += pay
		remaining -= pay
	}

	// 2. Fees (insurance + processing)
	feesOwed := entry.FeesDue - entry.FeesPaid
	if feesOwed > 0 {
		pay := min64(feesOwed, remaining)
		entry.FeesPaid += pay
		result.feesApplied += pay
		remaining -= pay
	}

	// 3. Principal last
	principalOwed := entry.PrincipalDue - entry.PrincipalPaid
	if principalOwed > 0 {
		pay := min64(principalOwed, remaining)
		entry.PrincipalPaid += pay
		result.principalApplied += pay
		remaining -= pay
	}

	// Update entry status
	entryTotalPaid := entry.PrincipalPaid + entry.InterestPaid + entry.FeesPaid
	switch {
	case entryTotalPaid >= entry.TotalDue:
		entry.Status = int32(loansv1.ScheduleEntryStatus_SCHEDULE_ENTRY_STATUS_PAID)
	case entryTotalPaid > 0:
		entry.Status = int32(loansv1.ScheduleEntryStatus_SCHEDULE_ENTRY_STATUS_PARTIAL)
	}
	entry.TotalPaid = entryTotalPaid
	entry.Outstanding = entry.TotalDue - entryTotalPaid

	if emitErr := b.eventsMan.Emit(ctx, events.ScheduleEntrySaveEvent, entry); emitErr != nil {
		logger.WithField("entry_id", entry.GetID()).
			WithError(emitErr).
			Warn("could not emit schedule entry update")
	}

	return remaining
}

// min64 returns the smaller of two int64 values.
func min64(a, b int64) int64 {
	if a < b {
		return a
	}
	return b
}

func (b *repaymentBusiness) Get(ctx context.Context, id string) (*loansv1.RepaymentObject, error) {
	r, err := b.repaymentRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrRepaymentNotFound
	}
	return r.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *repaymentBusiness) Search(
	ctx context.Context,
	req *loansv1.RepaymentSearchRequest,
	consumer func(ctx context.Context, batch []*loansv1.RepaymentObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "RepaymentBusiness.Search")

	var searchOpts []data.SearchOption

	cursor := req.GetCursor()
	if cursor != nil {
		offset, offsetErr := strconv.Atoi(cursor.GetPage())
		if offsetErr != nil {
			offset = 0
		}
		searchOpts = append(searchOpts, data.WithSearchOffset(offset), data.WithSearchLimit(int(cursor.GetLimit())))
	}

	andQueryVal := map[string]any{}
	if req.GetLoanAccountId() != "" {
		andQueryVal["loan_account_id = ?"] = req.GetLoanAccountId()
	}
	if req.GetStatus() != loansv1.RepaymentStatus_REPAYMENT_STATUS_UNSPECIFIED {
		andQueryVal["status = ?"] = int32(req.GetStatus())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.repaymentRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search repayments")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Repayment) error {
		var apiResults []*loansv1.RepaymentObject
		for _, r := range res {
			apiResults = append(apiResults, r.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

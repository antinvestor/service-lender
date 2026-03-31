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

	// Waterfall allocation against schedule entries
	var principalApplied, interestApplied, feesApplied int64
	var excessAmount int64
	remaining := amount
	status := loansv1.RepaymentStatus_REPAYMENT_STATUS_PENDING

	// Get active schedule and unpaid entries for waterfall allocation
	schedule, schedErr := b.scheduleRepo.GetActivByLoanAccountID(ctx, req.GetLoanAccountId())
	if schedErr == nil && schedule != nil {
		entries, entryErr := b.scheduleEntryRepo.GetByScheduleID(ctx, schedule.GetID())
		if entryErr == nil {
			// Filter to unpaid entries (not fully paid)
			for _, entry := range entries {
				if remaining <= 0 {
					break
				}
				totalPaid := entry.PrincipalPaid + entry.InterestPaid + entry.FeesPaid
				if totalPaid >= entry.TotalDue {
					continue // already fully paid
				}

				// 1. Interest first
				interestOwed := entry.InterestDue - entry.InterestPaid
				if interestOwed > 0 {
					pay := min64(interestOwed, remaining)
					entry.InterestPaid += pay
					interestApplied += pay
					remaining -= pay
				}

				// 2. Fees (insurance + processing)
				feesOwed := entry.FeesDue - entry.FeesPaid
				if feesOwed > 0 {
					pay := min64(feesOwed, remaining)
					entry.FeesPaid += pay
					feesApplied += pay
					remaining -= pay
				}

				// 3. Principal last
				principalOwed := entry.PrincipalDue - entry.PrincipalPaid
				if principalOwed > 0 {
					pay := min64(principalOwed, remaining)
					entry.PrincipalPaid += pay
					principalApplied += pay
					remaining -= pay
				}

				// Update entry status
				entryTotalPaid := entry.PrincipalPaid + entry.InterestPaid + entry.FeesPaid
				if entryTotalPaid >= entry.TotalDue {
					entry.Status = int32(loansv1.ScheduleEntryStatus_SCHEDULE_ENTRY_STATUS_PAID)
				} else if entryTotalPaid > 0 {
					entry.Status = int32(loansv1.ScheduleEntryStatus_SCHEDULE_ENTRY_STATUS_PARTIAL)
				}
				entry.TotalPaid = entryTotalPaid
				entry.Outstanding = entry.TotalDue - entryTotalPaid

				// Emit entry update
				if emitErr := b.eventsMan.Emit(ctx, events.ScheduleEntrySaveEvent, entry); emitErr != nil {
					logger.WithField("entry_id", entry.GetID()).
						WithError(emitErr).
						Warn("could not emit schedule entry update")
				}
			}

			excessAmount = remaining
			if excessAmount == 0 {
				status = loansv1.RepaymentStatus_REPAYMENT_STATUS_MATCHED
			} else if principalApplied+interestApplied+feesApplied > 0 {
				status = loansv1.RepaymentStatus_REPAYMENT_STATUS_MATCHED
			}
		}
	}

	// If no schedule was found, fall back to applying full amount as principal
	if schedule == nil {
		principalApplied = amount
	}

	r := &models.Repayment{
		LoanAccountID:    req.GetLoanAccountId(),
		Amount:           amount,
		CurrencyCode:     la.CurrencyCode,
		Status:           int32(status),
		PaymentReference: req.GetPaymentReference(),
		ReceivedAt:       receivedAt,
		Channel:          req.GetChannel(),
		PayerReference:   req.GetPayerReference(),
		PrincipalApplied: principalApplied,
		InterestApplied:  interestApplied,
		FeesApplied:      feesApplied,
		ExcessAmount:     excessAmount,
		IdempotencyKey:   req.GetIdempotencyKey(),
	}
	r.GenID(ctx)

	err = b.eventsMan.Emit(ctx, events.RepaymentSaveEvent, r)
	if err != nil {
		logger.WithError(err).Error("could not emit repayment save event")
		return nil, err
	}

	// Update loan balance to reflect the repayment
	balance, balErr := b.loanBalanceRepo.GetByLoanAccountID(ctx, req.GetLoanAccountId())
	if balErr == nil && balance != nil {
		balance.PrincipalOutstanding -= principalApplied
		if balance.PrincipalOutstanding < 0 {
			balance.PrincipalOutstanding = 0
		}
		balance.InterestAccrued -= interestApplied
		if balance.InterestAccrued < 0 {
			balance.InterestAccrued = 0
		}
		balance.FeesOutstanding -= feesApplied
		if balance.FeesOutstanding < 0 {
			balance.FeesOutstanding = 0
		}
		balance.TotalPaid += amount - remaining
		balance.TotalOutstanding = balance.PrincipalOutstanding + balance.InterestAccrued + balance.FeesOutstanding + balance.PenaltiesOutstanding
		now := time.Now().UTC()
		balance.LastCalculatedAt = &now
		if emitErr := b.eventsMan.Emit(ctx, events.LoanBalanceSaveEvent, balance); emitErr != nil {
			logger.WithError(emitErr).Error("could not update loan balance after repayment")
		}
	}

	// Notify client about repayment received
	if b.notifier != nil && balance != nil {
		b.notifier.NotifyRepaymentReceived(ctx, la.ClientID, "",
			models.MinorUnitsToString(amount),
			la.CurrencyCode,
			models.MinorUnitsToString(balance.TotalOutstanding),
		)
	}

	// Check if loan is fully paid off
	if balance != nil && balance.TotalOutstanding <= 0 {
		la.Status = int32(loansv1.LoanStatus_LOAN_STATUS_PAID_OFF)
		if emitErr := b.eventsMan.Emit(ctx, events.LoanAccountSaveEvent, la); emitErr != nil {
			logger.WithError(emitErr).Error("could not transition loan to PAID_OFF")
		} else {
			logger.WithField("loan_id", la.GetID()).Info("loan fully paid off")
		}

		// Notify client about full payoff
		if b.notifier != nil {
			b.notifier.NotifyLoanFullyPaid(ctx, la.ClientID, "")
		}
	}

	return r.ToAPI(), nil
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

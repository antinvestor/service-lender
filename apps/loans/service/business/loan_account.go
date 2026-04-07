package business

import (
	"context"
	"fmt"
	"math"
	"sort"
	"strconv"
	"time"

	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	"buf.build/gen/go/antinvestor/origination/connectrpc/go/origination/v1/originationv1connect"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"
	"github.com/pitabwire/util/decimalx"

	"github.com/antinvestor/service-lender/apps/loans/service/events"
	"github.com/antinvestor/service-lender/apps/loans/service/models"
	"github.com/antinvestor/service-lender/apps/loans/service/repository"
	"github.com/antinvestor/service-lender/pkg/calculation"
)

const (
	// decimalPrecision is the number of decimal places for minor unit conversions (cents).
	decimalPrecision = 2
	// daysPerWeek is the number of days in a weekly period.
	daysPerWeek = 7
	// daysPerBiweek is the number of days in a biweekly period.
	daysPerBiweek = 14
	// daysPerMonth is the approximate number of days in a monthly period.
	daysPerMonth = 30
	// daysPerQuarter is the approximate number of days in a quarterly period.
	daysPerQuarter = 90
)

// validTransitions defines the allowed loan status transitions.
var validTransitions = map[loansv1.LoanStatus][]loansv1.LoanStatus{ //nolint:gochecknoglobals // state machine
	loansv1.LoanStatus_LOAN_STATUS_UNSPECIFIED: {},
	loansv1.LoanStatus_LOAN_STATUS_PENDING_DISBURSEMENT: {
		loansv1.LoanStatus_LOAN_STATUS_ACTIVE,
		loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED,
	},
	loansv1.LoanStatus_LOAN_STATUS_ACTIVE: {
		loansv1.LoanStatus_LOAN_STATUS_DELINQUENT,
		loansv1.LoanStatus_LOAN_STATUS_PAID_OFF,
		loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED,
	},
	loansv1.LoanStatus_LOAN_STATUS_DELINQUENT: {
		loansv1.LoanStatus_LOAN_STATUS_DEFAULT,
		loansv1.LoanStatus_LOAN_STATUS_ACTIVE,
		loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED,
	},
	loansv1.LoanStatus_LOAN_STATUS_DEFAULT: {
		loansv1.LoanStatus_LOAN_STATUS_WRITTEN_OFF,
		loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED,
	},
	loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED: {
		loansv1.LoanStatus_LOAN_STATUS_ACTIVE,
		loansv1.LoanStatus_LOAN_STATUS_DELINQUENT,
		loansv1.LoanStatus_LOAN_STATUS_PAID_OFF,
	},
	loansv1.LoanStatus_LOAN_STATUS_PAID_OFF: {
		loansv1.LoanStatus_LOAN_STATUS_CLOSED,
	},
	loansv1.LoanStatus_LOAN_STATUS_WRITTEN_OFF: {
		loansv1.LoanStatus_LOAN_STATUS_CLOSED,
	},
	loansv1.LoanStatus_LOAN_STATUS_CLOSED: {},
}

type LoanAccountBusiness interface {
	Create(ctx context.Context, applicationID string) (*loansv1.LoanAccountObject, error)
	Get(ctx context.Context, id string) (*loansv1.LoanAccountObject, error)
	Search(
		ctx context.Context,
		req *loansv1.LoanAccountSearchRequest,
		consumer func(ctx context.Context, batch []*loansv1.LoanAccountObject) error,
	) error
	GetBalance(ctx context.Context, loanAccountID string) (*loansv1.LoanBalanceObject, error)
	GetStatement(ctx context.Context, req *loansv1.LoanStatementRequest) (*loansv1.LoanStatementResponse, error)
	TransitionStatus(
		ctx context.Context,
		loanAccountID string,
		newStatus loansv1.LoanStatus,
		changedBy, reason string,
	) (*loansv1.LoanAccountObject, error)
}

type loanAccountBusiness struct {
	eventsMan        fevents.Manager
	loanProductRepo  repository.LoanProductRepository
	loanAccountRepo  repository.LoanAccountRepository
	loanBalanceRepo  repository.LoanBalanceRepository
	statusChangeRepo repository.LoanStatusChangeRepository
	repaymentRepo    repository.RepaymentRepository
	penaltyRepo      repository.PenaltyRepository
	originationCli   originationv1connect.OriginationServiceClient
	scheduleBusiness RepaymentScheduleBusiness
}

func NewLoanAccountBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	loanProductRepo repository.LoanProductRepository,
	loanAccountRepo repository.LoanAccountRepository,
	loanBalanceRepo repository.LoanBalanceRepository,
	statusChangeRepo repository.LoanStatusChangeRepository,
	repaymentRepo repository.RepaymentRepository,
	penaltyRepo repository.PenaltyRepository,
	originationCli originationv1connect.OriginationServiceClient,
	scheduleBusiness RepaymentScheduleBusiness,
) LoanAccountBusiness {
	return &loanAccountBusiness{
		eventsMan:        eventsMan,
		loanProductRepo:  loanProductRepo,
		loanAccountRepo:  loanAccountRepo,
		loanBalanceRepo:  loanBalanceRepo,
		statusChangeRepo: statusChangeRepo,
		repaymentRepo:    repaymentRepo,
		penaltyRepo:      penaltyRepo,
		originationCli:   originationCli,
		scheduleBusiness: scheduleBusiness,
	}
}

func (b *loanAccountBusiness) Create(ctx context.Context, applicationID string) (*loansv1.LoanAccountObject, error) {
	logger := util.Log(ctx).WithField("method", "LoanAccountBusiness.Create")

	if b.originationCli == nil {
		return nil, ErrOriginationServiceUnavailable
	}

	la, lp, err := b.populateLoanFromApplication(ctx, logger, applicationID)
	if err != nil {
		return nil, err
	}

	if la.PrincipalAmount <= 0 {
		return nil, fmt.Errorf("loan principal amount must be positive, got %d", la.PrincipalAmount)
	}

	la.GenID(ctx)
	setDisbursementDates(la)

	if err = b.eventsMan.Emit(ctx, events.LoanAccountSaveEvent, la); err != nil {
		logger.WithError(err).Error("could not emit loan account save event")
		return nil, err
	}

	b.createInitialBalance(ctx, logger, la, lp)

	if b.scheduleBusiness != nil {
		if _, schedErr := b.scheduleBusiness.Generate(ctx, la.GetID()); schedErr != nil {
			logger.WithError(schedErr).Error("could not generate repayment schedule")
		}
	}

	return la.ToAPI(), nil
}

// populateLoanFromApplication fetches the application from origination and
// populates a LoanAccount with its data and optional product defaults.
func (b *loanAccountBusiness) populateLoanFromApplication(
	ctx context.Context,
	logger *util.LogEntry,
	applicationID string,
) (*models.LoanAccount, *models.LoanProduct, error) {
	la := &models.LoanAccount{
		ApplicationID: applicationID,
		Status:        int32(loansv1.LoanStatus_LOAN_STATUS_PENDING_DISBURSEMENT),
	}

	appResp, appErr := b.originationCli.ApplicationGet(ctx, connect.NewRequest(
		&originationv1.ApplicationGetRequest{Id: applicationID},
	))
	if appErr != nil {
		logger.WithError(appErr).Error("could not fetch application from origination service")
		return nil, nil, ErrApplicationNotFound
	}

	app := appResp.Msg.GetData()
	la.ProductID = app.GetProductId()
	la.ClientID = app.GetClientId()
	la.AgentID = app.GetAgentId()
	la.BranchID = app.GetBranchId()
	la.OrganizationID = app.GetOrganizationId()
	approvedAmount, approvedCurrency := models.MoneyToMinorUnits(app.GetApprovedAmount())
	la.CurrencyCode = approvedCurrency
	la.PrincipalAmount = approvedAmount
	la.InterestRate = models.StringToBasisPoints(app.GetInterestRate())
	la.TermDays = app.GetApprovedTermDays()

	lp := b.applyProductDefaults(ctx, logger, la, app.GetProductId())

	// Use requested amounts as fallback if approved amounts are zero
	if la.PrincipalAmount == 0 {
		reqAmt, reqCur := models.MoneyToMinorUnits(app.GetRequestedAmount())
		la.PrincipalAmount = reqAmt
		if la.CurrencyCode == "" {
			la.CurrencyCode = reqCur
		}
	}
	if la.TermDays == 0 {
		la.TermDays = app.GetRequestedTermDays()
	}

	return la, lp, nil
}

// applyProductDefaults enriches a loan account with product-level defaults
// (interest method, repayment frequency, rate, currency).
func (b *loanAccountBusiness) applyProductDefaults(
	ctx context.Context,
	logger *util.LogEntry,
	la *models.LoanAccount,
	productID string,
) *models.LoanProduct {
	if productID == "" {
		return nil
	}
	prod, prodErr := b.loanProductRepo.GetByID(ctx, productID)
	if prodErr != nil || prod == nil {
		logger.WithError(prodErr).Warn("could not fetch loan product, using application data only")
		return nil
	}
	la.InterestMethod = prod.InterestMethod
	la.RepaymentFrequency = prod.RepaymentFrequency
	if la.InterestRate == 0 {
		la.InterestRate = prod.AnnualInterestRate
	}
	if la.CurrencyCode == "" {
		la.CurrencyCode = prod.CurrencyCode
	}
	return prod
}

// setDisbursementDates sets the disbursement date to now and computes the first repayment date.
func setDisbursementDates(la *models.LoanAccount) {
	now := time.Now().UTC()
	la.DisbursedAt = &now
	firstRepayment := now.AddDate(0, 0, computeFirstRepaymentDays(loansv1.RepaymentFrequency(la.RepaymentFrequency)))
	la.FirstRepaymentDate = &firstRepayment
}

// createInitialBalance creates the initial loan balance snapshot and emits it.
func (b *loanAccountBusiness) createInitialBalance(
	ctx context.Context,
	logger *util.LogEntry,
	la *models.LoanAccount,
	lp *models.LoanProduct,
) {
	totalInterest, totalFees := computeInterestAndFees(la, lp)
	now := time.Now().UTC()

	balance := &models.LoanBalance{
		LoanAccountID:        la.GetID(),
		CurrencyCode:         la.CurrencyCode,
		PrincipalOutstanding: la.PrincipalAmount,
		InterestAccrued:      totalInterest,
		FeesOutstanding:      totalFees,
		TotalOutstanding:     la.PrincipalAmount + totalInterest + totalFees,
		TotalDisbursed:       la.PrincipalAmount,
		LastCalculatedAt:     &now,
	}
	balance.GenID(ctx)

	if err := b.eventsMan.Emit(ctx, events.LoanBalanceSaveEvent, balance); err != nil {
		logger.WithError(err).Warn("could not emit loan balance save event")
	}
}

func (b *loanAccountBusiness) Get(ctx context.Context, id string) (*loansv1.LoanAccountObject, error) {
	la, err := b.loanAccountRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrLoanAccountNotFound
	}
	return la.ToAPI(), nil
}

func (b *loanAccountBusiness) Search(
	ctx context.Context,
	req *loansv1.LoanAccountSearchRequest,
	consumer func(ctx context.Context, batch []*loansv1.LoanAccountObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "LoanAccountBusiness.Search")

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
	if req.GetClientId() != "" {
		andQueryVal["client_id = ?"] = req.GetClientId()
	}
	if req.GetAgentId() != "" {
		andQueryVal["agent_id = ?"] = req.GetAgentId()
	}
	if req.GetBranchId() != "" {
		andQueryVal["branch_id = ?"] = req.GetBranchId()
	}
	if req.GetOrganizationId() != "" {
		andQueryVal["organization_id = ?"] = req.GetOrganizationId()
	}
	if req.GetStatus() != loansv1.LoanStatus_LOAN_STATUS_UNSPECIFIED {
		andQueryVal["status = ?"] = int32(req.GetStatus())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	if req.GetQuery() != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{"searchable @@ websearch_to_tsquery( 'english', ?) ": req.GetQuery()},
			),
		)
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.loanAccountRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search loan accounts")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.LoanAccount) error {
		var apiResults []*loansv1.LoanAccountObject
		for _, la := range res {
			apiResults = append(apiResults, la.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

func (b *loanAccountBusiness) GetBalance(
	ctx context.Context,
	loanAccountID string,
) (*loansv1.LoanBalanceObject, error) {
	balance, err := b.loanBalanceRepo.GetByLoanAccountID(ctx, loanAccountID)
	if err != nil {
		return nil, ErrBalanceNotFound
	}
	return balance.ToAPI(), nil
}

func (b *loanAccountBusiness) GetStatement(
	ctx context.Context,
	req *loansv1.LoanStatementRequest,
) (*loansv1.LoanStatementResponse, error) {
	logger := util.Log(ctx).WithField("method", "LoanAccountBusiness.GetStatement")

	la, err := b.loanAccountRepo.GetByID(ctx, req.GetLoanAccountId())
	if err != nil {
		return nil, ErrLoanAccountNotFound
	}

	balance, balErr := b.loanBalanceRepo.GetByLoanAccountID(ctx, req.GetLoanAccountId())
	if balErr != nil {
		logger.WithError(balErr).Warn("could not load balance for statement")
	}

	var balanceAPI *loansv1.LoanBalanceObject
	if balance != nil {
		balanceAPI = balance.ToAPI()
	}

	fromDate := models.StringToTime(req.GetFromDate())
	toDate := models.StringToTime(req.GetToDate())
	statementEntries := b.buildStatementEntries(ctx, req.GetLoanAccountId(), fromDate, toDate)

	return &loansv1.LoanStatementResponse{
		Loan:    la.ToAPI(),
		Balance: balanceAPI,
		Entries: statementEntries,
	}, nil
}

// statementEntry is an internal type used to sort and compute running balances
// before converting to the proto LoanStatementEntry.
type statementEntry struct {
	date        time.Time
	description string
	debit       int64 // charges to the borrower (increases balance)
	credit      int64 // payments by the borrower (decreases balance)
	reference   string
	currency    string
}

// buildStatementEntries collects all financial events for a loan (disbursement,
// penalties, repayments), sorts them chronologically, computes a running
// balance, and returns proto statement entries filtered by the given date range.
//
//nolint:gocognit,funlen // statement assembly is inherently complex
func (b *loanAccountBusiness) buildStatementEntries(
	ctx context.Context,
	loanAccountID string,
	fromDate, toDate *time.Time,
) []*loansv1.LoanStatementEntry {
	la, laErr := b.loanAccountRepo.GetByID(ctx, loanAccountID)
	if laErr != nil {
		return nil
	}

	var raw []statementEntry

	// 1. Disbursement entry (the initial loan advance)
	if la.DisbursedAt != nil {
		raw = append(raw, statementEntry{
			date:        *la.DisbursedAt,
			description: "Loan disbursement",
			debit:       la.PrincipalAmount,
			currency:    la.CurrencyCode,
			reference:   la.ApplicationID,
		})
	}

	// 2. Penalty entries
	penQuery := data.NewSearchQuery(
		data.WithSearchFiltersAndByValue(map[string]any{
			"loan_account_id = ?": loanAccountID,
		}),
	)
	if penResults, penErr := b.penaltyRepo.Search(ctx, penQuery); penErr == nil {
		_ = workerpoolConsumeStream(ctx, penResults, func(batch []*models.Penalty) error {
			for _, p := range batch {
				if p.IsWaived {
					continue
				}
				t := time.Now().UTC()
				if p.AppliedAt != nil {
					t = *p.AppliedAt
				}
				raw = append(raw, statementEntry{
					date:        t,
					description: "Penalty: " + p.Reason,
					debit:       p.Amount,
					currency:    p.CurrencyCode,
					reference:   p.GetID(),
				})
			}
			return nil
		})
	}

	// 3. Repayment entries
	repQuery := data.NewSearchQuery(
		data.WithSearchFiltersAndByValue(map[string]any{
			"loan_account_id = ?": loanAccountID,
		}),
	)
	if repResults, repErr := b.repaymentRepo.Search(ctx, repQuery); repErr == nil {
		_ = workerpoolConsumeStream(ctx, repResults, func(batch []*models.Repayment) error {
			for _, r := range batch {
				if r.ReceivedAt == nil {
					continue
				}
				raw = append(raw, statementEntry{
					date:        *r.ReceivedAt,
					description: "Repayment via " + r.Channel,
					credit:      r.Amount,
					currency:    r.CurrencyCode,
					reference:   r.PaymentReference,
				})
			}
			return nil
		})
	}

	// Sort chronologically
	sort.Slice(raw, func(i, j int) bool {
		return raw[i].date.Before(raw[j].date)
	})

	// Compute running balance and filter by date range.
	// If fromDate is set, emit an opening balance row for the period.
	var entries []*loansv1.LoanStatementEntry
	var runningBalance int64
	openingBalanceEmitted := fromDate == nil // skip opening balance if no date filter
	currency := la.CurrencyCode

	for _, e := range raw {
		runningBalance += e.debit - e.credit

		if !isTimeInRange(e.date, fromDate, toDate) {
			continue
		}

		// Emit opening balance row before the first in-range entry
		if !openingBalanceEmitted {
			openingBalance := runningBalance - e.debit + e.credit // balance before this entry
			entries = append(entries, &loansv1.LoanStatementEntry{
				Date:        models.TimeToString(fromDate),
				Description: "Opening balance brought forward",
				Balance:     models.MinorUnitsToMoney(openingBalance, currency),
			})
			openingBalanceEmitted = true
		}

		entry := &loansv1.LoanStatementEntry{
			Date:        models.TimeToString(&e.date),
			Description: e.description,
			Balance:     models.MinorUnitsToMoney(runningBalance, e.currency),
			Reference:   e.reference,
		}
		if e.debit > 0 {
			entry.Debit = models.MinorUnitsToMoney(e.debit, e.currency)
		}
		if e.credit > 0 {
			entry.Credit = models.MinorUnitsToMoney(e.credit, e.currency)
		}
		entries = append(entries, entry)
	}

	return entries
}

// isTimeInRange checks whether a time falls within the given date range.
func isTimeInRange(t time.Time, fromDate, toDate *time.Time) bool {
	if fromDate != nil && t.Before(*fromDate) {
		return false
	}
	if toDate != nil && t.After(*toDate) {
		return false
	}
	return true
}

func (b *loanAccountBusiness) TransitionStatus(
	ctx context.Context,
	loanAccountID string,
	newStatus loansv1.LoanStatus,
	changedBy, reason string,
) (*loansv1.LoanAccountObject, error) {
	logger := util.Log(ctx).WithField("method", "LoanAccountBusiness.TransitionStatus")

	la, err := b.loanAccountRepo.GetByID(ctx, loanAccountID)
	if err != nil {
		return nil, ErrLoanAccountNotFound
	}

	currentStatus := loansv1.LoanStatus(la.Status)

	// Validate transition
	allowed, ok := validTransitions[currentStatus]
	if !ok {
		return nil, ErrInvalidStatusTransition
	}

	valid := false
	for _, s := range allowed {
		if s == newStatus {
			valid = true
			break
		}
	}
	if !valid {
		return nil, ErrInvalidStatusTransition.Extend(
			"cannot transition from " + currentStatus.String() + " to " + newStatus.String(),
		)
	}

	// Record status change
	now := time.Now().UTC()
	statusChange := &models.LoanStatusChange{
		LoanAccountID: la.GetID(),
		FromStatus:    la.Status,
		ToStatus:      int32(newStatus),
		ChangedBy:     changedBy,
		Reason:        reason,
		ChangedAt:     &now,
	}
	statusChange.GenID(ctx)

	err = b.eventsMan.Emit(ctx, events.LoanStatusChangeSaveEvent, statusChange)
	if err != nil {
		logger.WithError(err).Error("could not emit loan status change save event")
		return nil, err
	}

	// Update loan account status
	la.Status = int32(newStatus)
	err = b.eventsMan.Emit(ctx, events.LoanAccountSaveEvent, la)
	if err != nil {
		logger.WithError(err).Error("could not emit loan account save event")
		return nil, err
	}

	return la.ToAPI(), nil
}

// computeFirstRepaymentDays returns the number of days from disbursement
// to the first repayment date based on the repayment frequency.
func computeFirstRepaymentDays(freq loansv1.RepaymentFrequency) int {
	switch freq { //nolint:exhaustive // unspecified and quarterly fall through to default (weekly)
	case loansv1.RepaymentFrequency_REPAYMENT_FREQUENCY_DAILY:
		return 1
	case loansv1.RepaymentFrequency_REPAYMENT_FREQUENCY_WEEKLY:
		return daysPerWeek
	case loansv1.RepaymentFrequency_REPAYMENT_FREQUENCY_BIWEEKLY:
		return daysPerBiweek
	case loansv1.RepaymentFrequency_REPAYMENT_FREQUENCY_MONTHLY:
		return daysPerMonth
	case loansv1.RepaymentFrequency_REPAYMENT_FREQUENCY_QUARTERLY:
		return daysPerQuarter
	default:
		return daysPerWeek
	}
}

// computeInterestAndFees calculates total interest and fees for a loan based on
// the product configuration. Returns (0, 0) if no product is provided.
func computeInterestAndFees(la *models.LoanAccount, lp *models.LoanProduct) (int64, int64) {
	if lp == nil {
		return 0, 0
	}
	ppy := int64(
		calculation.PeriodsPerYear(frequencyToPeriodType(loansv1.RepaymentFrequency(la.RepaymentFrequency))),
	)
	numInstallments := computeInstallmentCount(la.TermDays, loansv1.RepaymentFrequency(la.RepaymentFrequency))
	if numInstallments <= 0 {
		numInstallments = 1
	}
	principal := decimalx.FromMinorUnits(la.PrincipalAmount, decimalPrecision)
	totalInterest := calculation.FlatRateInterest(principal, la.InterestRate, numInstallments, safeInt32(ppy)).
		ToMinorUnits(decimalPrecision)
	totalFees := calculation.FlatRateInterest(
		principal,
		lp.InsuranceFeePercent+lp.ProcessingFeePercent,
		numInstallments,
		safeInt32(ppy),
	).ToMinorUnits(decimalPrecision)
	return totalInterest, totalFees
}

// safeInt32 converts an int64 to int32 with clamping to avoid overflow.
func safeInt32(v int64) int32 {
	if v > math.MaxInt32 {
		return math.MaxInt32
	}
	if v < math.MinInt32 {
		return math.MinInt32
	}
	return int32(v)
}

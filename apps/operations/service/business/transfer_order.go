package business

import (
	"context"
	"fmt"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	ledgerv1 "buf.build/gen/go/antinvestor/ledger/protocolbuffers/go/ledger/v1"
	paymentv1 "buf.build/gen/go/antinvestor/payment/protocolbuffers/go/payment/v1"
	"connectrpc.com/connect"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"
	"github.com/pitabwire/util/decimalx"
	utilmoney "github.com/pitabwire/util/money"
	"google.golang.org/genproto/googleapis/type/money"

	fundingmodels "github.com/antinvestor/service-lender/apps/funding/service/models"
	fundingrepo "github.com/antinvestor/service-lender/apps/funding/service/repository"
	"github.com/antinvestor/service-lender/apps/operations/service/events"
	"github.com/antinvestor/service-lender/apps/operations/service/models"
	"github.com/antinvestor/service-lender/apps/operations/service/repository"
	"github.com/antinvestor/service-lender/pkg/calculation"
	"github.com/antinvestor/service-lender/pkg/clients"
	"github.com/antinvestor/service-lender/pkg/constants"
)

const (
	// decimalPrecisionTO is the number of decimal places for minor unit conversions.
	decimalPrecisionTO = 2
	// basisPointsDenominator is the multiplier used to convert proportions to basis points.
	basisPointsDenominator = 10000
)

type transferOrderBusiness struct {
	eventsMan fevents.Manager
	toRepo    repository.TransferOrderRepository
	csRepo    repository.CBSSyncRecordRepository
	arRepo    repository.AccountRefRepository
	lfRepo    fundingrepo.LoanFundingRepository
	ftRepo    fundingrepo.FundingTrancheRepository
	iaRepo    fundingrepo.InvestorAccountRepository
	clients   *clients.PlatformClients
}

func NewTransferOrderBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	toRepo repository.TransferOrderRepository,
	csRepo repository.CBSSyncRecordRepository,
	arRepo repository.AccountRefRepository,
	lfRepo fundingrepo.LoanFundingRepository,
	ftRepo fundingrepo.FundingTrancheRepository,
	iaRepo fundingrepo.InvestorAccountRepository,
	pc *clients.PlatformClients,
) TransferOrderBusiness {
	return &transferOrderBusiness{
		eventsMan: eventsMan,
		toRepo:    toRepo,
		csRepo:    csRepo,
		arRepo:    arRepo,
		lfRepo:    lfRepo,
		ftRepo:    ftRepo,
		iaRepo:    iaRepo,
		clients:   pc,
	}
}

// Execute processes a transfer order based on its type.
// The execution flow is:
//  1. Load the transfer order from the repository
//  2. Resolve debit/credit account references
//  3. Post the base ledger transaction (debit source, credit destination)
//  4. Run type-specific side effects (e.g. loan repayment notifies Lender)
//  5. Log a CBS sync record for external reconciliation
//  6. Mark the transfer order as completed
func (b *transferOrderBusiness) Execute(ctx context.Context, orderID string) error {
	logger := util.Log(ctx).WithField("method", "TransferOrderBusiness.Execute").
		WithField("order_id", orderID)

	order, err := b.toRepo.GetByID(ctx, orderID)
	if err != nil {
		return fmt.Errorf("transfer order not found: %w", err)
	}

	orderType := int(order.OrderType)
	typeName := constants.TransferTypeName(orderType)
	logger = logger.WithField("order_type", typeName)

	if order.State == int32(constants.StateInactive) || order.State == int32(constants.StateDeleted) {
		logger.Info("transfer order already completed, skipping")
		return nil
	}

	order.State = int32(constants.StateCheckCreated)
	if err = b.eventsMan.Emit(ctx, events.TransferOrderSaveEvent, order); err != nil {
		return fmt.Errorf("could not claim transfer order for execution: %w", err)
	}

	logger.Info("executing transfer order")

	debitRef, creditRef, err := b.resolveAccountRefs(ctx, order)
	if err != nil {
		logger.WithError(err).Error("failed to resolve account references")
		return fmt.Errorf("resolve account refs: %w", err)
	}

	if execErr := b.executeBaseLedgerTransfer(ctx, order, debitRef, creditRef); execErr != nil {
		logger.WithError(execErr).Error("base ledger transfer failed")
		return execErr
	}

	if sideEffectErr := b.dispatchSideEffect(ctx, logger, orderType, order); sideEffectErr != nil {
		logger.WithError(sideEffectErr).Error("side effect failed")
		return sideEffectErr
	}

	// Step 5: Log CBS sync record for external reconciliation
	if syncErr := b.logCBSSyncRecord(ctx, order); syncErr != nil {
		logger.WithError(syncErr).Warn("CBS sync record logging failed (non-fatal)")
	}

	// Step 6: Mark the transfer order as completed
	order.State = int32(constants.StateInactive)
	if emitErr := b.eventsMan.Emit(ctx, events.TransferOrderSaveEvent, order); emitErr != nil {
		logger.WithError(emitErr).Error("could not update transfer order state")
		return emitErr
	}

	logger.Info("transfer order executed successfully")
	return nil
}

// transferHandler is the signature for side-effect handlers that may return an error.
type transferHandler func(ctx context.Context, order *models.TransferOrder) error

// noErr wraps a void handler into a transferHandler returning nil.
func noErr(fn func(ctx context.Context, order *models.TransferOrder)) transferHandler {
	return func(ctx context.Context, order *models.TransferOrder) error {
		fn(ctx, order)
		return nil
	}
}

// sideEffectHandlers returns a dispatch map from order type to handler.
func (b *transferOrderBusiness) sideEffectHandlers() map[int]transferHandler {
	return map[int]transferHandler{
		constants.TransferTypeLoan:                                      b.handleLoanDisbursement,
		constants.TransferTypeLoanRepayment:                             noErr(b.handleLoanRepayment),
		constants.TransferTypeLoanInterest:                              noErr(b.handleLoanInterest),
		constants.TransferTypeLoanInterestRepayment:                     noErr(b.handleLoanInterestRepayment),
		constants.TransferTypeLoanInsurance:                             noErr(b.handleLoanInsurance),
		constants.TransferTypeLoanInsuranceRepayment:                    noErr(b.handleLoanInsuranceRepayment),
		constants.TransferTypeDisbursement:                              b.handleDisbursement,
		constants.TransferTypeDisbursementReversal:                      noErr(b.handleDisbursementReversal),
		constants.TransferTypeDisbursementReversalReroute:               b.handleDisbursementReversalReroute,
		constants.TransferTypePeriodicSaving:                            noErr(b.handlePeriodicSaving),
		constants.TransferTypePeriodicSavingRecovery:                    noErr(b.handlePeriodicSavingRecovery),
		constants.TransferTypePeriodicSavingsInterestIncomeDistribution: noErr(b.handleSavingsInterestDistribution),
		constants.TransferTypeRegistrationFee:                           noErr(b.handleRegistrationFee),
		constants.TransferTypeTerminalDisbursement:                      b.handleTerminalDisbursement,
		constants.TransferTypeTerminalDisbursementRecovery:              noErr(b.handleTerminalDisbursementRecovery),
		constants.TransferTypePayment:                                   noErr(b.handlePaymentOutflow),
		constants.TransferTypePaymentIdentified:                         noErr(b.handlePaymentIdentified),
		constants.TransferTypePaymentAllocated:                          noErr(b.handlePaymentAllocated),
		constants.TransferTypePenalty:                                   noErr(b.handlePenalty),
		constants.TransferTypePenaltyCancel:                             noErr(b.handlePenaltyCancel),
		constants.TransferTypePenaltyIncomeDistribution:                 noErr(b.handlePenaltyIncomeDistribution),
		constants.TransferTypeCost:                                      noErr(b.handleCost),
		constants.TransferTypeServiceFee:                                noErr(b.handleServiceFee),
		constants.TransferTypeLoanFundingExternalLending:                noErr(b.handleExternalLending),
		constants.TransferTypeLoanFundingExternalLendingPayback:         b.handleExternalLendingPayback,
		constants.TransferTypeShutdownLoanRecovery:                      noErr(b.handleShutdownLoanRecovery),
		constants.TransferTypeInterSubscriptionPayment:                  noErr(b.handleInterSubscriptionPayment),
		constants.TransferTypeLoanInterestIncomeDistribution:            noErr(b.handleLoanInterestIncomeDistribution),
		constants.TransferTypeInvestorDeployment:                        noErr(b.handleInvestorDeployment),
		constants.TransferTypeInvestorPrincipalReturn:                   noErr(b.handleInvestorPrincipalReturn),
		constants.TransferTypeInvestorIncomeDistribution:                noErr(b.handleInvestorIncomeDistribution),
		constants.TransferTypePlatformFirstLossAbsorption:               noErr(b.handlePlatformFirstLossAbsorption),
		constants.TransferTypeInvestorLossAbsorption:                    noErr(b.handleInvestorLossAbsorption),
	}
}

// dispatchSideEffect looks up and executes the type-specific side effect handler.
func (b *transferOrderBusiness) dispatchSideEffect(
	ctx context.Context,
	logger *util.LogEntry,
	orderType int,
	order *models.TransferOrder,
) error {
	handler, ok := b.sideEffectHandlers()[orderType]
	if !ok {
		logger.Warn("unknown transfer order type, executing base transfer only")
		return nil
	}
	return handler(ctx, order)
}

// resolveAccountRefs looks up the debit and credit AccountRef records for the
// transfer order. The order stores account ref IDs; this method resolves them
// to the full AccountRef objects so downstream logic has access to ledger IDs.
func (b *transferOrderBusiness) resolveAccountRefs(
	ctx context.Context,
	order *models.TransferOrder,
) (*models.AccountRef, *models.AccountRef, error) {
	var debitRef, creditRef *models.AccountRef

	if order.DebitAccountRef != "" {
		ref, err := b.arRepo.GetByID(ctx, order.DebitAccountRef)
		if err != nil {
			return nil, nil, fmt.Errorf("debit account ref %s: %w", order.DebitAccountRef, err)
		}
		debitRef = ref
	}

	if order.CreditAccountRef != "" {
		ref, err := b.arRepo.GetByID(ctx, order.CreditAccountRef)
		if err != nil {
			return nil, nil, fmt.Errorf("credit account ref %s: %w", order.CreditAccountRef, err)
		}
		creditRef = ref
	}

	return debitRef, creditRef, nil
}

// executeBaseLedgerTransfer posts a double-entry transaction to the Ledger service.
// It debits the source account and credits the destination account for the
// transfer amount. When the Ledger client is available this will make the
// actual API call; until then it logs the intent.
func (b *transferOrderBusiness) executeBaseLedgerTransfer(
	ctx context.Context,
	order *models.TransferOrder,
	debitRef, creditRef *models.AccountRef,
) error {
	logger := util.Log(ctx).WithField("method", "executeBaseLedgerTransfer").
		WithField("order_id", order.GetID())

	debitLedgerID := ""
	creditLedgerID := ""
	if debitRef != nil {
		debitLedgerID = debitRef.LedgerID
	}
	if creditRef != nil {
		creditLedgerID = creditRef.LedgerID
	}

	logger.WithField("debit_ledger", debitLedgerID).
		WithField("credit_ledger", creditLedgerID).
		WithField("amount", order.Amount).
		WithField("currency", order.Currency).
		Info("posting ledger transaction")

	if b.clients.LedgerClient == nil {
		logger.Warn("LedgerClient not configured, skipping ledger posting")
		return nil
	}

	amt := minorToMoney(order.Currency, order.Amount)

	req := (&ledgerv1.CreateTransactionRequest_builder{
		Id:       order.GetID(),
		Currency: order.Currency,
		Entries: []*ledgerv1.TransactionEntry{
			(&ledgerv1.TransactionEntry_builder{
				AccountId: debitLedgerID,
				Amount:    amt,
				Credit:    false,
			}).Build(),
			(&ledgerv1.TransactionEntry_builder{
				AccountId: creditLedgerID,
				Amount:    amt,
				Credit:    true,
			}).Build(),
		},
		Cleared: true,
		Type:    ledgerv1.TransactionType_NORMAL,
	}).Build()

	_, err := b.clients.LedgerClient.CreateTransaction(ctx, connect.NewRequest(req))
	if err != nil {
		return fmt.Errorf("ledger CreateTransaction failed: %w", err)
	}

	return nil
}

// logCBSSyncRecord creates a CBS synchronization record for the executed transfer
// order. This record is used by the reconciliation system to sync with the
// external core banking system.
func (b *transferOrderBusiness) logCBSSyncRecord(ctx context.Context, order *models.TransferOrder) error {
	record := &models.CBSSyncRecord{
		OwnerID:       order.DebitAccountRef,
		OwnerType:     "transfer_order",
		OrderType:     order.OrderType,
		TransactionID: order.GetID(),
		Amount:        order.Amount,
		Currency:      order.Currency,
		State:         int32(constants.StateActive),
	}
	record.GenID(ctx)
	record.CopyPartitionInfo(&order.BaseModel)

	if err := b.eventsMan.Emit(ctx, events.CBSSyncRecordSaveEvent, record); err != nil {
		return fmt.Errorf("emit CBS sync record: %w", err)
	}
	return nil
}

// minorToMoney converts a minor-unit int64 amount and currency code to a
// google.type.Money protobuf value. Assumes 2-decimal-place currencies.
func minorToMoney(currency string, amount int64) *money.Money {
	return utilmoney.FromInt64(currency, amount, decimalPrecisionTO)
}

// sendPayment is a helper that calls PaymentClient.Send with common parameters.
// It returns nil if PaymentClient is not configured (graceful degradation).
func (b *transferOrderBusiness) sendPayment(
	ctx context.Context,
	order *models.TransferOrder,
	recipientID string,
	route string,
) error {
	if b.clients.PaymentClient == nil {
		util.Log(ctx).Warn("PaymentClient not configured, skipping payment send")
		return nil
	}

	req := (&paymentv1.SendRequest_builder{
		Data: (&paymentv1.Payment_builder{
			ReferenceId: order.Reference,
			Route:       route,
			Recipient: (&commonv1.ContactLink_builder{
				ProfileId: recipientID,
			}).Build(),
			Amount:   minorToMoney(order.Currency, order.Amount),
			Outbound: true,
		}).Build(),
	}).Build()

	_, err := b.clients.PaymentClient.Send(ctx, connect.NewRequest(req))
	if err != nil {
		return fmt.Errorf("payment send failed: %w", err)
	}
	return nil
}

// extraDataString safely extracts a string value from the order's ExtraData map.
func extraDataString(order *models.TransferOrder, key string) string {
	if order.ExtraData == nil {
		return ""
	}
	v, ok := order.ExtraData[key]
	if !ok {
		return ""
	}
	s, _ := v.(string)
	return s
}

// extraDataInt64 safely extracts an int64 value from a JSONMap.
func extraDataInt64(m map[string]interface{}, key string) int64 {
	if m == nil {
		return 0
	}
	v, ok := m[key]
	if !ok {
		return 0
	}
	switch val := v.(type) {
	case float64:
		return int64(val)
	case int64:
		return val
	case int:
		return int64(val)
	default:
		return 0
	}
}

// redistributeRepayment distributes a repayment (principal or interest) across
// all funding tranches proportionally and creates transfer orders for each.
// For interest distributions to investors, platform fees and withholding tax are deducted.
func (b *transferOrderBusiness) redistributeRepayment(
	ctx context.Context,
	sourceOrder *models.TransferOrder,
	amount int64,
	repaymentType string,
	transferType int,
) {
	logger := util.Log(ctx).WithField("method", "redistributeRepayment").
		WithField("type", repaymentType).
		WithField("order_id", sourceOrder.GetID())

	loanOfferID := extraDataString(sourceOrder, "loan_offer_id")
	if loanOfferID == "" {
		logger.Debug("no loan_offer_id in transfer order, skipping redistribution")
		return
	}

	fundings, err := b.lfRepo.GetByLoanOfferID(ctx, loanOfferID)
	if err != nil || len(fundings) == 0 {
		logger.WithError(err).Warn("no funding records found for redistribution")
		return
	}

	tranchesByFunding := b.loadTrancheMap(ctx, fundings)
	platformFeeBP, taxBP := extractFeeRates(sourceOrder)
	isInterest := repaymentType == "interest"

	var distributed int64
	for i, funding := range fundings {
		var share int64
		if i == len(fundings)-1 {
			share = amount - distributed
		} else {
			share = amount * funding.Proportion / basisPointsDenominator
		}
		if share <= 0 {
			continue
		}

		b.redistributeToFundingSource(ctx, sourceOrder, funding, share,
			repaymentType, transferType, isInterest, platformFeeBP, taxBP,
			tranchesByFunding, logger)

		distributed += share
	}

	logger.WithFields(map[string]any{"amount": amount, "distributed": distributed, "funding_sources": len(fundings)}).
		Info("repayment redistribution completed")
}

// loadTrancheMap loads the first tranche for each funding record into a lookup map.
func (b *transferOrderBusiness) loadTrancheMap(
	ctx context.Context,
	fundings []*fundingmodels.LoanFunding,
) map[string]*fundingmodels.FundingTranche {
	result := make(map[string]*fundingmodels.FundingTranche)
	if b.ftRepo == nil {
		return result
	}
	for _, funding := range fundings {
		tranches, tErr := b.ftRepo.GetByLoanFundingID(ctx, funding.GetID())
		if tErr == nil && len(tranches) > 0 {
			result[funding.GetID()] = tranches[0]
		}
	}
	return result
}

// extractFeeRates reads platform fee and withholding tax basis points from a
// transfer order's extra data, falling back to system defaults.
func extractFeeRates(order *models.TransferOrder) (int64, int64) {
	feeBP := calculation.DefaultPlatformFeePercent
	taxBP := calculation.DefaultWithholdingTaxPercent
	if order.ExtraData == nil {
		return feeBP, taxBP
	}
	if pfee, ok := order.ExtraData["platform_fee_bp"].(float64); ok && pfee > 0 {
		feeBP = int64(pfee)
	}
	if tax, ok := order.ExtraData["withholding_tax_bp"].(float64); ok && tax > 0 {
		taxBP = int64(tax)
	}
	return feeBP, taxBP
}

// redistributeToFundingSource routes a single funding source's share of a repayment,
// handling investor fee/tax deductions, tranche tracking updates, and investor balance release.
func (b *transferOrderBusiness) redistributeToFundingSource(
	ctx context.Context,
	sourceOrder *models.TransferOrder,
	funding *fundingmodels.LoanFunding,
	share int64,
	repaymentType string,
	transferType int,
	isInterest bool,
	platformFeeBP, taxBP int64,
	tranchesByFunding map[string]*fundingmodels.FundingTranche,
	logger *util.LogEntry,
) {
	var creditAccount string
	actualTransferType := transferType
	actualAmount := share

	switch fundingmodels.FundingSource(funding.FundingType) {
	case fundingmodels.FundingSourceGroupSavings:
		creditAccount = constants.MemberPeriodicSavingsAccount(funding.OwnerID)
	case fundingmodels.FundingSourceGroupIncome:
		creditAccount = constants.GroupInterestIncomeAccount(funding.OwnerID)
	case fundingmodels.FundingSourceInvestorAffiliated, fundingmodels.FundingSourceInvestorGeneral:
		creditAccount = constants.InvestorCapitalAccount(funding.OwnerID)
		if isInterest {
			actualTransferType = constants.TransferTypeInvestorIncomeDistribution
			shareDec := decimalx.FromMinorUnits(share, decimalPrecisionTO)
			dist := calculation.CalculateInterestDistribution(shareDec, platformFeeBP, taxBP)
			actualAmount = dist.NetInterest.ToMinorUnits(decimalPrecisionTO)

			if dist.PlatformFee.IsPositive() {
				b.createRedistributionOrder(ctx, sourceOrder, dist.PlatformFee.ToMinorUnits(decimalPrecisionTO),
					constants.ProductServiceFeePayableAccount("default"),
					constants.TransferTypeServiceFee,
					fmt.Sprintf("platform_fee:%s:%s", sourceOrder.GetID(), funding.GetID()),
					fmt.Sprintf("Platform fee on investor interest from %s", funding.OwnerID),
				)
			}
			if dist.WithholdingTax.IsPositive() {
				b.createRedistributionOrder(ctx, sourceOrder, dist.WithholdingTax.ToMinorUnits(decimalPrecisionTO),
					constants.ProductServiceFeePayableAccount("tax"),
					constants.TransferTypeCost,
					fmt.Sprintf("wht:%s:%s", sourceOrder.GetID(), funding.GetID()),
					fmt.Sprintf("Withholding tax on investor interest from %s", funding.OwnerID),
				)
			}
		} else {
			actualTransferType = constants.TransferTypeInvestorPrincipalReturn
		}
	case fundingmodels.FundingSourcePlatformReserve:
		creditAccount = constants.PlatformFirstLossAccount("default")
	case fundingmodels.FundingSourceUnspecified:
		creditAccount = constants.GroupInterestIncomeAccount(funding.OwnerID)
	}

	b.createRedistributionOrder(ctx, sourceOrder, actualAmount,
		creditAccount, actualTransferType,
		fmt.Sprintf("redist:%s:%s:%s", repaymentType, sourceOrder.GetID(), funding.GetID()),
		fmt.Sprintf("%s redistribution to %s funding source", repaymentType, funding.OwnerID),
	)

	if tranche, ok := tranchesByFunding[funding.GetID()]; ok {
		if isInterest {
			tranche.InterestEarned += share
		} else {
			tranche.PrincipalRepaid += share
		}
		if ftErr := b.eventsMan.Emit(ctx, "funding_tranche.save", tranche); ftErr != nil {
			logger.WithError(ftErr).Warn("could not update funding tranche")
		}
	}

	if !isInterest && b.iaRepo != nil &&
		(fundingmodels.FundingSource(funding.FundingType) == fundingmodels.FundingSourceInvestorAffiliated ||
			fundingmodels.FundingSource(funding.FundingType) == fundingmodels.FundingSourceInvestorGeneral) {
		b.releaseInvestorBalance(ctx, funding.OwnerID, share)
	}
}

// createRedistributionOrder creates and emits a transfer order for redistribution.
func (b *transferOrderBusiness) createRedistributionOrder(
	ctx context.Context,
	sourceOrder *models.TransferOrder,
	amount int64,
	creditAccount string,
	transferType int,
	reference string,
	description string,
) {
	if amount <= 0 {
		return
	}

	redistOrder := &models.TransferOrder{
		DebitAccountRef:  sourceOrder.CreditAccountRef,
		CreditAccountRef: creditAccount,
		Amount:           amount,
		Currency:         sourceOrder.Currency,
		OrderType:        constants.SafeInt32FromInt(transferType),
		Reference:        reference,
		Description:      description,
		State:            int32(constants.StateJustCreated),
	}
	redistOrder.GenID(ctx)

	if emitErr := b.eventsMan.Emit(ctx, events.TransferOrderSaveEvent, redistOrder); emitErr != nil {
		util.Log(ctx).WithError(emitErr).Error("could not create redistribution transfer order")
	}
}

// releaseInvestorBalance decrements the reserved balance when principal is returned.
func (b *transferOrderBusiness) releaseInvestorBalance(ctx context.Context, investorAccountID string, amount int64) {
	if b.iaRepo == nil || amount <= 0 {
		return
	}

	account, err := b.iaRepo.GetByID(ctx, investorAccountID)
	if err != nil {
		util.Log(ctx).WithError(err).Warn("could not load investor account for balance release")
		return
	}

	account.ReservedBalance -= amount
	if account.ReservedBalance < 0 {
		account.ReservedBalance = 0
	}
	account.AvailableBalance += amount
	account.TotalReturned += amount

	if emitErr := b.eventsMan.Emit(ctx, "investor_account.save", account); emitErr != nil {
		util.Log(ctx).WithError(emitErr).Warn("could not update investor account after balance release")
	}
}

// ---------------------------------------------------------------------------
// Loan-related handlers
// ---------------------------------------------------------------------------

// handleLoanDisbursement processes a loan disbursement transfer.
// Debit: subscription loans account -> Credit: group bank account.
// Side effect: initiates the actual payment disbursement to the member.
func (b *transferOrderBusiness) handleLoanDisbursement(ctx context.Context, order *models.TransferOrder) error {
	logger := util.Log(ctx).WithField("handler", "handleLoanDisbursement").
		WithField("order_id", order.GetID())

	memberID := extraDataString(order, "member_id")
	loanID := extraDataString(order, "loan_id")

	logger.WithField("member_id", memberID).
		WithField("loan_id", loanID).
		Info("loan disbursement: creating payment initiation for member payout")

	if err := b.sendPayment(ctx, order, memberID, "loan_disbursement"); err != nil {
		return fmt.Errorf("loan disbursement payment for member %s: %w", memberID, err)
	}

	return nil
}

// handleLoanRepayment processes a loan principal repayment transfer.
// Debit: member suspense -> Credit: subscription loans account.
// Side effect: records the repayment in Lender loans.
func (b *transferOrderBusiness) handleLoanRepayment(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleLoanRepayment").
		WithField("order_id", order.GetID())

	loanID := extraDataString(order, "loan_id")
	clientID := extraDataString(order, "client_id")

	// Extract repayment breakdown from ExtraData
	interestPortion := extraDataInt64(order.ExtraData, "interest_applied")
	feesPortion := extraDataInt64(order.ExtraData, "fees_applied")
	principalPortion := order.Amount - interestPortion - feesPortion

	logger.WithField("loan_id", loanID).
		WithField("client_id", clientID).
		WithField("amount", order.Amount).
		WithField("principal", principalPortion).
		WithField("interest", interestPortion).
		WithField("fees", feesPortion).
		Info("recording loan repayment in lender system")

	// Loan repayment recording is handled by the loans app via its own event
	// pipeline. The operations app only manages ledger postings and redistribution.

	// Redistribute principal to funding sources (investors get their capital back)
	if principalPortion > 0 {
		b.redistributeRepayment(ctx, order, principalPortion, "principal", constants.TransferTypeLoanRepayment)
	}

	// Redistribute interest to funding sources (with platform fees + tax for investors)
	if interestPortion > 0 {
		b.redistributeRepayment(
			ctx,
			order,
			interestPortion,
			"interest",
			constants.TransferTypeLoanInterestIncomeDistribution,
		)
	}

	// Fees go to platform
	if feesPortion > 0 {
		b.redistributeRepayment(ctx, order, feesPortion, "fees", constants.TransferTypeServiceFee)
	}
}

// handleLoanInterest processes a loan interest charge transfer.
// Debit: group bank -> Credit: group interest income account.
// No external side effect beyond the base ledger posting.
func (b *transferOrderBusiness) handleLoanInterest(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleLoanInterest").
		WithField("order_id", order.GetID())
	logger.Info("loan interest charge posted")
}

// handleLoanInterestRepayment processes a loan interest repayment.
// Debit: member suspense -> Credit: interest account.
// Side effect: records the interest repayment in Lender.
func (b *transferOrderBusiness) handleLoanInterestRepayment(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleLoanInterestRepayment").
		WithField("order_id", order.GetID())

	loanID := extraDataString(order, "loan_id")

	logger.WithField("loan_id", loanID).
		Info("recording loan interest repayment in lender system")

	// Interest repayment recording is handled by the loans app via its own event
	// pipeline. This handler only manages the base ledger posting.
}

// handleLoanInsurance processes a loan insurance charge.
// Debit: group bank -> Credit: product insurance account.
// No external side effect beyond the base ledger posting.
func (b *transferOrderBusiness) handleLoanInsurance(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleLoanInsurance").
		WithField("order_id", order.GetID())
	logger.Info("loan insurance charge posted")
}

// handleLoanInsuranceRepayment processes a loan insurance repayment.
// Debit: member suspense -> Credit: insurance account.
func (b *transferOrderBusiness) handleLoanInsuranceRepayment(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleLoanInsuranceRepayment").
		WithField("order_id", order.GetID())
	logger.Info("loan insurance repayment posted")
}

// handleDisbursement processes an external disbursement via the payment service.
// This is the actual money-out to the member's external account/mobile wallet.
func (b *transferOrderBusiness) handleDisbursement(ctx context.Context, order *models.TransferOrder) error {
	logger := util.Log(ctx).WithField("handler", "handleDisbursement").
		WithField("order_id", order.GetID())

	recipientID := extraDataString(order, "recipient_id")
	paymentChannel := extraDataString(order, "payment_channel")

	logger.WithField("recipient_id", recipientID).
		WithField("payment_channel", paymentChannel).
		Info("initiating external disbursement")

	route := paymentChannel
	if route == "" {
		route = "disbursement"
	}

	if err := b.sendPayment(ctx, order, recipientID, route); err != nil {
		return fmt.Errorf("disbursement payment for recipient %s: %w", recipientID, err)
	}

	return nil
}

// handleDisbursementReversal reverses a failed disbursement.
// Credit goes back to group bank from the disbursement holding account.
func (b *transferOrderBusiness) handleDisbursementReversal(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleDisbursementReversal").
		WithField("order_id", order.GetID())

	originalOrderID := extraDataString(order, "original_order_id")

	logger.WithField("original_order_id", originalOrderID).
		Info("disbursement reversal processed")
}

// handleDisbursementReversalReroute processes a disbursement reversal that is
// rerouted to a different payment channel or account.
func (b *transferOrderBusiness) handleDisbursementReversalReroute(
	ctx context.Context,
	order *models.TransferOrder,
) error {
	logger := util.Log(ctx).WithField("handler", "handleDisbursementReversalReroute").
		WithField("order_id", order.GetID())

	originalOrderID := extraDataString(order, "original_order_id")
	newChannel := extraDataString(order, "new_payment_channel")

	recipientID := extraDataString(order, "recipient_id")

	logger.WithField("original_order_id", originalOrderID).
		WithField("new_channel", newChannel).
		Info("disbursement reversal rerouted to new channel")

	route := newChannel
	if route == "" {
		route = "disbursement_reroute"
	}

	if err := b.sendPayment(ctx, order, recipientID, route); err != nil {
		return fmt.Errorf("rerouted disbursement for recipient %s: %w", recipientID, err)
	}

	return nil
}

// ---------------------------------------------------------------------------
// Savings-related handlers
// ---------------------------------------------------------------------------

// handlePeriodicSaving processes a periodic savings deposit.
// Debit: member suspense -> Credit: member periodic savings.
// Side effect: records the deposit in Lender savings.
func (b *transferOrderBusiness) handlePeriodicSaving(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handlePeriodicSaving").
		WithField("order_id", order.GetID())

	memberID := extraDataString(order, "member_id")
	savingsAccountID := extraDataString(order, "savings_account_id")

	logger.WithField("member_id", memberID).
		WithField("savings_account_id", savingsAccountID).
		WithField("amount", order.Amount).
		Info("recording periodic savings deposit")

	// Savings deposit recording is handled by the savings app via its own event
	// pipeline. The operations app manages the ledger posting which handles the
	// accounting side of the deposit.
}

// handlePeriodicSavingRecovery processes a recovery transfer for a missed periodic saving.
// The member is being charged for previously missed savings contributions.
func (b *transferOrderBusiness) handlePeriodicSavingRecovery(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handlePeriodicSavingRecovery").
		WithField("order_id", order.GetID())

	memberID := extraDataString(order, "member_id")
	periodID := extraDataString(order, "period_id")

	logger.WithField("member_id", memberID).
		WithField("period_id", periodID).
		Info("periodic saving recovery processed")
}

// handleSavingsInterestDistribution processes the distribution of savings interest
// income to group members proportional to their savings balances.
func (b *transferOrderBusiness) handleSavingsInterestDistribution(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleSavingsInterestDistribution").
		WithField("order_id", order.GetID())

	groupID := extraDataString(order, "group_id")

	logger.WithField("group_id", groupID).
		Info("savings interest income distribution processed")
}

// handleRegistrationFee processes a member registration fee payment.
// Debit: member suspense -> Credit: group joining fee account.
func (b *transferOrderBusiness) handleRegistrationFee(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleRegistrationFee").
		WithField("order_id", order.GetID())

	memberID := extraDataString(order, "member_id")

	logger.WithField("member_id", memberID).
		Info("registration fee processed")
}

// handleTerminalDisbursement processes a terminal (end-of-tenure) savings
// disbursement back to the member.
func (b *transferOrderBusiness) handleTerminalDisbursement(ctx context.Context, order *models.TransferOrder) error {
	logger := util.Log(ctx).WithField("handler", "handleTerminalDisbursement").
		WithField("order_id", order.GetID())

	memberID := extraDataString(order, "member_id")

	logger.WithField("member_id", memberID).
		Info("terminal disbursement: initiating payout to member")

	if err := b.sendPayment(ctx, order, memberID, "terminal_disbursement"); err != nil {
		return fmt.Errorf("terminal disbursement payment for member %s: %w", memberID, err)
	}

	return nil
}

// handleTerminalDisbursementRecovery processes a recovery for a failed terminal
// disbursement. Funds are moved back to the savings account for retry.
func (b *transferOrderBusiness) handleTerminalDisbursementRecovery(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleTerminalDisbursementRecovery").
		WithField("order_id", order.GetID())

	originalOrderID := extraDataString(order, "original_order_id")

	logger.WithField("original_order_id", originalOrderID).
		Info("terminal disbursement recovery processed")
}

// ---------------------------------------------------------------------------
// Payment flow handlers
// ---------------------------------------------------------------------------

// handlePaymentOutflow processes an outgoing payment.
// Debit: group bank -> Credit: product unidentified account.
// This is the initial receipt of funds before identification.
func (b *transferOrderBusiness) handlePaymentOutflow(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handlePaymentOutflow").
		WithField("order_id", order.GetID())

	transactionID := extraDataString(order, "transaction_id")

	logger.WithField("transaction_id", transactionID).
		Info("payment outflow posted to unidentified holding")
}

// handlePaymentIdentified processes a payment that has been identified to a
// specific member. Funds move from unidentified to unallocated.
func (b *transferOrderBusiness) handlePaymentIdentified(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handlePaymentIdentified").
		WithField("order_id", order.GetID())

	memberID := extraDataString(order, "member_id")
	paymentID := extraDataString(order, "payment_id")

	logger.WithField("member_id", memberID).
		WithField("payment_id", paymentID).
		Info("payment identified and moved to member suspense")
}

// handlePaymentAllocated processes a payment that has been allocated to specific
// obligations (loan repayment, savings, fees, etc.). This triggers creation of
// the downstream transfer orders for each allocation target.
func (b *transferOrderBusiness) handlePaymentAllocated(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handlePaymentAllocated").
		WithField("order_id", order.GetID())

	memberID := extraDataString(order, "member_id")
	paymentID := extraDataString(order, "payment_id")

	logger.WithField("member_id", memberID).
		WithField("payment_id", paymentID).
		Info("payment allocated to obligations")

	// NOTE: The payment routing business handles the creation of downstream
	// transfer orders for each obligation the payment is allocated against.
	// This handler only manages the base ledger movement.
}

// ---------------------------------------------------------------------------
// Penalty handlers
// ---------------------------------------------------------------------------

// handlePenalty processes a penalty charge against a member.
// Debit: member suspense -> Credit: group penalty income account.
func (b *transferOrderBusiness) handlePenalty(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handlePenalty").
		WithField("order_id", order.GetID())

	memberID := extraDataString(order, "member_id")
	reason := extraDataString(order, "penalty_reason")

	logger.WithField("member_id", memberID).
		WithField("reason", reason).
		Info("penalty charge posted")
}

// handlePenaltyCancel reverses a previously posted penalty.
// Debit: group penalty income -> Credit: member suspense.
func (b *transferOrderBusiness) handlePenaltyCancel(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handlePenaltyCancel").
		WithField("order_id", order.GetID())

	originalOrderID := extraDataString(order, "original_order_id")

	logger.WithField("original_order_id", originalOrderID).
		Info("penalty cancellation processed")
}

// handlePenaltyIncomeDistribution distributes accumulated penalty income to
// group members at the end of a tenure or period.
func (b *transferOrderBusiness) handlePenaltyIncomeDistribution(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handlePenaltyIncomeDistribution").
		WithField("order_id", order.GetID())

	groupID := extraDataString(order, "group_id")

	logger.WithField("group_id", groupID).
		Info("penalty income distribution processed")
}

// ---------------------------------------------------------------------------
// Other handlers
// ---------------------------------------------------------------------------

// handleCost processes a transaction cost charge.
// Debit: group bank -> Credit: group transaction costs account.
func (b *transferOrderBusiness) handleCost(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleCost").
		WithField("order_id", order.GetID())

	costType := extraDataString(order, "cost_type")

	logger.WithField("cost_type", costType).
		Info("transaction cost posted")
}

// handleServiceFee processes a platform service fee charge.
// Debit: group bank -> Credit: product service fee payable account.
func (b *transferOrderBusiness) handleServiceFee(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleServiceFee").
		WithField("order_id", order.GetID())

	periodID := extraDataString(order, "period_id")

	logger.WithField("period_id", periodID).
		Info("service fee posted")
}

// handleExternalLending processes a loan funding transfer from an external
// lending source into the group's bank account.
func (b *transferOrderBusiness) handleExternalLending(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleExternalLending").
		WithField("order_id", order.GetID())

	funderID := extraDataString(order, "funder_id")
	fundingID := extraDataString(order, "funding_id")

	logger.WithField("funder_id", funderID).
		WithField("funding_id", fundingID).
		Info("external lending funding received")
}

// handleExternalLendingPayback processes a payback from the group to the
// external lending source. This returns principal + interest to the funder.
func (b *transferOrderBusiness) handleExternalLendingPayback(ctx context.Context, order *models.TransferOrder) error {
	logger := util.Log(ctx).WithField("handler", "handleExternalLendingPayback").
		WithField("order_id", order.GetID())

	funderID := extraDataString(order, "funder_id")
	fundingID := extraDataString(order, "funding_id")

	logger.WithField("funder_id", funderID).
		WithField("funding_id", fundingID).
		Info("external lending payback: initiating funder payout")

	if err := b.sendPayment(ctx, order, funderID, "external_lending_payback"); err != nil {
		return fmt.Errorf("external lending payback payment for funder %s: %w", funderID, err)
	}

	return nil
}

// handleShutdownLoanRecovery processes loan recovery during group shutdown.
// Outstanding loan balances are recovered from member savings or guarantors.
func (b *transferOrderBusiness) handleShutdownLoanRecovery(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleShutdownLoanRecovery").
		WithField("order_id", order.GetID())

	memberID := extraDataString(order, "member_id")
	loanID := extraDataString(order, "loan_id")

	logger.WithField("member_id", memberID).
		WithField("loan_id", loanID).
		Info("shutdown loan recovery processed")
}

// handleInterSubscriptionPayment processes a payment between two different
// group subscriptions (e.g., transferring savings from one group to fund
// a loan in another).
func (b *transferOrderBusiness) handleInterSubscriptionPayment(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleInterSubscriptionPayment").
		WithField("order_id", order.GetID())

	sourceGroupID := extraDataString(order, "source_group_id")
	targetGroupID := extraDataString(order, "target_group_id")

	logger.WithField("source_group_id", sourceGroupID).
		WithField("target_group_id", targetGroupID).
		Info("inter-subscription payment processed")
}

// handleLoanInterestIncomeDistribution distributes accumulated loan interest
// income to group members proportional to their savings balances.
func (b *transferOrderBusiness) handleLoanInterestIncomeDistribution(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleLoanInterestIncomeDistribution").
		WithField("order_id", order.GetID())

	groupID := extraDataString(order, "group_id")

	logger.WithField("group_id", groupID).
		Info("loan interest income distribution processed")
}

// ---------------------------------------------------------------------------
// Investor-related handlers
// ---------------------------------------------------------------------------

// handleInvestorDeployment processes capital deployment from an investor account to fund a loan.
func (b *transferOrderBusiness) handleInvestorDeployment(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleInvestorDeployment").
		WithField("order_id", order.GetID())

	investorAccountID := extraDataString(order, "investor_account_id")
	loanOfferID := extraDataString(order, "loan_offer_id")

	logger.WithField("investor_account_id", investorAccountID).
		WithField("loan_offer_id", loanOfferID).
		WithField("amount", order.Amount).
		Info("investor capital deployed to loan")
}

// handleInvestorPrincipalReturn processes principal being returned to an investor account.
func (b *transferOrderBusiness) handleInvestorPrincipalReturn(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleInvestorPrincipalReturn").
		WithField("order_id", order.GetID())

	investorAccountID := extraDataString(order, "investor_account_id")

	logger.WithField("investor_account_id", investorAccountID).
		WithField("amount", order.Amount).
		Info("principal returned to investor")
}

// handleInvestorIncomeDistribution processes interest/income distribution to an investor.
// Platform fees and withholding tax have already been deducted by redistributeRepayment.
func (b *transferOrderBusiness) handleInvestorIncomeDistribution(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleInvestorIncomeDistribution").
		WithField("order_id", order.GetID())

	investorAccountID := extraDataString(order, "investor_account_id")

	logger.WithField("investor_account_id", investorAccountID).
		WithField("amount", order.Amount).
		Info("income distributed to investor (net of platform fees and tax)")
}

// handlePlatformFirstLossAbsorption processes a first-loss absorption from the platform reserve.
func (b *transferOrderBusiness) handlePlatformFirstLossAbsorption(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handlePlatformFirstLossAbsorption").
		WithField("order_id", order.GetID())

	loanOfferID := extraDataString(order, "loan_offer_id")

	logger.WithField("loan_offer_id", loanOfferID).
		WithField("amount", order.Amount).
		Info("platform first-loss reserve absorbed loss")
}

// handleInvestorLossAbsorption processes a loss absorption from an investor account.
func (b *transferOrderBusiness) handleInvestorLossAbsorption(
	ctx context.Context,
	order *models.TransferOrder,
) {
	logger := util.Log(ctx).WithField("handler", "handleInvestorLossAbsorption").
		WithField("order_id", order.GetID())

	investorAccountID := extraDataString(order, "investor_account_id")

	logger.WithField("investor_account_id", investorAccountID).
		WithField("amount", order.Amount).
		Info("investor account absorbed loss")
}

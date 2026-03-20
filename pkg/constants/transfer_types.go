package constants

// Transfer order type constants matching Java OrderType enum values exactly.
const (
	TransferTypePayment                                   = 1
	TransferTypePaymentIdentified                         = 2
	TransferTypePaymentAllocated                          = 3
	TransferTypeDisbursement                              = 6
	TransferTypeDisbursementReversal                      = 7
	TransferTypeDisbursementReversalReroute               = 8
	TransferTypeTerminalDisbursement                      = 9
	TransferTypeTerminalDisbursementRecovery              = 10
	TransferTypeCost                                      = 11
	TransferTypeServiceFee                                = 16
	TransferTypeRegistrationFee                           = 21
	TransferTypePeriodicSaving                            = 25
	TransferTypePeriodicSavingsInterestIncomeDistribution = 26
	TransferTypePeriodicSavingRecovery                    = 27
	TransferTypePenalty                                   = 31
	TransferTypePenaltyCancel                             = 32
	TransferTypePenaltyIncomeDistribution                 = 33
	TransferTypeLoanFundingExternalLending                = 36
	TransferTypeLoanFundingExternalLendingPayback         = 37
	TransferTypeInvestorDeployment                        = 38 // investor account → loan (capital deployed)
	TransferTypeInvestorPrincipalReturn                   = 39 // loan repayment → investor account (principal back)
	TransferTypeInvestorIncomeDistribution                = 40 // interest/fees → investor account (earnings)
	TransferTypeLoan                                      = 41
	TransferTypeLoanRepayment                             = 42
	TransferTypeShutdownLoanRecovery                      = 43
	TransferTypePlatformFirstLossAbsorption               = 44 // platform reserve → loss (first-loss triggered)
	TransferTypeInvestorLossAbsorption                    = 45 // investor account → loss (investor loss)
	TransferTypeLoanInterest                              = 46
	TransferTypeLoanInterestRepayment                     = 47
	TransferTypeLoanInterestIncomeDistribution            = 48
	TransferTypeLoanInsurance                             = 51
	TransferTypeLoanInsuranceRepayment                    = 52
	TransferTypeInterSubscriptionPayment                  = 71
)

// TransferTypeName returns a human-readable name for a transfer type.
func TransferTypeName(t int) string {
	switch t {
	case TransferTypePayment:
		return "PAYMENT"
	case TransferTypePaymentIdentified:
		return "PAYMENT_IDENTIFIED"
	case TransferTypePaymentAllocated:
		return "PAYMENT_ALLOCATED"
	case TransferTypeDisbursement:
		return "DISBURSEMENT"
	case TransferTypeDisbursementReversal:
		return "DISBURSEMENT_REVERSAL"
	case TransferTypeDisbursementReversalReroute:
		return "DISBURSEMENT_REVERSAL_REROUTE"
	case TransferTypeTerminalDisbursement:
		return "TERMINAL_DISBURSEMENT"
	case TransferTypeTerminalDisbursementRecovery:
		return "TERMINAL_DISBURSEMENT_RECOVERY"
	case TransferTypeCost:
		return "COST"
	case TransferTypeServiceFee:
		return "SERVICE_FEE"
	case TransferTypeRegistrationFee:
		return "REGISTRATION_FEE"
	case TransferTypePeriodicSaving:
		return "PERIODIC_SAVING"
	case TransferTypePeriodicSavingsInterestIncomeDistribution:
		return "PERIODIC_SAVINGS_INTEREST_INCOME_DISTRIBUTION"
	case TransferTypePeriodicSavingRecovery:
		return "PERIODIC_SAVING_RECOVERY"
	case TransferTypePenalty:
		return "PENALTY"
	case TransferTypePenaltyCancel:
		return "PENALTY_CANCEL"
	case TransferTypePenaltyIncomeDistribution:
		return "PENALTY_INCOME_DISTRIBUTION"
	case TransferTypeLoanFundingExternalLending:
		return "LOAN_FUNDING_EXTERNAL_LENDING"
	case TransferTypeLoanFundingExternalLendingPayback:
		return "LOAN_FUNDING_EXTERNAL_LENDING_PAYBACK"
	case TransferTypeLoan:
		return "LOAN"
	case TransferTypeLoanRepayment:
		return "LOAN_REPAYMENT"
	case TransferTypeShutdownLoanRecovery:
		return "SHUTDOWN_LOAN_RECOVERY"
	case TransferTypeLoanInterest:
		return "LOAN_INTEREST"
	case TransferTypeLoanInterestRepayment:
		return "LOAN_INTEREST_REPAYMENT"
	case TransferTypeLoanInterestIncomeDistribution:
		return "LOAN_INTEREST_INCOME_DISTRIBUTION"
	case TransferTypeLoanInsurance:
		return "LOAN_INSURANCE"
	case TransferTypeLoanInsuranceRepayment:
		return "LOAN_INSURANCE_REPAYMENT"
	case TransferTypeInvestorDeployment:
		return "INVESTOR_DEPLOYMENT"
	case TransferTypeInvestorPrincipalReturn:
		return "INVESTOR_PRINCIPAL_RETURN"
	case TransferTypeInvestorIncomeDistribution:
		return "INVESTOR_INCOME_DISTRIBUTION"
	case TransferTypePlatformFirstLossAbsorption:
		return "PLATFORM_FIRST_LOSS_ABSORPTION"
	case TransferTypeInvestorLossAbsorption:
		return "INVESTOR_LOSS_ABSORPTION"
	case TransferTypeInterSubscriptionPayment:
		return "INTER_SUBSCRIPTION_PAYMENT"
	default:
		return "UNKNOWN"
	}
}

// IsLoanRelated returns true if the transfer type is related to loan management.
func IsLoanRelated(t int) bool {
	switch t {
	case TransferTypeDisbursement, TransferTypeDisbursementReversal,
		TransferTypeLoan, TransferTypeLoanRepayment,
		TransferTypeLoanInterest, TransferTypeLoanInterestRepayment,
		TransferTypeLoanInsurance, TransferTypeLoanInsuranceRepayment,
		TransferTypeInvestorDeployment, TransferTypeInvestorPrincipalReturn,
		TransferTypeInvestorIncomeDistribution,
		TransferTypePlatformFirstLossAbsorption, TransferTypeInvestorLossAbsorption:
		return true
	default:
		return false
	}
}

// IsSavingsRelated returns true if the transfer type is related to savings.
func IsSavingsRelated(t int) bool {
	switch t {
	case TransferTypePeriodicSaving, TransferTypePeriodicSavingRecovery,
		TransferTypePeriodicSavingsInterestIncomeDistribution,
		TransferTypeRegistrationFee, TransferTypeTerminalDisbursement,
		TransferTypeTerminalDisbursementRecovery:
		return true
	default:
		return false
	}
}

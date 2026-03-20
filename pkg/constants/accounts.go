package constants

import "fmt"

// Product-level ledger account names.
func ProductUnallocatedAccount(productID string) string {
	return fmt.Sprintf("product:%s:unallocated", productID)
}

func ProductUnidentifiedAccount(productID string) string {
	return fmt.Sprintf("product:%s:unidentified", productID)
}

func ProductServiceFeePayableAccount(productID string) string {
	return fmt.Sprintf("product:%s:service_fee_payable", productID)
}

func ProductInsuranceAccount(productID string) string {
	return fmt.Sprintf("product:%s:insurance", productID)
}

// Group-level ledger account names.
func GroupBankAccount(groupID string) string {
	return fmt.Sprintf("group:%s:bank", groupID)
}

func GroupPenaltyIncomeAccount(groupID string) string {
	return fmt.Sprintf("group:%s:penalty_income", groupID)
}

func GroupInterestIncomeAccount(groupID string) string {
	return fmt.Sprintf("group:%s:interest_income", groupID)
}

func GroupJoiningFeeAccount(groupID string) string {
	return fmt.Sprintf("group:%s:joining_fee", groupID)
}

func GroupTransactionCostsAccount(groupID string) string {
	return fmt.Sprintf("group:%s:transaction_costs", groupID)
}

func GroupServiceFeeAccount(groupID string) string {
	return fmt.Sprintf("group:%s:service_fee", groupID)
}

func GroupSavingsInterestIncomeAccount(groupID string) string {
	return fmt.Sprintf("group:%s:savings_interest_income", groupID)
}

// Member-level ledger account names.
func MemberSuspenseAccount(memberID string) string {
	return fmt.Sprintf("member:%s:suspense", memberID)
}

func MemberLendingAccount(memberID string) string {
	return fmt.Sprintf("member:%s:lending", memberID)
}

func MemberPeriodicSavingsAccount(memberID string) string {
	return fmt.Sprintf("member:%s:periodic_savings", memberID)
}

func MemberLoansAccount(memberID string) string {
	return fmt.Sprintf("member:%s:loans", memberID)
}

// Investor-level ledger account names.
func InvestorCapitalAccount(investorAccountID string) string {
	return fmt.Sprintf("investor:%s:capital", investorAccountID)
}

func InvestorReservedAccount(investorAccountID string) string {
	return fmt.Sprintf("investor:%s:reserved", investorAccountID)
}

// Platform-level ledger account names.
func PlatformFirstLossAccount(productID string) string {
	return fmt.Sprintf("platform:%s:first_loss", productID)
}

func PlatformIncomeAccount(productID string) string {
	return fmt.Sprintf("platform:%s:income", productID)
}

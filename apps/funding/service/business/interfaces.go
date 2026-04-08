package business

import (
	"context"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
)

// LoanWindowBusiness handles loan window operations.
type LoanWindowBusiness interface {
	Evaluate(ctx context.Context, groupID string) (map[string]interface{}, error)
}

// LoanOfferBusiness handles loan offer operations.
type LoanOfferBusiness interface {
	GenerateForWindow(ctx context.Context, windowID string) (interface{}, error)
	Respond(ctx context.Context, offerID string, response int32) error
	CreateLoanAccount(ctx context.Context, offerID string) (map[string]interface{}, error)
}

// FundingAllocationBusiness handles funding allocation operations.
type FundingAllocationBusiness interface {
	SourceForOffer(ctx context.Context, offerID string) (map[string]interface{}, error)
	AbsorbLoss(ctx context.Context, loanOfferID string, lossAmount int64) error
}

// InvestorAccountBusiness handles investor account operations.
type InvestorAccountBusiness interface {
	Create(ctx context.Context, account *models.InvestorAccount) (*models.InvestorAccount, error)
	Get(ctx context.Context, accountID string) (*models.InvestorAccount, error)
	GetByInvestorID(ctx context.Context, investorID string) ([]*models.InvestorAccount, error)
	Deposit(ctx context.Context, accountID string, amount int64) error
	Withdraw(ctx context.Context, accountID string, amount int64) error
	GetAvailable(ctx context.Context, accountID string) (int64, error)
	ReserveBalance(ctx context.Context, accountID string, amount int64) error
	ReleaseBalance(ctx context.Context, accountID string, principalReturned int64, interestEarned int64) error
	AbsorbLoss(ctx context.Context, accountID string, lossAmount int64) error
}

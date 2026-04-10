package business

import (
	"context"

	"github.com/pitabwire/frame/data"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
)

// LoanOfferInfo is a lightweight projection of the loan offer for funding allocation.
type LoanOfferInfo struct {
	data.BaseModel
	Amount     int64
	Currency   string
	Properties data.JSONMap
}

// LoanOfferReader provides read access to loan offer data.
// Implemented by adapters in cmd/ that wrap stawi repos or SDK clients.
type LoanOfferReader interface {
	GetByID(ctx context.Context, id string) (*LoanOfferInfo, error)
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

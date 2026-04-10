package business

import (
	"context"

	"github.com/pitabwire/frame/data"

	"github.com/antinvestor/service-fintech/apps/funding/service/models"
)

// LoanRequestInfo is a lightweight projection of the loan request for funding allocation.
type LoanRequestInfo struct {
	data.BaseModel
	Amount     int64
	Currency   string
	Properties data.JSONMap
}

// LoanRequestReader provides read access to canonical loan request data.
// Implemented by adapters in cmd/ that bridge legacy sources into a coherent request view.
type LoanRequestReader interface {
	GetByID(ctx context.Context, id string) (*LoanRequestInfo, error)
}

// FundingAllocationBusiness handles funding allocation operations.
type FundingAllocationBusiness interface {
	SourceForRequest(ctx context.Context, loanRequestID string) (map[string]interface{}, error)
	AbsorbLoss(ctx context.Context, loanRequestID string, lossAmount int64) error
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

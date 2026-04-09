package business

// deps.go defines local interfaces and lightweight data types for external
// service dependencies. Implementations are injected by cmd/main.go so the
// business layer never imports identity, stawi, or funding packages directly.

import (
	"context"
	"time"

	"github.com/pitabwire/frame/data"
)

// ---------------------------------------------------------------------------
// Identity: groups & memberships
// ---------------------------------------------------------------------------

// MembershipState / type constants used by payment routing and obligation logic.
const (
	MembershipTypeMember int32 = 3 // identitymodels.MembershipTypeMember
	GroupStateDeleted    int32 = 5 // identitymodels.GroupStateDeleted
	GroupStateShutdown   int32 = 6 // identitymodels.GroupStateShutdown
)

// MemberInfo is a lightweight projection of identity's Membership model.
// Only the fields that the operations business layer accesses are included.
type MemberInfo struct {
	data.BaseModel
	GroupID        string
	ProfileID      string
	Name           string
	ContactID      string
	MembershipType int32
	State          int32
}

// GroupInfo is a lightweight projection of identity's ClientGroup model.
type GroupInfo struct {
	data.BaseModel
	SavingAmount int64
	CurrencyCode string
	State        int32
}

// MembershipReader provides read access to membership data.
type MembershipReader interface {
	GetByID(ctx context.Context, id string) (*MemberInfo, error)
	GetByGroupID(ctx context.Context, groupID string, offset, limit int) ([]*MemberInfo, error)
	GetByProfileID(ctx context.Context, profileID string, offset, limit int) ([]*MemberInfo, error)
}

// GroupReader provides read access to client group data.
type GroupReader interface {
	GetByID(ctx context.Context, id string) (*GroupInfo, error)
}

// ---------------------------------------------------------------------------
// Stawi: periods
// ---------------------------------------------------------------------------

// PeriodInfo is a lightweight projection of stawi's Period model.
type PeriodInfo struct {
	data.BaseModel
	EndDate  *time.Time
	Position int32
}

// PeriodReader provides read access to period data.
type PeriodReader interface {
	GetCurrentByGroupID(ctx context.Context, groupID string) (*PeriodInfo, error)
}

// ---------------------------------------------------------------------------
// Funding: loan fundings, tranches, investor accounts
// ---------------------------------------------------------------------------

// FundingSource defines the source of loan funding (mirrors fundingmodels.FundingSource).
type FundingSource int32

const (
	FundingSourceUnspecified        FundingSource = 0
	FundingSourceGroupSavings       FundingSource = 1
	FundingSourceGroupIncome        FundingSource = 2
	FundingSourceInvestorAffiliated FundingSource = 3
	FundingSourceInvestorGeneral    FundingSource = 4
	FundingSourcePlatformReserve    FundingSource = 5
)

// LoanFundingInfo is a lightweight projection of funding's LoanFunding model.
type LoanFundingInfo struct {
	data.BaseModel
	OwnerID     string
	FundingType int32
	Proportion  int64
}

// FundingTrancheInfo is a lightweight projection of funding's FundingTranche model.
type FundingTrancheInfo struct {
	data.BaseModel
	PrincipalRepaid int64
	InterestEarned  int64
}

// InvestorAccountInfo is a lightweight projection of funding's InvestorAccount model.
type InvestorAccountInfo struct {
	data.BaseModel
	ReservedBalance  int64
	AvailableBalance int64
	TotalReturned    int64
}

// LoanFundingReader provides read access to loan funding data.
type LoanFundingReader interface {
	GetByLoanOfferID(ctx context.Context, loanOfferID string) ([]*LoanFundingInfo, error)
}

// FundingTrancheManager provides read/write access to funding tranche data.
type FundingTrancheManager interface {
	GetByLoanFundingID(ctx context.Context, loanFundingID string) ([]*FundingTrancheInfo, error)
	Save(ctx context.Context, tranche *FundingTrancheInfo) error
}

// InvestorAccountManager provides read/write access to investor account data.
type InvestorAccountManager interface {
	GetByID(ctx context.Context, id string) (*InvestorAccountInfo, error)
	Save(ctx context.Context, account *InvestorAccountInfo) error
}

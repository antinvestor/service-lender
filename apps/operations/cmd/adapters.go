package main

// adapters.go provides thin wrapper types that adapt external service
// repositories (identity, stawi, funding) to the local interfaces defined
// in the operations business layer. This keeps all cross-service imports
// confined to the cmd package.

import (
	"context"

	fundingmodels "github.com/antinvestor/service-fintech/apps/funding/service/models"
	fundingrepo "github.com/antinvestor/service-fintech/apps/funding/service/repository"
	identitymodels "github.com/antinvestor/service-fintech/apps/identity/service/models"
	identityrepo "github.com/antinvestor/service-fintech/apps/identity/service/repository"
	"github.com/antinvestor/service-fintech/apps/operations/service/business"
	stawimodels "github.com/antinvestor/service-fintech/apps/stawi/service/models"
	stawirepo "github.com/antinvestor/service-fintech/apps/stawi/service/repository"
	fevents "github.com/pitabwire/frame/events"
)

// ---------------------------------------------------------------------------
// Identity adapters
// ---------------------------------------------------------------------------

type membershipAdapter struct {
	repo identityrepo.MembershipRepository
}

func (a *membershipAdapter) GetByID(ctx context.Context, id string) (*business.MemberInfo, error) {
	m, err := a.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return memberToInfo(m), nil
}

func (a *membershipAdapter) GetByGroupID(
	ctx context.Context,
	groupID string,
	offset, limit int,
) ([]*business.MemberInfo, error) {
	members, err := a.repo.GetByGroupID(ctx, groupID, offset, limit)
	if err != nil {
		return nil, err
	}
	return membersToInfos(members), nil
}

func (a *membershipAdapter) GetByProfileID(
	ctx context.Context,
	profileID string,
	offset, limit int,
) ([]*business.MemberInfo, error) {
	members, err := a.repo.GetByProfileID(ctx, profileID, offset, limit)
	if err != nil {
		return nil, err
	}
	return membersToInfos(members), nil
}

func memberToInfo(m *identitymodels.Membership) *business.MemberInfo {
	if m == nil {
		return nil
	}
	info := &business.MemberInfo{
		GroupID:        m.GroupID,
		ProfileID:      m.ProfileID,
		Name:           m.Name,
		ContactID:      m.ContactID,
		MembershipType: m.MembershipType,
		State:          m.State,
	}
	info.BaseModel = m.BaseModel
	return info
}

func membersToInfos(members []*identitymodels.Membership) []*business.MemberInfo {
	result := make([]*business.MemberInfo, len(members))
	for i, m := range members {
		result[i] = memberToInfo(m)
	}
	return result
}

type groupAdapter struct {
	repo identityrepo.ClientGroupRepository
}

func (a *groupAdapter) GetByID(ctx context.Context, id string) (*business.GroupInfo, error) {
	g, err := a.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	info := &business.GroupInfo{
		SavingAmount: g.SavingAmount,
		CurrencyCode: g.CurrencyCode,
		State:        g.State,
	}
	info.BaseModel = g.BaseModel
	return info, nil
}

// ---------------------------------------------------------------------------
// Stawi adapter
// ---------------------------------------------------------------------------

type periodAdapter struct {
	repo stawirepo.PeriodRepository
}

func (a *periodAdapter) GetCurrentByGroupID(ctx context.Context, groupID string) (*business.PeriodInfo, error) {
	p, err := a.repo.GetCurrentByGroupID(ctx, groupID)
	if err != nil {
		return nil, err
	}
	return periodToInfo(p), nil
}

func periodToInfo(p *stawimodels.Period) *business.PeriodInfo {
	if p == nil {
		return nil
	}
	info := &business.PeriodInfo{
		EndDate:  p.EndDate,
		Position: p.Position,
	}
	info.BaseModel = p.BaseModel
	return info
}

// ---------------------------------------------------------------------------
// Funding adapters
// ---------------------------------------------------------------------------

type loanFundingAdapter struct {
	repo fundingrepo.LoanFundingRepository
}

func (a *loanFundingAdapter) GetByLoanOfferID(
	ctx context.Context,
	loanOfferID string,
) ([]*business.LoanFundingInfo, error) {
	fundings, err := a.repo.GetByLoanOfferID(ctx, loanOfferID)
	if err != nil {
		return nil, err
	}
	result := make([]*business.LoanFundingInfo, len(fundings))
	for i, f := range fundings {
		info := &business.LoanFundingInfo{
			OwnerID:     f.OwnerID,
			FundingType: f.FundingType,
			Proportion:  f.Proportion,
		}
		info.BaseModel = f.BaseModel
		result[i] = info
	}
	return result, nil
}

type fundingTrancheAdapter struct {
	repo      fundingrepo.FundingTrancheRepository
	eventsMan fevents.Manager
}

func (a *fundingTrancheAdapter) GetByLoanFundingID(
	ctx context.Context,
	loanFundingID string,
) ([]*business.FundingTrancheInfo, error) {
	tranches, err := a.repo.GetByLoanFundingID(ctx, loanFundingID)
	if err != nil {
		return nil, err
	}
	result := make([]*business.FundingTrancheInfo, len(tranches))
	for i, t := range tranches {
		info := &business.FundingTrancheInfo{
			PrincipalRepaid: t.PrincipalRepaid,
			InterestEarned:  t.InterestEarned,
		}
		info.BaseModel = t.BaseModel
		result[i] = info
	}
	return result, nil
}

func (a *fundingTrancheAdapter) Save(ctx context.Context, tranche *business.FundingTrancheInfo) error {
	// Convert back to the funding model and emit save event.
	model := &fundingmodels.FundingTranche{
		PrincipalRepaid: tranche.PrincipalRepaid,
		InterestEarned:  tranche.InterestEarned,
	}
	model.BaseModel = tranche.BaseModel
	return a.eventsMan.Emit(ctx, "funding_tranche.save", model)
}

type investorAccountAdapter struct {
	repo      fundingrepo.InvestorAccountRepository
	eventsMan fevents.Manager
}

func (a *investorAccountAdapter) GetByID(ctx context.Context, id string) (*business.InvestorAccountInfo, error) {
	acct, err := a.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	info := &business.InvestorAccountInfo{
		ReservedBalance:  acct.ReservedBalance,
		AvailableBalance: acct.AvailableBalance,
		TotalReturned:    acct.TotalReturned,
	}
	info.BaseModel = acct.BaseModel
	return info, nil
}

func (a *investorAccountAdapter) Save(ctx context.Context, account *business.InvestorAccountInfo) error {
	// Convert back to the funding model and emit save event.
	model := &fundingmodels.InvestorAccount{
		ReservedBalance:  account.ReservedBalance,
		AvailableBalance: account.AvailableBalance,
		TotalReturned:    account.TotalReturned,
	}
	model.BaseModel = account.BaseModel
	return a.eventsMan.Emit(ctx, "investor_account.save", model)
}

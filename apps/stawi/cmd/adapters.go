package main

// adapters.go provides thin wrapper types that adapt external service
// repositories to the local interfaces defined in the operations business
// layer, keeping cross-service imports out of the business packages.

import (
	"context"

	fundingbusiness "github.com/antinvestor/service-fintech/apps/funding/service/business"
	fundingmodels "github.com/antinvestor/service-fintech/apps/funding/service/models"
	fundingrepo "github.com/antinvestor/service-fintech/apps/funding/service/repository"
	identitymodels "github.com/antinvestor/service-fintech/apps/identity/service/models"
	identityrepo "github.com/antinvestor/service-fintech/apps/identity/service/repository"
	opsbusiness "github.com/antinvestor/service-fintech/apps/operations/service/business"
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

func (a *membershipAdapter) GetByID(ctx context.Context, id string) (*opsbusiness.MemberInfo, error) {
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
) ([]*opsbusiness.MemberInfo, error) {
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
) ([]*opsbusiness.MemberInfo, error) {
	members, err := a.repo.GetByProfileID(ctx, profileID, offset, limit)
	if err != nil {
		return nil, err
	}
	return membersToInfos(members), nil
}

func memberToInfo(m *identitymodels.Membership) *opsbusiness.MemberInfo {
	if m == nil {
		return nil
	}
	info := &opsbusiness.MemberInfo{
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

func membersToInfos(members []*identitymodels.Membership) []*opsbusiness.MemberInfo {
	result := make([]*opsbusiness.MemberInfo, len(members))
	for i, m := range members {
		result[i] = memberToInfo(m)
	}
	return result
}

type groupAdapter struct {
	repo identityrepo.ClientGroupRepository
}

func (a *groupAdapter) GetByID(ctx context.Context, id string) (*opsbusiness.GroupInfo, error) {
	g, err := a.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	info := &opsbusiness.GroupInfo{
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

func (a *periodAdapter) GetCurrentByGroupID(ctx context.Context, groupID string) (*opsbusiness.PeriodInfo, error) {
	p, err := a.repo.GetCurrentByGroupID(ctx, groupID)
	if err != nil {
		return nil, err
	}
	return periodToInfo(p), nil
}

func periodToInfo(p *stawimodels.Period) *opsbusiness.PeriodInfo {
	if p == nil {
		return nil
	}
	info := &opsbusiness.PeriodInfo{
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
) ([]*opsbusiness.LoanFundingInfo, error) {
	fundings, err := a.repo.GetByLoanOfferID(ctx, loanOfferID)
	if err != nil {
		return nil, err
	}
	result := make([]*opsbusiness.LoanFundingInfo, len(fundings))
	for i, f := range fundings {
		info := &opsbusiness.LoanFundingInfo{
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
) ([]*opsbusiness.FundingTrancheInfo, error) {
	tranches, err := a.repo.GetByLoanFundingID(ctx, loanFundingID)
	if err != nil {
		return nil, err
	}
	result := make([]*opsbusiness.FundingTrancheInfo, len(tranches))
	for i, t := range tranches {
		info := &opsbusiness.FundingTrancheInfo{
			PrincipalRepaid: t.PrincipalRepaid,
			InterestEarned:  t.InterestEarned,
		}
		info.BaseModel = t.BaseModel
		result[i] = info
	}
	return result, nil
}

func (a *fundingTrancheAdapter) Save(ctx context.Context, tranche *opsbusiness.FundingTrancheInfo) error {
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

func (a *investorAccountAdapter) GetByID(ctx context.Context, id string) (*opsbusiness.InvestorAccountInfo, error) {
	acct, err := a.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	info := &opsbusiness.InvestorAccountInfo{
		ReservedBalance:  acct.ReservedBalance,
		AvailableBalance: acct.AvailableBalance,
		TotalReturned:    acct.TotalReturned,
	}
	info.BaseModel = acct.BaseModel
	return info, nil
}

func (a *investorAccountAdapter) Save(ctx context.Context, account *opsbusiness.InvestorAccountInfo) error {
	model := &fundingmodels.InvestorAccount{
		ReservedBalance:  account.ReservedBalance,
		AvailableBalance: account.AvailableBalance,
		TotalReturned:    account.TotalReturned,
	}
	model.BaseModel = account.BaseModel
	return a.eventsMan.Emit(ctx, "investor_account.save", model)
}

// ---------------------------------------------------------------------------
// Funding membership adapter (for LoanOfferBusiness)
// ---------------------------------------------------------------------------

type fundingMembershipAdapter struct {
	repo identityrepo.MembershipRepository
}

func (a *fundingMembershipAdapter) GetByGroupID(
	ctx context.Context,
	groupID string,
	offset, limit int,
) ([]*fundingbusiness.MemberInfo, error) {
	members, err := a.repo.GetByGroupID(ctx, groupID, offset, limit)
	if err != nil {
		return nil, err
	}
	result := make([]*fundingbusiness.MemberInfo, len(members))
	for i, m := range members {
		info := &fundingbusiness.MemberInfo{
			GroupID:        m.GroupID,
			ProfileID:      m.ProfileID,
			Name:           m.Name,
			MembershipType: m.MembershipType,
			State:          m.State,
			Properties:     m.Properties,
		}
		info.ID = m.ID
		result[i] = info
	}
	return result, nil
}

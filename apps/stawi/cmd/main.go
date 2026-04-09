package main

import (
	"context"
	"net/http"

	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	"github.com/antinvestor/common"
	"github.com/antinvestor/common/connection"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/config"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/util"

	aconfig "github.com/antinvestor/service-fintech/apps/stawi/config"

	// Stawi domain (Tenure, Period, Motion, Infraction, LoanWindow, LoanOffer)
	stawibusiness "github.com/antinvestor/service-fintech/apps/stawi/service/business"
	stawievents "github.com/antinvestor/service-fintech/apps/stawi/service/events"
	"github.com/antinvestor/service-fintech/apps/stawi/service/handlers"
	stawimodels "github.com/antinvestor/service-fintech/apps/stawi/service/models"
	stawirepo "github.com/antinvestor/service-fintech/apps/stawi/service/repository"

	// Funding domain (LoanFunding, FundingAllocation, InvestorAccount, FundingTranche)
	fundingbusiness "github.com/antinvestor/service-fintech/apps/funding/service/business"
	fundingevents "github.com/antinvestor/service-fintech/apps/funding/service/events"
	fundingmodels "github.com/antinvestor/service-fintech/apps/funding/service/models"
	fundingrepo "github.com/antinvestor/service-fintech/apps/funding/service/repository"

	// Operations domain
	opsbusiness "github.com/antinvestor/service-fintech/apps/operations/service/business"
	opsevents "github.com/antinvestor/service-fintech/apps/operations/service/events"
	opsrepo "github.com/antinvestor/service-fintech/apps/operations/service/repository"

	// Platform clients
	"github.com/antinvestor/service-fintech/pkg/clients"

	fevents "github.com/pitabwire/frame/events"
)

func main() {
	tmpCtx := context.Background()

	cfg, err := config.LoadWithOIDC[aconfig.StawiConfig](tmpCtx)
	if err != nil {
		util.Log(tmpCtx).With("err", err).Error("could not process configs")
		return
	}

	if cfg.Name() == "" {
		cfg.ServiceName = "service_stawi"
	}

	ctx, svc := frame.NewServiceWithContext(
		tmpCtx,
		frame.WithConfig(&cfg),
		frame.WithDatastore(),
	)
	defer svc.Stop(ctx)
	log := util.Log(ctx)

	dbManager := svc.DatastoreManager()
	workMan := svc.WorkManager()
	evtsMan := svc.EventsManager()

	// Handle database migration if requested (stawi domain only)
	if handleDatabaseMigration(ctx, dbManager, cfg) {
		return
	}

	// Get database pool
	dbPool := dbManager.GetPool(ctx, datastore.DefaultPoolName)
	if dbPool == nil {
		log.Error("Database pool is nil - check DATABASE_PRIMARY_URL environment variable")
		return
	}

	// --- Identity SDK client (for ClientGroup + Membership) ---
	identityCli, idErr := setupIdentityClient(ctx, cfg)
	if idErr != nil {
		log.WithError(idErr).Warn("main -- Could not setup identity client")
	}

	// --- Platform clients ---
	platformClients, pcErr := clients.NewPlatformClients(ctx, &cfg, cfg.ServiceEndpoints())
	if pcErr != nil {
		log.WithError(pcErr).Warn("main -- Some platform clients could not be initialised")
	}

	// --- Stawi repositories (Tenure, Period, Motion, Infraction, LoanWindow, LoanOffer) ---
	tenRepo := stawirepo.NewTenureRepository(ctx, dbPool, workMan)
	perRepo := stawirepo.NewPeriodRepository(ctx, dbPool, workMan)
	motRepo := stawirepo.NewMotionRepository(ctx, dbPool, workMan)
	infRepo := stawirepo.NewInfractionRepository(ctx, dbPool, workMan)
	lwRepo := stawirepo.NewLoanWindowRepository(ctx, dbPool, workMan)
	loRepo := stawirepo.NewLoanOfferRepository(ctx, dbPool, workMan)

	// --- Funding repositories (needed by workflow callbacks) ---
	lfRepo := fundingrepo.NewLoanFundingRepository(ctx, dbPool, workMan)
	faRepo := fundingrepo.NewFundingAllocationRepository(ctx, dbPool, workMan)
	ftRepo := fundingrepo.NewFundingTrancheRepository(ctx, dbPool, workMan)
	iaRepo := fundingrepo.NewInvestorAccountRepository(ctx, dbPool, workMan)

	// --- Operations repositories (needed by workflow callbacks) ---
	toRepo := opsrepo.NewTransferOrderRepository(ctx, dbPool, workMan)
	obRepo := opsrepo.NewObligationRepository(ctx, dbPool, workMan)
	ipRepo := opsrepo.NewIncomingPaymentRepository(ctx, dbPool, workMan)
	arRepo := opsrepo.NewAccountRefRepository(ctx, dbPool, workMan)
	csRepo := opsrepo.NewCBSSyncRecordRepository(ctx, dbPool, workMan)

	// --- Stawi business (uses identity SDK for group/membership) ---
	grpBiz := stawibusiness.NewClientGroupBusiness(ctx, identityCli, platformClients)
	memBiz := stawibusiness.NewMembershipBusiness(ctx, identityCli)
	tenBiz := stawibusiness.NewTenureBusiness(ctx, evtsMan, identityCli, tenRepo, perRepo)
	perBiz := stawibusiness.NewPeriodBusiness(ctx, evtsMan, tenRepo, perRepo)
	_ = stawibusiness.NewMotionBusiness(ctx, evtsMan, motRepo)

	// --- Stawi loan window/offer business ---
	lwBiz := stawibusiness.NewLoanWindowBusiness(ctx, evtsMan, lwRepo)
	loBiz := stawibusiness.NewLoanOfferBusiness(ctx, evtsMan, loRepo, lwRepo, identityCli, platformClients)

	// --- Funding business (for workflow callbacks) ---
	lfBiz := fundingbusiness.NewFundingAllocationBusiness(
		ctx,
		evtsMan,
		lfRepo,
		faRepo,
		&loanOfferAdapter{repo: loRepo},
		iaRepo,
		ftRepo,
		platformClients,
	)

	// --- Cross-domain adapters for operations business ---
	perAdapter := &periodAdapter{repo: perRepo}
	lfAdapter := &loanFundingAdapter{repo: lfRepo}
	ftAdapter := &fundingTrancheAdapter{repo: ftRepo, eventsMan: evtsMan}
	iaAdapter := &investorAccountAdapter{repo: iaRepo, eventsMan: evtsMan}

	// --- Operations business (for workflow callbacks, uses identity SDK directly) ---
	prBiz := opsbusiness.NewPaymentRoutingBusiness(
		ctx,
		evtsMan,
		ipRepo,
		toRepo,
		obRepo,
		arRepo,
		identityCli,
		platformClients,
	)
	toBiz := opsbusiness.NewTransferOrderBusiness(
		ctx,
		evtsMan,
		toRepo,
		csRepo,
		arRepo,
		lfAdapter,
		ftAdapter,
		iaAdapter,
		platformClients,
	)
	obBiz := opsbusiness.NewObligationBusiness(ctx, evtsMan, obRepo, identityCli, perAdapter)

	// --- HTTP mux with workflow callbacks only ---
	mux := http.NewServeMux()
	handlers.RegisterWorkflowCallbacks(mux, grpBiz, memBiz, tenBiz, perBiz,
		lwBiz, loBiz, lfBiz, prBiz, toBiz, obBiz, platformClients)

	// --- Assemble service options ---
	serviceOptions := []frame.Option{
		frame.WithHTTPHandler(mux),
		frame.WithRegisterEvents(
			// Stawi events (lifecycle + loan window/offer)
			stawievents.NewTenureSave(ctx, tenRepo),
			stawievents.NewPeriodSave(ctx, perRepo),
			stawievents.NewMotionSave(ctx, motRepo),
			stawievents.NewInfractionSave(ctx, infRepo),
			stawievents.NewLoanWindowSave(ctx, lwRepo),
			stawievents.NewLoanOfferSave(ctx, loRepo),
			// Funding events
			fundingevents.NewLoanFundingSave(ctx, lfRepo),
			fundingevents.NewFundingAllocationSave(ctx, faRepo),
			fundingevents.NewFundingTrancheSave(ctx, ftRepo),
			fundingevents.NewInvestorAccountSave(ctx, iaRepo),
			// Operations events
			opsevents.NewTransferOrderSave(ctx, toRepo),
			opsevents.NewObligationSave(ctx, obRepo),
			opsevents.NewIncomingPaymentSave(ctx, ipRepo),
			opsevents.NewAccountRefSave(ctx, arRepo),
			opsevents.NewCBSSyncRecordSave(ctx, csRepo),
		),
	}

	svc.Init(ctx, serviceOptions...)

	err = svc.Run(ctx, "")
	if err != nil {
		log.WithError(err).Fatal("could not run Server")
	}
}

func handleDatabaseMigration(
	ctx context.Context,
	dbManager datastore.Manager,
	cfg aconfig.StawiConfig,
) bool {
	if cfg.DoDatabaseMigrate() {
		migrationPath := cfg.GetDatabaseMigrationPath()
		if err := stawirepo.Migrate(ctx, dbManager, migrationPath); err != nil {
			util.Log(ctx).WithError(err).Fatal("main -- Could not migrate stawi tables")
		}
		return true
	}
	return false
}

func setupIdentityClient(
	ctx context.Context,
	cfg aconfig.StawiConfig,
) (identityv1connect.IdentityServiceClient, error) {
	return connection.NewServiceClient(ctx, &cfg, common.ServiceTarget{
		Endpoint:  cfg.IdentityServiceURI,
		Audiences: []string{"service_identity"},
	}, identityv1connect.NewIdentityServiceClient)
}

// ---------------------------------------------------------------------------
// Cross-domain adapters (funding repos, stawi period, stawi loan offer)
// ---------------------------------------------------------------------------

// loanOfferAdapter wraps stawi's LoanOfferRepository for funding's LoanOfferReader.
type loanOfferAdapter struct {
	repo stawirepo.LoanOfferRepository
}

func (a *loanOfferAdapter) GetByID(ctx context.Context, id string) (*fundingbusiness.LoanOfferInfo, error) {
	offer, err := a.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return loanOfferToInfo(offer), nil
}

func loanOfferToInfo(o *stawimodels.LoanOffer) *fundingbusiness.LoanOfferInfo {
	if o == nil {
		return nil
	}
	info := &fundingbusiness.LoanOfferInfo{
		Amount:     o.Amount,
		Currency:   o.Currency,
		Properties: o.Properties,
	}
	info.BaseModel = o.BaseModel
	return info
}

// periodAdapter wraps stawi's PeriodRepository for operations' PeriodReader.
type periodAdapter struct {
	repo stawirepo.PeriodRepository
}

func (a *periodAdapter) GetCurrentByGroupID(ctx context.Context, groupID string) (*opsbusiness.PeriodInfo, error) {
	p, err := a.repo.GetCurrentByGroupID(ctx, groupID)
	if err != nil {
		return nil, err
	}
	if p == nil {
		return nil, nil
	}
	info := &opsbusiness.PeriodInfo{
		EndDate:  p.EndDate,
		Position: p.Position,
	}
	info.BaseModel = p.BaseModel
	return info, nil
}

// loanFundingAdapter wraps funding's LoanFundingRepository for operations' LoanFundingReader.
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

package business

import (
	"context"
	"strconv"
	"time"

	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"buf.build/gen/go/antinvestor/loans/connectrpc/go/loans/v1/loansv1connect"
	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-lender/apps/origination/service/events"
	"github.com/antinvestor/service-lender/apps/origination/service/models"
	"github.com/antinvestor/service-lender/apps/origination/service/repository"
)

// Terminal statuses cannot transition further.
var terminalStatuses = map[int32]bool{ //nolint:gochecknoglobals // status machine registry
	int32(originationv1.ApplicationStatus_APPLICATION_STATUS_LOAN_CREATED):   true,
	int32(originationv1.ApplicationStatus_APPLICATION_STATUS_CANCELLED):      true,
	int32(originationv1.ApplicationStatus_APPLICATION_STATUS_EXPIRED):        true,
	int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_DECLINED): true,
	int32(originationv1.ApplicationStatus_APPLICATION_STATUS_REJECTED):       true,
}

type ApplicationBusiness interface {
	Save(ctx context.Context, obj *originationv1.ApplicationObject) (*originationv1.ApplicationObject, error)
	Get(ctx context.Context, id string) (*originationv1.ApplicationObject, error)
	Search(
		ctx context.Context,
		req *originationv1.ApplicationSearchRequest,
		consumer func(ctx context.Context, batch []*originationv1.ApplicationObject) error,
	) error
	Submit(ctx context.Context, id string) (*originationv1.ApplicationObject, error)
	Cancel(ctx context.Context, id, reason string) (*originationv1.ApplicationObject, error)
	AcceptOffer(ctx context.Context, id string) (*originationv1.ApplicationObject, error)
	DeclineOffer(ctx context.Context, id, reason string) (*originationv1.ApplicationObject, error)

	// TransitionStatus is used internally by other business modules to advance the workflow.
	TransitionStatus(ctx context.Context, id string, newStatus originationv1.ApplicationStatus, reason string) error
}

type applicationBusiness struct {
	eventsMan    fevents.Manager
	appRepo      repository.ApplicationRepository
	identityCli  identityv1connect.FieldServiceClient
	loanMgmtCli  loansv1connect.LoanManagementServiceClient
}

func NewApplicationBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	appRepo repository.ApplicationRepository,
	identityCli identityv1connect.FieldServiceClient,
	loanMgmtCli loansv1connect.LoanManagementServiceClient,
) ApplicationBusiness {
	return &applicationBusiness{
		eventsMan:   eventsMan,
		appRepo:     appRepo,
		identityCli: identityCli,
		loanMgmtCli: loanMgmtCli,
	}
}

func (b *applicationBusiness) Save(ctx context.Context, obj *originationv1.ApplicationObject) (*originationv1.ApplicationObject, error) {
	logger := util.Log(ctx).WithField("method", "ApplicationBusiness.Save")

	isNew := obj.GetId() == ""
	app := models.ApplicationFromAPI(ctx, obj)

	if isNew {
		if app.Status == 0 {
			app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_DRAFT)
		}

		// Validate client exists via identity service
		if b.identityCli != nil && app.ClientID != "" {
			_, err := b.identityCli.ClientGet(ctx, connect.NewRequest(&identityv1.ClientGetRequest{
				Id: app.ClientID,
			}))
			if err != nil {
				logger.WithError(err).Warn("client validation failed")
				return nil, ErrClientNotFound
			}
		}

		// Validate agent exists via identity service
		if b.identityCli != nil && app.AgentID != "" {
			_, err := b.identityCli.AgentGet(ctx, connect.NewRequest(&identityv1.AgentGetRequest{
				Id: app.AgentID,
			}))
			if err != nil {
				logger.WithError(err).Warn("agent validation failed")
				return nil, ErrAgentNotFound
			}
		}
	}

	err := b.eventsMan.Emit(ctx, events.ApplicationSaveEvent, app)
	if err != nil {
		logger.WithError(err).Error("could not emit application save event")
		return nil, err
	}

	return app.ToAPI(), nil
}

func (b *applicationBusiness) Get(ctx context.Context, id string) (*originationv1.ApplicationObject, error) {
	app, err := b.appRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrApplicationNotFound
	}
	return app.ToAPI(), nil
}

//nolint:dupl // similar search logic for different entity types
func (b *applicationBusiness) Search(
	ctx context.Context,
	req *originationv1.ApplicationSearchRequest,
	consumer func(ctx context.Context, batch []*originationv1.ApplicationObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "ApplicationBusiness.Search")

	var searchOpts []data.SearchOption

	cursor := req.GetCursor()
	if cursor != nil {
		offset, offsetErr := strconv.Atoi(cursor.GetPage())
		if offsetErr != nil {
			offset = 0
		}
		searchOpts = append(searchOpts, data.WithSearchOffset(offset), data.WithSearchLimit(int(cursor.GetLimit())))
	}

	andQueryVal := map[string]any{}
	if req.GetClientId() != "" {
		andQueryVal["client_id = ?"] = req.GetClientId()
	}
	if req.GetAgentId() != "" {
		andQueryVal["agent_id = ?"] = req.GetAgentId()
	}
	if req.GetBranchId() != "" {
		andQueryVal["branch_id = ?"] = req.GetBranchId()
	}
	if req.GetBankId() != "" {
		andQueryVal["bank_id = ?"] = req.GetBankId()
	}
	if req.GetStatus() != originationv1.ApplicationStatus_APPLICATION_STATUS_UNSPECIFIED {
		andQueryVal["status = ?"] = int32(req.GetStatus())
	}

	if len(andQueryVal) > 0 {
		searchOpts = append(searchOpts, data.WithSearchFiltersAndByValue(andQueryVal))
	}

	if req.GetQuery() != "" {
		searchOpts = append(searchOpts,
			data.WithSearchFiltersOrByValue(
				map[string]any{"searchable @@ websearch_to_tsquery( 'english', ?) ": req.GetQuery()},
			),
		)
	}

	query := data.NewSearchQuery(searchOpts...)
	results, err := b.appRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search applications")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Application) error {
		var apiResults []*originationv1.ApplicationObject
		for _, app := range res {
			apiResults = append(apiResults, app.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

func (b *applicationBusiness) Submit(ctx context.Context, id string) (*originationv1.ApplicationObject, error) {
	logger := util.Log(ctx).WithField("method", "ApplicationBusiness.Submit")

	app, err := b.appRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrApplicationNotFound
	}

	if app.Status != int32(originationv1.ApplicationStatus_APPLICATION_STATUS_DRAFT) {
		return nil, ErrApplicationNotDraft
	}

	previousStatus := app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_SUBMITTED)
	now := time.Now()
	app.SubmittedAt = &now

	if err := b.emitTransition(ctx, logger, app, previousStatus, ""); err != nil {
		return nil, err
	}

	// Auto-advance: SUBMITTED → KYC_PENDING (simplified workflow without Trustage)
	previousStatus = app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_KYC_PENDING)
	if advErr := b.emitTransition(ctx, logger, app, previousStatus, "auto-advance after submission"); advErr != nil {
		logger.WithError(advErr).Warn("could not auto-advance to KYC_PENDING")
	}

	// Auto-advance: KYC_PENDING → DOCUMENTS_PENDING (KYC assumed complete for now)
	previousStatus = app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_DOCUMENTS_PENDING)
	if advErr := b.emitTransition(ctx, logger, app, previousStatus, "auto-advance KYC complete"); advErr != nil {
		logger.WithError(advErr).Warn("could not auto-advance to DOCUMENTS_PENDING")
	}

	// Auto-advance: DOCUMENTS_PENDING → VERIFICATION (ready for verifier tasks)
	previousStatus = app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_VERIFICATION)
	if advErr := b.emitTransition(ctx, logger, app, previousStatus, "auto-advance documents received"); advErr != nil {
		logger.WithError(advErr).Warn("could not auto-advance to VERIFICATION")
	}

	return app.ToAPI(), nil
}

func (b *applicationBusiness) Cancel(ctx context.Context, id, reason string) (*originationv1.ApplicationObject, error) {
	logger := util.Log(ctx).WithField("method", "ApplicationBusiness.Cancel")

	app, err := b.appRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrApplicationNotFound
	}

	if terminalStatuses[app.Status] {
		return nil, ErrApplicationTerminal
	}

	previousStatus := app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_CANCELLED)
	app.RejectionReason = reason

	if err := b.emitTransition(ctx, logger, app, previousStatus, reason); err != nil {
		return nil, err
	}

	return app.ToAPI(), nil
}

func (b *applicationBusiness) AcceptOffer(ctx context.Context, id string) (*originationv1.ApplicationObject, error) {
	logger := util.Log(ctx).WithField("method", "ApplicationBusiness.AcceptOffer")

	app, err := b.appRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrApplicationNotFound
	}

	if app.Status != int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_GENERATED) {
		return nil, ErrApplicationNotOfferGenerated
	}

	previousStatus := app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_ACCEPTED)

	if err := b.emitTransition(ctx, logger, app, previousStatus, ""); err != nil {
		return nil, err
	}

	// Create loan account in the Loan Management service
	if b.loanMgmtCli != nil {
		createResp, createErr := b.loanMgmtCli.LoanAccountCreate(ctx, connect.NewRequest(
			&loansv1.LoanAccountCreateRequest{
				ApplicationId: app.GetID(),
			},
		))
		if createErr != nil {
			logger.WithError(createErr).Error("could not create loan account")
			return nil, ErrLoanCreationFailed
		}

		// Record the loan account ID and transition to LOAN_CREATED
		app.LoanAccountID = createResp.Msg.GetData().GetId()
		previousStatus = app.Status
		app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_LOAN_CREATED)

		if transErr := b.emitTransition(ctx, logger, app, previousStatus, "loan account created"); transErr != nil {
			return nil, transErr
		}
	}

	return app.ToAPI(), nil
}

func (b *applicationBusiness) DeclineOffer(ctx context.Context, id, reason string) (*originationv1.ApplicationObject, error) {
	logger := util.Log(ctx).WithField("method", "ApplicationBusiness.DeclineOffer")

	app, err := b.appRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrApplicationNotFound
	}

	if app.Status != int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_GENERATED) {
		return nil, ErrApplicationNotOfferGenerated
	}

	previousStatus := app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_DECLINED)
	app.RejectionReason = reason

	if err := b.emitTransition(ctx, logger, app, previousStatus, reason); err != nil {
		return nil, err
	}

	return app.ToAPI(), nil
}

func (b *applicationBusiness) TransitionStatus(
	ctx context.Context,
	id string,
	newStatus originationv1.ApplicationStatus,
	reason string,
) error {
	logger := util.Log(ctx).WithField("method", "ApplicationBusiness.TransitionStatus")

	app, err := b.appRepo.GetByID(ctx, id)
	if err != nil {
		return ErrApplicationNotFound
	}

	if terminalStatuses[app.Status] {
		return ErrApplicationTerminal
	}

	previousStatus := app.Status
	app.Status = int32(newStatus)

	return b.emitTransition(ctx, logger, app, previousStatus, reason)
}

// emitTransition emits both the application save event and the status history event.
func (b *applicationBusiness) emitTransition(
	ctx context.Context,
	logger *util.LogEntry,
	app *models.Application,
	previousStatus int32,
	reason string,
) error {
	err := b.eventsMan.Emit(ctx, events.ApplicationSaveEvent, app)
	if err != nil {
		logger.WithError(err).Error("could not emit application save event")
		return err
	}

	history := &models.ApplicationStatusHistory{
		ApplicationID:  app.GetID(),
		PreviousStatus: previousStatus,
		NewStatus:      app.Status,
		Reason:         reason,
	}
	history.GenID(ctx)

	err = b.eventsMan.Emit(ctx, events.ApplicationStatusHistorySaveEvent, history)
	if err != nil {
		logger.WithError(err).Error("could not emit application status history save event")
		return err
	}

	return nil
}

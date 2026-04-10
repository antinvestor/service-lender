package business

import (
	"context"
	"fmt"
	"strconv"
	"time"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	"buf.build/gen/go/antinvestor/field/connectrpc/go/field/v1/fieldv1connect"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	"buf.build/gen/go/antinvestor/loans/connectrpc/go/loans/v1/loansv1connect"
	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"
	structpb "google.golang.org/protobuf/types/known/structpb"

	"github.com/antinvestor/service-fintech/apps/origination/service/events"
	"github.com/antinvestor/service-fintech/apps/origination/service/models"
	"github.com/antinvestor/service-fintech/apps/origination/service/repository"
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
	CheckEligibility(ctx context.Context, clientID, productID string, requestedAmount int64) error

	// TransitionStatus is used internally by other business modules to advance the workflow.
	TransitionStatus(ctx context.Context, id string, newStatus originationv1.ApplicationStatus, reason string) error
}

type applicationBusiness struct {
	eventsMan    fevents.Manager
	appRepo      repository.ApplicationRepository
	cpaRepo      repository.ClientProductAccessRepository
	riskAssessor *RiskAssessor
	identityCli  fieldv1connect.FieldServiceClient
	loanMgmtCli  loansv1connect.LoanManagementServiceClient
}

func NewApplicationBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	appRepo repository.ApplicationRepository,
	cpaRepo repository.ClientProductAccessRepository,
	identityCli fieldv1connect.FieldServiceClient,
	loanMgmtCli loansv1connect.LoanManagementServiceClient,
) ApplicationBusiness {
	return &applicationBusiness{
		eventsMan:    eventsMan,
		appRepo:      appRepo,
		cpaRepo:      cpaRepo,
		riskAssessor: NewRiskAssessor(identityCli, appRepo),
		identityCli:  identityCli,
		loanMgmtCli:  loanMgmtCli,
	}
}

func (b *applicationBusiness) Save(
	ctx context.Context,
	obj *originationv1.ApplicationObject,
) (*originationv1.ApplicationObject, error) {
	logger := util.Log(ctx).WithField("method", "ApplicationBusiness.Save")

	isNew := obj.GetId() == ""
	app := models.ApplicationFromAPI(ctx, obj)

	if isNew {
		if app.Status == 0 {
			app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_DRAFT)
		}
		if err := b.validateNewApplication(ctx, logger, app); err != nil {
			return nil, err
		}
	}

	err := b.eventsMan.Emit(ctx, events.ApplicationSaveEvent, app)
	if err != nil {
		logger.WithError(err).Error("could not emit application save event")
		return nil, err
	}

	return app.ToAPI(), nil
}

// validateNewApplication runs identity and eligibility checks for a new application.
func (b *applicationBusiness) validateNewApplication(
	ctx context.Context,
	logger *util.LogEntry,
	app *models.Application,
) error {
	if b.identityCli != nil && app.ClientID != "" {
		resp, err := b.identityCli.ClientGet(ctx, connect.NewRequest(&fieldv1.ClientGetRequest{
			Id: app.ClientID,
		}))
		if err != nil {
			logger.WithError(err).Warn("client validation failed")
			return ErrClientNotFound
		}
		if !isClientEligibleForLending(resp.Msg.GetData()) {
			logger.WithField("client_id", app.ClientID).Warn("client is not active for lending")
			return ErrClientNotActive
		}
	}

	if b.identityCli != nil && app.AgentID != "" {
		_, err := b.identityCli.AgentGet(ctx, connect.NewRequest(&fieldv1.AgentGetRequest{
			Id: app.AgentID,
		}))
		if err != nil {
			logger.WithError(err).Warn("agent validation failed")
			return ErrAgentNotFound
		}
	}

	if app.ClientID != "" && app.ProductID != "" {
		return b.CheckEligibility(ctx, app.ClientID, app.ProductID, app.RequestedAmount)
	}

	return nil
}

func (b *applicationBusiness) Get(ctx context.Context, id string) (*originationv1.ApplicationObject, error) {
	app, err := b.appRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrApplicationNotFound
	}
	return app.ToAPI(), nil
}

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
	if req.GetOrganizationId() != "" {
		andQueryVal["bank_id = ?"] = req.GetOrganizationId()
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

	if err = b.emitTransition(ctx, logger, app, previousStatus, ""); err != nil {
		return nil, err
	}

	// Direct client products skip the origination workflow entirely.
	// These clients were onboarded and verified by agents before they ever
	// reach a loan request portal (app, USSD, etc). The product-level flag
	// "direct_borrower" controls this — it is set on the application
	// properties when the loan request originates from a direct client
	// product channel.
	if isDirectClientProduct(app) {
		return b.submitDirectClient(ctx, logger, app)
	}

	// Standard product: go through the full verification workflow.
	return b.submitWithVerificationWorkflow(ctx, logger, app)
}

// isDirectClientProduct returns true if the application is for a direct
// client product. Direct client products are pre-verified at onboarding
// time by agents, so no origination workflow (KYC, documents, verification,
// underwriting) is needed. The flag is set in Properties by the originating
// channel (app, USSD) based on the loan product configuration.
func isDirectClientProduct(app *models.Application) bool {
	if app.Properties == nil {
		return false
	}
	v, ok := app.Properties["direct_borrower"]
	if !ok {
		return false
	}
	b, isBool := v.(bool)
	return isBool && b
}

// submitDirectClient handles submission for direct client products.
// The client was onboarded and verified by an agent (full KYC, documents,
// verification, and underwriting happened during onboarding).
//
// For all direct client loan requests the system:
//  1. Runs automated risk checks (data consistency, fraud signals)
//  2. Records the findings on the application
//  3. Routes to UNDERWRITING for the responsible agent to approve/reject
//
// The agent is always in the loop — they are responsible for the customer.
// Risk check results are available to the agent to inform their decision.
func (b *applicationBusiness) submitDirectClient(
	ctx context.Context,
	logger *util.LogEntry,
	app *models.Application,
) (*originationv1.ApplicationObject, error) {
	logger.WithFields(map[string]any{"client_id": app.ClientID, "product_id": app.ProductID}).
		Debug("direct client product — running automated risk checks before agent review")

	// Run automated risk checks (name/ID consistency, fraud signals, etc.)
	riskResult := b.riskAssessor.Assess(ctx, app)

	// Store risk assessment results on the application for the agent's review
	if app.Properties == nil {
		app.Properties = make(map[string]interface{})
	}
	app.Properties["risk_assessment_passed"] = riskResult.Passed
	if len(riskResult.Flags) > 0 {
		flagSummaries := make([]interface{}, 0, len(riskResult.Flags))
		for _, f := range riskResult.Flags {
			flagSummaries = append(flagSummaries, map[string]interface{}{
				"code": f.Code, "severity": f.Severity, "message": f.Message,
			})
		}
		app.Properties["risk_flags"] = flagSummaries
	}

	// Route to UNDERWRITING — the responsible agent reviews the request
	// along with the automated risk findings and makes the final decision.
	reason := "direct client: automated risk checks complete, awaiting agent approval"
	if !riskResult.Passed {
		reason = "direct client: automated risk checks flagged issues, requires agent review"
		logger.WithField("flags", len(riskResult.Flags)).
			Warn("risk assessment flagged issues for agent review")
	}

	previousStatus := app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_UNDERWRITING)
	if err := b.emitTransition(ctx, logger, app, previousStatus, reason); err != nil {
		return nil, err
	}

	// Persist the risk assessment data
	if err := b.eventsMan.Emit(ctx, events.ApplicationSaveEvent, app); err != nil {
		logger.WithError(err).Error("could not save risk assessment results")
		return nil, err
	}

	return app.ToAPI(), nil
}

// submitWithVerificationWorkflow runs the standard origination flow for
// products that require KYC, document collection, and manual verification:
// SUBMITTED → KYC_PENDING → DOCUMENTS_PENDING → VERIFICATION.
func (b *applicationBusiness) submitWithVerificationWorkflow(
	ctx context.Context,
	logger *util.LogEntry,
	app *models.Application,
) (*originationv1.ApplicationObject, error) {
	// Stop at KYC_PENDING until the downstream onboarding and verification
	// steps have been explicitly completed.
	previousStatus := app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_KYC_PENDING)
	if advErr := b.emitTransition(ctx, logger, app, previousStatus, "awaiting KYC completion"); advErr != nil {
		logger.WithError(advErr).Warn("could not transition application to KYC_PENDING")
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

	if err = b.emitTransition(ctx, logger, app, previousStatus, reason); err != nil {
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

	// Enforce offer expiry
	if app.OfferExpiresAt != nil && time.Now().After(*app.OfferExpiresAt) {
		return nil, ErrOfferExpired
	}

	previousStatus := app.Status
	app.Status = int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_ACCEPTED)

	if err = b.emitTransition(ctx, logger, app, previousStatus, ""); err != nil {
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

func (b *applicationBusiness) DeclineOffer(
	ctx context.Context,
	id, reason string,
) (*originationv1.ApplicationObject, error) {
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

	if err = b.emitTransition(ctx, logger, app, previousStatus, reason); err != nil {
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

// CheckEligibility verifies that a client can apply for a loan product.
// A client is eligible when:
//  1. They have access to the requested product (via ClientProductAccess, or unrestricted)
//  2. The requested amount is within the client's effective credit limit
//  3. They have no outstanding (active/delinquent/defaulted) loans in the loan management service
//  4. They have no in-progress loan applications in origination
func (b *applicationBusiness) CheckEligibility(
	ctx context.Context,
	clientID, productID string,
	requestedAmount int64,
) error {
	logger := util.Log(ctx).WithFields(map[string]any{
		"method": "ApplicationBusiness.CheckEligibility", "client_id": clientID, "product_id": productID,
	})

	// 1. Check product access
	if b.cpaRepo != nil {
		hasAccess, err := b.cpaRepo.HasAccess(ctx, clientID, productID)
		if err != nil {
			logger.WithError(err).Error("could not check product access")
			return ErrEligibilityCheckFailed
		} else if !hasAccess {
			return ErrProductAccessDenied
		}
	}

	// 2. Check credit limit via identity service
	if err := b.checkCreditLimit(ctx, logger, clientID, requestedAmount); err != nil {
		return err
	}

	// 3. Check for active loans via loan management service
	if b.loanMgmtCli != nil {
		if err := b.checkNoActiveLoans(ctx, clientID); err != nil {
			return err
		}
	}

	// 4. Check for in-progress applications in origination
	if err := b.checkNoPendingApplications(ctx, clientID); err != nil {
		return err
	}

	return nil
}

// checkCreditLimit verifies the requested amount is within the client's effective credit limit.
func (b *applicationBusiness) checkCreditLimit(
	ctx context.Context,
	logger *util.LogEntry,
	clientID string,
	requestedAmount int64,
) error {
	if b.identityCli == nil || requestedAmount <= 0 {
		return nil
	}

	resp, err := b.identityCli.ClientGet(ctx, connect.NewRequest(&fieldv1.ClientGetRequest{
		Id: clientID,
	}))
	if err != nil {
		logger.WithError(err).Error("could not verify credit limit")
		return ErrCreditLimitCheckFailed
	}

	client := resp.Msg.GetData()
	props := client.GetProperties()
	if props == nil {
		return nil
	}

	fields := props.GetFields()
	systemLimit := protoFieldInt64(fields, "system_credit_limit")
	agentLimit := protoFieldInt64(fields, "agent_credit_limit")

	effectiveLimit := systemLimit
	if agentLimit > 0 && agentLimit < effectiveLimit {
		effectiveLimit = agentLimit
	}

	if effectiveLimit > 0 && requestedAmount > effectiveLimit {
		logger.WithFields(map[string]any{"requested": requestedAmount, "effective_limit": effectiveLimit}).
			Warn("requested amount exceeds credit limit")
		return ErrAmountExceedsCreditLimit
	}

	return nil
}

// protoFieldInt64 extracts an int64 from a protobuf Struct's fields map.
func protoFieldInt64(fields map[string]*structpb.Value, key string) int64 {
	if fields == nil {
		return 0
	}
	v, ok := fields[key]
	if !ok || v == nil {
		return 0
	}
	return int64(v.GetNumberValue())
}

// checkNoActiveLoans queries the loan management service for any outstanding loans.
// A loan is considered outstanding if it is in ACTIVE, DELINQUENT, DEFAULT,
// PENDING_DISBURSEMENT, or RESTRUCTURED status.
func (b *applicationBusiness) checkNoActiveLoans(ctx context.Context, clientID string) error {
	logger := util.Log(ctx).WithField("method", "checkNoActiveLoans")

	// Check each non-cleared status. The search API uses streaming but we only
	// need to know if at least one record exists.
	outstandingStatuses := []loansv1.LoanStatus{
		loansv1.LoanStatus_LOAN_STATUS_PENDING_DISBURSEMENT,
		loansv1.LoanStatus_LOAN_STATUS_ACTIVE,
		loansv1.LoanStatus_LOAN_STATUS_DELINQUENT,
		loansv1.LoanStatus_LOAN_STATUS_DEFAULT,
		loansv1.LoanStatus_LOAN_STATUS_RESTRUCTURED,
	}

	for _, status := range outstandingStatuses {
		req := (&loansv1.LoanAccountSearchRequest_builder{
			ClientId: clientID,
			Status:   status,
		}).Build()

		stream, err := b.loanMgmtCli.LoanAccountSearch(ctx, connect.NewRequest(req))
		if err != nil {
			logger.WithError(err).Error("could not query loan accounts")
			return fmt.Errorf("%w: active loan lookup unavailable", ErrEligibilityCheckFailed)
		}

		if stream.Receive() {
			resp := stream.Msg()
			if len(resp.GetData()) > 0 {
				_ = stream.Close()
				return ErrClientHasActiveLoan
			}
		}
		_ = stream.Close()
	}

	return nil
}

// checkNoPendingApplications verifies the client has no in-progress applications.
// An application is in-progress if it is not in a terminal status.
func (b *applicationBusiness) checkNoPendingApplications(ctx context.Context, clientID string) error {
	logger := util.Log(ctx).WithField("method", "checkNoPendingApplications")

	// Build a list of non-terminal statuses as int32 values for IN query
	nonTerminalStatuses := []int32{
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_DRAFT),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_SUBMITTED),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_KYC_PENDING),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_DOCUMENTS_PENDING),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_VERIFICATION),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_UNDERWRITING),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_APPROVED),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_GENERATED),
		int32(originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_ACCEPTED),
	}

	query := data.NewSearchQuery(
		data.WithSearchFiltersAndByValue(map[string]any{
			"client_id = ?": clientID,
			"status IN (?)": nonTerminalStatuses,
		}),
		data.WithSearchLimit(1),
	)

	results, err := b.appRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("could not search applications")
		return fmt.Errorf("%w: pending application lookup unavailable", ErrEligibilityCheckFailed)
	}

	found := false
	_ = workerpoolConsumeStream(ctx, results, func(batch []*models.Application) error {
		if len(batch) > 0 {
			found = true
		}
		return nil
	})

	if found {
		return ErrClientHasPendingApplication
	}

	return nil
}

func isClientEligibleForLending(client *fieldv1.ClientObject) bool {
	if client == nil {
		return false
	}

	return client.GetState() == commonv1.STATE_ACTIVE
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

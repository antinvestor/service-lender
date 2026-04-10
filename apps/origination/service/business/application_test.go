package business

import (
	"context"
	"errors"
	"testing"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/frame/queue"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/origination/service/models"
)

var errUnexpectedStubCall = errors.New("unexpected stub call")

func TestValidateNewApplicationRejectsInactiveClient(t *testing.T) {
	t.Parallel()

	ctx := context.Background()
	appBusiness := &applicationBusiness{
		identityCli: &fieldServiceClientStub{
			clientGetResp: connect.NewResponse(&fieldv1.ClientGetResponse{
				Data: &fieldv1.ClientObject{
					Id:    "client-1",
					Name:  "Client One",
					State: commonv1.STATE_CREATED,
				},
			}),
			agentGetResp: connect.NewResponse(&fieldv1.AgentGetResponse{
				Data: &fieldv1.AgentObject{Id: "agent-1", Name: "Agent One", State: commonv1.STATE_ACTIVE},
			}),
		},
	}

	err := appBusiness.validateNewApplication(ctx, testLogEntry(ctx), &models.Application{
		ClientID:  "client-1",
		AgentID:   "agent-1",
		ProductID: "",
	})

	if !errors.Is(err, ErrClientNotActive) {
		t.Fatalf("expected ErrClientNotActive, got %v", err)
	}
}

func TestCheckNoActiveLoansFailsClosedWhenLoanServiceUnavailable(t *testing.T) {
	t.Parallel()

	ctx := context.Background()
	appBusiness := &applicationBusiness{
		loanMgmtCli: &loanManagementClientStub{
			loanAccountSearchErr: errors.New("loan service unavailable"),
		},
	}

	err := appBusiness.checkNoActiveLoans(ctx, "client-1")

	if !errors.Is(err, ErrEligibilityCheckFailed) {
		t.Fatalf("expected ErrEligibilityCheckFailed, got %v", err)
	}
}

func TestSubmitWithVerificationWorkflowStopsAtKycPending(t *testing.T) {
	t.Parallel()

	ctx := context.Background()
	app := &models.Application{
		Status: int32(originationv1.ApplicationStatus_APPLICATION_STATUS_SUBMITTED),
	}
	app.GenID(ctx)

	appBusiness := &applicationBusiness{
		eventsMan: &eventsManagerStub{},
	}

	result, err := appBusiness.submitWithVerificationWorkflow(ctx, testLogEntry(ctx), app)

	if err != nil {
		t.Fatalf("submitWithVerificationWorkflow returned error: %v", err)
	}
	if got := result.GetStatus(); got != originationv1.ApplicationStatus_APPLICATION_STATUS_KYC_PENDING {
		t.Fatalf("expected KYC_PENDING, got %v", got)
	}
}

func testLogEntry(ctx context.Context) *util.LogEntry {
	return util.Log(ctx)
}

type eventsManagerStub struct{}

func (e *eventsManagerStub) Add(fevents.EventI) {}

func (e *eventsManagerStub) Get(string) (fevents.EventI, error) { panic(errUnexpectedStubCall) }

func (e *eventsManagerStub) Emit(context.Context, string, any) error { return nil }

func (e *eventsManagerStub) Handler() queue.SubscribeWorker { return nil }

type fieldServiceClientStub struct {
	clientGetResp *connect.Response[fieldv1.ClientGetResponse]
	clientGetErr  error
	agentGetResp  *connect.Response[fieldv1.AgentGetResponse]
	agentGetErr   error
}

func (c *fieldServiceClientStub) AgentSave(
	context.Context,
	*connect.Request[fieldv1.AgentSaveRequest],
) (*connect.Response[fieldv1.AgentSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *fieldServiceClientStub) AgentGet(
	context.Context,
	*connect.Request[fieldv1.AgentGetRequest],
) (*connect.Response[fieldv1.AgentGetResponse], error) {
	return c.agentGetResp, c.agentGetErr
}

func (c *fieldServiceClientStub) AgentSearch(
	context.Context,
	*connect.Request[fieldv1.AgentSearchRequest],
) (*connect.ServerStreamForClient[fieldv1.AgentSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *fieldServiceClientStub) AgentHierarchy(
	context.Context,
	*connect.Request[fieldv1.AgentHierarchyRequest],
) (*connect.ServerStreamForClient[fieldv1.AgentHierarchyResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *fieldServiceClientStub) AgentBranchSave(
	context.Context,
	*connect.Request[fieldv1.AgentBranchSaveRequest],
) (*connect.Response[fieldv1.AgentBranchSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *fieldServiceClientStub) AgentBranchDelete(
	context.Context,
	*connect.Request[fieldv1.AgentBranchDeleteRequest],
) (*connect.Response[fieldv1.AgentBranchDeleteResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *fieldServiceClientStub) AgentBranchList(
	context.Context,
	*connect.Request[fieldv1.AgentBranchListRequest],
) (*connect.ServerStreamForClient[fieldv1.AgentBranchListResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *fieldServiceClientStub) ClientSave(
	context.Context,
	*connect.Request[fieldv1.ClientSaveRequest],
) (*connect.Response[fieldv1.ClientSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *fieldServiceClientStub) ClientGet(
	context.Context,
	*connect.Request[fieldv1.ClientGetRequest],
) (*connect.Response[fieldv1.ClientGetResponse], error) {
	return c.clientGetResp, c.clientGetErr
}

func (c *fieldServiceClientStub) ClientSearch(
	context.Context,
	*connect.Request[fieldv1.ClientSearchRequest],
) (*connect.ServerStreamForClient[fieldv1.ClientSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *fieldServiceClientStub) ClientReassign(
	context.Context,
	*connect.Request[fieldv1.ClientReassignRequest],
) (*connect.Response[fieldv1.ClientReassignResponse], error) {
	panic(errUnexpectedStubCall)
}

type loanManagementClientStub struct {
	loanAccountSearchErr error
}

func (c *loanManagementClientStub) LoanAccountCreate(
	context.Context,
	*connect.Request[loansv1.LoanAccountCreateRequest],
) (*connect.Response[loansv1.LoanAccountCreateResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) LoanAccountGet(
	context.Context,
	*connect.Request[loansv1.LoanAccountGetRequest],
) (*connect.Response[loansv1.LoanAccountGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) LoanAccountSearch(
	context.Context,
	*connect.Request[loansv1.LoanAccountSearchRequest],
) (*connect.ServerStreamForClient[loansv1.LoanAccountSearchResponse], error) {
	return nil, c.loanAccountSearchErr
}

func (c *loanManagementClientStub) LoanBalanceGet(
	context.Context,
	*connect.Request[loansv1.LoanBalanceGetRequest],
) (*connect.Response[loansv1.LoanBalanceGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) LoanStatement(
	context.Context,
	*connect.Request[loansv1.LoanStatementRequest],
) (*connect.Response[loansv1.LoanStatementResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) DisbursementCreate(
	context.Context,
	*connect.Request[loansv1.DisbursementCreateRequest],
) (*connect.Response[loansv1.DisbursementCreateResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) DisbursementGet(
	context.Context,
	*connect.Request[loansv1.DisbursementGetRequest],
) (*connect.Response[loansv1.DisbursementGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) DisbursementSearch(
	context.Context,
	*connect.Request[loansv1.DisbursementSearchRequest],
) (*connect.ServerStreamForClient[loansv1.DisbursementSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) RepaymentRecord(
	context.Context,
	*connect.Request[loansv1.RepaymentRecordRequest],
) (*connect.Response[loansv1.RepaymentRecordResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) RepaymentGet(
	context.Context,
	*connect.Request[loansv1.RepaymentGetRequest],
) (*connect.Response[loansv1.RepaymentGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) RepaymentSearch(
	context.Context,
	*connect.Request[loansv1.RepaymentSearchRequest],
) (*connect.ServerStreamForClient[loansv1.RepaymentSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) RepaymentScheduleGet(
	context.Context,
	*connect.Request[loansv1.RepaymentScheduleGetRequest],
) (*connect.Response[loansv1.RepaymentScheduleGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) PenaltySave(
	context.Context,
	*connect.Request[loansv1.PenaltySaveRequest],
) (*connect.Response[loansv1.PenaltySaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) PenaltyWaive(
	context.Context,
	*connect.Request[loansv1.PenaltyWaiveRequest],
) (*connect.Response[loansv1.PenaltyWaiveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) PenaltySearch(
	context.Context,
	*connect.Request[loansv1.PenaltySearchRequest],
) (*connect.ServerStreamForClient[loansv1.PenaltySearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) LoanRestructureCreate(
	context.Context,
	*connect.Request[loansv1.LoanRestructureCreateRequest],
) (*connect.Response[loansv1.LoanRestructureCreateResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) LoanRestructureApprove(
	context.Context,
	*connect.Request[loansv1.LoanRestructureApproveRequest],
) (*connect.Response[loansv1.LoanRestructureApproveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) LoanRestructureReject(
	context.Context,
	*connect.Request[loansv1.LoanRestructureRejectRequest],
) (*connect.Response[loansv1.LoanRestructureRejectResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) LoanRestructureSearch(
	context.Context,
	*connect.Request[loansv1.LoanRestructureSearchRequest],
) (*connect.ServerStreamForClient[loansv1.LoanRestructureSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) ReconciliationSave(
	context.Context,
	*connect.Request[loansv1.ReconciliationSaveRequest],
) (*connect.Response[loansv1.ReconciliationSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) ReconciliationSearch(
	context.Context,
	*connect.Request[loansv1.ReconciliationSearchRequest],
) (*connect.ServerStreamForClient[loansv1.ReconciliationSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) InitiateCollection(
	context.Context,
	*connect.Request[loansv1.InitiateCollectionRequest],
) (*connect.Response[loansv1.InitiateCollectionResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) LoanStatusChangeSearch(
	context.Context,
	*connect.Request[loansv1.LoanStatusChangeSearchRequest],
) (*connect.ServerStreamForClient[loansv1.LoanStatusChangeSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) LoanRequest(
	context.Context,
	*connect.Request[loansv1.LoanRequestRequest],
) (*connect.Response[loansv1.LoanRequestResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) PortfolioSummary(
	context.Context,
	*connect.Request[loansv1.PortfolioSummaryRequest],
) (*connect.Response[loansv1.PortfolioSummaryResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *loanManagementClientStub) PortfolioExport(
	context.Context,
	*connect.Request[loansv1.PortfolioExportRequest],
) (*connect.Response[loansv1.PortfolioExportResponse], error) {
	panic(errUnexpectedStubCall)
}

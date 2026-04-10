package business

import (
	"context"
	"errors"
	"testing"

	loansv1 "buf.build/gen/go/antinvestor/loans/protocolbuffers/go/loans/v1"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"connectrpc.com/connect"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/frame/queue"
	"github.com/pitabwire/util"
	moneyv1 "google.golang.org/genproto/googleapis/type/money"
)

var errUnexpectedStubCall = errors.New("unexpected stub call")

func TestPopulateLoanFromApplicationRequiresAcceptedOffer(t *testing.T) {
	t.Parallel()

	business := &loanAccountBusiness{
		originationCli: &originationServiceClientStub{
			applicationGetResp: connect.NewResponse(&originationv1.ApplicationGetResponse{
				Data: &originationv1.ApplicationObject{
					Id:               "app-1",
					Status:           originationv1.ApplicationStatus_APPLICATION_STATUS_APPROVED,
					ApprovedAmount:   money("UGX", 100_000),
					ApprovedTermDays: 30,
				},
			}),
		},
	}

	_, _, err := business.populateLoanFromApplication(context.Background(), testLoanLogEntry(), "app-1")

	if !errors.Is(err, ErrApplicationNotOfferAccepted) {
		t.Fatalf("expected ErrApplicationNotOfferAccepted, got %v", err)
	}
}

func TestPopulateLoanFromApplicationRequiresApprovedTerms(t *testing.T) {
	t.Parallel()

	business := &loanAccountBusiness{
		originationCli: &originationServiceClientStub{
			applicationGetResp: connect.NewResponse(&originationv1.ApplicationGetResponse{
				Data: &originationv1.ApplicationObject{
					Id:               "app-1",
					Status:           originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_ACCEPTED,
					ApprovedTermDays: 30,
				},
			}),
		},
	}

	_, _, err := business.populateLoanFromApplication(context.Background(), testLoanLogEntry(), "app-1")

	if !errors.Is(err, ErrApplicationTermsNotApproved) {
		t.Fatalf("expected ErrApplicationTermsNotApproved, got %v", err)
	}
}

func TestCreateDoesNotMarkLoanAsDisbursed(t *testing.T) {
	t.Parallel()

	ctx := context.Background()
	business := &loanAccountBusiness{
		eventsMan: &eventsManagerStub{},
		originationCli: &originationServiceClientStub{
			applicationGetResp: connect.NewResponse(&originationv1.ApplicationGetResponse{
				Data: &originationv1.ApplicationObject{
					Id:               "app-1",
					Status:           originationv1.ApplicationStatus_APPLICATION_STATUS_OFFER_ACCEPTED,
					ApprovedAmount:   money("UGX", 250_000),
					ApprovedTermDays: 45,
				},
			}),
		},
	}

	loan, err := business.Create(ctx, "app-1")

	if err != nil {
		t.Fatalf("Create returned error: %v", err)
	}
	if loan.GetDisbursedAt() != "" {
		t.Fatalf("expected no disbursed timestamp, got %q", loan.GetDisbursedAt())
	}
	if loan.GetFirstRepaymentDate() == "" {
		t.Fatal("expected first repayment date to be set")
	}
	if got := loan.GetStatus(); got != loansv1.LoanStatus_LOAN_STATUS_PENDING_DISBURSEMENT {
		t.Fatalf("expected pending disbursement status, got %v", got)
	}
}

func testLoanLogEntry() *util.LogEntry {
	return util.Log(context.Background())
}

func money(currency string, units int64) *moneyv1.Money {
	return &moneyv1.Money{CurrencyCode: currency, Units: units}
}

type originationServiceClientStub struct {
	applicationGetResp *connect.Response[originationv1.ApplicationGetResponse]
	applicationGetErr  error
}

type eventsManagerStub struct{}

func (e *eventsManagerStub) Add(fevents.EventI) {}

func (e *eventsManagerStub) Get(string) (fevents.EventI, error) { panic(errUnexpectedStubCall) }

func (e *eventsManagerStub) Emit(context.Context, string, any) error { return nil }

func (e *eventsManagerStub) Handler() queue.SubscribeWorker { return nil }

func (c *originationServiceClientStub) LoanProductSave(
	context.Context,
	*connect.Request[originationv1.LoanProductSaveRequest],
) (*connect.Response[originationv1.LoanProductSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) LoanProductGet(
	context.Context,
	*connect.Request[originationv1.LoanProductGetRequest],
) (*connect.Response[originationv1.LoanProductGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) LoanProductSearch(
	context.Context,
	*connect.Request[originationv1.LoanProductSearchRequest],
) (*connect.ServerStreamForClient[originationv1.LoanProductSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) ApplicationSave(
	context.Context,
	*connect.Request[originationv1.ApplicationSaveRequest],
) (*connect.Response[originationv1.ApplicationSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) ApplicationGet(
	context.Context,
	*connect.Request[originationv1.ApplicationGetRequest],
) (*connect.Response[originationv1.ApplicationGetResponse], error) {
	return c.applicationGetResp, c.applicationGetErr
}

func (c *originationServiceClientStub) ApplicationSearch(
	context.Context,
	*connect.Request[originationv1.ApplicationSearchRequest],
) (*connect.ServerStreamForClient[originationv1.ApplicationSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) ApplicationSubmit(
	context.Context,
	*connect.Request[originationv1.ApplicationSubmitRequest],
) (*connect.Response[originationv1.ApplicationSubmitResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) ApplicationCancel(
	context.Context,
	*connect.Request[originationv1.ApplicationCancelRequest],
) (*connect.Response[originationv1.ApplicationCancelResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) ApplicationAcceptOffer(
	context.Context,
	*connect.Request[originationv1.ApplicationAcceptOfferRequest],
) (*connect.Response[originationv1.ApplicationAcceptOfferResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) ApplicationDeclineOffer(
	context.Context,
	*connect.Request[originationv1.ApplicationDeclineOfferRequest],
) (*connect.Response[originationv1.ApplicationDeclineOfferResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) ApplicationDocumentSave(
	context.Context,
	*connect.Request[originationv1.ApplicationDocumentSaveRequest],
) (*connect.Response[originationv1.ApplicationDocumentSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) ApplicationDocumentGet(
	context.Context,
	*connect.Request[originationv1.ApplicationDocumentGetRequest],
) (*connect.Response[originationv1.ApplicationDocumentGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) ApplicationDocumentSearch(
	context.Context,
	*connect.Request[originationv1.ApplicationDocumentSearchRequest],
) (*connect.ServerStreamForClient[originationv1.ApplicationDocumentSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) VerificationTaskSave(
	context.Context,
	*connect.Request[originationv1.VerificationTaskSaveRequest],
) (*connect.Response[originationv1.VerificationTaskSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) VerificationTaskGet(
	context.Context,
	*connect.Request[originationv1.VerificationTaskGetRequest],
) (*connect.Response[originationv1.VerificationTaskGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) VerificationTaskSearch(
	context.Context,
	*connect.Request[originationv1.VerificationTaskSearchRequest],
) (*connect.ServerStreamForClient[originationv1.VerificationTaskSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) VerificationTaskComplete(
	context.Context,
	*connect.Request[originationv1.VerificationTaskCompleteRequest],
) (*connect.Response[originationv1.VerificationTaskCompleteResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) UnderwritingDecisionSave(
	context.Context,
	*connect.Request[originationv1.UnderwritingDecisionSaveRequest],
) (*connect.Response[originationv1.UnderwritingDecisionSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) UnderwritingDecisionGet(
	context.Context,
	*connect.Request[originationv1.UnderwritingDecisionGetRequest],
) (*connect.Response[originationv1.UnderwritingDecisionGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) UnderwritingDecisionSearch(
	context.Context,
	*connect.Request[originationv1.UnderwritingDecisionSearchRequest],
) (*connect.ServerStreamForClient[originationv1.UnderwritingDecisionSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) FormTemplateSave(
	context.Context,
	*connect.Request[originationv1.FormTemplateSaveRequest],
) (*connect.Response[originationv1.FormTemplateSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) FormTemplateGet(
	context.Context,
	*connect.Request[originationv1.FormTemplateGetRequest],
) (*connect.Response[originationv1.FormTemplateGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) FormTemplateSearch(
	context.Context,
	*connect.Request[originationv1.FormTemplateSearchRequest],
) (*connect.ServerStreamForClient[originationv1.FormTemplateSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) FormTemplatePublish(
	context.Context,
	*connect.Request[originationv1.FormTemplatePublishRequest],
) (*connect.Response[originationv1.FormTemplatePublishResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) FormSubmissionSave(
	context.Context,
	*connect.Request[originationv1.FormSubmissionSaveRequest],
) (*connect.Response[originationv1.FormSubmissionSaveResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) FormSubmissionGet(
	context.Context,
	*connect.Request[originationv1.FormSubmissionGetRequest],
) (*connect.Response[originationv1.FormSubmissionGetResponse], error) {
	panic(errUnexpectedStubCall)
}

func (c *originationServiceClientStub) FormSubmissionSearch(
	context.Context,
	*connect.Request[originationv1.FormSubmissionSearchRequest],
) (*connect.ServerStreamForClient[originationv1.FormSubmissionSearchResponse], error) {
	panic(errUnexpectedStubCall)
}

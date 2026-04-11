package business

import (
	"context"
	"errors"
	"testing"
	"time"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/datastore/pool"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/frame/queue"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

var errIdentityUnexpectedStubCall = errors.New("unexpected stub call")

func TestBranchSaveCreatesPendingApprovalCaseWithoutPartition(t *testing.T) {
	t.Parallel()

	ctx := context.Background()
	now := time.Now().UTC()
	caseRecord := &models.ApprovalCase{
		Status:      approvalCaseStatusPendingVerification,
		CaseType:    approvalCaseTypeBranchCreate,
		RequestedBy: "profile-requestor",
	}
	caseRecord.GenID(ctx)
	caseRecord.CreatedAt = now

	eventsStub := &identityEventsManagerStub{}
	business := &branchBusiness{
		eventsMan: eventsStub,
		organizationRepo: &organizationRepoStub{
			baseRepoStub: baseRepoStub[*models.Organization]{
				getByID: func(context.Context, string) (*models.Organization, error) {
					return &models.Organization{BaseModel: data.BaseModel{TenantID: "tenant-1"}, Name: "Org"}, nil
				},
			},
		},
		approvalCases: &approvalCaseBusinessStub{submitResp: caseRecord},
	}

	result, err := business.Save(ctx, &identityv1.BranchObject{
		OrganizationId: "org-1",
		Name:           "Central Branch",
		Code:           "CENTRAL",
		Properties: (&data.JSONMap{
			caseActorIDKey: "profile-requestor",
		}).ToProtoStruct(),
	})
	if err != nil {
		t.Fatalf("Save returned error: %v", err)
	}

	if result.GetPartitionId() != "" {
		t.Fatalf("expected no partition before approval, got %q", result.GetPartitionId())
	}

	savedBranch, ok := eventsStub.lastPayload.(*models.Branch)
	if !ok {
		t.Fatalf("expected branch payload, got %T", eventsStub.lastPayload)
	}
	if got := savedBranch.Properties.GetString(approvalCaseStatusKey); got != approvalCaseStatusPendingVerification {
		t.Fatalf("expected pending verification status, got %q", got)
	}
}

func TestClientSavePhoneChangeCreatesPendingCaseAndPreservesCurrentPhone(t *testing.T) {
	t.Parallel()

	ctx := context.Background()
	now := time.Now().UTC()
	caseRecord := &models.ApprovalCase{
		Status:      approvalCaseStatusPendingVerification,
		CaseType:    approvalCaseTypeClientPhoneChange,
		RequestedBy: "agent-actor",
		Payload: data.JSONMap{
			approvalCaseRequestedValueKey: "+256700000222",
		},
	}
	caseRecord.GenID(ctx)
	caseRecord.CreatedAt = now

	existingClient := &models.Client{
		BaseModel:  data.BaseModel{ID: "client-1"},
		AgentID:    "agent-1",
		Name:       "Jane Doe",
		State:      int32(commonv1.STATE_ACTIVE),
		Properties: data.JSONMap{clientPhoneNumberKey: "+256700000111"},
	}

	eventsStub := &identityEventsManagerStub{}
	business := &clientBusiness{
		eventsMan: eventsStub,
		agentRepo: &agentRepoStub{
			baseRepoStub: baseRepoStub[*models.Agent]{getByID: func(context.Context, string) (*models.Agent, error) {
				return &models.Agent{State: int32(commonv1.STATE_ACTIVE)}, nil
			}},
		},
		clientRepo: &clientRepoStub{
			baseRepoStub: baseRepoStub[*models.Client]{getByID: func(context.Context, string) (*models.Client, error) {
				return existingClient, nil
			}},
		},
		approvalCases: &approvalCaseBusinessStub{
			getOpenErr: errors.New("not found"),
			submitResp: caseRecord,
		},
	}

	_, err := business.Save(ctx, &fieldv1.ClientObject{
		Id:      "client-1",
		AgentId: "agent-1",
		Name:    "Jane Doe",
		Properties: (&data.JSONMap{
			clientPhoneNumberKey: "+256700000222",
			caseActorIDKey:       "agent-actor",
		}).ToProtoStruct(),
	})
	if err != nil {
		t.Fatalf("Save returned error: %v", err)
	}

	savedClient, ok := eventsStub.lastPayload.(*models.Client)
	if !ok {
		t.Fatalf("expected client payload, got %T", eventsStub.lastPayload)
	}
	if got := savedClient.Properties.GetString(clientPhoneNumberKey); got != "+256700000111" {
		t.Fatalf("expected current phone to remain unchanged, got %q", got)
	}
	if got := savedClient.Properties.GetString(clientPendingPhoneNumberKey); got != "+256700000222" {
		t.Fatalf("expected pending phone number to be stored, got %q", got)
	}
	if got := savedClient.Properties.GetString(approvalCaseStatusKey); got != approvalCaseStatusPendingVerification {
		t.Fatalf("expected pending verification status, got %q", got)
	}
}

func TestClientApprovalAppliesPendingPhoneOnApprove(t *testing.T) {
	t.Parallel()

	ctx := context.Background()
	now := time.Now().UTC()
	openCase := &models.ApprovalCase{
		BaseModel: data.BaseModel{ID: "case-1", CreatedAt: now},
		Status:    approvalCaseStatusPendingApproval,
		CaseType:  approvalCaseTypeClientPhoneChange,
		Payload: data.JSONMap{
			approvalCaseRequestedValueKey: "+256700000222",
		},
		RequestedBy: "agent-actor",
	}
	approvedCase := &models.ApprovalCase{
		BaseModel:   openCase.BaseModel,
		Status:      approvalCaseStatusApproved,
		CaseType:    approvalCaseTypeClientPhoneChange,
		Payload:     openCase.Payload,
		RequestedBy: "agent-actor",
		ApprovedBy:  "approver-actor",
	}

	existingClient := &models.Client{
		BaseModel: data.BaseModel{ID: "client-1"},
		AgentID:   "agent-1",
		Name:      "Jane Doe",
		State:     int32(commonv1.STATE_ACTIVE),
		Properties: data.JSONMap{
			clientPhoneNumberKey:        "+256700000111",
			clientPendingPhoneNumberKey: "+256700000222",
			approvalCaseIDKey:           "case-1",
		},
	}

	eventsStub := &identityEventsManagerStub{}
	business := &clientBusiness{
		eventsMan: eventsStub,
		agentRepo: &agentRepoStub{
			baseRepoStub: baseRepoStub[*models.Agent]{getByID: func(context.Context, string) (*models.Agent, error) {
				return &models.Agent{State: int32(commonv1.STATE_ACTIVE)}, nil
			}},
		},
		clientRepo: &clientRepoStub{
			baseRepoStub: baseRepoStub[*models.Client]{getByID: func(context.Context, string) (*models.Client, error) {
				return existingClient, nil
			}},
		},
		approvalCases: &approvalCaseBusinessStub{
			getOpenResp: openCase,
			approveResp: approvedCase,
		},
	}

	_, err := business.Save(ctx, &fieldv1.ClientObject{
		Id:      "client-1",
		AgentId: "agent-1",
		Name:    "Jane Doe",
		Properties: (&data.JSONMap{
			caseActionKey:  approvalCaseActionApprove,
			caseActorIDKey: "approver-actor",
		}).ToProtoStruct(),
	})
	if err != nil {
		t.Fatalf("Save returned error: %v", err)
	}

	savedClient, ok := eventsStub.lastPayload.(*models.Client)
	if !ok {
		t.Fatalf("expected client payload, got %T", eventsStub.lastPayload)
	}
	if got := savedClient.Properties.GetString(clientPhoneNumberKey); got != "+256700000222" {
		t.Fatalf("expected approved phone to be applied, got %q", got)
	}
	if got := savedClient.Properties.GetString(clientPendingPhoneNumberKey); got != "" {
		t.Fatalf("expected pending phone number to be cleared, got %q", got)
	}
	if got := savedClient.Properties.GetString(approvalCaseStatusKey); got != approvalCaseStatusApproved {
		t.Fatalf("expected approved status, got %q", got)
	}
}

type identityEventsManagerStub struct {
	lastEvent   string
	lastPayload any
}

func (e *identityEventsManagerStub) Add(fevents.EventI) {}

func (e *identityEventsManagerStub) Get(string) (fevents.EventI, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (e *identityEventsManagerStub) Emit(_ context.Context, event string, payload any) error {
	e.lastEvent = event
	e.lastPayload = payload
	return nil
}

func (e *identityEventsManagerStub) Handler() queue.SubscribeWorker { return nil }

type approvalCaseBusinessStub struct {
	submitResp  *models.ApprovalCase
	submitErr   error
	getOpenResp *models.ApprovalCase
	getOpenErr  error
	verifyResp  *models.ApprovalCase
	verifyErr   error
	approveResp *models.ApprovalCase
	approveErr  error
	rejectResp  *models.ApprovalCase
	rejectErr   error
}

func (a *approvalCaseBusinessStub) Submit(
	context.Context,
	ApprovalCaseSubmission,
) (*models.ApprovalCase, error) {
	return a.submitResp, a.submitErr
}

func (a *approvalCaseBusinessStub) Verify(
	context.Context,
	string, string, string,
) (*models.ApprovalCase, error) {
	return a.verifyResp, a.verifyErr
}

func (a *approvalCaseBusinessStub) Approve(
	context.Context,
	string, string, string,
) (*models.ApprovalCase, error) {
	return a.approveResp, a.approveErr
}

func (a *approvalCaseBusinessStub) Reject(
	context.Context,
	string, string, string,
) (*models.ApprovalCase, error) {
	return a.rejectResp, a.rejectErr
}

func (a *approvalCaseBusinessStub) GetOpenBySubject(
	context.Context,
	string, string, string,
) (*models.ApprovalCase, error) {
	if a.getOpenResp != nil || a.getOpenErr != nil {
		return a.getOpenResp, a.getOpenErr
	}
	return nil, errors.New("not found")
}

type baseRepoStub[T any] struct {
	getByID func(ctx context.Context, id string) (T, error)
}

func (b *baseRepoStub[T]) Pool() pool.Pool { return nil }

func (b *baseRepoStub[T]) WorkManager() workerpool.Manager { return nil }

func (b *baseRepoStub[T]) GetByID(ctx context.Context, id string) (T, error) {
	if b.getByID != nil {
		return b.getByID(ctx, id)
	}
	var zero T
	return zero, errors.New("not found")
}

func (b *baseRepoStub[T]) GetLastestBy(context.Context, map[string]any) (T, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (b *baseRepoStub[T]) GetAllBy(context.Context, map[string]any, int, int) ([]T, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (b *baseRepoStub[T]) Search(context.Context, *data.SearchQuery) (workerpool.JobResultPipe[[]T], error) {
	panic(errIdentityUnexpectedStubCall)
}

func (b *baseRepoStub[T]) Count(context.Context) (int64, error) { panic(errIdentityUnexpectedStubCall) }

func (b *baseRepoStub[T]) CountBy(context.Context, map[string]any) (int64, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (b *baseRepoStub[T]) Create(context.Context, T) error { panic(errIdentityUnexpectedStubCall) }

func (b *baseRepoStub[T]) BatchSize() int { panic(errIdentityUnexpectedStubCall) }

func (b *baseRepoStub[T]) BulkCreate(context.Context, []T) error {
	panic(errIdentityUnexpectedStubCall)
}

func (b *baseRepoStub[T]) FieldsImmutable() []string { panic(errIdentityUnexpectedStubCall) }

func (b *baseRepoStub[T]) FieldsAllowed() map[string]struct{} { panic(errIdentityUnexpectedStubCall) }

func (b *baseRepoStub[T]) ExtendFieldsAllowed(...string) {}

func (b *baseRepoStub[T]) IsFieldAllowed(string) error { panic(errIdentityUnexpectedStubCall) }

func (b *baseRepoStub[T]) Update(context.Context, T, ...string) (int64, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (b *baseRepoStub[T]) BulkUpdate(context.Context, []string, map[string]any) (int64, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (b *baseRepoStub[T]) Delete(context.Context, string) error { panic(errIdentityUnexpectedStubCall) }

func (b *baseRepoStub[T]) DeleteBatch(context.Context, []string) error {
	panic(errIdentityUnexpectedStubCall)
}

type organizationRepoStub struct {
	baseRepoStub[*models.Organization]
}

func (o *organizationRepoStub) GetByCode(context.Context, string) (*models.Organization, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (o *organizationRepoStub) GetByPartitionID(context.Context, string) (*models.Organization, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (o *organizationRepoStub) GetByTenantID(context.Context, string, int, int) ([]*models.Organization, error) {
	panic(errIdentityUnexpectedStubCall)
}

type agentRepoStub struct {
	baseRepoStub[*models.Agent]
}

func (a *agentRepoStub) GetByBranchID(context.Context, string, int, int) ([]*models.Agent, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (a *agentRepoStub) GetByParentAgentID(context.Context, string, int, int) ([]*models.Agent, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (a *agentRepoStub) GetByProfileID(context.Context, string) (*models.Agent, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (a *agentRepoStub) GetDescendants(context.Context, string, int) ([]*models.Agent, error) {
	panic(errIdentityUnexpectedStubCall)
}

type clientRepoStub struct {
	baseRepoStub[*models.Client]
}

func (c *clientRepoStub) GetByAgentID(context.Context, string, int, int) ([]*models.Client, error) {
	panic(errIdentityUnexpectedStubCall)
}

func (c *clientRepoStub) GetByProfileID(context.Context, string) (*models.Client, error) {
	panic(errIdentityUnexpectedStubCall)
}

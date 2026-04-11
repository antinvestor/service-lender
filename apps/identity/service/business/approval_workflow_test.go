package business

import (
	"context"
	"errors"
	"testing"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/frame/frametests"
	"github.com/pitabwire/frame/frametests/definition"
	"github.com/pitabwire/frame/frametests/deps/testpostgres"
	"github.com/pitabwire/frame/queue"
	"github.com/pitabwire/util"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"
	"google.golang.org/protobuf/types/known/structpb"

	identityevents "github.com/antinvestor/service-fintech/apps/identity/service/events"
	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type approvalWorkflowSuite struct {
	frametests.FrameBaseTestSuite
}

type approvalWorkflowEnv struct {
	t                *testing.T
	ctx              context.Context
	organizationRepo repository.OrganizationRepository
	branchRepo       repository.BranchRepository
	agentRepo        repository.AgentRepository
	agentBranchRepo  repository.AgentBranchRepository
	clientRepo       repository.ClientRepository
	cahRepo          repository.ClientAssignmentHistoryRepository
	clcrRepo         repository.CreditLimitChangeRequestRepository
	approvalCaseRepo repository.ApprovalCaseRepository
	branchBusiness   BranchBusiness
	clientBusiness   ClientBusiness
}

func TestApprovalWorkflowSuite(t *testing.T) {
	suite.Run(t, new(approvalWorkflowSuite))
}

func (s *approvalWorkflowSuite) SetupSuite() {
	s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
		return []definition.TestResource{
			testpostgres.NewWithOpts(
				"identity_approval_workflow",
				definition.WithUserName("ant"),
				definition.WithCredential("s3cr3t"),
				definition.WithEnableLogging(false),
			),
		}
	}
	s.FrameBaseTestSuite.SetupSuite()
}

func (s *approvalWorkflowSuite) TestBranchSaveCreatesPendingApprovalCaseWithoutPartition() {
	env := s.newEnv()
	org := env.createOrganization("Org Branch Create", "org-branch-create")

	result, err := env.branchBusiness.Save(env.ctx, &identityv1.BranchObject{
		OrganizationId: org.GetID(),
		Name:           "Central Branch",
		Code:           "central-branch",
		Properties: propertiesStruct(map[string]any{
			caseActorIDKey: "profile-requestor",
		}),
	})
	s.Require().NoError(err)
	s.Require().NotEmpty(result.GetId())
	s.Require().Empty(result.GetPartitionId())

	savedBranch, err := env.branchRepo.GetByID(env.ctx, result.GetId())
	s.Require().NoError(err)
	s.Equal(approvalCaseStatusPendingVerification, savedBranch.Properties.GetString(approvalCaseStatusKey))
	s.Empty(savedBranch.PartitionID)

	approvalCase, err := env.approvalCaseRepo.GetOpenBySubject(
		env.ctx,
		approvalCaseSubjectBranch,
		savedBranch.GetID(),
		approvalCaseTypeBranchCreate,
	)
	s.Require().NoError(err)
	s.Equal(approvalCaseStatusPendingVerification, approvalCase.Status)
	s.Equal("profile-requestor", approvalCase.RequestedBy)
}

func (s *approvalWorkflowSuite) TestBranchVerificationTransitionsCaseToPendingApproval() {
	env := s.newEnv()
	org := env.createOrganization("Org Branch Verify", "org-branch-verify")

	result, err := env.branchBusiness.Save(env.ctx, &identityv1.BranchObject{
		OrganizationId: org.GetID(),
		Name:           "North Branch",
		Code:           "north-branch",
		Properties: propertiesStruct(map[string]any{
			caseActorIDKey: "profile-requestor",
		}),
	})
	s.Require().NoError(err)

	verified, err := env.branchBusiness.Save(env.ctx, &identityv1.BranchObject{
		Id:             result.GetId(),
		OrganizationId: org.GetID(),
		Name:           "North Branch",
		Code:           "north-branch",
		Properties: propertiesStruct(map[string]any{
			caseActionKey:  approvalCaseActionVerify,
			caseActorIDKey: "profile-verifier",
			caseCommentKey: "documents checked",
		}),
	})
	s.Require().NoError(err)
	s.Require().NotNil(verified)

	savedBranch, err := env.branchRepo.GetByID(env.ctx, result.GetId())
	s.Require().NoError(err)
	s.Equal(approvalCaseStatusPendingApproval, savedBranch.Properties.GetString(approvalCaseStatusKey))

	approvalCase, err := env.approvalCaseRepo.GetByID(
		env.ctx,
		savedBranch.Properties.GetString(approvalCaseIDKey),
	)
	s.Require().NoError(err)
	s.Equal(approvalCaseStatusPendingApproval, approvalCase.Status)
	s.Equal("profile-verifier", approvalCase.VerifiedBy)
}

func (s *approvalWorkflowSuite) TestClientPhoneChangeActualizesOnlyAfterApproval() {
	env := s.newEnv()
	org := env.createOrganization("Org Client Phone", "org-client-phone")
	branch := env.createBranch(org, "Field Branch", "field-branch")
	agent := env.createAgent(org, "Agent One", "agent-profile-1")
	env.assignAgentToBranch(agent, branch)
	client := env.createClient(agent, "Jane Doe", "+256700000111")

	updated, err := env.clientBusiness.Save(env.ctx, &fieldv1.ClientObject{
		Id:      client.GetID(),
		AgentId: agent.GetID(),
		Name:    client.Name,
		Properties: propertiesStruct(map[string]any{
			clientPhoneNumberKey: "+256700000222",
			caseActorIDKey:       "agent-profile-1",
			caseCommentKey:       "customer requested number change",
		}),
	})
	s.Require().NoError(err)
	s.Require().NotNil(updated)

	pendingClient, err := env.clientRepo.GetByID(env.ctx, client.GetID())
	s.Require().NoError(err)
	s.Equal("+256700000111", pendingClient.Properties.GetString(clientPhoneNumberKey))
	s.Equal("+256700000222", pendingClient.Properties.GetString(clientPendingPhoneNumberKey))
	s.Equal(approvalCaseStatusPendingVerification, pendingClient.Properties.GetString(approvalCaseStatusKey))

	verified, err := env.clientBusiness.Save(env.ctx, &fieldv1.ClientObject{
		Id:      client.GetID(),
		AgentId: agent.GetID(),
		Name:    client.Name,
		Properties: propertiesStruct(map[string]any{
			caseActionKey:  approvalCaseActionVerify,
			caseActorIDKey: "profile-verifier",
			caseCommentKey: "identity cross-check complete",
		}),
	})
	s.Require().NoError(err)
	s.Require().NotNil(verified)

	verifiedClient, err := env.clientRepo.GetByID(env.ctx, client.GetID())
	s.Require().NoError(err)
	s.Equal(approvalCaseStatusPendingApproval, verifiedClient.Properties.GetString(approvalCaseStatusKey))
	s.Equal("+256700000111", verifiedClient.Properties.GetString(clientPhoneNumberKey))
	s.Equal("+256700000222", verifiedClient.Properties.GetString(clientPendingPhoneNumberKey))

	approved, err := env.clientBusiness.Save(env.ctx, &fieldv1.ClientObject{
		Id:      client.GetID(),
		AgentId: agent.GetID(),
		Name:    client.Name,
		Properties: propertiesStruct(map[string]any{
			caseActionKey:  approvalCaseActionApprove,
			caseActorIDKey: "profile-approver",
			caseCommentKey: "approved after review",
		}),
	})
	s.Require().NoError(err)
	s.Require().NotNil(approved)

	approvedClient, err := env.clientRepo.GetByID(env.ctx, client.GetID())
	s.Require().NoError(err)
	s.Equal("+256700000222", approvedClient.Properties.GetString(clientPhoneNumberKey))
	s.Empty(approvedClient.Properties.GetString(clientPendingPhoneNumberKey))
	s.Equal(approvalCaseStatusApproved, approvedClient.Properties.GetString(approvalCaseStatusKey))

	approvalCase, err := env.approvalCaseRepo.GetByID(
		env.ctx,
		approvedClient.Properties.GetString(approvalCaseIDKey),
	)
	s.Require().NoError(err)
	s.Equal(approvalCaseStatusApproved, approvalCase.Status)
	s.Equal("profile-approver", approvalCase.ApprovedBy)
}

func (s *approvalWorkflowSuite) newEnv() *approvalWorkflowEnv {
	s.T().Helper()

	ctx := s.T().Context()
	db := s.databaseResource(ctx)
	dsn, cleanup, err := db.GetRandomisedDS(ctx, util.RandomAlphaNumericString(8))
	s.Require().NoError(err)
	s.T().Cleanup(func() {
		cleanup(ctx)
	})

	ctx, svc := frame.NewServiceWithContext(
		ctx,
		frame.WithName("identity-approval-test"),
		frame.WithDatastore(pool.WithConnection(dsn.String(), false)),
	)
	s.T().Cleanup(func() {
		svc.Stop(ctx)
	})

	svc.Init(ctx)

	dbPool := svc.DatastoreManager().GetPool(ctx, datastore.DefaultPoolName)
	s.Require().NotNil(dbPool)
	workMan := svc.WorkManager()

	s.Require().NoError(dbPool.DB(ctx, false).AutoMigrate(
		&models.Organization{},
		&models.Branch{},
		&models.Agent{},
		&models.AgentBranch{},
		&models.Client{},
		&models.ClientAssignmentHistory{},
		&models.CreditLimitChangeRequest{},
		&models.ApprovalCase{},
	))

	organizationRepo := repository.NewOrganizationRepository(ctx, dbPool, workMan)
	branchRepo := repository.NewBranchRepository(ctx, dbPool, workMan)
	agentRepo := repository.NewAgentRepository(ctx, dbPool, workMan)
	agentBranchRepo := repository.NewAgentBranchRepository(ctx, dbPool, workMan)
	clientRepo := repository.NewClientRepository(ctx, dbPool, workMan)
	cahRepo := repository.NewClientAssignmentHistoryRepository(ctx, dbPool, workMan)
	clcrRepo := repository.NewCreditLimitChangeRequestRepository(ctx, dbPool, workMan)
	approvalCaseRepo := repository.NewApprovalCaseRepository(ctx, dbPool, workMan)

	evtsMan := newImmediateEventsManager(
		identityevents.NewOrganizationSave(ctx, organizationRepo),
		identityevents.NewBranchSave(ctx, branchRepo),
		identityevents.NewClientSave(ctx, clientRepo),
		identityevents.NewApprovalCaseSave(ctx, approvalCaseRepo),
	)

	approvalCaseBusiness := NewApprovalCaseBusiness(ctx, evtsMan, approvalCaseRepo, nil)
	branchBusiness := NewBranchBusiness(
		ctx,
		evtsMan,
		organizationRepo,
		branchRepo,
		nil,
		approvalCaseBusiness,
	)
	clientBusiness := NewClientBusiness(
		ctx,
		evtsMan,
		agentRepo,
		clientRepo,
		cahRepo,
		clcrRepo,
		approvalCaseBusiness,
	)

	return &approvalWorkflowEnv{
		t:                s.T(),
		ctx:              ctx,
		organizationRepo: organizationRepo,
		branchRepo:       branchRepo,
		agentRepo:        agentRepo,
		agentBranchRepo:  agentBranchRepo,
		clientRepo:       clientRepo,
		cahRepo:          cahRepo,
		clcrRepo:         clcrRepo,
		approvalCaseRepo: approvalCaseRepo,
		branchBusiness:   branchBusiness,
		clientBusiness:   clientBusiness,
	}
}

type immediateEventsManager struct {
	events map[string]fevents.EventI
}

func newImmediateEventsManager(events ...fevents.EventI) fevents.Manager {
	manager := &immediateEventsManager{events: make(map[string]fevents.EventI, len(events))}
	for _, event := range events {
		manager.Add(event)
	}
	return manager
}

func (m *immediateEventsManager) Add(evt fevents.EventI) {
	m.events[evt.Name()] = evt
}

func (m *immediateEventsManager) Get(name string) (fevents.EventI, error) {
	event, ok := m.events[name]
	if !ok {
		return nil, errors.New("event not found")
	}
	return event, nil
}

func (m *immediateEventsManager) Emit(ctx context.Context, name string, payload any) error {
	event, err := m.Get(name)
	if err != nil {
		return err
	}
	if err = event.Validate(ctx, payload); err != nil {
		return err
	}
	return event.Execute(ctx, payload)
}

func (m *immediateEventsManager) Handler() queue.SubscribeWorker {
	return nil
}

func (s *approvalWorkflowSuite) databaseResource(ctx context.Context) definition.DependancyConn {
	s.T().Helper()

	for _, resource := range s.Resources() {
		if resource.Name() == testpostgres.PostgresqlDBImage && resource.GetDS(ctx).IsDB() {
			return resource
		}
	}
	s.T().Fatal("postgres test resource not found")
	return nil
}

func (e *approvalWorkflowEnv) createOrganization(name, code string) *models.Organization {
	org := &models.Organization{
		Name:       name,
		Code:       code,
		State:      int32(commonv1.STATE_ACTIVE),
		ProfileID:  util.IDString(),
		ClientID:   util.IDString(),
		Properties: data.JSONMap{},
	}
	org.GenID(e.ctx)
	org.TenantID = util.IDString()
	org.PartitionID = util.IDString()
	require.NoError(e.t, e.organizationRepo.Create(e.ctx, org))
	return org
}

func (e *approvalWorkflowEnv) createBranch(
	org *models.Organization,
	name, code string,
) *models.Branch {
	branch := &models.Branch{
		OrganizationID: org.GetID(),
		Name:           name,
		Code:           code,
		State:          int32(commonv1.STATE_ACTIVE),
		Properties:     data.JSONMap{},
	}
	branch.GenID(e.ctx)
	branch.TenantID = org.TenantID
	branch.PartitionID = util.IDString()
	require.NoError(e.t, e.branchRepo.Create(e.ctx, branch))
	return branch
}

func (e *approvalWorkflowEnv) createAgent(
	org *models.Organization,
	name, profileID string,
) *models.Agent {
	agent := &models.Agent{
		OrganizationID: org.GetID(),
		Name:           name,
		ProfileID:      profileID,
		State:          int32(commonv1.STATE_ACTIVE),
		Properties:     data.JSONMap{},
	}
	agent.GenID(e.ctx)
	agent.TenantID = org.TenantID
	require.NoError(e.t, e.agentRepo.Create(e.ctx, agent))
	return agent
}

func (e *approvalWorkflowEnv) assignAgentToBranch(agent *models.Agent, branch *models.Branch) {
	assignment := &models.AgentBranch{
		AgentID:    agent.GetID(),
		BranchID:   branch.GetID(),
		State:      int32(commonv1.STATE_ACTIVE),
		Properties: data.JSONMap{},
	}
	assignment.GenID(e.ctx)
	assignment.TenantID = branch.TenantID
	require.NoError(e.t, e.agentBranchRepo.Create(e.ctx, assignment))
}

func (e *approvalWorkflowEnv) createClient(agent *models.Agent, name, phone string) *models.Client {
	client := &models.Client{
		AgentID:    agent.GetID(),
		Name:       name,
		State:      int32(commonv1.STATE_ACTIVE),
		Properties: data.JSONMap{clientPhoneNumberKey: phone},
	}
	client.GenID(e.ctx)
	client.TenantID = agent.TenantID
	require.NoError(e.t, e.clientRepo.Create(e.ctx, client))
	return client
}

func propertiesStruct(values map[string]any) *structpb.Struct {
	props := data.JSONMap(values)
	return (&props).ToProtoStruct()
}

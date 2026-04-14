package business

import (
	"context"
	"fmt"
	"strconv"
	"strings"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"buf.build/gen/go/antinvestor/tenancy/connectrpc/go/tenancy/v1/tenancyv1connect"
	tenancyv1 "buf.build/gen/go/antinvestor/tenancy/protocolbuffers/go/tenancy/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/frame/data"
	fevents "github.com/pitabwire/frame/events"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/events"
	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type BranchBusiness interface {
	Save(ctx context.Context, obj *identityv1.BranchObject) (*identityv1.BranchObject, error)
	Get(ctx context.Context, id string) (*identityv1.BranchObject, error)
	Search(
		ctx context.Context,
		req *identityv1.BranchSearchRequest,
		consumer func(ctx context.Context, batch []*identityv1.BranchObject) error,
	) error
}

type branchBusiness struct {
	eventsMan        fevents.Manager
	organizationRepo repository.OrganizationRepository
	branchRepo       repository.BranchRepository
	partitionCli     tenancyv1connect.TenancyServiceClient
	approvalCases    ApprovalCaseBusiness
}

func NewBranchBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	organizationRepo repository.OrganizationRepository,
	branchRepo repository.BranchRepository,
	partitionCli tenancyv1connect.TenancyServiceClient,
	approvalCases ApprovalCaseBusiness,
) BranchBusiness {
	return &branchBusiness{
		eventsMan:        eventsMan,
		organizationRepo: organizationRepo,
		branchRepo:       branchRepo,
		partitionCli:     partitionCli,
		approvalCases:    approvalCases,
	}
}

func (b *branchBusiness) Save(ctx context.Context, obj *identityv1.BranchObject) (*identityv1.BranchObject, error) {
	logger := util.Log(ctx).WithField("method", "BranchBusiness.Save")

	// Validate organization exists
	org, err := b.organizationRepo.GetByID(ctx, obj.GetOrganizationId())
	if err != nil {
		logger.WithError(err).Warn("organization not found for branch")
		return nil, ErrOrganizationNotFound
	}

	isNew := obj.GetId() == ""
	branch := models.BranchFromAPI(ctx, obj)
	branch.Properties = entityProperties(branch.Properties)

	if action := caseAction(branch.Properties); action != "" {
		result, actionErr := b.handleApprovalAction(ctx, logger, branch, action)
		if actionErr != nil {
			return nil, actionErr
		}
		return result, nil
	}
	if strings.TrimSpace(branch.GeoID) == "" {
		return nil, ErrCoverageAreaRequired
	}

	if isNew && branch.State == 0 {
		branch.State = int32(commonv1.STATE_CREATED.Number())
	}

	if isNew {
		commandProps := entityProperties(branch.Properties)
		branch.TenantID = org.TenantID
		branch.PartitionID = org.PartitionID
		stripCaseCommand(branch.Properties)

		if err = b.eventsMan.Emit(ctx, events.BranchSaveEvent, branch); err != nil {
			logger.WithError(err).Error("could not emit branch save event")
			return nil, err
		}
		if createErr := b.submitBranchCreateCase(
			ctx,
			logger,
			branch,
			caseActorID(commandProps),
			caseComment(commandProps),
		); createErr != nil {
			logger.WithError(createErr).Warn("branch created without approval case metadata")
		}
		return branch.ToAPI(), nil
	}

	existing, err := b.branchRepo.GetByID(ctx, branch.GetID())
	if err != nil {
		logger.WithError(err).Warn("branch not found for update")
		return nil, ErrBranchNotFound
	}
	if existing.UnitType != int32(identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH) {
		return nil, ErrBranchNotFound
	}
	branch.TenantID = existing.TenantID
	branch.PartitionID = existing.PartitionID
	stripCaseCommand(branch.Properties)

	err = b.eventsMan.Emit(ctx, events.BranchSaveEvent, branch)
	if err != nil {
		logger.WithError(err).Error("could not emit branch save event")
		return nil, err
	}

	return branch.ToAPI(), nil
}

func (b *branchBusiness) submitBranchCreateCase(
	ctx context.Context,
	logger *util.LogEntry,
	branch *models.Branch,
	actorID, comment string,
) error {
	actorID = resolveCaseActorID(ctx, actorID, branch.CreatedBy)
	requestedState := branch.State
	if requestedState == 0 {
		requestedState = int32(commonv1.STATE_CREATED.Number())
	}

	approvalCase, err := b.approvalCases.Submit(ctx, ApprovalCaseSubmission{
		SubjectType:         approvalCaseSubjectBranch,
		SubjectID:           branch.GetID(),
		CaseType:            approvalCaseTypeBranchCreate,
		Summary:             fmt.Sprintf("Branch %s requires verification and approval", branch.Name),
		RequestedBy:         actorID,
		Comment:             comment,
		RequireVerification: true,
		Payload: map[string]any{
			"organization_id": branch.OrganizationID,
			"requested_state": requestedState,
		},
	})
	if err != nil {
		logger.WithError(err).Error("could not create branch approval case")
		return err
	}

	branch.Properties = applyApprovalCaseSnapshot(branch.Properties, approvalCase)

	if err = b.eventsMan.Emit(ctx, events.BranchSaveEvent, branch); err != nil {
		logger.WithError(err).Error("could not emit branch save event")
		return err
	}

	return nil
}

func (b *branchBusiness) handleApprovalAction(
	ctx context.Context,
	logger *util.LogEntry,
	branch *models.Branch,
	action string,
) (*identityv1.BranchObject, error) {
	if branch.GetID() == "" {
		return nil, ErrBranchNotFound
	}

	existing, err := b.branchRepo.GetByID(ctx, branch.GetID())
	if err != nil {
		logger.WithError(err).Warn("branch not found for approval action")
		return nil, ErrBranchNotFound
	}
	if existing.UnitType != int32(identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH) {
		return nil, ErrBranchNotFound
	}

	props := entityProperties(existing.Properties)
	caseID := openApprovalCaseID(props)
	approvalCase, err := b.resolveApprovalCase(ctx, caseID, existing.GetID())
	if err != nil {
		return nil, err
	}

	actorID := caseActorID(branch.Properties)
	comment := caseComment(branch.Properties)

	approvalCase, err = b.transitionApprovalAction(ctx, logger, existing, approvalCase, action, actorID, comment)
	if err != nil {
		return nil, err
	}

	stripCaseCommand(props)
	existing.Properties = applyApprovalCaseSnapshot(props, approvalCase)
	if err = b.eventsMan.Emit(ctx, events.BranchSaveEvent, existing); err != nil {
		logger.WithError(err).Error("could not persist branch approval action")
		return nil, err
	}

	logApprovalCaseTransition(ctx, action, approvalCase)
	return existing.ToAPI(), nil
}

func (b *branchBusiness) transitionApprovalAction(
	ctx context.Context,
	logger *util.LogEntry,
	existing *models.Branch,
	approvalCase *models.ApprovalCase,
	action, actorID, comment string,
) (*models.ApprovalCase, error) {
	switch action {
	case approvalCaseActionVerify:
		return b.approvalCases.Verify(ctx, approvalCase.GetID(), actorID, comment)
	case approvalCaseActionApprove:
		return b.approveBranchCase(ctx, logger, existing, approvalCase, actorID, comment)
	case approvalCaseActionReject:
		return b.rejectBranchCase(ctx, existing, approvalCase, actorID, comment)
	default:
		return nil, ErrApprovalCaseNotPending.Extend("unsupported case action")
	}
}

func (b *branchBusiness) approveBranchCase(
	ctx context.Context,
	logger *util.LogEntry,
	existing *models.Branch,
	approvalCase *models.ApprovalCase,
	actorID, comment string,
) (*models.ApprovalCase, error) {
	approvedCase, err := b.approvalCases.Approve(ctx, approvalCase.GetID(), actorID, comment)
	if err != nil {
		return nil, err
	}

	org, orgErr := b.organizationRepo.GetByID(ctx, existing.OrganizationID)
	if orgErr != nil {
		return nil, ErrOrganizationNotFound
	}
	if existing.PartitionID == "" || existing.PartitionID == org.PartitionID {
		partitionID, partitionErr := b.createChildPartition(
			ctx, logger, org.TenantID, org.PartitionID, existing.Name,
		)
		if partitionErr != nil {
			return nil, partitionErr
		}
		existing.PartitionID = partitionID
		existing.TenantID = org.TenantID
	}

	if requestedState := int32Value(approvedCase.Payload["requested_state"]); requestedState != 0 {
		existing.State = requestedState
	}

	return approvedCase, nil
}

func (b *branchBusiness) rejectBranchCase(
	ctx context.Context,
	existing *models.Branch,
	approvalCase *models.ApprovalCase,
	actorID, comment string,
) (*models.ApprovalCase, error) {
	rejectedCase, err := b.approvalCases.Reject(ctx, approvalCase.GetID(), actorID, comment)
	if err != nil {
		return nil, err
	}
	existing.State = int32(commonv1.STATE_INACTIVE.Number())
	return rejectedCase, nil
}

func (b *branchBusiness) resolveApprovalCase(
	ctx context.Context,
	caseID, branchID string,
) (*models.ApprovalCase, error) {
	if caseID != "" {
		approvalCase, err := b.approvalCases.GetOpenBySubject(
			ctx,
			approvalCaseSubjectBranch,
			branchID,
			approvalCaseTypeBranchCreate,
		)
		if err == nil && approvalCase != nil && approvalCase.GetID() == caseID {
			return approvalCase, nil
		}
	}

	approvalCase, err := b.approvalCases.GetOpenBySubject(
		ctx,
		approvalCaseSubjectBranch,
		branchID,
		approvalCaseTypeBranchCreate,
	)
	if err != nil {
		return nil, ErrApprovalCaseNotFound
	}
	return approvalCase, nil
}

func (b *branchBusiness) createChildPartition(
	ctx context.Context,
	logger *util.LogEntry,
	tenantID, parentID, name string,
) (string, error) {
	if b.partitionCli == nil {
		logger.Warn("partition client is nil")
		return "", ErrLoginClientCreationFailed.Extend("partition client is nil")
	}
	resp, err := b.partitionCli.CreatePartition(ctx, connect.NewRequest(
		&tenancyv1.CreatePartitionRequest{
			TenantId:    tenantID,
			ParentId:    parentID,
			Name:        name,
			Description: "Partition for branch: " + name,
		},
	))
	if err != nil {
		logger.WithError(err).Warn("failed to create child partition")
		return "", ErrLoginClientCreationFailed.Extend("failed to create child partition")
	}
	return resp.Msg.GetData().GetId(), nil
}

func (b *branchBusiness) Get(ctx context.Context, id string) (*identityv1.BranchObject, error) {
	branch, err := b.branchRepo.GetByID(ctx, id)
	if err != nil {
		return nil, ErrBranchNotFound
	}
	if branch.UnitType != int32(identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH) {
		return nil, ErrBranchNotFound
	}
	return branch.ToAPI(), nil
}

func (b *branchBusiness) Search(
	ctx context.Context,
	req *identityv1.BranchSearchRequest,
	consumer func(ctx context.Context, batch []*identityv1.BranchObject) error,
) error {
	logger := util.Log(ctx).WithField("method", "BranchBusiness.Search")

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
	andQueryVal["unit_type = ?"] = int32(identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH)
	if req.GetOrganizationId() != "" {
		andQueryVal["organization_id = ?"] = req.GetOrganizationId()
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
	results, err := b.branchRepo.Search(ctx, query)
	if err != nil {
		logger.WithError(err).Error("failed to search branches")
		return err
	}

	return workerpoolConsumeStream(ctx, results, func(res []*models.Branch) error {
		var apiResults []*identityv1.BranchObject
		for _, branch := range res {
			apiResults = append(apiResults, branch.ToAPI())
		}
		return consumer(ctx, apiResults)
	})
}

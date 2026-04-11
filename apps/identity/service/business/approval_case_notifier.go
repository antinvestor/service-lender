package business

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"buf.build/gen/go/antinvestor/notification/connectrpc/go/notification/v1/notificationv1connect"
	notificationv1 "buf.build/gen/go/antinvestor/notification/protocolbuffers/go/notification/v1"
	"buf.build/gen/go/antinvestor/profile/connectrpc/go/profile/v1/profilev1connect"
	profilev1 "buf.build/gen/go/antinvestor/profile/protocolbuffers/go/profile/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

const (
	approvalCaseVerificationRequiredTemplate = "template.fintech.case.verification_required"
	approvalCaseApprovalRequiredTemplate     = "template.fintech.case.approval_required"
	approvalCaseApprovedTemplate             = "template.fintech.case.approved"
	approvalCaseRejectedTemplate             = "template.fintech.case.rejected"

	caseNotificationType = "approval_case"
	maxCaseRecipients    = 500
)

// ApprovalCaseNotifier dispatches workflow notifications for reusable approval cases.
// Delivery is best effort and never blocks the underlying business transition.
type ApprovalCaseNotifier struct {
	client          notificationv1connect.NotificationServiceClient
	profileClient   profilev1connect.ProfileServiceClient
	systemUserRepo  repository.SystemUserRepository
	branchRepo      repository.BranchRepository
	clientRepo      repository.ClientRepository
	agentRepo       repository.AgentRepository
	agentBranchRepo repository.AgentBranchRepository
}

func NewApprovalCaseNotifier(
	client notificationv1connect.NotificationServiceClient,
	profileClient profilev1connect.ProfileServiceClient,
	systemUserRepo repository.SystemUserRepository,
	branchRepo repository.BranchRepository,
	clientRepo repository.ClientRepository,
	agentRepo repository.AgentRepository,
	agentBranchRepo repository.AgentBranchRepository,
) *ApprovalCaseNotifier {
	return &ApprovalCaseNotifier{
		client:          client,
		profileClient:   profileClient,
		systemUserRepo:  systemUserRepo,
		branchRepo:      branchRepo,
		clientRepo:      clientRepo,
		agentRepo:       agentRepo,
		agentBranchRepo: agentBranchRepo,
	}
}

func (n *ApprovalCaseNotifier) NotifySubmitted(ctx context.Context, approvalCase *models.ApprovalCase) {
	if approvalCase == nil {
		return
	}

	switch approvalCase.Status {
	case approvalCaseStatusPendingVerification:
		n.notifyRole(ctx,
			approvalCase,
			identityv1.SystemUserRole_SYSTEM_USER_ROLE_VERIFIER,
			approvalCaseVerificationRequiredTemplate,
			notificationv1.PRIORITY_HIGH,
		)
	case approvalCaseStatusPendingApproval:
		n.notifyRole(ctx,
			approvalCase,
			identityv1.SystemUserRole_SYSTEM_USER_ROLE_APPROVER,
			approvalCaseApprovalRequiredTemplate,
			notificationv1.PRIORITY_HIGH,
		)
	}
}

func (n *ApprovalCaseNotifier) NotifyVerified(ctx context.Context, approvalCase *models.ApprovalCase) {
	if approvalCase == nil {
		return
	}
	n.notifyRole(ctx,
		approvalCase,
		identityv1.SystemUserRole_SYSTEM_USER_ROLE_APPROVER,
		approvalCaseApprovalRequiredTemplate,
		notificationv1.PRIORITY_HIGH,
	)
}

func (n *ApprovalCaseNotifier) NotifyApproved(ctx context.Context, approvalCase *models.ApprovalCase) {
	n.notifyRequester(ctx, approvalCase, approvalCaseApprovedTemplate, notificationv1.PRIORITY_HIGH)
}

func (n *ApprovalCaseNotifier) NotifyRejected(ctx context.Context, approvalCase *models.ApprovalCase) {
	n.notifyRequester(ctx, approvalCase, approvalCaseRejectedTemplate, notificationv1.PRIORITY_HIGH)
}

func (n *ApprovalCaseNotifier) notifyRole(
	ctx context.Context,
	approvalCase *models.ApprovalCase,
	role identityv1.SystemUserRole,
	template string,
	priority notificationv1.PRIORITY,
) {
	logger := util.Log(ctx).WithFields(map[string]any{
		"component": "ApprovalCaseNotifier",
		"case_id":   approvalCase.GetID(),
		"template":  template,
		"role":      role.String(),
	})

	profileIDs, err := n.caseProfileRecipients(ctx, approvalCase, int32(role))
	if err != nil {
		logger.WithError(err).Warn("could not resolve approval case recipients")
		return
	}
	if len(profileIDs) == 0 {
		logger.Warn("no approval case recipients resolved")
		return
	}

	n.sendToProfiles(ctx, template, approvalCase, profileIDs, priority)
}

func (n *ApprovalCaseNotifier) notifyRequester(
	ctx context.Context,
	approvalCase *models.ApprovalCase,
	template string,
	priority notificationv1.PRIORITY,
) {
	if approvalCase == nil || approvalCase.RequestedBy == "" {
		return
	}

	n.sendToProfiles(ctx, template, approvalCase, []string{approvalCase.RequestedBy}, priority)
}

func (n *ApprovalCaseNotifier) caseProfileRecipients(
	ctx context.Context,
	approvalCase *models.ApprovalCase,
	role int32,
) ([]string, error) {
	if approvalCase == nil || n.systemUserRepo == nil {
		return nil, nil
	}

	switch approvalCase.SubjectType {
	case approvalCaseSubjectBranch:
		return n.branchCaseRecipients(ctx, approvalCase, role)
	case approvalCaseSubjectClient:
		return n.clientCaseRecipients(ctx, approvalCase.SubjectID, role)
	default:
		return n.profileIDsForRole(ctx, role)
	}
}

func (n *ApprovalCaseNotifier) branchCaseRecipients(
	ctx context.Context,
	approvalCase *models.ApprovalCase,
	role int32,
) ([]string, error) {
	if n.branchRepo == nil {
		return n.profileIDsForRole(ctx, role)
	}

	organizationID := ""
	branch, err := n.branchRepo.GetByID(ctx, approvalCase.SubjectID)
	if err == nil && branch != nil {
		organizationID = branch.OrganizationID
	}
	if organizationID == "" {
		organizationID = stringValue(approvalCase.Payload["organization_id"])
	}

	branchIDs := map[string]struct{}{}
	if organizationID != "" {
		branches, orgErr := n.branchRepo.GetByOrganizationID(ctx, organizationID, 0, maxCaseRecipients)
		if orgErr == nil {
			for _, item := range branches {
				if item == nil || item.GetID() == "" {
					continue
				}
				branchIDs[item.GetID()] = struct{}{}
			}
		}
	}
	if len(branchIDs) == 0 && branch != nil && branch.GetID() != "" {
		branchIDs[branch.GetID()] = struct{}{}
	}

	profileIDs, err := n.profileIDsForBranches(ctx, branchIDs, role)
	if err != nil {
		return nil, err
	}
	if len(profileIDs) == 0 {
		return n.profileIDsForRole(ctx, role)
	}
	return profileIDs, nil
}

func (n *ApprovalCaseNotifier) clientCaseRecipients(
	ctx context.Context,
	clientID string,
	role int32,
) ([]string, error) {
	if n.clientRepo == nil || n.agentRepo == nil || n.agentBranchRepo == nil {
		return n.profileIDsForRole(ctx, role)
	}

	client, err := n.clientRepo.GetByID(ctx, clientID)
	if err != nil {
		return n.profileIDsForRole(ctx, role)
	}

	agent, err := n.agentRepo.GetByID(ctx, client.AgentID)
	if err != nil {
		return n.profileIDsForRole(ctx, role)
	}

	assignments, err := n.agentBranchRepo.GetByAgentID(ctx, agent.GetID())
	if err != nil {
		return n.profileIDsForRole(ctx, role)
	}

	branchIDs := make(map[string]struct{}, len(assignments))
	for _, assignment := range assignments {
		if assignment == nil || assignment.BranchID == "" {
			continue
		}
		branchIDs[assignment.BranchID] = struct{}{}
	}

	profileIDs, err := n.profileIDsForBranches(ctx, branchIDs, role)
	if err != nil {
		return nil, err
	}
	if len(profileIDs) == 0 {
		return n.profileIDsForRole(ctx, role)
	}
	return profileIDs, nil
}

func (n *ApprovalCaseNotifier) profileIDsForBranches(
	ctx context.Context,
	branchIDs map[string]struct{},
	role int32,
) ([]string, error) {
	if len(branchIDs) == 0 || n.systemUserRepo == nil {
		return nil, nil
	}

	seen := map[string]struct{}{}
	var profileIDs []string

	appendUsers := func(users []*models.SystemUser) {
		for _, user := range users {
			if user == nil || user.ProfileID == "" {
				continue
			}
			if _, found := seen[user.ProfileID]; found {
				continue
			}
			seen[user.ProfileID] = struct{}{}
			profileIDs = append(profileIDs, user.ProfileID)
		}
	}

	for branchID := range branchIDs {
		users, err := n.systemUserRepo.GetByBranchAndRole(ctx, branchID, role, 0, maxCaseRecipients)
		if err != nil {
			return nil, err
		}
		appendUsers(users)
	}

	if len(profileIDs) == 0 && role != int32(identityv1.SystemUserRole_SYSTEM_USER_ROLE_ADMINISTRATOR) {
		admins, err := n.profileIDsForBranches(
			ctx,
			branchIDs,
			int32(identityv1.SystemUserRole_SYSTEM_USER_ROLE_ADMINISTRATOR),
		)
		if err != nil {
			return nil, err
		}
		profileIDs = append(profileIDs, admins...)
	}

	return profileIDs, nil
}

func (n *ApprovalCaseNotifier) profileIDsForRole(ctx context.Context, role int32) ([]string, error) {
	if n.systemUserRepo == nil {
		return nil, nil
	}

	users, err := n.systemUserRepo.GetByRole(ctx, role, 0, maxCaseRecipients)
	if err != nil {
		return nil, err
	}

	seen := map[string]struct{}{}
	profileIDs := make([]string, 0, len(users))
	for _, user := range users {
		if user == nil || user.ProfileID == "" {
			continue
		}
		if _, found := seen[user.ProfileID]; found {
			continue
		}
		seen[user.ProfileID] = struct{}{}
		profileIDs = append(profileIDs, user.ProfileID)
	}

	if len(profileIDs) == 0 && role != int32(identityv1.SystemUserRole_SYSTEM_USER_ROLE_ADMINISTRATOR) {
		return n.profileIDsForRole(ctx, int32(identityv1.SystemUserRole_SYSTEM_USER_ROLE_ADMINISTRATOR))
	}

	return profileIDs, nil
}

func (n *ApprovalCaseNotifier) sendToProfiles(
	ctx context.Context,
	template string,
	approvalCase *models.ApprovalCase,
	profileIDs []string,
	priority notificationv1.PRIORITY,
) {
	logger := util.Log(ctx).WithFields(map[string]any{
		"component": "ApprovalCaseNotifier",
		"case_id":   approvalCase.GetID(),
		"template":  template,
	})

	if n == nil || n.client == nil {
		logger.Warn("notification client is nil, skipping approval case notification")
		return
	}
	if n.profileClient == nil {
		logger.Warn("profile client is nil, skipping approval case notification")
		return
	}

	dataJSON := ""
	if raw, err := json.Marshal(approvalCaseNotificationData(approvalCase)); err != nil {
		logger.WithError(err).Warn("could not marshal approval case notification data")
	} else {
		dataJSON = string(raw)
	}

	sentTo := map[string]struct{}{}
	for _, profileID := range profileIDs {
		contactDetail, profileName, err := n.resolveProfileContact(ctx, profileID)
		if err != nil {
			logger.WithError(err).WithField("profile_id", profileID).
				Warn("could not resolve approval case notification recipient")
			continue
		}
		if contactDetail == "" {
			continue
		}
		if _, found := sentTo[contactDetail]; found {
			continue
		}
		sentTo[contactDetail] = struct{}{}

		n.send(ctx, template, contactDetail, profileName, dataJSON, priority)
	}
}

func (n *ApprovalCaseNotifier) resolveProfileContact(
	ctx context.Context,
	profileID string,
) (string, string, error) {
	resp, err := n.profileClient.GetById(ctx, connect.NewRequest(&profilev1.GetByIdRequest{Id: profileID}))
	if err != nil {
		return "", "", err
	}
	profile := resp.Msg.GetData()
	if profile == nil {
		return "", "", fmt.Errorf("profile %s not found", profileID)
	}

	name := profileID
	if props := profile.GetProperties(); props != nil {
		if value, ok := props.AsMap()["name"].(string); ok && strings.TrimSpace(value) != "" {
			name = value
		}
	}

	fallbackDetail := ""
	for _, contact := range profile.GetContacts() {
		if contact == nil || strings.TrimSpace(contact.GetDetail()) == "" {
			continue
		}
		if fallbackDetail == "" {
			fallbackDetail = contact.GetDetail()
		}
		if contact.GetState() == commonv1.STATE_INACTIVE || contact.GetState() == commonv1.STATE_DELETED {
			continue
		}
		if contact.GetVerified() {
			return contact.GetDetail(), name, nil
		}
	}

	return fallbackDetail, name, nil
}

func (n *ApprovalCaseNotifier) send(
	ctx context.Context,
	template, contactDetail, profileName, dataJSON string,
	priority notificationv1.PRIORITY,
) {
	logger := util.Log(ctx).WithFields(map[string]any{
		"component": "ApprovalCaseNotifier",
		"template":  template,
		"recipient": contactDetail,
	})

	stream, err := n.client.Send(ctx, connect.NewRequest(&notificationv1.SendRequest{
		Data: []*notificationv1.Notification{
			notificationv1.Notification_builder{
				Type:     caseNotificationType,
				Template: template,
				Data:     dataJSON,
				Recipient: commonv1.ContactLink_builder{
					Detail:      contactDetail,
					ProfileName: profileName,
				}.Build(),
				OutBound:    true,
				AutoRelease: true,
				Priority:    priority,
			}.Build(),
		},
	}))
	if err != nil {
		logger.WithError(err).Error("could not send approval case notification")
		return
	}

	for stream.Receive() {
	}
	if closeErr := stream.Close(); closeErr != nil {
		logger.WithError(closeErr).Warn("error closing approval case notification stream")
	}
}

func approvalCaseNotificationData(approvalCase *models.ApprovalCase) map[string]string {
	if approvalCase == nil {
		return map[string]string{}
	}

	return map[string]string{
		"case_id":           approvalCase.GetID(),
		"case_type":         approvalCase.CaseType,
		"case_type_label":   humanizeCaseValue(approvalCase.CaseType),
		"case_status":       approvalCase.Status,
		"case_status_label": humanizeCaseValue(approvalCase.Status),
		"subject_type":      approvalCase.SubjectType,
		"subject_id":        approvalCase.SubjectID,
		"summary":           approvalCase.Summary,
		"requested_by":      approvalCase.RequestedBy,
		"requested_value":   stringValue(approvalCase.Payload[approvalCaseRequestedValueKey]),
		"comment":           approvalCase.Comment,
	}
}

func humanizeCaseValue(value string) string {
	value = strings.TrimSpace(value)
	if value == "" {
		return ""
	}
	parts := strings.Fields(strings.NewReplacer("-", " ", "_", " ").Replace(value))
	for i, part := range parts {
		if part == "" {
			continue
		}
		parts[i] = strings.ToUpper(part[:1]) + strings.ToLower(part[1:])
	}
	return strings.Join(parts, " ")
}

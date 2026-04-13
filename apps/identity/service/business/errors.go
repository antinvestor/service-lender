package business

import "github.com/antinvestor/service-fintech/pkg/apperrors"

var (
	ErrOrganizationNotFound = apperrors.NewError(apperrors.NotFound, "organization not found")
	ErrOrgUnitNotFound      = apperrors.NewError(apperrors.NotFound, "org unit not found")
	ErrBranchNotFound       = apperrors.NewError(apperrors.NotFound, "branch not found")
	ErrAgentNotFound        = apperrors.NewError(apperrors.NotFound, "agent not found")
	ErrClientNotFound       = apperrors.NewError(apperrors.NotFound, "client not found")
	ErrGroupNotFound        = apperrors.NewError(apperrors.NotFound, "group not found")
	ErrMembershipNotFound   = apperrors.NewError(apperrors.NotFound, "membership not found")
	ErrInvestorNotFound     = apperrors.NewError(apperrors.NotFound, "investor not found")
	ErrSystemUserNotFound   = apperrors.NewError(apperrors.NotFound, "system user not found")

	ErrAgentDepthExceeded       = apperrors.NewError(apperrors.Unprocessable, "agent hierarchy depth limit exceeded")
	ErrAgentBranchNotInParent   = apperrors.NewError(apperrors.BadRequest, "branch is not assigned to parent agent")
	ErrOrgUnitNotInOrganization = apperrors.NewError(
		apperrors.BadRequest,
		"org unit does not belong to the specified organization",
	)
	ErrBranchNotInOrganization = apperrors.NewError(
		apperrors.BadRequest,
		"branch does not belong to agent's organization",
	)
	ErrAgentInactive             = apperrors.NewError(apperrors.Unprocessable, "agent is not active")
	ErrClientAlreadyExists       = apperrors.NewError(apperrors.Conflict, "client with this profile already exists")
	ErrReassignSameAgent         = apperrors.NewError(apperrors.BadRequest, "client is already assigned to this agent")
	ErrCoverageAreaRequired      = apperrors.NewError(apperrors.BadRequest, "coverage area is required")
	ErrReassignCrossOrganization = apperrors.NewError(
		apperrors.BadRequest,
		"cannot reassign client to agent in different organization",
	)

	ErrCreditLimitNegative     = apperrors.NewError(apperrors.BadRequest, "credit limit cannot be negative")
	ErrAgentLimitExceedsSystem = apperrors.NewError(
		apperrors.BadRequest,
		"agent credit limit cannot exceed system credit limit",
	)
	ErrCreditLimitChangePending = apperrors.NewError(
		apperrors.Conflict,
		"a credit limit change request is already pending for this client",
	)
	ErrCreditLimitChangeNotFound   = apperrors.NewError(apperrors.NotFound, "credit limit change request not found")
	ErrCreditLimitChangeNotPending = apperrors.NewError(
		apperrors.Unprocessable,
		"credit limit change request is not in pending status",
	)

	ErrApprovalCaseSubjectRequired = apperrors.NewError(
		apperrors.BadRequest,
		"approval case subject and type are required",
	)
	ErrApprovalCaseActorRequired = apperrors.NewError(
		apperrors.BadRequest,
		"approval case actor is required",
	)
	ErrApprovalCaseAlreadyPending = apperrors.NewError(
		apperrors.Conflict,
		"an approval case is already pending for this subject",
	)
	ErrApprovalCaseNotFound   = apperrors.NewError(apperrors.NotFound, "approval case not found")
	ErrApprovalCaseNotPending = apperrors.NewError(
		apperrors.Unprocessable,
		"approval case is not pending",
	)
	ErrApprovalCaseNotPendingVerification = apperrors.NewError(
		apperrors.Unprocessable,
		"approval case is not pending verification",
	)
	ErrApprovalCaseNotPendingApproval = apperrors.NewError(
		apperrors.Unprocessable,
		"approval case is not pending approval",
	)
	ErrClientPhoneChangePending = apperrors.NewError(
		apperrors.Conflict,
		"a phone number change case is already pending for this client",
	)

	ErrLoginClientCreationFailed = apperrors.NewError(
		apperrors.Unprocessable,
		"failed to create login client for partition",
	)

	ErrClientDataEntryNotFound = apperrors.NewError(apperrors.NotFound, "client data entry not found")
)

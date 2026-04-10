package business

import "github.com/antinvestor/service-fintech/pkg/apperrors"

var (
	ErrOrganizationNotFound = apperrors.NewError(apperrors.NotFound, "organization not found")
	ErrBranchNotFound       = apperrors.NewError(apperrors.NotFound, "branch not found")
	ErrAgentNotFound        = apperrors.NewError(apperrors.NotFound, "agent not found")
	ErrClientNotFound       = apperrors.NewError(apperrors.NotFound, "client not found")
	ErrGroupNotFound        = apperrors.NewError(apperrors.NotFound, "group not found")
	ErrMembershipNotFound   = apperrors.NewError(apperrors.NotFound, "membership not found")
	ErrInvestorNotFound     = apperrors.NewError(apperrors.NotFound, "investor not found")
	ErrSystemUserNotFound   = apperrors.NewError(apperrors.NotFound, "system user not found")

	ErrAgentDepthExceeded      = apperrors.NewError(apperrors.Unprocessable, "agent hierarchy depth limit exceeded")
	ErrAgentBranchNotInParent  = apperrors.NewError(apperrors.BadRequest, "branch is not assigned to parent agent")
	ErrBranchNotInOrganization = apperrors.NewError(
		apperrors.BadRequest,
		"branch does not belong to agent's organization",
	)
	ErrAgentInactive             = apperrors.NewError(apperrors.Unprocessable, "agent is not active")
	ErrClientAlreadyExists       = apperrors.NewError(apperrors.Conflict, "client with this profile already exists")
	ErrReassignSameAgent         = apperrors.NewError(apperrors.BadRequest, "client is already assigned to this agent")
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

	ErrLoginClientCreationFailed = apperrors.NewError(
		apperrors.Unprocessable,
		"failed to create login client for partition",
	)

	ErrClientDataEntryNotFound = apperrors.NewError(apperrors.NotFound, "client data entry not found")
)

package authz

const (
	NamespaceLenderIdentity = "service_lender_identity"
	NamespaceTenancyAccess  = "tenancy_access"
	NamespaceProfile        = "profile_user"
)

const (
	PermissionBankManage       = "bank_manage"
	PermissionBankView         = "bank_view"
	PermissionBranchManage     = "branch_manage"
	PermissionBranchView       = "branch_view"
	PermissionAgentCreate      = "agent_create"
	PermissionAgentManage      = "agent_manage"
	PermissionAgentView        = "agent_view"
	PermissionClientCreate     = "client_create"
	PermissionClientManage     = "client_manage"
	PermissionClientView       = "client_view"
	PermissionClientReassign   = "client_reassign"
	PermissionGroupCreate      = "group_create"
	PermissionGroupManage      = "group_manage"
	PermissionGroupView        = "group_view"
	PermissionMembershipCreate = "membership_create"
	PermissionMembershipManage = "membership_manage"
	PermissionMembershipView   = "membership_view"
	PermissionInvestorCreate   = "investor_create"
	PermissionInvestorManage   = "investor_manage"
	PermissionInvestorView     = "investor_view"
	PermissionSystemUserManage = "system_user_manage"
	PermissionSystemUserView   = "system_user_view"
)

const (
	GrantedBankManage       = "granted_bank_manage"
	GrantedBankView         = "granted_bank_view"
	GrantedBranchManage     = "granted_branch_manage"
	GrantedBranchView       = "granted_branch_view"
	GrantedAgentCreate      = "granted_agent_create"
	GrantedAgentManage      = "granted_agent_manage"
	GrantedAgentView        = "granted_agent_view"
	GrantedClientCreate     = "granted_client_create"
	GrantedClientManage     = "granted_client_manage"
	GrantedClientView       = "granted_client_view"
	GrantedClientReassign   = "granted_client_reassign"
	GrantedGroupCreate      = "granted_group_create"
	GrantedGroupManage      = "granted_group_manage"
	GrantedGroupView        = "granted_group_view"
	GrantedMembershipCreate = "granted_membership_create"
	GrantedMembershipManage = "granted_membership_manage"
	GrantedMembershipView   = "granted_membership_view"
	GrantedInvestorCreate   = "granted_investor_create"
	GrantedInvestorManage   = "granted_investor_manage"
	GrantedInvestorView     = "granted_investor_view"
	GrantedSystemUserManage = "granted_system_user_manage"
	GrantedSystemUserView   = "granted_system_user_view"
)

const (
	RoleOwner    = "owner"
	RoleAdmin    = "admin"
	RoleManager  = "manager"
	RoleAgent    = "agent"
	RoleVerifier = "verifier"
	RoleApprover = "approver"
	RoleAuditor  = "auditor"
	RoleViewer   = "viewer"
	RoleService  = "service"
)

var RolePermissions = map[string][]string{ //nolint:gochecknoglobals // permission model registry
	RoleOwner: {
		PermissionBankManage, PermissionBankView,
		PermissionBranchManage, PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionClientCreate, PermissionClientManage, PermissionClientView, PermissionClientReassign,
		PermissionGroupCreate, PermissionGroupManage, PermissionGroupView,
		PermissionMembershipCreate, PermissionMembershipManage, PermissionMembershipView,
		PermissionInvestorCreate, PermissionInvestorManage, PermissionInvestorView,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
	RoleAdmin: {
		PermissionBankManage, PermissionBankView,
		PermissionBranchManage, PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionClientCreate, PermissionClientManage, PermissionClientView, PermissionClientReassign,
		PermissionGroupCreate, PermissionGroupManage, PermissionGroupView,
		PermissionMembershipCreate, PermissionMembershipManage, PermissionMembershipView,
		PermissionInvestorCreate, PermissionInvestorManage, PermissionInvestorView,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
	RoleManager: {
		PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionClientCreate, PermissionClientManage, PermissionClientView, PermissionClientReassign,
		PermissionGroupCreate, PermissionGroupManage, PermissionGroupView,
		PermissionMembershipCreate, PermissionMembershipManage, PermissionMembershipView,
		PermissionSystemUserView,
	},
	RoleAgent: {
		PermissionAgentView,
		PermissionClientCreate, PermissionClientView,
		PermissionGroupCreate, PermissionGroupView,
		PermissionMembershipCreate, PermissionMembershipView,
	},
	RoleVerifier: {
		PermissionBranchView,
		PermissionAgentView,
		PermissionClientView,
		PermissionGroupView,
		PermissionMembershipView,
		PermissionInvestorView,
	},
	RoleApprover: {
		PermissionBranchView,
		PermissionAgentView,
		PermissionClientView,
		PermissionGroupView,
		PermissionMembershipView,
		PermissionInvestorView,
	},
	RoleAuditor: {
		PermissionBankView, PermissionBranchView,
		PermissionAgentView, PermissionClientView,
		PermissionGroupView,
		PermissionMembershipView,
		PermissionInvestorView,
		PermissionSystemUserView,
	},
	RoleViewer: {
		PermissionBankView, PermissionBranchView,
		PermissionAgentView, PermissionClientView,
		PermissionGroupView,
		PermissionMembershipView,
		PermissionInvestorView,
		PermissionSystemUserView,
	},
	RoleService: {
		PermissionBankManage, PermissionBankView,
		PermissionBranchManage, PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionClientCreate, PermissionClientManage, PermissionClientView, PermissionClientReassign,
		PermissionGroupCreate, PermissionGroupManage, PermissionGroupView,
		PermissionMembershipCreate, PermissionMembershipManage, PermissionMembershipView,
		PermissionInvestorCreate, PermissionInvestorManage, PermissionInvestorView,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
}

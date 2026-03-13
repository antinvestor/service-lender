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
		PermissionSystemUserManage, PermissionSystemUserView,
	},
	RoleAdmin: {
		PermissionBankManage, PermissionBankView,
		PermissionBranchManage, PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionClientCreate, PermissionClientManage, PermissionClientView, PermissionClientReassign,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
	RoleManager: {
		PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionClientCreate, PermissionClientManage, PermissionClientView, PermissionClientReassign,
		PermissionSystemUserView,
	},
	RoleAgent: {
		PermissionAgentView,
		PermissionClientCreate, PermissionClientView,
	},
	RoleVerifier: {
		PermissionBranchView,
		PermissionAgentView,
		PermissionClientView,
	},
	RoleApprover: {
		PermissionBranchView,
		PermissionAgentView,
		PermissionClientView,
	},
	RoleAuditor: {
		PermissionBankView, PermissionBranchView,
		PermissionAgentView, PermissionClientView,
		PermissionSystemUserView,
	},
	RoleViewer: {
		PermissionBankView, PermissionBranchView,
		PermissionAgentView, PermissionClientView,
		PermissionSystemUserView,
	},
	RoleService: {
		PermissionBankManage, PermissionBankView,
		PermissionBranchManage, PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionClientCreate, PermissionClientManage, PermissionClientView, PermissionClientReassign,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
}

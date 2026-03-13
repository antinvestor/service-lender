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
	PermissionBorrowerCreate   = "borrower_create"
	PermissionBorrowerManage   = "borrower_manage"
	PermissionBorrowerView     = "borrower_view"
	PermissionBorrowerReassign = "borrower_reassign"
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
	GrantedBorrowerCreate   = "granted_borrower_create"
	GrantedBorrowerManage   = "granted_borrower_manage"
	GrantedBorrowerView     = "granted_borrower_view"
	GrantedBorrowerReassign = "granted_borrower_reassign"
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
		PermissionBorrowerCreate, PermissionBorrowerManage, PermissionBorrowerView, PermissionBorrowerReassign,
		PermissionInvestorCreate, PermissionInvestorManage, PermissionInvestorView,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
	RoleAdmin: {
		PermissionBankManage, PermissionBankView,
		PermissionBranchManage, PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionBorrowerCreate, PermissionBorrowerManage, PermissionBorrowerView, PermissionBorrowerReassign,
		PermissionInvestorCreate, PermissionInvestorManage, PermissionInvestorView,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
	RoleManager: {
		PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionBorrowerCreate, PermissionBorrowerManage, PermissionBorrowerView, PermissionBorrowerReassign,
		PermissionSystemUserView,
	},
	RoleAgent: {
		PermissionAgentView,
		PermissionBorrowerCreate, PermissionBorrowerView,
	},
	RoleVerifier: {
		PermissionBranchView,
		PermissionAgentView,
		PermissionBorrowerView,
		PermissionInvestorView,
	},
	RoleApprover: {
		PermissionBranchView,
		PermissionAgentView,
		PermissionBorrowerView,
		PermissionInvestorView,
	},
	RoleAuditor: {
		PermissionBankView, PermissionBranchView,
		PermissionAgentView, PermissionBorrowerView,
		PermissionInvestorView,
		PermissionSystemUserView,
	},
	RoleViewer: {
		PermissionBankView, PermissionBranchView,
		PermissionAgentView, PermissionBorrowerView,
		PermissionInvestorView,
		PermissionSystemUserView,
	},
	RoleService: {
		PermissionBankManage, PermissionBankView,
		PermissionBranchManage, PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionBorrowerCreate, PermissionBorrowerManage, PermissionBorrowerView, PermissionBorrowerReassign,
		PermissionInvestorCreate, PermissionInvestorManage, PermissionInvestorView,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
}

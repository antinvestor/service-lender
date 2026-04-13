package authz

const (
	NamespaceLoanManagement = "service_loans"
	NamespaceTenancyAccess  = "tenancy_access"
	NamespaceProfile        = "profile_user"
)

const (
	PermissionLoanProductManage         = "loan_product_manage"
	PermissionLoanProductView           = "loan_product_view"
	PermissionLoanRequestView           = "loan_request_view"
	PermissionLoanRequestManage         = "loan_request_manage"
	PermissionLoanRequestSubmit         = "loan_request_submit"
	PermissionClientProductAccessView   = "client_product_access_view"
	PermissionClientProductAccessManage = "client_product_access_manage"
	PermissionLoanView                  = "loan_view"
	PermissionLoanViewOwn               = "loan_view_own"
	PermissionLoanManage                = "loan_manage"
	PermissionRepaymentRecord           = "repayment_record"
	PermissionRepaymentView             = "repayment_view"
	PermissionPenaltyManage             = "penalty_manage"
	PermissionPenaltyWaive              = "penalty_waive"
	PermissionPenaltyView               = "penalty_view"
	PermissionRestructureCreate         = "restructure_create"
	PermissionRestructureApprove        = "restructure_approve"
	PermissionRestructureView           = "restructure_view"
	PermissionReconciliationManage      = "reconciliation_manage"
	PermissionReconciliationView        = "reconciliation_view"
	PermissionCollectionInitiate        = "collection_initiate"
	PermissionStatementView             = "statement_view"
	PermissionWriteOff                  = "write_off"
)

const (
	GrantedLoanProductManage         = "granted_loan_product_manage"
	GrantedLoanProductView           = "granted_loan_product_view"
	GrantedLoanRequestView           = "granted_loan_request_view"
	GrantedLoanRequestManage         = "granted_loan_request_manage"
	GrantedLoanRequestSubmit         = "granted_loan_request_submit"
	GrantedClientProductAccessView   = "granted_client_product_access_view"
	GrantedClientProductAccessManage = "granted_client_product_access_manage"
	GrantedLoanView                  = "granted_loan_view"
	GrantedLoanViewOwn               = "granted_loan_view_own"
	GrantedLoanManage                = "granted_loan_manage"
	GrantedRepaymentRecord           = "granted_repayment_record"
	GrantedRepaymentView             = "granted_repayment_view"
	GrantedPenaltyManage             = "granted_penalty_manage"
	GrantedPenaltyWaive              = "granted_penalty_waive"
	GrantedPenaltyView               = "granted_penalty_view"
	GrantedRestructureCreate         = "granted_restructure_create"
	GrantedRestructureApprove        = "granted_restructure_approve"
	GrantedRestructureView           = "granted_restructure_view"
	GrantedReconciliationManage      = "granted_reconciliation_manage"
	GrantedReconciliationView        = "granted_reconciliation_view"
	GrantedCollectionInitiate        = "granted_collection_initiate"
	GrantedStatementView             = "granted_statement_view"
	GrantedWriteOff                  = "granted_write_off"
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
		PermissionLoanProductManage, PermissionLoanProductView,
		PermissionLoanView, PermissionLoanViewOwn, PermissionLoanManage,
		PermissionRepaymentRecord, PermissionRepaymentView,
		PermissionPenaltyManage, PermissionPenaltyWaive, PermissionPenaltyView,
		PermissionRestructureCreate, PermissionRestructureApprove, PermissionRestructureView,
		PermissionReconciliationManage, PermissionReconciliationView,
		PermissionCollectionInitiate, PermissionStatementView, PermissionWriteOff,
	},
	RoleAdmin: {
		PermissionLoanProductManage, PermissionLoanProductView,
		PermissionLoanView, PermissionLoanViewOwn, PermissionLoanManage,
		PermissionRepaymentRecord, PermissionRepaymentView,
		PermissionPenaltyManage, PermissionPenaltyWaive, PermissionPenaltyView,
		PermissionRestructureCreate, PermissionRestructureApprove, PermissionRestructureView,
		PermissionReconciliationManage, PermissionReconciliationView,
		PermissionCollectionInitiate, PermissionStatementView, PermissionWriteOff,
	},
	RoleManager: {
		PermissionLoanProductManage, PermissionLoanProductView,
		PermissionLoanView, PermissionLoanViewOwn, PermissionLoanManage,
		PermissionRepaymentRecord, PermissionRepaymentView,
		PermissionPenaltyManage, PermissionPenaltyView,
		PermissionRestructureCreate, PermissionRestructureView,
		PermissionReconciliationView,
		PermissionCollectionInitiate, PermissionStatementView,
	},
	RoleAgent: {
		PermissionLoanProductView,
		PermissionLoanViewOwn,
		PermissionRepaymentView,
		PermissionPenaltyView,
		PermissionCollectionInitiate, PermissionStatementView,
	},
	RoleVerifier: {
		PermissionLoanProductView,
		PermissionLoanView,
		PermissionRepaymentView,
		PermissionPenaltyView,
		PermissionRestructureView,
		PermissionReconciliationView,
		PermissionStatementView,
	},
	RoleApprover: {
		PermissionLoanProductView,
		PermissionLoanView,
		PermissionRepaymentView,
		PermissionPenaltyWaive, PermissionPenaltyView,
		PermissionRestructureApprove, PermissionRestructureView,
		PermissionStatementView, PermissionWriteOff,
	},
	RoleAuditor: {
		PermissionLoanProductView,
		PermissionLoanView,
		PermissionRepaymentView,
		PermissionPenaltyView,
		PermissionRestructureView,
		PermissionReconciliationView,
		PermissionStatementView,
	},
	RoleViewer: {
		PermissionLoanProductView,
		PermissionLoanView,
		PermissionRepaymentView,
		PermissionPenaltyView,
		PermissionRestructureView,
		PermissionReconciliationView,
		PermissionStatementView,
	},
	RoleService: {
		PermissionLoanProductManage, PermissionLoanProductView,
		PermissionLoanView, PermissionLoanViewOwn, PermissionLoanManage,
		PermissionRepaymentRecord, PermissionRepaymentView,
		PermissionPenaltyManage, PermissionPenaltyWaive, PermissionPenaltyView,
		PermissionRestructureCreate, PermissionRestructureApprove, PermissionRestructureView,
		PermissionReconciliationManage, PermissionReconciliationView,
		PermissionCollectionInitiate, PermissionStatementView, PermissionWriteOff,
	},
}

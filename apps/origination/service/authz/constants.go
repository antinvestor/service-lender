package authz

const (
	NamespaceLenderOrigination = "service_lender_origination"
	NamespaceTenancyAccess     = "tenancy_access"
	NamespaceProfile           = "profile_user"
)

const (
	PermissionApplicationCreate        = "application_create"
	PermissionApplicationManage        = "application_manage"
	PermissionApplicationView          = "application_view"
	PermissionApplicationSubmit        = "application_submit"
	PermissionApplicationCancel        = "application_cancel"
	PermissionApplicationAcceptOffer   = "application_accept_offer"
	PermissionApplicationDeclineOffer  = "application_decline_offer"
	PermissionDocumentManage           = "document_manage"
	PermissionDocumentView             = "document_view"
	PermissionVerificationTaskManage   = "verification_task_manage"
	PermissionVerificationTaskView     = "verification_task_view"
	PermissionVerificationTaskComplete = "verification_task_complete"
	PermissionUnderwritingManage       = "underwriting_manage"
	PermissionUnderwritingView         = "underwriting_view"
)

const (
	GrantedApplicationCreate        = "granted_application_create"
	GrantedApplicationManage        = "granted_application_manage"
	GrantedApplicationView          = "granted_application_view"
	GrantedApplicationSubmit        = "granted_application_submit"
	GrantedApplicationCancel        = "granted_application_cancel"
	GrantedApplicationAcceptOffer   = "granted_application_accept_offer"
	GrantedApplicationDeclineOffer  = "granted_application_decline_offer"
	GrantedDocumentManage           = "granted_document_manage"
	GrantedDocumentView             = "granted_document_view"
	GrantedVerificationTaskManage   = "granted_verification_task_manage"
	GrantedVerificationTaskView     = "granted_verification_task_view"
	GrantedVerificationTaskComplete = "granted_verification_task_complete"
	GrantedUnderwritingManage       = "granted_underwriting_manage"
	GrantedUnderwritingView         = "granted_underwriting_view"
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
		PermissionApplicationCreate, PermissionApplicationManage, PermissionApplicationView,
		PermissionApplicationSubmit, PermissionApplicationCancel,
		PermissionApplicationAcceptOffer, PermissionApplicationDeclineOffer,
		PermissionDocumentManage, PermissionDocumentView,
		PermissionVerificationTaskManage, PermissionVerificationTaskView, PermissionVerificationTaskComplete,
		PermissionUnderwritingManage, PermissionUnderwritingView,
	},
	RoleAdmin: {
		PermissionApplicationCreate, PermissionApplicationManage, PermissionApplicationView,
		PermissionApplicationSubmit, PermissionApplicationCancel,
		PermissionApplicationAcceptOffer, PermissionApplicationDeclineOffer,
		PermissionDocumentManage, PermissionDocumentView,
		PermissionVerificationTaskManage, PermissionVerificationTaskView, PermissionVerificationTaskComplete,
		PermissionUnderwritingManage, PermissionUnderwritingView,
	},
	RoleManager: {
		PermissionApplicationCreate, PermissionApplicationManage, PermissionApplicationView,
		PermissionApplicationSubmit, PermissionApplicationCancel,
		PermissionDocumentManage, PermissionDocumentView,
		PermissionVerificationTaskManage, PermissionVerificationTaskView, PermissionVerificationTaskComplete,
		PermissionUnderwritingView,
	},
	RoleAgent: {
		PermissionApplicationCreate, PermissionApplicationView,
		PermissionApplicationSubmit,
		PermissionDocumentManage, PermissionDocumentView,
	},
	RoleVerifier: {
		PermissionApplicationView,
		PermissionDocumentView,
		PermissionVerificationTaskView, PermissionVerificationTaskComplete,
	},
	RoleApprover: {
		PermissionApplicationView,
		PermissionDocumentView,
		PermissionVerificationTaskView,
		PermissionUnderwritingManage, PermissionUnderwritingView,
		PermissionApplicationAcceptOffer, PermissionApplicationDeclineOffer,
	},
	RoleAuditor: {
		PermissionApplicationView,
		PermissionDocumentView,
		PermissionVerificationTaskView,
		PermissionUnderwritingView,
	},
	RoleViewer: {
		PermissionApplicationView,
		PermissionDocumentView,
		PermissionVerificationTaskView,
		PermissionUnderwritingView,
	},
	RoleService: {
		PermissionApplicationCreate, PermissionApplicationManage, PermissionApplicationView,
		PermissionApplicationSubmit, PermissionApplicationCancel,
		PermissionApplicationAcceptOffer, PermissionApplicationDeclineOffer,
		PermissionDocumentManage, PermissionDocumentView,
		PermissionVerificationTaskManage, PermissionVerificationTaskView, PermissionVerificationTaskComplete,
		PermissionUnderwritingManage, PermissionUnderwritingView,
	},
}

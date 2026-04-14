// Copyright 2023-2026 Ant Investor Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package authz

const (
	NamespaceLenderIdentity = "service_identity"
	NamespaceField          = "service_field"
	NamespaceTenancyAccess  = "tenancy_access"
	NamespaceProfile        = "profile_user"
)

const (
	PermissionOrganizationManage   = "organization_manage"
	PermissionOrganizationView     = "organization_view"
	PermissionBranchManage         = "branch_manage"
	PermissionBranchView           = "branch_view"
	PermissionAgentCreate          = "agent_create"
	PermissionAgentManage          = "agent_manage"
	PermissionAgentView            = "agent_view"
	PermissionClientCreate         = "client_create"
	PermissionClientManage         = "client_manage"
	PermissionClientView           = "client_view"
	PermissionClientReassign       = "client_reassign"
	PermissionGroupCreate          = "group_create"
	PermissionGroupManage          = "group_manage"
	PermissionGroupView            = "group_view"
	PermissionMembershipCreate     = "membership_create"
	PermissionMembershipManage     = "membership_manage"
	PermissionMembershipView       = "membership_view"
	PermissionInvestorCreate       = "investor_create"
	PermissionInvestorManage       = "investor_manage"
	PermissionInvestorView         = "investor_view"
	PermissionSystemUserManage     = "system_user_manage"
	PermissionSystemUserView       = "system_user_view"
	PermissionFormTemplateManage   = "form_template_manage"
	PermissionFormTemplateView     = "form_template_view"
	PermissionFormSubmissionManage = "form_submission_manage"
	PermissionFormSubmissionView   = "form_submission_view"
)

const (
	GrantedOrganizationManage = "granted_organization_manage"
	GrantedOrganizationView   = "granted_organization_view"
	GrantedBranchManage       = "granted_branch_manage"
	GrantedBranchView         = "granted_branch_view"
	GrantedAgentCreate        = "granted_agent_create"
	GrantedAgentManage        = "granted_agent_manage"
	GrantedAgentView          = "granted_agent_view"
	GrantedClientCreate       = "granted_client_create"
	GrantedClientManage       = "granted_client_manage"
	GrantedClientView         = "granted_client_view"
	GrantedClientReassign     = "granted_client_reassign"
	GrantedGroupCreate        = "granted_group_create"
	GrantedGroupManage        = "granted_group_manage"
	GrantedGroupView          = "granted_group_view"
	GrantedMembershipCreate   = "granted_membership_create"
	GrantedMembershipManage   = "granted_membership_manage"
	GrantedMembershipView     = "granted_membership_view"
	GrantedInvestorCreate     = "granted_investor_create"
	GrantedInvestorManage     = "granted_investor_manage"
	GrantedInvestorView       = "granted_investor_view"
	GrantedSystemUserManage   = "granted_system_user_manage"
	GrantedSystemUserView     = "granted_system_user_view"
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
		PermissionOrganizationManage, PermissionOrganizationView,
		PermissionBranchManage, PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionClientCreate, PermissionClientManage, PermissionClientView, PermissionClientReassign,
		PermissionGroupCreate, PermissionGroupManage, PermissionGroupView,
		PermissionMembershipCreate, PermissionMembershipManage, PermissionMembershipView,
		PermissionInvestorCreate, PermissionInvestorManage, PermissionInvestorView,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
	RoleAdmin: {
		PermissionOrganizationManage, PermissionOrganizationView,
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
		PermissionOrganizationView, PermissionBranchView,
		PermissionAgentView, PermissionClientView,
		PermissionGroupView,
		PermissionMembershipView,
		PermissionInvestorView,
		PermissionSystemUserView,
	},
	RoleViewer: {
		PermissionOrganizationView, PermissionBranchView,
		PermissionAgentView, PermissionClientView,
		PermissionGroupView,
		PermissionMembershipView,
		PermissionInvestorView,
		PermissionSystemUserView,
	},
	RoleService: {
		PermissionOrganizationManage, PermissionOrganizationView,
		PermissionBranchManage, PermissionBranchView,
		PermissionAgentCreate, PermissionAgentManage, PermissionAgentView,
		PermissionClientCreate, PermissionClientManage, PermissionClientView, PermissionClientReassign,
		PermissionGroupCreate, PermissionGroupManage, PermissionGroupView,
		PermissionMembershipCreate, PermissionMembershipManage, PermissionMembershipView,
		PermissionInvestorCreate, PermissionInvestorManage, PermissionInvestorView,
		PermissionSystemUserManage, PermissionSystemUserView,
	},
}

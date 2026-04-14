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
	NamespaceLenderSavings = "service_savings"
	NamespaceTenancyAccess = "tenancy_access"
	NamespaceProfile       = "profile_user"
)

// Permissions.
const (
	PermissionSavingsProductManage = "savings_product_manage"
	PermissionSavingsProductView   = "savings_product_view"
	PermissionSavingsAccountCreate = "savings_account_create"
	PermissionSavingsAccountManage = "savings_account_manage"
	PermissionSavingsAccountView   = "savings_account_view"
	PermissionDepositRecord        = "deposit_record"
	PermissionDepositView          = "deposit_view"
	PermissionWithdrawalRequest    = "withdrawal_request"
	PermissionWithdrawalApprove    = "withdrawal_approve"
	PermissionWithdrawalView       = "withdrawal_view"
	PermissionInterestAccrualView  = "interest_accrual_view"
)

// Granted relations.
const (
	GrantedSavingsProductManage = "granted_savings_product_manage"
	GrantedSavingsProductView   = "granted_savings_product_view"
	GrantedSavingsAccountCreate = "granted_savings_account_create"
	GrantedSavingsAccountManage = "granted_savings_account_manage"
	GrantedSavingsAccountView   = "granted_savings_account_view"
	GrantedDepositRecord        = "granted_deposit_record"
	GrantedDepositView          = "granted_deposit_view"
	GrantedWithdrawalRequest    = "granted_withdrawal_request"
	GrantedWithdrawalApprove    = "granted_withdrawal_approve"
	GrantedWithdrawalView       = "granted_withdrawal_view"
	GrantedInterestAccrualView  = "granted_interest_accrual_view"
)

// Roles.
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
		PermissionSavingsProductManage, PermissionSavingsProductView,
		PermissionSavingsAccountCreate, PermissionSavingsAccountManage, PermissionSavingsAccountView,
		PermissionDepositRecord, PermissionDepositView,
		PermissionWithdrawalRequest, PermissionWithdrawalApprove, PermissionWithdrawalView,
		PermissionInterestAccrualView,
	},
	RoleAdmin: {
		PermissionSavingsProductManage, PermissionSavingsProductView,
		PermissionSavingsAccountCreate, PermissionSavingsAccountManage, PermissionSavingsAccountView,
		PermissionDepositRecord, PermissionDepositView,
		PermissionWithdrawalRequest, PermissionWithdrawalApprove, PermissionWithdrawalView,
		PermissionInterestAccrualView,
	},
	RoleManager: {
		PermissionSavingsProductView,
		PermissionSavingsAccountCreate, PermissionSavingsAccountManage, PermissionSavingsAccountView,
		PermissionDepositRecord, PermissionDepositView,
		PermissionWithdrawalRequest, PermissionWithdrawalApprove, PermissionWithdrawalView,
		PermissionInterestAccrualView,
	},
	RoleAgent: {
		PermissionSavingsProductView,
		PermissionSavingsAccountCreate, PermissionSavingsAccountView,
		PermissionDepositRecord, PermissionDepositView,
		PermissionWithdrawalRequest, PermissionWithdrawalView,
	},
	RoleVerifier: {
		PermissionSavingsAccountView,
		PermissionDepositView,
		PermissionWithdrawalView,
		PermissionInterestAccrualView,
	},
	RoleApprover: {
		PermissionSavingsAccountView,
		PermissionDepositView,
		PermissionWithdrawalApprove, PermissionWithdrawalView,
		PermissionInterestAccrualView,
	},
	RoleAuditor: {
		PermissionSavingsProductView,
		PermissionSavingsAccountView,
		PermissionDepositView,
		PermissionWithdrawalView,
		PermissionInterestAccrualView,
	},
	RoleViewer: {
		PermissionSavingsProductView,
		PermissionSavingsAccountView,
		PermissionDepositView,
		PermissionWithdrawalView,
		PermissionInterestAccrualView,
	},
	RoleService: {
		PermissionSavingsProductManage, PermissionSavingsProductView,
		PermissionSavingsAccountCreate, PermissionSavingsAccountManage, PermissionSavingsAccountView,
		PermissionDepositRecord, PermissionDepositView,
		PermissionWithdrawalRequest, PermissionWithdrawalApprove, PermissionWithdrawalView,
		PermissionInterestAccrualView,
	},
}

import 'package:antinvestor_ui_core/permissions/permission_manifest.dart';
import 'package:antinvestor_ui_core/permissions/permission_registry.dart';

/// Register permission manifests for all fintech service features.
///
/// These declare the permissions each feature needs, enabling a single
/// batch check at startup. The namespace matches the service's proto
/// service_permissions namespace.
void registerPermissionManifests() {
  final registry = PermissionRegistry.instance;

  // Loan management
  registry.register(const PermissionManifest(
    namespace: 'service_loans',
    permissions: [
      PermissionEntry(
          key: 'loan_view', label: 'View Loans', scope: PermissionScope.service),
      PermissionEntry(
          key: 'loan_request_create',
          label: 'Create Loan Requests',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'loan_request_approve',
          label: 'Approve Loan Requests',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'loan_product_manage',
          label: 'Manage Loan Products',
          scope: PermissionScope.feature),
      PermissionEntry(
          key: 'loan_restructure',
          label: 'Restructure Loans',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'loan_disburse',
          label: 'Disburse Loans',
          scope: PermissionScope.action),
    ],
  ));

  // Savings
  registry.register(const PermissionManifest(
    namespace: 'service_savings',
    permissions: [
      PermissionEntry(
          key: 'savings_view',
          label: 'View Savings',
          scope: PermissionScope.service),
      PermissionEntry(
          key: 'savings_product_manage',
          label: 'Manage Savings Products',
          scope: PermissionScope.feature),
      PermissionEntry(
          key: 'savings_account_manage',
          label: 'Manage Savings Accounts',
          scope: PermissionScope.action),
    ],
  ));

  // Funding / Investors
  registry.register(const PermissionManifest(
    namespace: 'service_funding',
    permissions: [
      PermissionEntry(
          key: 'funding_view',
          label: 'View Funding',
          scope: PermissionScope.service),
      PermissionEntry(
          key: 'investor_manage',
          label: 'Manage Investors',
          scope: PermissionScope.action),
    ],
  ));

  // Field operations (clients, agents)
  registry.register(const PermissionManifest(
    namespace: 'service_field',
    permissions: [
      PermissionEntry(
          key: 'client_view',
          label: 'View Clients',
          scope: PermissionScope.service),
      PermissionEntry(
          key: 'client_create',
          label: 'Create Clients',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'client_manage',
          label: 'Manage Clients',
          scope: PermissionScope.action),
    ],
  ));

  // Operations (disbursements, transfers)
  registry.register(const PermissionManifest(
    namespace: 'service_operations',
    permissions: [
      PermissionEntry(
          key: 'disbursement_view',
          label: 'View Disbursements',
          scope: PermissionScope.feature),
      PermissionEntry(
          key: 'disbursement_execute',
          label: 'Execute Disbursements',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'transfer_view',
          label: 'View Transfers',
          scope: PermissionScope.feature),
      PermissionEntry(
          key: 'transfer_execute',
          label: 'Execute Transfers',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'template_manage',
          label: 'Manage Notification Templates',
          scope: PermissionScope.feature),
    ],
  ));

  // Organization management
  registry.register(const PermissionManifest(
    namespace: 'service_organization',
    permissions: [
      PermissionEntry(
          key: 'org_view',
          label: 'View Organizations',
          scope: PermissionScope.service),
      PermissionEntry(
          key: 'org_manage',
          label: 'Manage Organizations',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'branch_manage',
          label: 'Manage Branches',
          scope: PermissionScope.action),
    ],
  ));

  // Workforce
  registry.register(const PermissionManifest(
    namespace: 'service_workforce',
    permissions: [
      PermissionEntry(
          key: 'workforce_view',
          label: 'View Workforce',
          scope: PermissionScope.service),
      PermissionEntry(
          key: 'workforce_manage',
          label: 'Manage Workforce',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'workforce_transfer',
          label: 'Transfer Team Members',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'access_role_manage',
          label: 'Manage Access Roles',
          scope: PermissionScope.feature),
    ],
  ));

  // Admin / Audit
  registry.register(const PermissionManifest(
    namespace: 'service_admin',
    permissions: [
      PermissionEntry(
          key: 'audit_view',
          label: 'View Audit Log',
          scope: PermissionScope.feature),
      PermissionEntry(
          key: 'role_manage',
          label: 'Manage Roles',
          scope: PermissionScope.action),
      PermissionEntry(
          key: 'form_template_manage',
          label: 'Manage Form Templates',
          scope: PermissionScope.feature),
    ],
  ));

  // Reporting
  registry.register(const PermissionManifest(
    namespace: 'service_reporting',
    permissions: [
      PermissionEntry(
          key: 'report_view',
          label: 'View Reports',
          scope: PermissionScope.service),
      PermissionEntry(
          key: 'report_export',
          label: 'Export Reports',
          scope: PermissionScope.action),
    ],
  ));
}

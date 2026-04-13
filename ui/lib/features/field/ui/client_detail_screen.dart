import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/auth/role_guard.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/approval_case_panel.dart';
import '../../../core/widgets/application_status_badge.dart';
import '../../../core/widgets/dynamic_form.dart' show mapToStruct, structToMap;
import '../../../core/widgets/loan_status_badge.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../../sdk/src/loans/v1/loans.pbenum.dart';
import '../../../sdk/src/loans/v1/loans.pbenum.dart';
import '../../loan_management/data/loan_account_providers.dart';
import '../../loan_management/data/loan_request_providers.dart';
import '../../auth/data/auth_repository.dart';
import '../data/client_providers.dart';

class ClientDetailScreen extends ConsumerWidget {
  const ClientDetailScreen({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientListProvider(query: '', memberId: ''));

    return clientsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('Error: $e'),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () =>
                  ref.invalidate(clientListProvider(query: '', memberId: '')),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (clients) {
        final client = clients.where((c) => c.id == clientId).firstOrNull;
        if (client == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_off, size: 48),
                const SizedBox(height: 16),
                const Text('Client not found'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go('/field/clients'),
                  child: const Text('Back to Clients'),
                ),
              ],
            ),
          );
        }
        return _ClientDetailContent(client: client);
      },
    );
  }
}

class _ClientDetailContent extends ConsumerWidget {
  const _ClientDetailContent({required this.client});
  final ClientObject client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final properties = client.hasProperties() ? client.properties.fields : null;
    final canManageClients = ref.watch(canManageClientsProvider).value ?? false;
    final canVerify = ref.watch(canManageVerificationProvider).value ?? false;
    final canApprove = ref.watch(canManageUnderwritingProvider).value ?? false;

    // Extract KYC fields for completeness calculation
    final kycFields = _extractKycFields(properties);
    final totalFields = kycFields.length;
    final filledFields = kycFields.values.where((v) => v.isNotEmpty).length;
    final completeness = totalFields > 0 ? filledFields / totalFields : 0.0;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/field/clients'),
                  tooltip: 'Back to Clients',
                ),
                const SizedBox(width: 8),
                ProfileAvatar(
                  profileId: client.profileId,
                  name: client.name.isNotEmpty ? client.name : 'Unknown',
                  size: 56,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name.isNotEmpty ? client.name : 'Unnamed',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          if (properties != null &&
                              _fieldString(properties, 'phone_number').isNotEmpty)
                            Text(
                              _fieldString(properties, 'phone_number'),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          if (properties != null &&
                              _fieldString(properties, 'phone_number').isNotEmpty)
                            Text(
                              ' \u2022 ',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          Text(
                            'ID: ${_shortId(client.id)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      if (client.owningTeamId.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ProfileAvatar(
                              profileId: client.owningTeamId,
                              name: client.owningTeamId,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Relationship manager',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                StateBadge(state: client.state),
              ],
            ),
          ),

          // KYC completeness bar
          if (totalFields > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: _KycCompletenessBar(
                completeness: completeness,
                filled: filledFields,
                total: totalFields,
              ),
            ),

          if (properties != null &&
              _fieldString(properties, 'approval_case_status').isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: ApprovalCasePanel(
                properties: properties,
                title: 'Client change case',
                onVerify: canVerify
                    ? () => _performCaseAction(context, ref, 'verify')
                    : null,
                onApprove: canApprove
                    ? () => _performCaseAction(context, ref, 'approve')
                    : null,
                onReject: (canVerify || canApprove)
                    ? () => _performCaseAction(context, ref, 'reject')
                    : null,
              ),
            ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Row(
              children: [
                RoleGuard(
                  requiredRoles: const {
                    LenderRole.owner,
                    LenderRole.admin,
                    LenderRole.manager,
                    LenderRole.fieldWorker,
                  },
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to application creation with client pre-selected
                      context.go('/loans/requests');
                    },
                    icon: const Icon(Icons.description_outlined, size: 18),
                    label: const Text('New Application'),
                  ),
                ),
                if (canManageClients) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _requestPhoneChange(context, ref),
                    icon: const Icon(Icons.phone_outlined, size: 18),
                    label: const Text('Change Phone'),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Tabs
          TabBar(
            tabs: const [
              Tab(text: 'Profile'),
              Tab(text: 'Applications'),
              Tab(text: 'Loans'),
            ],
            labelColor: theme.colorScheme.secondary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.secondary,
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                _ProfileTab(client: client, kycFields: kycFields),
                _ApplicationsTab(clientId: client.id),
                _LoansTab(clientId: client.id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPhoneChange(BuildContext context, WidgetRef ref) async {
    final currentPhone = _fieldString(
      client.hasProperties() ? client.properties.fields : null,
      'pending_phone_number',
    ).isNotEmpty
        ? _fieldString(
            client.hasProperties() ? client.properties.fields : null,
            'pending_phone_number',
          )
        : _fieldString(
            client.hasProperties() ? client.properties.fields : null,
            'phone_number',
          );
    final controller = TextEditingController(text: currentPhone);
    final nextPhone = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Phone Change'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter the new client phone number',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (nextPhone == null || nextPhone.isEmpty) return;

    final profileId = await ref.read(currentProfileIdProvider.future) ?? '';
    final updated = client.clone();
    final props = updated.hasProperties()
        ? structToMap(updated.properties)
        : <String, dynamic>{};
    props['phone_number'] = nextPhone;
    props['case_actor_id'] = profileId;
    updated.properties = mapToStruct(props);

    try {
      await ref.read(clientProvider.notifier).save(updated);
      ref.invalidate(clientListProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone change case submitted')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit phone change: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _performCaseAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final profileId = await ref.read(currentProfileIdProvider.future) ?? '';
    final updated = client.clone();
    final props = updated.hasProperties()
        ? structToMap(updated.properties)
        : <String, dynamic>{};
    props['case_action'] = action;
    props['case_actor_id'] = profileId;
    updated.properties = mapToStruct(props);

    try {
      await ref.read(clientProvider.notifier).save(updated);
      ref.invalidate(clientListProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Client case ${action}d successfully')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to $action client case: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _shortId(String id) =>
      id.length > 12 ? '${id.substring(0, 12)}...' : id;

  /// Extract KYC-relevant fields from client properties.
  Map<String, String> _extractKycFields(Map<String, dynamic>? properties) {
    if (properties == null) return {};
    final result = <String, String>{};
    for (final entry in properties.entries) {
      final v = entry.value;
      String strVal = '';
      if (v.hasStringValue()) {
        strVal = v.stringValue;
      } else if (v.hasNumberValue()) {
        strVal = v.numberValue.toString();
      } else if (v.hasBoolValue()) {
        strVal = v.boolValue ? 'Yes' : 'No';
      }
      result[entry.key] = strVal;
    }
    return result;
  }

  String _fieldString(Map<String, dynamic>? properties, String key) {
    if (properties == null) return '';
    final value = properties[key];
    if (value == null) return '';
    if (value.hasStringValue()) return value.stringValue;
    if (value.hasNumberValue()) return value.numberValue.toString();
    if (value.hasBoolValue()) return value.boolValue.toString();
    return '';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KYC Completeness Bar
// ─────────────────────────────────────────────────────────────────────────────

class _KycCompletenessBar extends StatelessWidget {
  const _KycCompletenessBar({
    required this.completeness,
    required this.filled,
    required this.total,
  });

  final double completeness;
  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = completeness >= 0.8
        ? Colors.green
        : completeness >= 0.5
        ? Colors.orange
        : Colors.red;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  completeness >= 0.8 ? Icons.check_circle : Icons.info_outline,
                  size: 18,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  'KYC Completeness',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '$filled / $total fields',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completeness,
                backgroundColor: color.withAlpha(30),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Tab — structured property display
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.client, required this.kycFields});
  final ClientObject client;
  final Map<String, String> kycFields;

  /// Known field groupings for display organization.
  static const _personalFields = [
    'name',
    'full_name',
    'first_name',
    'last_name',
    'date_of_birth',
    'dob',
    'gender',
    'id_type',
    'id_number',
    'national_id',
  ];

  static const _contactFields = [
    'phone',
    'phone_number',
    'email',
    'address',
    'physical_address',
    'county',
    'district',
    'sub_county',
    'landmark',
  ];

  static const _financialFields = [
    'employment_status',
    'employer',
    'business_type',
    'monthly_income',
    'income',
    'next_of_kin',
    'next_of_kin_phone',
  ];

  @override
  Widget build(BuildContext context) {
    // Group fields by category
    final personal = <String, String>{};
    final contact = <String, String>{};
    final financial = <String, String>{};
    final other = <String, String>{};

    for (final entry in kycFields.entries) {
      final key = entry.key.toLowerCase();
      if (_personalFields.any((f) => key.contains(f))) {
        personal[entry.key] = entry.value;
      } else if (_contactFields.any((f) => key.contains(f))) {
        contact[entry.key] = entry.value;
      } else if (_financialFields.any((f) => key.contains(f))) {
        financial[entry.key] = entry.value;
      } else {
        other[entry.key] = entry.value;
      }
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Core client info
        _SectionCard(
          title: 'Client Information',
          fields: {
            'Name': client.name,
            'Client ID': client.id,
            'Profile ID': client.profileId,
            'Relationship Manager': client.owningTeamId,
            'State': client.state.name,
          },
        ),

        if (personal.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Personal Information',
            fields: personal.map((k, v) => MapEntry(_humanizeKey(k), v)),
          ),
        ],

        if (contact.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Contact & Address',
            fields: contact.map((k, v) => MapEntry(_humanizeKey(k), v)),
          ),
        ],

        if (financial.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Financial Information',
            fields: financial.map((k, v) => MapEntry(_humanizeKey(k), v)),
          ),
        ],

        if (other.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Additional Properties',
            fields: other.map((k, v) => MapEntry(_humanizeKey(k), v)),
          ),
        ],
      ],
    );
  }

  String _humanizeKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
        )
        .join(' ');
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.fields});
  final String title;
  final Map<String, String> fields;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            for (final entry in fields.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 6, right: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: entry.value.isNotEmpty
                                  ? Colors.green
                                  : Colors.red.withAlpha(150),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value.isNotEmpty ? entry.value : '\u2014',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Applications Tab
// ─────────────────────────────────────────────────────────────────────────────

class _ApplicationsTab extends ConsumerWidget {
  const _ApplicationsTab({required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appsAsync = ref.watch(
      applicationListProvider('', clientId: clientId),
    );

    return appsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $e'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () => ref.invalidate(
                applicationListProvider('', clientId: clientId),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (apps) {
        if (apps.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 48,
                  color: theme.colorScheme.onSurface.withAlpha(100),
                ),
                const SizedBox(height: 16),
                Text(
                  'No applications found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: apps.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final app = apps[index];
            return Card(
              child: InkWell(
                onTap: () => context.go('/loans/requests/${app.id}'),
                borderRadius: DesignTokens.borderRadiusAll,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: DesignTokens.accentBarWidth,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _statusColor(app.status),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatMoney(app.requestedAmount),
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Product: ${app.productId.isNotEmpty ? app.productId.substring(0, app.productId.length.clamp(0, 8)) : "\u2014"}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ApplicationStatusBadge(status: app.status),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(ApplicationStatus status) {
    return switch (status) {
      ApplicationStatus.APPLICATION_STATUS_APPROVED ||
      ApplicationStatus.APPLICATION_STATUS_OFFER_ACCEPTED ||
      ApplicationStatus.APPLICATION_STATUS_LOAN_CREATED => Colors.green,
      ApplicationStatus.APPLICATION_STATUS_REJECTED ||
      ApplicationStatus.APPLICATION_STATUS_CANCELLED => Colors.red,
      _ => Colors.blue,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loans Tab
// ─────────────────────────────────────────────────────────────────────────────

class _LoansTab extends ConsumerWidget {
  const _LoansTab({required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loansAsync = ref.watch(
      loanAccountListProvider(query: '', clientId: clientId),
    );

    return loansAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $e'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () => ref.invalidate(
                loanAccountListProvider(query: '', clientId: clientId),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (loans) {
        if (loans.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.credit_score_outlined,
                  size: 48,
                  color: theme.colorScheme.onSurface.withAlpha(100),
                ),
                const SizedBox(height: 16),
                Text(
                  'No loan accounts found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: loans.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final loan = loans[index];
            return Card(
              child: InkWell(
                onTap: () => context.go('/loans/${loan.id}'),
                borderRadius: DesignTokens.borderRadiusAll,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: DesignTokens.accentBarWidth,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _loanColor(loan.status),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatMoney(loan.principalAmount),
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (loan.daysPastDue > 0)
                              Text(
                                '${loan.daysPastDue} days past due',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.red,
                                ),
                              )
                            else
                              Text(
                                'Term: ${loan.termDays} days',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                      LoanStatusBadge(status: loan.status),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _loanColor(LoanStatus status) {
    return switch (status) {
      LoanStatus.LOAN_STATUS_ACTIVE => Colors.green,
      LoanStatus.LOAN_STATUS_DELINQUENT => Colors.deepOrange,
      LoanStatus.LOAN_STATUS_DEFAULT => Colors.red,
      LoanStatus.LOAN_STATUS_PAID_OFF => Colors.teal,
      _ => Colors.orange,
    };
  }
}

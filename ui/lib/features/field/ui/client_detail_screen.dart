import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/application_status_badge.dart';
import '../../../core/widgets/loan_status_badge.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../../sdk/src/loans/v1/loans.pbenum.dart';
import '../../../sdk/src/origination/v1/origination.pbenum.dart';
import '../../loan_management/data/loan_account_providers.dart';
import '../../origination/data/application_providers.dart';
import '../data/client_providers.dart';

class ClientDetailScreen extends ConsumerWidget {
  const ClientDetailScreen({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync =
        ref.watch(clientListProvider(query: '', agentId: ''));

    return clientsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (clients) {
        final client =
            clients.where((c) => c.id == clientId).firstOrNull;
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
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    client.name.isNotEmpty
                        ? client.name[0].toUpperCase()
                        : '?',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
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
                      Text(
                        'ID: ${_shortId(client.id)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                StateBadge(state: client.state),
              ],
            ),
          ),

          const SizedBox(height: 16),

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
                _ProfileTab(client: client),
                _ApplicationsTab(clientId: client.id),
                _LoansTab(clientId: client.id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _shortId(String id) =>
      id.length > 12 ? '${id.substring(0, 12)}...' : id;
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Tab
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.client});
  final ClientObject client;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final properties = client.hasProperties() ? client.properties : null;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Info card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Client Information',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                _InfoRow(label: 'Name', value: client.name),
                _InfoRow(label: 'Client ID', value: client.id),
                _InfoRow(label: 'Profile ID', value: client.profileId),
                _InfoRow(label: 'Agent ID', value: client.agentId),
                _InfoRow(label: 'State', value: client.state.name),
              ],
            ),
          ),
        ),

        if (properties != null && properties.fields.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Additional Properties',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  for (final entry in properties.fields.entries)
                    _InfoRow(
                      label: entry.key,
                      value: _valueToString(entry.value),
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _valueToString(dynamic value) {
    if (value == null) return '—';
    if (value.hasStringValue()) return value.stringValue;
    if (value.hasNumberValue()) return value.numberValue.toString();
    if (value.hasBoolValue()) return value.boolValue ? 'Yes' : 'No';
    return value.toString();
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
    final appsAsync = ref.watch(applicationListProvider(''));

    return appsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (apps) {
        final clientApps =
            apps.where((a) => a.clientId == clientId).toList();
        if (clientApps.isEmpty) {
          return Center(
            child: Text('No applications found',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: clientApps.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final app = clientApps[index];
            return Card(
              child: InkWell(
                onTap: () =>
                    context.go('/origination/applications/${app.id}'),
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
                              'Product: ${app.productId.isNotEmpty ? app.productId.substring(0, app.productId.length.clamp(0, 8)) : "—"}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    theme.colorScheme.onSurfaceVariant,
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
      ApplicationStatus.APPLICATION_STATUS_LOAN_CREATED =>
        Colors.green,
      ApplicationStatus.APPLICATION_STATUS_REJECTED ||
      ApplicationStatus.APPLICATION_STATUS_CANCELLED =>
        Colors.red,
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
    final loansAsync =
        ref.watch(loanAccountListProvider(query: ''));

    return loansAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (loans) {
        final clientLoans =
            loans.where((l) => l.clientId == clientId).toList();
        if (clientLoans.isEmpty) {
          return Center(
            child: Text('No loan accounts found',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: clientLoans.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final loan = clientLoans[index];
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
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.red),
                              )
                            else
                              Text(
                                'Term: ${loan.termDays} days',
                                style:
                                    theme.textTheme.bodySmall?.copyWith(
                                  color: theme
                                      .colorScheme.onSurfaceVariant,
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

// ─────────────────────────────────────────────────────────────────────────────
// Info Row
// ─────────────────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

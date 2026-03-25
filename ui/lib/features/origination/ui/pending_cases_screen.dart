import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/application_status_badge.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../../../sdk/src/origination/v1/origination.pbenum.dart';
import '../data/application_providers.dart';

class PendingCasesScreen extends ConsumerStatefulWidget {
  const PendingCasesScreen({super.key});

  @override
  ConsumerState<PendingCasesScreen> createState() =>
      _PendingCasesScreenState();
}

class _PendingCasesScreenState extends ConsumerState<PendingCasesScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Icon(Icons.assignment_late_outlined,
                  size: 28, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pending Cases',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tabs
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Verification'),
              Tab(text: 'Underwriting'),
              Tab(text: 'Offers'),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _PendingTab(
                statusFilter:
                    ApplicationStatus.APPLICATION_STATUS_VERIFICATION.name,
                emptyLabel: 'No cases pending verification',
              ),
              _PendingTab(
                statusFilter:
                    ApplicationStatus.APPLICATION_STATUS_UNDERWRITING.name,
                emptyLabel: 'No cases pending underwriting',
              ),
              _PendingTab(
                statusFilter:
                    ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED.name,
                emptyLabel: 'No cases with pending offers',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Individual tab showing filtered applications
// ---------------------------------------------------------------------------

class _PendingTab extends ConsumerStatefulWidget {
  const _PendingTab({
    required this.statusFilter,
    required this.emptyLabel,
  });

  final String statusFilter;
  final String emptyLabel;

  @override
  ConsumerState<_PendingTab> createState() => _PendingTabState();
}

class _PendingTabState extends ConsumerState<_PendingTab> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _query = value.trim();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appsAsync = ref.watch(
      applicationListProvider(_query, statusFilter: widget.statusFilter),
    );

    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search cases...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),
        ),

        // List
        Expanded(
          child: appsAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text('$error', style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () => ref.invalidate(
                      applicationListProvider(
                        _query,
                        statusFilter: widget.statusFilter,
                      ),
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
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer
                              .withAlpha(60),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.check_circle_outline,
                          size: 28,
                          color:
                              theme.colorScheme.primary.withAlpha(160),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.emptyLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withAlpha(140),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 8),
                itemCount: apps.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final app = apps[index];
                  return _PendingCaseCard(
                    app: app,
                    onTap: () => context.go(
                      '/origination/applications/${app.id}',
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Case card
// ---------------------------------------------------------------------------

class _PendingCaseCard extends StatelessWidget {
  const _PendingCaseCard({required this.app, required this.onTap});

  final ApplicationObject app;
  final VoidCallback onTap;

  String _extractRiskFlags() {
    if (!app.hasProperties()) return '';
    try {
      final fields = app.properties.fields;
      final riskFlags = fields['risk_flags'];
      if (riskFlags == null) return '';
      if (riskFlags.hasStringValue()) return riskFlags.stringValue;
      if (riskFlags.hasListValue()) {
        return riskFlags.listValue.values
            .map((v) => v.stringValue)
            .where((s) => s.isNotEmpty)
            .join(', ');
      }
    } catch (_) {
      // Ignore parse errors
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskFlags = _extractRiskFlags();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.description,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Borrower: ${app.borrowerId}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Product: ${app.productId} \u2022 ${formatMoney(app.requestedAmount)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withAlpha(160),
                      ),
                    ),
                    if (app.submittedAt.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Submitted: ${app.submittedAt}',
                          style:
                              theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withAlpha(120),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    if (riskFlags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.red.withAlpha(50),
                            ),
                          ),
                          child: Text(
                            riskFlags,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ApplicationStatusBadge(status: app.status),
            ],
          ),
        ),
      ),
    );
  }
}

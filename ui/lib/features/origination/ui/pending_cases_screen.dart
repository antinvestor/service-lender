import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/application_status_badge.dart';
import '../../../core/widgets/entity_chip.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../core/widgets/resolved_name.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../../dashboard/data/dashboard_providers.dart';
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
    final verCount = ref.watch(pendingVerificationCountProvider);
    final uwCount = ref.watch(pendingUnderwritingCountProvider);
    final offerCount = ref.watch(offerPendingCountProvider);

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
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  ref.invalidate(pendingVerificationCountProvider);
                  ref.invalidate(pendingUnderwritingCountProvider);
                  ref.invalidate(offerPendingCountProvider);
                  ref.invalidate(applicationListProvider);
                },
              ),
            ],
          ),
        ),

        // Tabs with count badges
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: TabBar(
            controller: _tabController,
            tabs: [
              _BadgeTab(
                label: 'Verification',
                count: verCount.when(
                    data: (c) => c, loading: () => null, error: (_, _) => null),
              ),
              _BadgeTab(
                label: 'Underwriting',
                count: uwCount.when(
                    data: (c) => c, loading: () => null, error: (_, _) => null),
              ),
              _BadgeTab(
                label: 'Offers',
                count: offerCount.when(
                    data: (c) => c, loading: () => null, error: (_, _) => null),
              ),
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
                emptyIcon: Icons.verified_user_outlined,
              ),
              _PendingTab(
                statusFilter:
                    ApplicationStatus.APPLICATION_STATUS_UNDERWRITING.name,
                emptyLabel: 'No cases pending underwriting',
                emptyIcon: Icons.gavel_outlined,
              ),
              _PendingTab(
                statusFilter:
                    ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED.name,
                emptyLabel: 'No cases with pending offers',
                emptyIcon: Icons.local_offer_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab with badge count
// ---------------------------------------------------------------------------

class _BadgeTab extends StatelessWidget {
  const _BadgeTab({required this.label, this.count});
  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count != null && count! > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count! > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
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
    this.emptyIcon = Icons.check_circle_outline,
  });

  final String statusFilter;
  final String emptyLabel;
  final IconData emptyIcon;

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
      if (mounted) setState(() => _query = value.trim());
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
            decoration: const InputDecoration(
              hintText: 'Search by client name or ID...',
              prefixIcon: Icon(Icons.search, size: 20),
            ),
          ),
        ),

        // List
        Expanded(
          child: appsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
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
                          _query, statusFilter: widget.statusFilter),
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
                        child: Icon(widget.emptyIcon,
                            size: 28,
                            color: theme.colorScheme.primary.withAlpha(160)),
                      ),
                      const SizedBox(height: 16),
                      Text(widget.emptyLabel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withAlpha(140),
                          )),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(
                  applicationListProvider(
                      _query, statusFilter: widget.statusFilter),
                ),
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: apps.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    return _PendingCaseCard(
                      app: app,
                      onTap: () =>
                          context.go('/origination/applications/${app.id}'),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Enhanced case card with resolved names and urgency
// ---------------------------------------------------------------------------

class _PendingCaseCard extends ConsumerWidget {
  const _PendingCaseCard({required this.app, required this.onTap});

  final ApplicationObject app;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Calculate days in current stage
    final daysInStage = _calculateDaysInStage(app.submittedAt);
    final urgencyColor = daysInStage > 5
        ? Colors.red
        : daysInStage > 2
            ? Colors.orange
            : Colors.green;

    // Risk flags
    final riskFlagCount = _countRiskFlags(app);

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
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClientNameText(
                      clientId: app.clientId,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ApplicationStatusBadge(status: app.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  EntityChip(type: EntityType.product, id: app.productId),
                  const SizedBox(width: 8),
                  Text(
                    formatMoney(app.requestedAmount),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Urgency indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: urgencyColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule,
                            size: 12, color: urgencyColor),
                        const SizedBox(width: 4),
                        Text(
                          daysInStage > 0
                              ? '${daysInStage}d'
                              : 'Today',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: urgencyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (riskFlagCount > 0 || app.agentId.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (app.agentId.isNotEmpty)
                      EntityChip(
                          type: EntityType.agent, id: app.agentId),
                    if (riskFlagCount > 0) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(15),
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: Colors.red.withAlpha(50)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flag,
                                size: 12, color: Colors.red),
                            const SizedBox(width: 4),
                            Text(
                              '$riskFlagCount risk flag${riskFlagCount > 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  int _calculateDaysInStage(String submittedAt) {
    if (submittedAt.isEmpty) return 0;
    try {
      final submitted = DateTime.parse(submittedAt);
      return DateTime.now().difference(submitted).inDays;
    } catch (_) {
      return 0;
    }
  }

  int _countRiskFlags(ApplicationObject app) {
    if (!app.hasProperties()) return 0;
    try {
      final riskFlags = app.properties.fields['risk_flags'];
      if (riskFlags == null) return 0;
      if (riskFlags.hasListValue()) {
        return riskFlags.listValue.values.length;
      }
    } catch (_) {}
    return 0;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/design_tokens.dart';
import '../data/dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);
        final padding = isMobile ? 16.0 : 24.0;
        final crossAxisCount =
            isMobile ? 2 : (constraints.maxWidth > 900 ? 3 : 2);

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pendingVerificationCountProvider);
            ref.invalidate(pendingUnderwritingCountProvider);
            ref.invalidate(offerPendingCountProvider);
            ref.invalidate(activeLoansCountProvider);
            ref.invalidate(pendingDisbursementCountProvider);
            ref.invalidate(delinquentLoansCountProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(padding, padding, padding, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Here\'s an overview of your lending operations.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // Metric cards
              SliverPadding(
                padding: EdgeInsets.all(padding),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 110,
                  ),
                  delegate: SliverChildListDelegate([
                    _MetricCard(
                      label: 'Pending Verification',
                      icon: Icons.verified_user_outlined,
                      accentColor: Colors.purple,
                      countAsync: ref.watch(pendingVerificationCountProvider),
                      onTap: () => context.go('/origination/applications'),
                    ),
                    _MetricCard(
                      label: 'Pending Underwriting',
                      icon: Icons.gavel_outlined,
                      accentColor: Colors.indigo,
                      countAsync: ref.watch(pendingUnderwritingCountProvider),
                      onTap: () => context.go('/origination/applications'),
                    ),
                    _MetricCard(
                      label: 'Offer Pending',
                      icon: Icons.local_offer_outlined,
                      accentColor: Colors.teal,
                      countAsync: ref.watch(offerPendingCountProvider),
                      onTap: () => context.go('/origination/applications'),
                    ),
                    _MetricCard(
                      label: 'Active Loans',
                      icon: Icons.account_balance_wallet_outlined,
                      accentColor: Colors.green,
                      countAsync: ref.watch(activeLoansCountProvider),
                      onTap: () => context.go('/loans'),
                    ),
                    _MetricCard(
                      label: 'Pending Disbursement',
                      icon: Icons.payments_outlined,
                      accentColor: Colors.orange,
                      countAsync: ref.watch(pendingDisbursementCountProvider),
                      onTap: () => context.go('/loans'),
                    ),
                    _MetricCard(
                      label: 'Delinquent Loans',
                      icon: Icons.warning_amber_outlined,
                      accentColor: Colors.red,
                      countAsync: ref.watch(delinquentLoansCountProvider),
                      onTap: () => context.go('/loans'),
                    ),
                  ]),
                ),
              ),

              // Quick Actions section label
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(padding, 8, padding, 16),
                  child: Text(
                    'QUICK ACTIONS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                          letterSpacing: 0.8,
                        ),
                  ),
                ),
              ),

              // Quick action grid
              SliverPadding(
                padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 100,
                  ),
                  delegate: SliverChildListDelegate([
                    _QuickActionCard(
                      icon: Icons.assignment_outlined,
                      label: 'Pending Cases',
                      subtitle: 'View all cases requiring action',
                      onTap: () => context.go('/origination/pending'),
                    ),
                    _QuickActionCard(
                      icon: Icons.description_outlined,
                      label: 'All Applications',
                      subtitle: 'Browse & manage applications',
                      onTap: () => context.go('/origination/applications'),
                    ),
                    _QuickActionCard(
                      icon: Icons.credit_score_outlined,
                      label: 'Loan Accounts',
                      subtitle: 'Manage active loan accounts',
                      onTap: () => context.go('/loans'),
                    ),
                    _QuickActionCard(
                      icon: Icons.history_outlined,
                      label: 'Audit Log',
                      subtitle: 'Review status change history',
                      onTap: () => context.go('/admin/audit'),
                    ),
                    _QuickActionCard(
                      icon: Icons.account_balance_outlined,
                      label: 'Banks & Branches',
                      subtitle: 'Manage organizational structure',
                      onTap: () => context.go('/organization/banks'),
                    ),
                    _QuickActionCard(
                      icon: Icons.person_pin_outlined,
                      label: 'Manage Agents',
                      subtitle: 'Agent hierarchy & assignment',
                      onTap: () => context.go('/field/agents'),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Metric card — tonal surface with left accent bar
// ---------------------------------------------------------------------------

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.countAsync,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accentColor;
  final AsyncValue<int> countAsync;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: DesignTokens.borderRadiusAll,
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: DesignTokens.accentBarWidth,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 22, color: accentColor),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          countAsync.when(
                            data: (count) => Text(
                              '$count',
                              style: GoogleFonts.manrope(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: count > 0 ? accentColor : null,
                              ),
                            ),
                            loading: () => const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            ),
                            error: (_, _) => Icon(
                              Icons.error_outline,
                              size: 20,
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: theme.colorScheme.onSurface.withAlpha(60),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick action card — tonal surface
// ---------------------------------------------------------------------------

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: DesignTokens.borderRadiusAll,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: theme.colorScheme.onSurface.withAlpha(80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

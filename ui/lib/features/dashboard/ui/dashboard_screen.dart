import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/responsive/breakpoints.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(currentUserRolesProvider);

    return rolesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (roles) => _DashboardContent(roles: roles),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.roles});
  final Set<LenderRole> roles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppBreakpoints.isMobile(constraints.maxWidth);
        final crossAxisCount = isMobile ? 1 : (constraints.maxWidth > 900 ? 3 : 2);
        final padding = isMobile ? 16.0 : 24.0;

        return CustomScrollView(
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
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Here\'s an overview of your lending operations.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(140),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stats row
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _buildStatCards(context, roles, isMobile),
                ),
              ),
            ),

            // Section label
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(padding, 8, padding, 12),
                child: Row(
                  children: [
                    Text(
                      'Quick Actions',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withAlpha(160),
                        letterSpacing: 0.3,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.outlineVariant.withAlpha(80),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick action grid
            SliverPadding(
              padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 100,
                ),
                delegate: SliverChildListDelegate(
                  _buildQuickActions(context, roles),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildStatCards(
    BuildContext context,
    Set<LenderRole> roles,
    bool isMobile,
  ) {
    final cards = <Widget>[];
    final cardWidth = isMobile ? double.infinity : 200.0;

    if (_canViewOrg(roles)) {
      cards.add(_StatCard(
        label: 'Active Banks',
        value: '--',
        icon: Icons.account_balance_outlined,
        trend: null,
        width: cardWidth,
      ));
      cards.add(_StatCard(
        label: 'Branches',
        value: '--',
        icon: Icons.store_outlined,
        trend: null,
        width: cardWidth,
      ));
    }

    if (_canViewField(roles)) {
      cards.add(_StatCard(
        label: 'Field Agents',
        value: '--',
        icon: Icons.person_pin_outlined,
        trend: null,
        width: cardWidth,
      ));
      cards.add(_StatCard(
        label: 'Total Clients',
        value: '--',
        icon: Icons.people_outline,
        trend: null,
        width: cardWidth,
      ));
    }

    return cards;
  }

  List<Widget> _buildQuickActions(
    BuildContext context,
    Set<LenderRole> roles,
  ) {
    final actions = <Widget>[];

    if (_canViewOrg(roles)) {
      actions.add(_QuickActionCard(
        icon: Icons.account_balance_outlined,
        label: 'Manage Banks',
        subtitle: 'View and configure banks',
        onTap: () {},
      ));
    }

    if (_canViewField(roles)) {
      actions.add(_QuickActionCard(
        icon: Icons.person_add_outlined,
        label: 'Onboard Client',
        subtitle: 'Register a new client',
        onTap: () {},
      ));
      actions.add(_QuickActionCard(
        icon: Icons.person_pin_outlined,
        label: 'Manage Agents',
        subtitle: 'Agent hierarchy & assignment',
        onTap: () {},
      ));
    }

    if (_canViewAdmin(roles)) {
      actions.add(_QuickActionCard(
        icon: Icons.manage_accounts_outlined,
        label: 'System Users',
        subtitle: 'Manage roles & access',
        onTap: () {},
      ));
    }

    if (actions.isEmpty) {
      actions.add(_QuickActionCard(
        icon: Icons.info_outline,
        label: 'Welcome',
        subtitle: 'No actions available for your role',
        onTap: () {},
      ));
    }

    return actions;
  }

  bool _canViewOrg(Set<LenderRole> roles) => roles.any(
        (r) => {
          LenderRole.owner,
          LenderRole.admin,
          LenderRole.manager,
          LenderRole.verifier,
          LenderRole.approver,
          LenderRole.auditor,
          LenderRole.viewer,
        }.contains(r),
      );

  bool _canViewField(Set<LenderRole> roles) => roles.any(
        (r) => {
          LenderRole.owner,
          LenderRole.admin,
          LenderRole.manager,
          LenderRole.agent,
          LenderRole.verifier,
          LenderRole.approver,
          LenderRole.auditor,
          LenderRole.viewer,
        }.contains(r),
      );

  bool _canViewAdmin(Set<LenderRole> roles) =>
      roles.any((r) => {LenderRole.owner, LenderRole.admin}.contains(r));
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat card
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.trend,
    required this.width,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? trend;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(120),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick action card
// ─────────────────────────────────────────────────────────────────────────────

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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: theme.colorScheme.primary,
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
                        color: theme.colorScheme.onSurface.withAlpha(120),
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

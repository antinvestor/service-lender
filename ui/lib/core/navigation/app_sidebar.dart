import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/auth_state_provider.dart';
import '../../features/organization/data/branch_providers.dart';
import '../../features/organization/data/organization_providers.dart';
import '../auth/tenancy_context.dart';
import '../theme/design_tokens.dart';
import '../widgets/profile_badge.dart';
import 'nav_items.dart';
import 'nav_state.dart';

/// Enterprise sidebar / drawer navigation.
///
/// On desktop/tablet this is rendered as a persistent sidebar.
/// On mobile it is rendered inside a [Drawer].
class AppSidebar extends ConsumerStatefulWidget {
  const AppSidebar({
    super.key,
    required this.currentRoute,
    this.onNavigate,
    this.isDrawer = false,
  });

  final String currentRoute;
  final VoidCallback? onNavigate;
  final bool isDrawer;

  @override
  ConsumerState<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends ConsumerState<AppSidebar> {
  bool _initialExpansionDone = false;
  late SidebarExpansionState _expansionState;

  @override
  void initState() {
    super.initState();
    _expansionState = ref.read(sidebarExpansionProvider);
    _expansionState.addListener(_onExpansionChanged);
  }

  @override
  void dispose() {
    _expansionState.removeListener(_onExpansionChanged);
    super.dispose();
  }

  void _onExpansionChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final navItemsAsync = ref.watch(filteredNavItemsProvider);
    final theme = Theme.of(context);
    final userInfoAsync = ref.watch(currentProfileIdProvider);
    final displayNameAsync = ref.watch(currentDisplayNameProvider);

    return navItemsAsync.when(
      loading: () => const SizedBox(width: 260),
      error: (_, _) => const SizedBox(width: 260),
      data: (items) {
        // Auto-expand current route's section on first build
        if (!_initialExpansionDone) {
          _initialExpansionDone = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _expansionState.expandForRoute(widget.currentRoute, items);
          });
        }

        return Container(
          width: 260,
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              // Brand header
              const _BrandHeader(),

              // Organization & branch context selector
              _TenancyContextSelector(onNavigate: widget.onNavigate),

              // Subtle separator
              Container(height: 1, color: Colors.white.withAlpha(15)),

              // Navigation items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  children: [
                    for (final item in items)
                      _buildNavItem(context, item, _expansionState, depth: 0),
                  ],
                ),
              ),

              // Subtle separator
              Container(height: 1, color: Colors.white.withAlpha(15)),
              // User section
              _UserFooter(
                displayName: displayNameAsync.when(
                  data: (name) => name,
                  loading: () => null,
                  error: (_, _) => null,
                ),
                profileId: userInfoAsync.when(
                  data: (id) => id,
                  loading: () => null,
                  error: (_, _) => null,
                ),
                onLogout: () {
                  ref.read(authStateProvider.notifier).logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavItem item,
    SidebarExpansionState expansion, {
    required int depth,
  }) {
    final isActive =
        item.route != null && widget.currentRoute.startsWith(item.route!);
    final isExpanded = expansion.isExpanded(item.id);

    if (item.hasChildren) {
      return _SectionTile(
        item: item,
        isExpanded: isExpanded,
        isActive: item.matchesRoute(widget.currentRoute),
        depth: depth,
        onToggle: () => expansion.toggle(item.id),
        children: [
          for (final child in item.children)
            _buildNavItem(context, child, expansion, depth: depth + 1),
        ],
      );
    }

    return _LeafTile(
      item: item,
      isActive: isActive,
      depth: depth,
      onTap: () {
        if (item.route != null) {
          context.go(item.route!);
          widget.onNavigate?.call();
        }
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Brand header — white on navy with gradient logo
// ─────────────────────────────────────────────────────────────────────────────

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: DesignTokens.primaryGradient,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withAlpha(30)),
            ),
            child: const Icon(
              Icons.account_balance,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'AntInvestor',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Lender Platform',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(130),
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tenancy context selector — organization & branch picker
// ─────────────────────────────────────────────────────────────────────────────

class _TenancyContextSelector extends ConsumerWidget {
  const _TenancyContextSelector({this.onNavigate});
  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenancy = ref.watch(tenancyContextProvider);

    // Listen for changes from the ChangeNotifier
    _useTenancyListener(context, ref, tenancy);

    final orgName = tenancy.organizationName;
    final branchName = tenancy.branchName;

    // Hide entire selector when fully scoped at branch level
    if (!tenancy.canSelectOrganization && !tenancy.canSelectBranch) {
      // Branch-level login: show fixed context label instead of selectors
      return Container(
        width: double.infinity,
        color: Colors.white.withAlpha(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (orgName.isNotEmpty)
                Text(
                  orgName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(200),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              if (branchName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    branchName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(160),
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      color: Colors.white.withAlpha(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Organization row (only when user can select org)
          if (tenancy.canSelectOrganization)
            InkWell(
              onTap: () => _showOrganizationPicker(context, ref),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 16,
                      color: Colors.white.withAlpha(130),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        orgName.isNotEmpty ? orgName : 'Select Organization',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: orgName.isNotEmpty
                              ? Colors.white.withAlpha(200)
                              : Colors.white.withAlpha(100),
                          fontSize: 11,
                          fontWeight: orgName.isNotEmpty
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.unfold_more,
                      size: 14,
                      color: Colors.white.withAlpha(80),
                    ),
                  ],
                ),
              ),
            ),
          // Fixed org name when logged in at org level
          if (!tenancy.canSelectOrganization && orgName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 16,
                    color: Colors.white.withAlpha(130),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      orgName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlpha(200),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          // Branch row (when org is selected and user can select branch)
          if (tenancy.hasOrganization && tenancy.canSelectBranch)
            InkWell(
              onTap: () =>
                  _showBranchPicker(context, ref, tenancy.organizationId),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 16,
                  top: 2,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.store_outlined,
                      size: 14,
                      color: Colors.white.withAlpha(100),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        branchName.isNotEmpty ? branchName : 'Select Branch',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: branchName.isNotEmpty
                              ? Colors.white.withAlpha(180)
                              : Colors.white.withAlpha(80),
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.unfold_more,
                      size: 12,
                      color: Colors.white.withAlpha(60),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _useTenancyListener(
    BuildContext context,
    WidgetRef ref,
    TenancyContext tenancy,
  ) {
    // Force rebuild on TenancyContext changes via ChangeNotifier
    // This is handled by watching the provider above since it's keepAlive.
  }

  void _showOrganizationPicker(BuildContext context, WidgetRef ref) {
    final orgsAsync = ref.read(organizationListProvider(''));

    final organizations = orgsAsync.value ?? [];
    if (organizations.isEmpty) {
      // Navigate to organizations screen if no orgs loaded yet
      context.go('/organization/organizations');
      onNavigate?.call();
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Select Organization'),
        children: [
          for (final org in organizations)
            SimpleDialogOption(
              onPressed: () {
                final tenancy = ref.read(tenancyContextProvider);
                tenancy.selectOrganization(
                  org.id,
                  org.name,
                  partitionId: org.partitionId,
                );
                Navigator.of(dialogContext).pop();
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    dialogContext,
                  ).colorScheme.primaryContainer,
                  child: Text(
                    org.name.isNotEmpty ? org.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Theme.of(
                        dialogContext,
                      ).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(org.name.isNotEmpty ? org.name : org.id),
                subtitle: org.code.isNotEmpty ? Text(org.code) : null,
                dense: true,
              ),
            ),
        ],
      ),
    );
  }

  void _showBranchPicker(
    BuildContext context,
    WidgetRef ref,
    String organizationId,
  ) {
    final branchesAsync = ref.read(branchListProvider('', organizationId));

    final branches = branchesAsync.value ?? [];
    if (branches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No branches found for this organization.'),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Select Branch'),
        children: [
          for (final branch in branches)
            SimpleDialogOption(
              onPressed: () {
                final tenancy = ref.read(tenancyContextProvider);
                tenancy.selectBranch(
                  branch.id,
                  branch.name,
                  partitionId: branch.partitionId,
                );
                Navigator.of(dialogContext).pop();
              },
              child: ListTile(
                leading: const Icon(Icons.store_outlined),
                title: Text(branch.name.isNotEmpty ? branch.name : branch.id),
                subtitle: branch.code.isNotEmpty ? Text(branch.code) : null,
                dense: true,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section tile (expandable parent)
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTile extends StatelessWidget {
  const _SectionTile({
    required this.item,
    required this.isExpanded,
    required this.isActive,
    required this.depth,
    required this.onToggle,
    required this.children,
  });

  final NavItem item;
  final bool isExpanded;
  final bool isActive;
  final int depth;
  final VoidCallback onToggle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final leftPad = 8.0 + (depth * 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (depth == 0) const SizedBox(height: 4),
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          hoverColor: Colors.white.withAlpha(12),
          splashColor: Colors.white.withAlpha(20),
          child: Container(
            padding: EdgeInsets.only(
              left: leftPad,
              right: 8,
              top: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isActive ? Colors.white.withAlpha(18) : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? (item.activeIcon ?? item.icon) : item.icon,
                  size: 20,
                  color: isActive ? Colors.white : Colors.white.withAlpha(180),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? Colors.white
                          : Colors.white.withAlpha(180),
                      fontSize: 13,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.white.withAlpha(100),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
          sizeCurve: Curves.easeInOut,
        ),
        if (depth == 0) const SizedBox(height: 2),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Leaf tile (navigatable item) with left accent bar
// ─────────────────────────────────────────────────────────────────────────────

class _LeafTile extends StatelessWidget {
  const _LeafTile({
    required this.item,
    required this.isActive,
    required this.depth,
    required this.onTap,
  });

  final NavItem item;
  final bool isActive;
  final int depth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leftPad = 8.0 + (depth * 16.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: Colors.white.withAlpha(12),
          splashColor: Colors.white.withAlpha(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.only(
              left: leftPad,
              right: 8,
              top: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isActive ? Colors.white.withAlpha(20) : Colors.transparent,
            ),
            child: Row(
              children: [
                // Left accent bar for active item
                if (isActive)
                  Container(
                    width: DesignTokens.accentBarWidth,
                    height: 20,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                Icon(
                  isActive ? (item.activeIcon ?? item.icon) : item.icon,
                  size: 18,
                  color: isActive ? Colors.white : Colors.white.withAlpha(140),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? Colors.white
                          : Colors.white.withAlpha(180),
                      fontSize: 13,
                    ),
                  ),
                ),
                if (item.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// User footer — white on navy
// ─────────────────────────────────────────────────────────────────────────────

class _UserFooter extends StatelessWidget {
  const _UserFooter({this.displayName, this.profileId, required this.onLogout});
  final String? displayName;
  final String? profileId;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final label = displayName != null && displayName!.isNotEmpty
        ? displayName!
        : 'User';
    final id = profileId ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: ProfileBadge(
        profileId: id,
        name: label,
        description: 'Signed in',
        avatarSize: 32,
        nameColor: Colors.white,
        descriptionColor: Colors.white.withAlpha(100),
        trailing: IconButton(
          icon: Icon(
            Icons.logout,
            size: 18,
            color: Colors.white.withAlpha(140),
          ),
          tooltip: 'Sign out',
          onPressed: onLogout,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/dynamic_form.dart' show mapToStruct, structToMap;
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../geography/ui/coverage_area_field.dart';
import '../data/org_unit_providers.dart';
import '../data/organization_providers.dart';
import 'org_unit_form_dialog.dart';
import 'organizations_screen.dart';

class OrganizationDetailScreen extends ConsumerWidget {
  const OrganizationDetailScreen({super.key, required this.organizationId});

  final String organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canManage = ref.watch(canManageOrganizationsProvider).value ?? false;

    return FutureBuilder<OrganizationObject>(
      future: _loadOrganization(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final organization = snapshot.data;
        if (organization == null) {
          return const Center(child: Text('Organization not found'));
        }
        return _OrganizationDetailContent(
          organization: organization,
          canManage: canManage,
        );
      },
    );
  }

  Future<OrganizationObject> _loadOrganization(WidgetRef ref) async {
    final client = ref.read(identityServiceClientProvider);
    final response = await client.organizationGet(
      OrganizationGetRequest(id: organizationId),
    );
    return response.data;
  }
}

class _OrganizationDetailContent extends ConsumerStatefulWidget {
  const _OrganizationDetailContent({
    required this.organization,
    required this.canManage,
  });

  final OrganizationObject organization;
  final bool canManage;

  @override
  ConsumerState<_OrganizationDetailContent> createState() =>
      _OrganizationDetailContentState();
}

class _OrganizationDetailContentState
    extends ConsumerState<_OrganizationDetailContent> {
  late OrganizationObject _organization;

  @override
  void initState() {
    super.initState();
    _organization = widget.organization;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orgUnitsAsync = ref.watch(
      orgUnitListProvider(
        organizationId: _organization.id,
        rootOnly: true,
        query: '',
      ),
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/organization/organizations'),
                  tooltip: 'Back to Organizations',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _organization.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Code: ${_organization.code}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(140),
                        ),
                      ),
                    ],
                  ),
                ),
                StateBadge(state: _organization.state),
                if (widget.canManage) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit Organization',
                    onPressed: () => _editOrganization(context),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_organization.clientId.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Card(
                color: theme.colorScheme.primaryContainer.withAlpha(40),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.link,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login URL',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SelectableText(
                              '${Uri.base.origin}/login/${_organization.clientId}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        tooltip: 'Copy login URL',
                        onPressed: () {
                          final url =
                              '${Uri.base.origin}/login/${_organization.clientId}';
                          Clipboard.setData(ClipboardData(text: url));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login URL copied')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (_organization.geoId.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: CoverageAreaSummary(areaId: _organization.geoId),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Top-Level Org Units',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.canManage)
                  FilledButton.icon(
                    onPressed: () => _showOrgUnitDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Org Unit'),
                  ),
              ],
            ),
          ),
        ),
        orgUnitsAsync.when(
          loading: () => const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, _) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Failed to load org units: $error'),
            ),
          ),
          data: (orgUnits) {
            if (orgUnits.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Text('No org units yet'),
                ),
              );
            }
            return SliverList.builder(
              itemCount: orgUnits.length,
              itemBuilder: (context, index) {
                final orgUnit = orgUnits[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        orgUnit.type == OrgUnitType.ORG_UNIT_TYPE_BRANCH
                            ? Icons.store_outlined
                            : Icons.account_tree_outlined,
                      ),
                      title: Text(orgUnit.name),
                      subtitle: Text(orgUnitTypeLabel(orgUnit.type)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (orgUnit.hasChildren)
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.subdirectory_arrow_right),
                            ),
                          StateBadge(state: orgUnit.state),
                        ],
                      ),
                      onTap: () => context.go(
                        '/organization/organizations/${_organization.id}/org-units/${orgUnit.id}',
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _editOrganization(BuildContext context) async {
    final result = await showDialog<OrganizationObject>(
      context: context,
      builder: (context) => OrganizationFormDialog(
        organization: _organization,
        onSave: (updated) async {},
      ),
    );
    if (result == null || !context.mounted) return;

    try {
      await ref.read(organizationProvider.notifier).save(result);
      if (!context.mounted) return;
      setState(() => _organization = result);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Organization updated successfully')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save organization: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _showOrgUnitDialog(BuildContext context) async {
    final result = await showDialog<OrgUnitObject>(
      context: context,
      builder: (context) => OrgUnitFormDialog(
        organizations: [_organization],
        fixedOrganizationId: _organization.id,
      ),
    );
    if (result == null || !context.mounted) return;

    try {
      final profileId = await ref.read(currentProfileIdProvider.future) ?? '';
      final props = result.hasProperties()
          ? structToMap(result.properties)
          : <String, dynamic>{};
      props['case_actor_id'] = profileId;
      result.properties = mapToStruct(props);
      await ref.read(orgUnitProvider.notifier).save(result);
      ref.invalidate(
        orgUnitListProvider(
          organizationId: _organization.id,
          rootOnly: true,
          query: '',
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Org unit created successfully')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save org unit: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

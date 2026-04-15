import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/dynamic_form.dart' show mapToStruct, structToMap;
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../data/org_unit_providers.dart';
import '../data/organization_providers.dart';
import 'org_unit_detail_screen.dart';
import 'org_unit_form_dialog.dart';

class OrgUnitsScreen extends ConsumerStatefulWidget {
  const OrgUnitsScreen({super.key});

  @override
  ConsumerState<OrgUnitsScreen> createState() => _OrgUnitsScreenState();
}

class _OrgUnitsScreenState extends ConsumerState<OrgUnitsScreen> {
  String _searchQuery = '';
  String _selectedOrganizationId = '';
  OrgUnitType _selectedType = OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() => _searchQuery = value.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orgUnitsAsync = ref.watch(
      orgUnitListProvider(
        query: _searchQuery,
        organizationId: _selectedOrganizationId,
        type: _selectedType,
      ),
    );
    final canManage = ref.watch(canManageOrganizationsProvider).value ?? false;
    final organizationsAsync = ref.watch(organizationListProvider(''));
    final organizations =
        organizationsAsync.value ?? const <OrganizationObject>[];
    final organizationMap = {for (final org in organizations) org.id: org.name};

    return EntityListPage<OrgUnitObject>(
      title: 'Org Units',
      icon: Icons.account_tree_outlined,
      items: orgUnitsAsync.value ?? const [],
      isLoading: orgUnitsAsync.isLoading,
      error: orgUnitsAsync.hasError ? orgUnitsAsync.error.toString() : null,
      onRetry: () => ref.invalidate(
        orgUnitListProvider(
          query: _searchQuery,
          organizationId: _selectedOrganizationId,
          type: _selectedType,
        ),
      ),
      searchHint: 'Search org units...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'Add Org Unit',
      canAction: canManage,
      onAction: () => _showOrgUnitDialog(context, organizations: organizations),
      filterWidget: _buildFilters(organizations),
      idOf: (orgUnit) => orgUnit.id,
      detailBuilder: (id) => OrgUnitDetailScreen(orgUnitId: id),
      onNavigate: (id) => context.go('/organization/org-units/$id'),
      emptyDetailMessage: 'Select an org unit to view its hierarchy',
      itemBuilder: (context, orgUnit) => _OrgUnitCard(
        orgUnit: orgUnit,
        organizationName: organizationMap[orgUnit.organizationId],
      ),
    );
  }

  Widget _buildFilters(List<OrganizationObject> organizations) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: _selectedOrganizationId,
          underline: const SizedBox.shrink(),
          items: [
            const DropdownMenuItem(value: '', child: Text('All Organizations')),
            ...organizations.map(
              (org) => DropdownMenuItem(value: org.id, child: Text(org.name)),
            ),
          ],
          onChanged: (value) =>
              setState(() => _selectedOrganizationId = value ?? ''),
        ),
        const SizedBox(width: 8),
        DropdownButton<OrgUnitType>(
          value: _selectedType,
          underline: const SizedBox.shrink(),
          items: [
            const DropdownMenuItem(
              value: OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED,
              child: Text('All Types'),
            ),
            ...editableOrgUnitTypes.map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(orgUnitTypeLabel(type)),
              ),
            ),
          ],
          onChanged: (value) => setState(
            () =>
                _selectedType = value ?? OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED,
          ),
        ),
      ],
    );
  }

  Future<void> _showOrgUnitDialog(
    BuildContext context, {
    OrgUnitObject? orgUnit,
    required List<OrganizationObject> organizations,
  }) async {
    final result = await showDialog<OrgUnitObject>(
      context: context,
      builder: (context) =>
          OrgUnitFormDialog(orgUnit: orgUnit, organizations: organizations),
    );
    if (result == null || !mounted) return;

    try {
      final profileId = await ref.read(currentProfileIdProvider.future) ?? '';
      final props = result.hasProperties()
          ? structToMap(result.properties)
          : <String, dynamic>{};
      props['case_actor_id'] = profileId;
      result.properties = mapToStruct(props);
      await ref.read(orgUnitProvider.notifier).save(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            orgUnit == null
                ? 'Org unit created successfully'
                : 'Org unit updated successfully',
          ),
        ),
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

class _OrgUnitCard extends StatelessWidget {
  const _OrgUnitCard({required this.orgUnit, this.organizationName});

  final OrgUnitObject orgUnit;
  final String? organizationName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            orgUnit.type == OrgUnitType.ORG_UNIT_TYPE_BRANCH
                ? Icons.store_outlined
                : Icons.account_tree_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(orgUnit.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${orgUnitTypeLabel(orgUnit.type)}${orgUnit.code.isNotEmpty ? ' • ${orgUnit.code}' : ''}',
            ),
            if (organizationName != null && organizationName!.isNotEmpty)
              Text(
                organizationName!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (orgUnit.hasChildren)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.subdirectory_arrow_right,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            StateBadge(state: orgUnit.state),
          ],
        ),
      ),
    );
  }
}

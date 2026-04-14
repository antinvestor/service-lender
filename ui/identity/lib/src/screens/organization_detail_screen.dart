import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';
import 'package:antinvestor_ui_core/widgets/state_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/identity_transport_provider.dart';
import '../providers/org_unit_providers.dart';
import '../providers/organization_providers.dart';
import '../widgets/org_unit_helpers.dart';
import '../widgets/state_helpers.dart';
import 'org_unit_form_dialog.dart';
import 'organizations_screen.dart';

class OrganizationDetailScreen extends ConsumerWidget {
  const OrganizationDetailScreen({
    super.key,
    required this.organizationId,
    this.canManage = true,
    this.backRoute = '/organization/organizations',
  });

  final String organizationId;
  final bool canManage;
  final String backRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          backRoute: backRoute,
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
    required this.backRoute,
  });

  final OrganizationObject organization;
  final bool canManage;
  final String backRoute;

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
      orgUnitListProvider((
        organizationId: _organization.id,
        rootOnly: true,
        query: '',
        parentId: '',
        type: OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED,
      )),
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: CustomScrollView(
      slivers: [
        // -- Header -----------------------------------------------------------
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go(widget.backRoute),
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
                StateBadge(state: toCommonState(_organization.state)),
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

        // -- Profile card -----------------------------------------------------
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: _buildProfileCard(theme),
          ),
        ),

        // -- Info grid --------------------------------------------------------
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: _buildInfoGrid(theme),
          ),
        ),

        // -- Client ID card ---------------------------------------------------
        if (_organization.clientId.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: _buildClientIdCard(theme),
            ),
          ),

        // -- Org Units header -------------------------------------------------
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

        // -- Org Units list ---------------------------------------------------
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
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: theme.colorScheme.outlineVariant.withAlpha(38),
                      ),
                    ),
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
                          StateBadge(state: toCommonState(orgUnit.state)),
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
    ),
      ),
    );
  }

  // -- Profile card -----------------------------------------------------------

  Widget _buildProfileCard(ThemeData theme) {
    final initial = _organization.name.isNotEmpty
        ? _organization.name[0].toUpperCase()
        : '?';
    final logoUri = _prop('logo_content_uri');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(38),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: theme.colorScheme.primaryContainer,
              backgroundImage:
                  logoUri.isNotEmpty ? NetworkImage(logoUri) : null,
              child: logoUri.isNotEmpty
                  ? null
                  : Text(
                      initial,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _organization.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      orgTypeLabel(_organization.organizationType),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (_prop('description').isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      _prop('description'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            StateBadge(state: toCommonState(_organization.state)),
          ],
        ),
      ),
    );
  }

  // -- Info grid --------------------------------------------------------------

  Widget _buildInfoGrid(ThemeData theme) {
    final leftItems = <_InfoItem>[
      _InfoItem(
        label: 'Organization Type',
        value: orgTypeLabel(_organization.organizationType),
      ),
      if (_organization.code.isNotEmpty)
        _InfoItem(label: 'Code', value: _organization.code),
      if (_prop('domain_name').isNotEmpty)
        _InfoItem(label: 'Domain', value: _prop('domain_name')),
      if (_organization.geoId.isNotEmpty)
        _InfoItem(label: 'Coverage Area', value: _organization.geoId),
      if (_organization.profileId.isNotEmpty)
        _InfoItem(label: 'Profile ID', value: _organization.profileId),
    ];

    final rightItems = <_InfoItem>[];
    if (_organization.hasProperties()) {
      final addressParts = [
        _prop('address_street'),
        _prop('address_city'),
        _prop('address_country'),
        _prop('address_postal_code'),
      ].where((s) => s.isNotEmpty);
      if (addressParts.isNotEmpty) {
        rightItems.add(
          _InfoItem(label: 'Address', value: addressParts.join('\n')),
        );
      }
    }

    // Read structured contacts from properties.
    final contacts = _readContacts();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(38),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 480) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: leftItems
                              .map((item) => _InfoTile(
                                  label: item.label, value: item.value))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: rightItems
                              .map((item) => _InfoTile(
                                  label: item.label, value: item.value))
                              .toList(),
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [...leftItems, ...rightItems]
                      .map((item) =>
                          _InfoTile(label: item.label, value: item.value))
                      .toList(),
                );
              },
            ),
            if (contacts.isNotEmpty) ...[
              const Divider(height: 32),
              Text(
                'Contacts',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: contacts.map((c) {
                  return Chip(
                    avatar: Icon(
                      c.type == ContactType.email
                          ? Icons.email
                          : Icons.phone,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      '${contactPurposeLabel(c.purpose)}: ${c.value}',
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Read structured contacts from the organization's properties.
  List<OrganizationContact> _readContacts() {
    if (!_organization.hasProperties()) return const [];
    final field = _organization.properties.fields['contacts'];
    if (field == null || !field.hasListValue()) return const [];
    final result = <OrganizationContact>[];
    for (final v in field.listValue.values) {
      if (!v.hasStructValue()) continue;
      final m = <String, dynamic>{};
      for (final entry in v.structValue.fields.entries) {
        if (entry.value.hasStringValue()) {
          m[entry.key] = entry.value.stringValue;
        }
      }
      final contact = OrganizationContact.fromMap(m);
      if (contact != null) result.add(contact);
    }
    return result;
  }

  // -- Client ID card ---------------------------------------------------------

  Widget _buildClientIdCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(38),
        ),
      ),
      color: theme.colorScheme.primaryContainer.withAlpha(40),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    'Client ID',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    _organization.clientId,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              tooltip: 'Copy client ID',
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: _organization.clientId),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Client ID copied')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // -- Property helpers -------------------------------------------------------

  /// Read a string property from the organization's Struct.
  String _prop(String key) {
    if (!_organization.hasProperties()) return '';
    final field = _organization.properties.fields[key];
    if (field == null || !field.hasStringValue()) return '';
    return field.stringValue;
  }


  // -- Actions ----------------------------------------------------------------

  Future<void> _editOrganization(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrganizationFormDialog(
        organization: _organization,
        onSave: (formData) async {
          final org = formData.organization;
          await ref
              .read(organizationNotifierProvider.notifier)
              .save(org);
          if (mounted) {
            setState(() => _organization = org);
          }
        },
      ),
    );
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
      await ref.read(orgUnitNotifierProvider.notifier).save(result);
      ref.invalidate(
        orgUnitListProvider((
          organizationId: _organization.id,
          rootOnly: true,
          query: '',
          parentId: '',
          type: OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED,
        )),
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

// -- Data class for info items ------------------------------------------------

class _InfoItem {
  const _InfoItem({required this.label, required this.value});
  final String label;
  final String value;
}

// -- Info tile widget ---------------------------------------------------------

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

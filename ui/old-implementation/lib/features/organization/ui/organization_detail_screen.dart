import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/file_upload_helper.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/auth/tenancy_context.dart';
import '../../../core/widgets/audit_trail_widget.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/google/protobuf/struct.pb.dart';
import '../../../sdk/src/identity/v1/identity.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../../geography/ui/coverage_area_field.dart';
import '../../workforce/data/workforce_member_providers.dart';
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

  String _prop(String key) {
    if (!_organization.hasProperties()) return '';
    final field = _organization.properties.fields[key];
    if (field == null || !field.hasStringValue()) return '';
    return field.stringValue;
  }

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
    final membersAsync = ref.watch(
      workforceMemberListProvider(
        query: '',
        organizationId: _organization.id,
      ),
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: CustomScrollView(
          slivers: [
            // -- Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () =>
                          context.go('/organization/organizations'),
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
                              color:
                                  theme.colorScheme.onSurface.withAlpha(140),
                            ),
                          ),
                        ],
                      ),
                    ),
                    StateBadge(state: _organization.state),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _setAsActiveOrganization(context),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Set Active'),
                    ),
                    if (widget.canManage) ...[
                      const SizedBox(width: 8),
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

            // -- Profile card with logo
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _buildProfileCard(theme),
              ),
            ),

            // -- Info grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _buildInfoGrid(theme),
              ),
            ),

            // -- Login URL
            if (_organization.clientId.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: _buildClientIdCard(theme),
                ),
              ),

            // -- Coverage area
            if (_organization.geoId.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: CoverageAreaSummary(areaId: _organization.geoId),
                ),
              ),

            // -- Org Units section
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
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withAlpha(38),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: const [
                          DataColumn(label: Text('NAME')),
                          DataColumn(label: Text('TYPE')),
                          DataColumn(label: Text('CODE')),
                          DataColumn(label: Text('STATE')),
                        ],
                        rows: orgUnits.map((orgUnit) {
                          return DataRow(
                            onSelectChanged: (_) => context.go(
                              '/organization/organizations/${_organization.id}/org-units/${orgUnit.id}',
                            ),
                            cells: [
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    orgUnit.type ==
                                            OrgUnitType.ORG_UNIT_TYPE_BRANCH
                                        ? Icons.store_outlined
                                        : Icons.account_tree_outlined,
                                    size: 18,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(orgUnit.name),
                                ],
                              )),
                              DataCell(Text(orgUnitTypeLabel(orgUnit.type))),
                              DataCell(Text(orgUnit.code)),
                              DataCell(StateBadge(state: orgUnit.state)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),

            // -- Workforce section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Workforce Members',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.go('/workforce/members'),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('View All'),
                    ),
                  ],
                ),
              ),
            ),
            membersAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Failed to load members: $error'),
                ),
              ),
              data: (members) {
                if (members.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Text('No workforce members yet'),
                    ),
                  );
                }
                final shown = members.take(5).toList();
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withAlpha(38),
                        ),
                      ),
                      child: Column(
                        children: [
                          ...shown.map((member) {
                            final name = member.hasProperties() &&
                                    member.properties.fields
                                        .containsKey('name')
                                ? member.properties.fields['name']!
                                    .stringValue
                                : member.profileId;
                            return ListTile(
                              leading: ProfileAvatar(
                                profileId: member.profileId,
                                name: name,
                                size: 36,
                              ),
                              title: Text(name),
                              subtitle: Text(
                                _engagementLabel(member.engagementType),
                                style: theme.textTheme.bodySmall,
                              ),
                              trailing: StateBadge(state: member.state),
                              onTap: () => context.go(
                                '/workforce/members/${member.id}',
                              ),
                            );
                          }),
                          if (members.length > 5)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '+ ${members.length - 5} more members',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // -- Audit trail
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: _buildAuditTrail(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Profile card
  Widget _buildProfileCard(ThemeData theme) {
    final initial = _organization.name.isNotEmpty
        ? _organization.name[0].toUpperCase()
        : '?';
    var logoUri = _prop('logo_content_uri');
    if (logoUri.isNotEmpty) logoUri = mxcToHttpUrl(logoUri);

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
          ],
        ),
      ),
    );
  }

  // -- Info grid
  Widget _buildInfoGrid(ThemeData theme) {
    final leftItems = <_InfoItem>[
      _InfoItem(
          label: 'Organization Type',
          value: orgTypeLabel(_organization.organizationType)),
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

  // -- Client ID card
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.link, color: theme.colorScheme.primary, size: 20),
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
    );
  }

  // -- Audit trail placeholder (scoped to this organization)
  Widget _buildAuditTrail(ThemeData theme) {
    // TODO: Wire to real audit service when available.
    // For now, show organization state change history from properties.
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
            Row(
              children: [
                Icon(Icons.history, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Activity History',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAuditEntries(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditEntries(ThemeData theme) {
    // Read audit data from properties if available
    final entries = <AuditTrailEntry>[];
    if (_organization.hasProperties()) {
      final caseAction = _propStr('case_action');
      final caseActorId = _propStr('case_actor_id');
      if (caseAction.isNotEmpty) {
        entries.add(AuditTrailEntry(
          action: 'Case Action: $caseAction',
          timestamp: 'Recent',
          performedBy: caseActorId.isNotEmpty ? caseActorId : null,
          icon: Icons.gavel,
          color: theme.colorScheme.tertiary,
        ));
      }
    }

    // Always show creation entry
    entries.add(AuditTrailEntry(
      action: 'Organization created',
      timestamp: 'State: ${_organization.state.name}',
      performedBy: _organization.profileId.isNotEmpty
          ? _organization.profileId
          : null,
      icon: Icons.add_circle_outline,
      color: theme.colorScheme.primary,
    ));

    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No activity recorded yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Column(children: entries);
  }

  String _propStr(String key) {
    if (!_organization.hasProperties()) return '';
    final field = _organization.properties.fields[key];
    if (field == null || !field.hasStringValue()) return '';
    return field.stringValue;
  }

  // -- Actions
  void _setAsActiveOrganization(BuildContext context) {
    final tenancy = ref.read(tenancyContextProvider);
    tenancy.selectOrganization(
      _organization.id,
      _organization.name,
      partitionId: _organization.partitionId,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_organization.name} set as active organization'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _editOrganization(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrganizationFormDialog(
        organization: _organization,
        onSave: (org, {logoBytes, logoFileName, contacts, description, domainName, street, city, country, postalCode}) async {
          // Upload logo if provided
          String? logoContentUri;
          if (logoBytes != null && logoFileName != null) {
            logoContentUri = await uploadPublicImage(
              ref,
              logoBytes,
              logoFileName,
            );
          }

          // Merge metadata into properties
          final existingFields = org.hasProperties()
              ? Map<String, Value>.from(org.properties.fields)
              : <String, Value>{};
          if (description != null && description.isNotEmpty) {
            existingFields['description'] = Value(stringValue: description);
          }
          if (domainName != null && domainName.isNotEmpty) {
            existingFields['domain_name'] = Value(stringValue: domainName);
          }
          if (street != null) {
            existingFields['address_street'] = Value(stringValue: street);
          }
          if (city != null) {
            existingFields['address_city'] = Value(stringValue: city);
          }
          if (country != null) {
            existingFields['address_country'] = Value(stringValue: country);
          }
          if (postalCode != null) {
            existingFields['address_postal_code'] = Value(stringValue: postalCode);
          }
          if (contacts != null) {
            existingFields['contacts'] = Value(
              listValue: ListValue(
                values: contacts
                    .map((c) => Value(
                          structValue: Struct(fields: {
                            'purpose': Value(stringValue: c.purpose.name),
                            'type': Value(stringValue: c.type.name),
                            'value': Value(stringValue: c.value),
                          }),
                        ))
                    .toList(),
              ),
            );
          }
          if (logoContentUri != null) {
            existingFields['logo_content_uri'] =
                Value(stringValue: logoContentUri);
          }
          if (existingFields.isNotEmpty) {
            org.properties = Struct(fields: existingFields);
          }

          await ref.read(organizationProvider.notifier).save(org);
          if (mounted) {
            // Reload
            final client = ref.read(identityServiceClientProvider);
            final response = await client.organizationGet(
              OrganizationGetRequest(id: _organization.id),
            );
            setState(() => _organization = response.data);
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

  String _engagementLabel(WorkforceEngagementType type) => switch (type) {
        WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE =>
          'Employee',
        WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_CONTRACTOR =>
          'Contractor',
        WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_SERVICE_ACCOUNT =>
          'Service Account',
        _ => 'Unspecified',
      };
}

// -- Helper widgets

class _InfoItem {
  const _InfoItem({required this.label, required this.value});
  final String label;
  final String value;
}

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

/// Convert a proto Struct to a plain map.
Map<String, dynamic> structToMap(Struct struct) {
  final result = <String, dynamic>{};
  for (final entry in struct.fields.entries) {
    if (entry.value.hasStringValue()) {
      result[entry.key] = entry.value.stringValue;
    } else if (entry.value.hasNumberValue()) {
      result[entry.key] = entry.value.numberValue;
    } else if (entry.value.hasBoolValue()) {
      result[entry.key] = entry.value.boolValue;
    }
  }
  return result;
}

/// Convert a plain map to a proto Struct.
Struct mapToStruct(Map<String, dynamic> map) {
  final fields = <String, Value>{};
  for (final entry in map.entries) {
    if (entry.value is String) {
      fields[entry.key] = Value(stringValue: entry.value as String);
    } else if (entry.value is num) {
      fields[entry.key] =
          Value(numberValue: (entry.value as num).toDouble());
    } else if (entry.value is bool) {
      fields[entry.key] = Value(boolValue: entry.value as bool);
    }
  }
  return Struct(fields: fields);
}

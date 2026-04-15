import 'dart:async';

import 'package:antinvestor_api_geolocation/antinvestor_api_geolocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/form_field_card.dart';
import '../data/area_providers.dart';

String areaTypeLabel(AreaType type) {
  final raw = type.name.replaceFirst('AREA_TYPE_', '');
  if (raw.isEmpty) {
    return 'Area';
  }

  return raw
      .toLowerCase()
      .split('_')
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}

class CoverageAreaField extends ConsumerWidget {
  const CoverageAreaField({
    super.key,
    required this.selectedAreaId,
    this.selectedAreaName,
    this.errorText,
    this.enabled = true,
    required this.onSelected,
  });

  final String selectedAreaId;
  final String? selectedAreaName;
  final String? errorText;
  final bool enabled;
  final ValueChanged<AreaObject?> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentAreaAsync = selectedAreaId.isEmpty || selectedAreaName != null
        ? null
        : ref.watch(areaByIdProvider(selectedAreaId));

    final currentArea = currentAreaAsync?.asData?.value;
    final displayName = selectedAreaName ?? currentArea?.name;
    final displaySubtitle = currentArea == null
        ? (selectedAreaId.isNotEmpty
              ? 'Selected area ID: $selectedAreaId'
              : null)
        : '${areaTypeLabel(currentArea.areaType)}${currentArea.description.isNotEmpty ? ' • ${currentArea.description}' : ''}';

    return FormFieldCard(
      label: 'Coverage Area',
      description:
          'Select the geographic area this organization or org unit is responsible for.',
      isRequired: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton.icon(
            onPressed: !enabled
                ? null
                : () async {
                    final selected = await showDialog<AreaObject>(
                      context: context,
                      builder: (context) => const AreaPickerDialog(),
                    );
                    if (selected != null) {
                      onSelected(selected);
                    }
                  },
            icon: const Icon(Icons.public_outlined),
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                displayName == null || displayName.isEmpty
                    ? 'Choose coverage area'
                    : displayName,
              ),
            ),
          ),
          if (displaySubtitle != null && displaySubtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              displaySubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (selectedAreaId.isNotEmpty && enabled) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => onSelected(null),
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear selection'),
            ),
          ],
          if (currentAreaAsync?.hasError ?? false) ...[
            const SizedBox(height: 8),
            Text(
              'Unable to load area details. The saved area ID will still be used.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CoverageAreaSummary extends ConsumerWidget {
  const CoverageAreaSummary({super.key, required this.areaId});

  final String areaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (areaId.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final areaAsync = ref.watch(areaByIdProvider(areaId));

    return areaAsync.when(
      data: (area) {
        final title = area?.name ?? areaId;
        final subtitle = area == null
            ? 'Coverage area ID: $areaId'
            : '${areaTypeLabel(area.areaType)}${area.description.isNotEmpty ? ' • ${area.description}' : ''}';
        return Card(
          child: ListTile(
            leading: Icon(Icons.public, color: theme.colorScheme.primary),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        );
      },
      loading: () => const Card(
        child: ListTile(
          leading: Icon(Icons.public),
          title: Text('Loading coverage area...'),
        ),
      ),
      error: (_, _) => Card(
        child: ListTile(
          leading: Icon(Icons.public, color: theme.colorScheme.primary),
          title: const Text('Coverage Area'),
          subtitle: Text(areaId),
        ),
      ),
    );
  }
}

class AreaPickerDialog extends ConsumerStatefulWidget {
  const AreaPickerDialog({super.key});

  @override
  ConsumerState<AreaPickerDialog> createState() => _AreaPickerDialogState();
}

class _AreaPickerDialogState extends ConsumerState<AreaPickerDialog> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _query = value.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final areasAsync = ref.watch(areaSearchProvider(query: _query));

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 640),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Coverage Area',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Search for an existing geographic area to attach coverage to.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: _onChanged,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search areas by name...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: switch ((_query.length >= 2, areasAsync)) {
                  (false, _) => const Center(
                    child: Text('Type at least 2 characters to search areas'),
                  ),
                  (_, AsyncData(:final value)) when value.isEmpty =>
                    const Center(child: Text('No matching areas found')),
                  (_, AsyncData(:final value)) => ListView.separated(
                    itemCount: value.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final area = value[index];
                      return ListTile(
                        leading: const Icon(Icons.public_outlined),
                        title: Text(area.name),
                        subtitle: Text(
                          '${areaTypeLabel(area.areaType)}${area.description.isNotEmpty ? ' • ${area.description}' : ''}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).pop(area),
                      );
                    },
                  ),
                  (_, AsyncError(:final error)) => Center(
                    child: Text('Failed to search areas: $error'),
                  ),
                  _ => const Center(child: CircularProgressIndicator()),
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

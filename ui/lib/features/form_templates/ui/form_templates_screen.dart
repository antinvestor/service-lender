import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/stream_helpers.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../../../core/data/form_template_providers.dart';

/// Lists all form templates with search, status filter, and create action.
class FormTemplatesScreen extends ConsumerStatefulWidget {
  const FormTemplatesScreen({super.key});

  @override
  ConsumerState<FormTemplatesScreen> createState() =>
      _FormTemplatesScreenState();
}

class _FormTemplatesScreenState extends ConsumerState<FormTemplatesScreen> {
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
        setState(() => _query = value.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(formTemplateListProvider(_query));
    final items = templatesAsync.value ?? [];

    return EntityListPage<FormTemplateObject>(
      title: 'KYC Form Templates',
      icon: Icons.dynamic_form_outlined,
      items: items,
      isLoading: templatesAsync.isLoading,
      hasMore: items.length >= kDefaultPagedResultLimit,
      error:
          templatesAsync.hasError ? templatesAsync.error.toString() : null,
      onRetry: () => ref.invalidate(formTemplateListProvider(_query)),
      searchHint: 'Search templates...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'New Template',
      onAction: () => context.go('/admin/form-templates/new'),
      itemBuilder: (context, template) =>
          _TemplateCard(template: template),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});

  final FormTemplateObject template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.dynamic_form,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          template.name.isNotEmpty ? template.name : '(untitled)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${template.fields.length} fields  \u2022  v${template.version}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: _StatusBadge(status: template.status),
        onTap: () => context.go(
          '/admin/form-templates/${template.id}',
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final FormTemplateStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      FormTemplateStatus.FORM_TEMPLATE_STATUS_DRAFT =>
        ('DRAFT', Colors.orange),
      FormTemplateStatus.FORM_TEMPLATE_STATUS_PUBLISHED =>
        ('PUBLISHED', Colors.green),
      FormTemplateStatus.FORM_TEMPLATE_STATUS_ARCHIVED =>
        ('ARCHIVED', Colors.grey),
      _ => ('UNKNOWN', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

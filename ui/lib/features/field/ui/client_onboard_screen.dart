import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/tenancy_context.dart';
import '../../../core/data/form_template_providers.dart';
import '../../../core/widgets/dynamic_form.dart';
import '../../../core/widgets/dynamic_form_renderer.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../data/client_providers.dart';
import '../data/current_agent_provider.dart';

/// Multi-step client onboarding wizard using the dynamic form renderer.
///
/// Loads form templates configured for the "client" entity type from the
/// backend. If multiple templates are found, they are presented as sequential
/// forms via [FormRequirementWizard] semantics. If no templates are configured
/// yet, a helpful empty state guides the admin to create one.
class ClientOnboardScreen extends ConsumerWidget {
  const ClientOnboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tenancy = ref.watch(tenancyContextProvider);

    if (!tenancy.hasBranch) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.store_outlined,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text('Select a branch first', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Use the sidebar to select an organization and branch '
                'before onboarding a client.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final templatesAsync = ref.watch(
      entityFormTemplatesProvider(entityType: FormEntityType.client),
    );

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/field/clients'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Onboard New Client',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Dynamic form loaded from backend templates
        Expanded(
          child: templatesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error loading form templates: $e'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => ref.invalidate(
                      entityFormTemplatesProvider(
                        entityType: FormEntityType.client,
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (templates) {
              if (templates.isEmpty) {
                return _NoTemplatesConfigured(theme: theme);
              }

              // Use the first published template for onboarding.
              // Multiple templates would use FormRequirementWizard.
              if (templates.length == 1) {
                return DynamicFormRenderer(
                  template: templates.first,
                  onSubmit: (data, fileData) =>
                      _saveClient(context, ref, data),
                );
              }

              // Multiple templates — build ProductFormRequirements for the
              // wizard to iterate through.
              final requirements = templates.asMap().entries.map((e) {
                return ProductFormRequirement(
                  templateId: e.value.id,
                  stage: 'onboarding',
                  required: true,
                  order: e.key,
                  description: e.value.name,
                );
              }).toList();

              return _MultiTemplateOnboarding(
                requirements: requirements,
                onSave: (data) => _saveClient(context, ref, data),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _saveClient(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> data,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    try {
      final profileId = ref.read(currentProfileIdProvider).value ?? '';
      final agentId = ref.read(currentAgentIdProvider).value ?? '';

      // Extract the name — try common field keys.
      final name = (data['full_name'] ?? data['name'] ?? '').toString().trim();

      // Build properties from all collected data.
      final props = Map<String, dynamic>.from(data);
      props.remove('full_name');
      props.remove('name');

      final client = ClientObject(
        name: name,
        profileId: profileId,
        agentId: agentId,
        state: STATE.CREATED,
        properties: mapToStruct(props),
      );

      await ref.read(clientProvider.notifier).save(client);

      messenger.showSnackBar(
        const SnackBar(content: Text('Client onboarded successfully')),
      );
      if (context.mounted) context.go('/field/clients');
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to save client: $e'),
          backgroundColor: errorColor,
        ),
      );
    }
  }
}

/// Shown when no form templates are configured for clients.
class _NoTemplatesConfigured extends StatelessWidget {
  const _NoTemplatesConfigured({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dynamic_form_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
            ),
            const SizedBox(height: 16),
            Text(
              'No Client Forms Configured',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'An administrator needs to create and publish a form template '
              'for client onboarding. Go to Administration > Form Templates '
              'to set one up.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.go('/admin/form-templates/new'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Template'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Multi-template onboarding that uses individual form renderers sequentially.
class _MultiTemplateOnboarding extends ConsumerStatefulWidget {
  const _MultiTemplateOnboarding({
    required this.requirements,
    required this.onSave,
  });

  final List<ProductFormRequirement> requirements;
  final Future<void> Function(Map<String, dynamic> data) onSave;

  @override
  ConsumerState<_MultiTemplateOnboarding> createState() =>
      _MultiTemplateOnboardingState();
}

class _MultiTemplateOnboardingState
    extends ConsumerState<_MultiTemplateOnboarding> {
  int _currentIndex = 0;
  final Map<String, dynamic> _allData = {};

  @override
  Widget build(BuildContext context) {
    final req = widget.requirements[_currentIndex];
    final templateAsync = ref.watch(formTemplateDetailProvider(req.templateId));

    return templateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (template) {
        final isLast = _currentIndex == widget.requirements.length - 1;
        return DynamicFormRenderer(
          key: ValueKey('onboard_${req.templateId}'),
          template: template,
          initialData: _allData,
          onSubmit: (data, fileData) async {
            _allData.addAll(data);
            if (isLast) {
              await widget.onSave(_allData);
            } else {
              setState(() => _currentIndex++);
            }
          },
        );
      },
    );
  }
}

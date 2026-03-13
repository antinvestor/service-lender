import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/entity_list_page.dart';
import '../../../core/widgets/state_badge.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/lender/v1/identity.pb.dart';
import '../data/investor_providers.dart';

class InvestorsScreen extends ConsumerStatefulWidget {
  const InvestorsScreen({super.key});

  @override
  ConsumerState<InvestorsScreen> createState() => _InvestorsScreenState();
}

class _InvestorsScreenState extends ConsumerState<InvestorsScreen> {
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
        setState(() {
          _query = value.trim();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final investorsAsync = ref.watch(investorListProvider(query: _query));
    final canManage = ref.watch(canManageInvestorsProvider).value ?? false;

    return EntityListPage<InvestorObject>(
      title: 'Investors',
      icon: Icons.trending_up_outlined,
      items: investorsAsync.value ?? [],
      isLoading: investorsAsync.isLoading,
      error: investorsAsync.hasError ? investorsAsync.error.toString() : null,
      onRetry: () => ref.invalidate(investorListProvider(query: _query)),
      searchHint: 'Search investors...',
      onSearchChanged: _onSearchChanged,
      actionLabel: 'Add Investor',
      canAction: canManage,
      onAction: () => _showInvestorDialog(context),
      itemBuilder: (context, investor) => _InvestorCard(
        investor: investor,
        canManage: canManage,
        onTap: () => _showInvestorDialog(context, investor: investor),
      ),
    );
  }

  void _showInvestorDialog(BuildContext context, {InvestorObject? investor}) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _InvestorFormDialog(
        investor: investor,
        onSave: (updated) async {
          try {
            await ref.read(investorProvider.notifier).save(updated);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    investor == null
                        ? 'Investor created successfully'
                        : 'Investor updated successfully',
                  ),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to save investor: $e'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class _InvestorCard extends StatelessWidget {
  const _InvestorCard({
    required this.investor,
    required this.canManage,
    required this.onTap,
  });

  final InvestorObject investor;
  final bool canManage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            investor.name.isNotEmpty ? investor.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          investor.name.isNotEmpty ? investor.name : 'Unnamed Investor',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Profile: ${investor.profileId}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        trailing: StateBadge(state: investor.state),
        onTap: canManage ? onTap : null,
      ),
    );
  }
}

class _InvestorFormDialog extends StatefulWidget {
  const _InvestorFormDialog({this.investor, required this.onSave});

  final InvestorObject? investor;
  final Future<void> Function(InvestorObject investor) onSave;

  @override
  State<_InvestorFormDialog> createState() => _InvestorFormDialogState();
}

class _InvestorFormDialogState extends State<_InvestorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _profileIdCtrl;
  late STATE _selectedState;
  bool _saving = false;

  bool get _isEditing => widget.investor != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.investor?.name ?? '');
    _profileIdCtrl =
        TextEditingController(text: widget.investor?.profileId ?? '');
    _selectedState = widget.investor?.state ?? STATE.CREATED;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _profileIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final investor = InvestorObject(
      id: widget.investor?.id,
      name: _nameCtrl.text.trim(),
      profileId: _profileIdCtrl.text.trim(),
      state: _selectedState,
    );

    if (widget.investor != null && widget.investor!.hasProperties()) {
      investor.properties = widget.investor!.properties;
    }

    await widget.onSave(investor);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  static const _editableStates = [
    STATE.CREATED,
    STATE.CHECKED,
    STATE.ACTIVE,
    STATE.INACTIVE,
    STATE.DELETED,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Investor' : 'Add Investor'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _profileIdCtrl,
                decoration: const InputDecoration(labelText: 'Profile ID'),
                textInputAction: TextInputAction.done,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Profile ID is required'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<STATE>(
                initialValue: _selectedState,
                decoration: const InputDecoration(labelText: 'State'),
                items: _editableStates
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(stateLabel(s)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedState = v);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}

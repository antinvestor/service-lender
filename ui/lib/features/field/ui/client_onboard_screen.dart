import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/tenancy_context.dart';
import '../../../core/widgets/dynamic_form.dart';
import '../../../sdk/src/common/v1/common.pbenum.dart';
import '../../../sdk/src/field/v1/field.pb.dart';
import '../../auth/data/auth_repository.dart';
import '../data/client_providers.dart';

/// Multi-step client onboarding wizard.
///
/// Steps:
/// 1. Basic Information (name, phone, ID)
/// 2. Address & Location
/// 3. Financial Information
/// 4. Review & Submit
class ClientOnboardScreen extends ConsumerStatefulWidget {
  const ClientOnboardScreen({super.key});

  @override
  ConsumerState<ClientOnboardScreen> createState() =>
      _ClientOnboardScreenState();
}

class _ClientOnboardScreenState extends ConsumerState<ClientOnboardScreen> {
  int _currentStep = 0;
  bool _saving = false;

  // Step 1: Basic Information
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _idType = 'National ID';
  final _idNumberCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  String _gender = '';

  // Step 2: Address
  final _addressCtrl = TextEditingController();
  final _countyCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();

  // Step 3: Financial
  String _employmentStatus = '';
  final _employerCtrl = TextEditingController();
  final _businessTypeCtrl = TextEditingController();
  final _monthlyIncomeCtrl = TextEditingController();
  final _nextOfKinNameCtrl = TextEditingController();
  final _nextOfKinPhoneCtrl = TextEditingController();

  // Form keys per step
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _idNumberCtrl.dispose();
    _dobCtrl.dispose();
    _addressCtrl.dispose();
    _countyCtrl.dispose();
    _districtCtrl.dispose();
    _landmarkCtrl.dispose();
    _employerCtrl.dispose();
    _businessTypeCtrl.dispose();
    _monthlyIncomeCtrl.dispose();
    _nextOfKinNameCtrl.dispose();
    _nextOfKinPhoneCtrl.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    return switch (_currentStep) {
      0 => _step1Key.currentState?.validate() ?? false,
      1 => _step2Key.currentState?.validate() ?? false,
      2 => _step3Key.currentState?.validate() ?? false,
      _ => true,
    };
  }

  void _next() {
    if (!_validateCurrentStep()) return;
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Map<String, dynamic> _buildProperties() {
    final props = <String, dynamic>{};
    void add(String key, String value) {
      if (value.isNotEmpty) props[key] = value;
    }

    add('phone', _phoneCtrl.text.trim());
    add('id_type', _idType);
    add('id_number', _idNumberCtrl.text.trim());
    add('date_of_birth', _dobCtrl.text.trim());
    add('gender', _gender);
    add('address', _addressCtrl.text.trim());
    add('county', _countyCtrl.text.trim());
    add('district', _districtCtrl.text.trim());
    add('landmark', _landmarkCtrl.text.trim());
    add('employment_status', _employmentStatus);
    add('employer', _employerCtrl.text.trim());
    add('business_type', _businessTypeCtrl.text.trim());
    add('monthly_income', _monthlyIncomeCtrl.text.trim());
    add('next_of_kin', _nextOfKinNameCtrl.text.trim());
    add('next_of_kin_phone', _nextOfKinPhoneCtrl.text.trim());

    return props;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    try {
      final profileId = ref.read(currentProfileIdProvider).value ?? '';
      final propsMap = _buildProperties();

      final client = ClientObject(
        name: _nameCtrl.text.trim(),
        profileId: profileId,
        agentId: profileId,
        state: STATE.CREATED,
        properties: mapToStruct(propsMap),
      );

      await ref.read(clientProvider.notifier).save(client);

      messenger.showSnackBar(
        const SnackBar(content: Text('Client onboarded successfully')),
      );
      if (mounted) context.go('/field/clients');
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to save client: $e'),
          backgroundColor: errorColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                'Step ${_currentStep + 1} of 4',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Step indicator
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: i <= _currentStep
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Step label
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _stepLabel(_currentStep),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // Form content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildStep(),
          ),
        ),

        // Navigation buttons
        Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outlineVariant.withAlpha(60),
              ),
            ),
          ),
          child: Row(
            children: [
              if (_currentStep > 0)
                OutlinedButton(
                  onPressed: _saving ? null : _back,
                  child: const Text('Back'),
                ),
              const Spacer(),
              if (_currentStep < 3)
                FilledButton(
                  onPressed: _saving ? null : _next,
                  child: const Text('Continue'),
                )
              else
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check, size: 18),
                  label: const Text('Save & Onboard'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _stepLabel(int step) {
    return switch (step) {
      0 => 'Basic Information',
      1 => 'Address & Location',
      2 => 'Financial Information',
      3 => 'Review & Submit',
      _ => '',
    };
  }

  Widget _buildStep() {
    return switch (_currentStep) {
      0 => _buildStep1(),
      1 => _buildStep2(),
      2 => _buildStep3(),
      3 => _buildReview(),
      _ => const SizedBox.shrink(),
    };
  }

  // ── Step 1: Basic Information ──────────────────────────────────────────────

  Widget _buildStep1() {
    return Form(
      key: _step1Key,
      child: Column(
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Full Name *'),
            textInputAction: TextInputAction.next,
            validator: (v) => (v == null || v.trim().length < 2)
                ? 'Name is required (min 2 characters)'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(
              labelText: 'Phone Number *',
              hintText: '+254712345678',
              prefixIcon: Icon(Icons.phone, size: 20),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\s]')),
            ],
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Phone number is required';
              }
              final cleaned = v.trim().replaceAll(RegExp(r'[\s\-]'), '');
              if (cleaned.length < 7 || cleaned.length > 15) {
                return 'Enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _idType,
            decoration: const InputDecoration(labelText: 'ID Type *'),
            items: const [
              DropdownMenuItem(
                value: 'National ID',
                child: Text('National ID'),
              ),
              DropdownMenuItem(value: 'Passport', child: Text('Passport')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (v) => setState(() => _idType = v ?? _idType),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _idNumberCtrl,
            decoration: const InputDecoration(labelText: 'ID Number *'),
            textInputAction: TextInputAction.next,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'ID number is required'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dobCtrl,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              hintText: 'YYYY-MM-DD',
              suffixIcon: Icon(Icons.calendar_today, size: 20),
            ),
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(
                  const Duration(days: 365 * 25),
                ),
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _dobCtrl.text =
                    '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _gender.isNotEmpty ? _gender : null,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (v) => setState(() => _gender = v ?? ''),
          ),
        ],
      ),
    );
  }

  // ── Step 2: Address ────────────────────────────────────────────────────────

  Widget _buildStep2() {
    return Form(
      key: _step2Key,
      child: Column(
        children: [
          TextFormField(
            controller: _addressCtrl,
            decoration: const InputDecoration(
              labelText: 'Physical Address',
              hintText: 'Street name, building, etc.',
            ),
            maxLines: 2,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _countyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'County / Province',
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _districtCtrl,
                  decoration: const InputDecoration(
                    labelText: 'District / Sub-county',
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _landmarkCtrl,
            decoration: const InputDecoration(labelText: 'Nearest Landmark'),
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  // ── Step 3: Financial ──────────────────────────────────────────────────────

  Widget _buildStep3() {
    final showEmployer = _employmentStatus == 'Employed';
    final showBusiness =
        _employmentStatus == 'Self-Employed' ||
        _employmentStatus == 'Business Owner';

    return Form(
      key: _step3Key,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _employmentStatus.isNotEmpty
                ? _employmentStatus
                : null,
            decoration: const InputDecoration(labelText: 'Employment Status'),
            items: const [
              DropdownMenuItem(value: 'Employed', child: Text('Employed')),
              DropdownMenuItem(
                value: 'Self-Employed',
                child: Text('Self-Employed'),
              ),
              DropdownMenuItem(
                value: 'Business Owner',
                child: Text('Business Owner'),
              ),
              DropdownMenuItem(value: 'Unemployed', child: Text('Unemployed')),
              DropdownMenuItem(value: 'Retired', child: Text('Retired')),
            ],
            onChanged: (v) => setState(() => _employmentStatus = v ?? ''),
          ),
          const SizedBox(height: 16),
          if (showEmployer)
            TextFormField(
              controller: _employerCtrl,
              decoration: const InputDecoration(labelText: 'Employer Name'),
              textInputAction: TextInputAction.next,
            ),
          if (showBusiness)
            TextFormField(
              controller: _businessTypeCtrl,
              decoration: const InputDecoration(labelText: 'Business Type'),
              textInputAction: TextInputAction.next,
            ),
          if (showEmployer || showBusiness) const SizedBox(height: 16),
          TextFormField(
            controller: _monthlyIncomeCtrl,
            decoration: const InputDecoration(
              labelText: 'Monthly Income Estimate',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          Text(
            'Next of Kin',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nextOfKinNameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nextOfKinPhoneCtrl,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  // ── Step 4: Review ─────────────────────────────────────────────────────────

  Widget _buildReview() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Information',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _ReviewRow('Name', _nameCtrl.text),
                _ReviewRow('Phone', _phoneCtrl.text),
                _ReviewRow('ID Type', _idType),
                _ReviewRow('ID Number', _idNumberCtrl.text),
                _ReviewRow('Date of Birth', _dobCtrl.text),
                _ReviewRow('Gender', _gender),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _ReviewRow('Address', _addressCtrl.text),
                _ReviewRow('County', _countyCtrl.text),
                _ReviewRow('District', _districtCtrl.text),
                _ReviewRow('Landmark', _landmarkCtrl.text),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _ReviewRow('Employment', _employmentStatus),
                _ReviewRow('Employer', _employerCtrl.text),
                _ReviewRow('Business Type', _businessTypeCtrl.text),
                _ReviewRow('Monthly Income', _monthlyIncomeCtrl.text),
                _ReviewRow('Next of Kin', _nextOfKinNameCtrl.text),
                _ReviewRow('Next of Kin Phone', _nextOfKinPhoneCtrl.text),
              ],
            ),
          ),
        ),

        // Missing fields warning
        if (_hasMissingFields())
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Some optional fields are empty. You can continue onboarding and complete them later.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  bool _hasMissingFields() {
    return _dobCtrl.text.isEmpty ||
        _gender.isEmpty ||
        _addressCtrl.text.isEmpty ||
        _employmentStatus.isEmpty;
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/auth/audit_context.dart';
import '../../../core/auth/role_guard.dart';
import '../../../core/auth/role_provider.dart';
import '../../../core/widgets/application_status_badge.dart';
import '../../../core/widgets/entity_chip.dart';
import '../../../core/widgets/profile_badge.dart';
import '../../../core/widgets/workflow_stepper.dart';
import '../../../core/widgets/money_helpers.dart';
import '../../../sdk/src/google/protobuf/struct.pb.dart' as struct_pb;
import '../../../sdk/src/origination/v1/origination.pb.dart';
import '../data/application_providers.dart';
import '../data/underwriting_decision_providers.dart';
import '../data/verification_task_providers.dart';
import '../../loan_management/data/loan_product_providers.dart';
import 'applications_screen.dart';
import 'client_data_review_screen.dart';
import 'form_submissions_timeline.dart';

class ApplicationDetailScreen extends ConsumerWidget {
  const ApplicationDetailScreen({super.key, required this.applicationId});

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appAsync = ref.watch(applicationDetailProvider(applicationId));

    return appAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $error'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () =>
                  ref.invalidate(applicationDetailProvider(applicationId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (app) => _ApplicationDetailContent(app: app),
    );
  }
}

class _ApplicationDetailContent extends ConsumerStatefulWidget {
  const _ApplicationDetailContent({required this.app});

  final ApplicationObject app;

  @override
  ConsumerState<_ApplicationDetailContent> createState() =>
      _ApplicationDetailContentState();
}

class _ApplicationDetailContentState
    extends ConsumerState<_ApplicationDetailContent>
    with SingleTickerProviderStateMixin {
  late ApplicationObject _app;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _app = widget.app;
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void didUpdateWidget(covariant _ApplicationDetailContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.app != widget.app) {
      setState(() => _app = widget.app);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isTerminal => {
    ApplicationStatus.APPLICATION_STATUS_LOAN_CREATED,
    ApplicationStatus.APPLICATION_STATUS_REJECTED,
    ApplicationStatus.APPLICATION_STATUS_OFFER_DECLINED,
    ApplicationStatus.APPLICATION_STATUS_CANCELLED,
    ApplicationStatus.APPLICATION_STATUS_EXPIRED,
  }.contains(_app.status);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/origination/applications'),
                tooltip: 'Back to Applications',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Application ${_app.id}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        EntityChip(type: EntityType.client, id: _app.clientId),
                        EntityChip(
                          type: EntityType.product,
                          id: _app.productId,
                        ),
                        if (_app.agentId.isNotEmpty)
                          EntityChip(type: EntityType.agent, id: _app.agentId),
                      ],
                    ),
                  ],
                ),
              ),
              ApplicationStatusBadge(status: _app.status),
            ],
          ),
        ),

        // Workflow stepper
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: ApplicationWorkflowStepper(status: _app.status),
        ),

        // Action buttons — role-gated
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(children: _buildActionButtons(context, ref)),
        ),

        // Info section
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: _buildInfoSection(context, theme),
        ),

        // Risk flags
        if (_app.hasProperties()) _buildRiskFlagsSection(context, theme),

        // Tabs
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Forms'),
              Tab(text: 'Documents'),
              Tab(text: 'Verification'),
              Tab(text: 'Underwriting'),
              Tab(text: 'Timeline'),
            ],
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _FormsTab(app: _app),
              _DocumentsTab(applicationId: _app.id),
              _VerificationTab(applicationId: _app.id),
              _UnderwritingTab(applicationId: _app.id),
              _TimelineTab(app: _app),
            ],
          ),
        ),
      ],
    );
  }

  /// Roles that can edit/submit draft applications
  static const _editRoles = {
    LenderRole.owner,
    LenderRole.admin,
    LenderRole.manager,
    LenderRole.agent,
  };

  /// Roles that can accept/decline offers
  static const _offerRoles = {
    LenderRole.owner,
    LenderRole.admin,
    LenderRole.manager,
  };

  /// Roles that can cancel applications
  static const _cancelRoles = {
    LenderRole.owner,
    LenderRole.admin,
    LenderRole.manager,
    LenderRole.agent,
  };

  List<Widget> _buildActionButtons(BuildContext context, WidgetRef ref) {
    final buttons = <Widget>[];

    switch (_app.status) {
      case ApplicationStatus.APPLICATION_STATUS_DRAFT:
        buttons.add(
          RoleGuard(
            requiredRoles: _editRoles,
            child: FilledButton.icon(
              onPressed: () => _confirmSubmit(context),
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Submit'),
            ),
          ),
        );
        buttons.add(const SizedBox(width: 8));
        buttons.add(
          RoleGuard(
            requiredRoles: _editRoles,
            child: OutlinedButton.icon(
              onPressed: () => _showEditDialog(context),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit'),
            ),
          ),
        );
      case ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED:
        buttons.add(
          RoleGuard(
            requiredRoles: _offerRoles,
            child: FilledButton.icon(
              onPressed: () => _confirmAcceptOffer(context),
              icon: const Icon(Icons.check_circle, size: 18),
              label: const Text('Accept Offer'),
            ),
          ),
        );
        buttons.add(const SizedBox(width: 8));
        buttons.add(
          RoleGuard(
            requiredRoles: _offerRoles,
            child: OutlinedButton.icon(
              onPressed: () => _confirmDeclineOffer(context),
              icon: const Icon(Icons.cancel, size: 18),
              label: const Text('Decline Offer'),
            ),
          ),
        );
      default:
        break;
    }

    if (!_isTerminal &&
        _app.status != ApplicationStatus.APPLICATION_STATUS_DRAFT &&
        _app.status != ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED &&
        _app.status != ApplicationStatus.APPLICATION_STATUS_LOAN_CREATED) {
      if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
      buttons.add(
        RoleGuard(
          requiredRoles: _cancelRoles,
          child: OutlinedButton.icon(
            onPressed: () => _confirmCancel(context),
            icon: Icon(
              Icons.block,
              size: 18,
              color: Theme.of(context).colorScheme.error,
            ),
            label: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  Widget _buildInfoSection(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _InfoTile(
                  label: 'Requested Amount',
                  value: formatMoney(_app.requestedAmount),
                ),
                _InfoTile(
                  label: 'Requested Term',
                  value: '${_app.requestedTermDays} days',
                ),
                _InfoTile(
                  label: 'Approved Amount',
                  value: _app.hasApprovedAmount()
                      ? formatMoney(_app.approvedAmount)
                      : '-',
                ),
                _InfoTile(
                  label: 'Approved Term',
                  value: _app.approvedTermDays > 0
                      ? '${_app.approvedTermDays} days'
                      : '-',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoTile(
                  label: 'Interest Rate',
                  value: _app.interestRate.isNotEmpty
                      ? '${_app.interestRate}%'
                      : '-',
                ),
                _InfoTile(
                  label: 'Purpose',
                  value: _app.purpose.isNotEmpty ? _app.purpose : '-',
                ),
                _InfoTile(
                  label: 'Agent',
                  value: _app.agentId.isNotEmpty ? _app.agentId : '-',
                  profileId: _app.agentId.isNotEmpty ? _app.agentId : null,
                ),
                _InfoTile(
                  label: 'Branch',
                  value: _app.branchId.isNotEmpty ? _app.branchId : '-',
                ),
              ],
            ),
            if (_app.submittedAt.isNotEmpty ||
                _app.decidedAt.isNotEmpty ||
                _app.rejectionReason.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoTile(
                    label: 'Submitted At',
                    value: _app.submittedAt.isNotEmpty ? _app.submittedAt : '-',
                  ),
                  _InfoTile(
                    label: 'Decided At',
                    value: _app.decidedAt.isNotEmpty ? _app.decidedAt : '-',
                  ),
                  if (_app.rejectionReason.isNotEmpty)
                    Expanded(
                      child: _InfoTile(
                        label: 'Rejection Reason',
                        value: _app.rejectionReason,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRiskFlagsSection(BuildContext context, ThemeData theme) {
    final props = _app.properties;
    final fields = props.fields;

    // Check for risk_assessment_passed
    final riskPassed = fields.containsKey('risk_assessment_passed')
        ? fields['risk_assessment_passed']!.boolValue
        : null;

    // Check for risk_flags (expected as a ListValue of Structs with 'label' and 'severity')
    final riskFlagsValue = fields['risk_flags'];
    final hasFlags =
        riskFlagsValue != null &&
        riskFlagsValue.hasListValue() &&
        riskFlagsValue.listValue.values.isNotEmpty;

    if (!hasFlags && riskPassed == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        children: [
          if (riskPassed != null) ...[
            Icon(
              riskPassed ? Icons.verified : Icons.dangerous,
              size: 20,
              color: riskPassed ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 4),
            Text(
              riskPassed ? 'Risk Assessment Passed' : 'Risk Assessment Failed',
              style: theme.textTheme.labelMedium?.copyWith(
                color: riskPassed ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
          ],
          if (hasFlags)
            ...riskFlagsValue.listValue.values.map((flagVal) {
              final flagStruct = flagVal.structValue;
              final label = flagStruct.fields.containsKey('label')
                  ? flagStruct.fields['label']!.stringValue
                  : 'Unknown';
              final severity = flagStruct.fields.containsKey('severity')
                  ? flagStruct.fields['severity']!.stringValue
                  : 'info';

              final (chipColor, chipFg) = switch (severity) {
                'block' => (Colors.red, Colors.white),
                'review' => (Colors.orange, Colors.white),
                _ => (Colors.blue, Colors.white),
              };

              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Chip(
                  label: Text(
                    label,
                    style: TextStyle(
                      color: chipFg,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: chipColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _confirmSubmit(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Application'),
        content: const Text(
          'Are you sure you want to submit this application? This will trigger the origination workflow.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final errorColor = Theme.of(context).colorScheme.error;
              Navigator.of(ctx).pop();
              try {
                final updated = await ref
                    .read(applicationProvider.notifier)
                    .submit(_app.id);
                if (mounted) {
                  setState(() => _app = updated);
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Application submitted successfully'),
                    ),
                  );
                }
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Failed to submit: $e'),
                    backgroundColor: errorColor,
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    final reasonCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Application'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to cancel this application?'),
              const SizedBox(height: 12),
              TextField(
                controller: reasonCtrl,
                decoration: const InputDecoration(
                  labelText: 'Reason for cancellation',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Back'),
          ),
          FilledButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final errorColor = Theme.of(context).colorScheme.error;
              Navigator.of(ctx).pop();
              try {
                final updated = await ref
                    .read(applicationProvider.notifier)
                    .cancel(_app.id, reasonCtrl.text.trim());
                if (mounted) {
                  setState(() => _app = updated);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Application cancelled')),
                  );
                }
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Failed to cancel: $e'),
                    backgroundColor: errorColor,
                  ),
                );
              }
            },
            child: const Text('Cancel Application'),
          ),
        ],
      ),
    );
  }

  void _confirmAcceptOffer(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Accept Loan Terms'),
        content: const Text(
          'Are you sure you want to accept these approved loan terms? This will trigger loan account creation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final errorColor = Theme.of(context).colorScheme.error;
              Navigator.of(ctx).pop();
              try {
                final updated = await ref
                    .read(applicationProvider.notifier)
                    .acceptOffer(_app.id);
                if (mounted) {
                  setState(() => _app = updated);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Loan terms accepted')),
                  );
                }
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Failed to accept loan terms: $e'),
                    backgroundColor: errorColor,
                  ),
                );
              }
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _confirmDeclineOffer(BuildContext context) {
    final reasonCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Decline Loan Terms'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to decline these approved loan terms?'),
              const SizedBox(height: 12),
              TextField(
                controller: reasonCtrl,
                decoration: const InputDecoration(
                  labelText: 'Reason for declining terms',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Back'),
          ),
          FilledButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final errorColor = Theme.of(context).colorScheme.error;
              Navigator.of(ctx).pop();
              try {
                final updated = await ref
                    .read(applicationProvider.notifier)
                    .declineOffer(_app.id, reasonCtrl.text.trim());
                if (mounted) {
                  setState(() => _app = updated);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Offer declined')),
                  );
                }
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Failed to decline offer: $e'),
                    backgroundColor: errorColor,
                  ),
                );
              }
            },
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ApplicationCreateDialog(
        onSave: (updated) async {
          final messenger = ScaffoldMessenger.of(context);
          final errorColor = Theme.of(context).colorScheme.error;
          // Preserve the ID for editing.
          updated.id = _app.id;
          try {
            final saved = await ref
                .read(applicationProvider.notifier)
                .save(updated);
            if (mounted) {
              setState(() => _app = saved);
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Application updated successfully'),
                ),
              );
            }
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(
                content: Text('Failed to update application: $e'),
                backgroundColor: errorColor,
              ),
            );
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info tile helper
// ---------------------------------------------------------------------------

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    this.profileId,
  });

  final String label;
  final String value;

  /// If set, shows a [ProfileAvatar] next to the value text.
  final String? profileId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(120),
            ),
          ),
          const SizedBox(height: 2),
          if (profileId != null && profileId!.isNotEmpty)
            Row(
              children: [
                ProfileAvatar(
                  profileId: profileId!,
                  name: value,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Forms tab — shows all required forms grouped by stage
// ---------------------------------------------------------------------------

class _FormsTab extends ConsumerWidget {
  const _FormsTab({required this.app});

  final ApplicationObject app;

  /// Whether the application is in a verification/underwriting status
  /// where per-field review actions should be shown.
  bool get _isReviewStatus => const {
    ApplicationStatus.APPLICATION_STATUS_VERIFICATION,
    ApplicationStatus.APPLICATION_STATUS_UNDERWRITING,
  }.contains(app.status);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(loanProductDetailProvider(app.productId));

    return productAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading product: $e')),
      data: (product) {
        // Show per-field client data review when in verification/underwriting
        // and we have a client ID.
        if (_isReviewStatus && app.clientId.isNotEmpty) {
          return Column(
            children: [
              // Client data review with verify/reject/request-info actions
              Expanded(
                flex: 3,
                child: ClientDataReviewScreen(
                  clientId: app.clientId,
                  applicationId: app.id,
                ),
              ),
              // Divider
              const Divider(height: 1),
              // Form submissions timeline (collapsed view)
              if (product.requiredForms.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: FormSubmissionsTimeline(
                    applicationId: app.id,
                    requiredForms: product.requiredForms,
                    isReadOnly: true,
                  ),
                ),
            ],
          );
        }

        if (product.requiredForms.isEmpty) {
          // If no required forms but client has data, show data review.
          if (app.clientId.isNotEmpty) {
            return ClientDataReviewScreen(
              clientId: app.clientId,
              applicationId: app.id,
            );
          }
          return Center(
            child: Text(
              'No required forms configured for this product',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(140),
                  ),
            ),
          );
        }

        return FormSubmissionsTimeline(
          applicationId: app.id,
          requiredForms: product.requiredForms,
          isReadOnly: true,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Documents tab
// ---------------------------------------------------------------------------

class _DocumentsTab extends ConsumerWidget {
  const _DocumentsTab({required this.applicationId});

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(originationServiceClientProvider);
    final theme = Theme.of(context);

    return FutureBuilder<List<ApplicationDocumentObject>>(
      future: _loadDocuments(client),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final docs = snapshot.data ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  const Spacer(),
                  RoleGuard(
                    requiredRoles: const {
                      LenderRole.owner,
                      LenderRole.admin,
                      LenderRole.manager,
                      LenderRole.agent,
                      LenderRole.verifier,
                    },
                    child: FilledButton.icon(
                      onPressed: () => _showAddDocumentDialog(context, ref),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Document'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: docs.isEmpty
                  ? Center(
                      child: Text(
                        'No documents attached',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(140),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        return Card(
                          elevation: 0,
                          child: ListTile(
                            leading: const Icon(Icons.attach_file),
                            title: Text(
                              doc.fileName.isNotEmpty ? doc.fileName : doc.id,
                            ),
                            subtitle: Text(
                              '${_documentTypeLabel(doc.documentType)} \u2022 ${_verificationStatusLabel(doc.verificationStatus)}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<List<ApplicationDocumentObject>> _loadDocuments(dynamic client) async {
    final results = <ApplicationDocumentObject>[];
    var pages = 0;
    await for (final response in client.applicationDocumentSearch(
      ApplicationDocumentSearchRequest(applicationId: applicationId),
    )) {
      results.addAll(response.data);
      if (++pages >= 10 || response.data.isEmpty) break;
    }
    return results;
  }

  void _showAddDocumentDialog(BuildContext context, WidgetRef ref) {
    final fileNameCtrl = TextEditingController();
    final fileIdCtrl = TextEditingController();
    var docType = DocumentType.DOCUMENT_TYPE_OTHER;
    var saving = false;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Document'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<DocumentType>(
                  initialValue: docType,
                  decoration: const InputDecoration(labelText: 'Document Type'),
                  items: DocumentType.values
                      .where((d) => d != DocumentType.DOCUMENT_TYPE_UNSPECIFIED)
                      .map(
                        (d) => DropdownMenuItem(
                          value: d,
                          child: Text(_documentTypeLabel(d)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => docType = v);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: fileIdCtrl,
                  decoration: const InputDecoration(labelText: 'File ID'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: fileNameCtrl,
                  decoration: const InputDecoration(labelText: 'File Name'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      setDialogState(() => saving = true);
                      try {
                        final client = ref.read(
                          originationServiceClientProvider,
                        );
                        await client.applicationDocumentSave(
                          ApplicationDocumentSaveRequest(
                            data: ApplicationDocumentObject(
                              applicationId: applicationId,
                              documentType: docType,
                              fileId: fileIdCtrl.text.trim(),
                              fileName: fileNameCtrl.text.trim(),
                            ),
                          ),
                        );
                        if (ctx.mounted) Navigator.of(ctx).pop();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Document added successfully'),
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() => saving = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to add document: $e'),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                          );
                        }
                      }
                    },
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  static String _documentTypeLabel(DocumentType type) {
    return switch (type) {
      DocumentType.DOCUMENT_TYPE_NATIONAL_ID => 'National ID',
      DocumentType.DOCUMENT_TYPE_PASSPORT => 'Passport',
      DocumentType.DOCUMENT_TYPE_BUSINESS_REGISTRATION =>
        'Business Registration',
      DocumentType.DOCUMENT_TYPE_BANK_STATEMENT => 'Bank Statement',
      DocumentType.DOCUMENT_TYPE_TAX_CERTIFICATE => 'Tax Certificate',
      DocumentType.DOCUMENT_TYPE_PROOF_OF_ADDRESS => 'Proof of Address',
      DocumentType.DOCUMENT_TYPE_INCOME_PROOF => 'Income Proof',
      DocumentType.DOCUMENT_TYPE_COLLATERAL_PHOTO => 'Collateral Photo',
      DocumentType.DOCUMENT_TYPE_OTHER => 'Other',
      _ => 'Unknown',
    };
  }

  static String _verificationStatusLabel(VerificationStatus status) {
    return switch (status) {
      VerificationStatus.VERIFICATION_STATUS_PENDING => 'Pending',
      VerificationStatus.VERIFICATION_STATUS_IN_PROGRESS => 'In Progress',
      VerificationStatus.VERIFICATION_STATUS_PASSED => 'Passed',
      VerificationStatus.VERIFICATION_STATUS_FAILED => 'Failed',
      VerificationStatus.VERIFICATION_STATUS_NEEDS_REVIEW => 'Needs Review',
      _ => 'Unknown',
    };
  }
}

// ---------------------------------------------------------------------------
// Verification tab
// ---------------------------------------------------------------------------

class _VerificationTab extends ConsumerWidget {
  const _VerificationTab({required this.applicationId});

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(verificationTaskListProvider(applicationId));
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            children: [
              const Spacer(),
              RoleGuard(
                requiredRoles: const {
                  LenderRole.owner,
                  LenderRole.admin,
                  LenderRole.verifier,
                },
                child: FilledButton.icon(
                  onPressed: () => _showAddTaskDialog(context, ref),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Task'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: tasksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
            data: (tasks) {
              if (tasks.isEmpty) {
                return Center(
                  child: Text(
                    'No verification tasks',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final isPending =
                      task.status ==
                          VerificationStatus.VERIFICATION_STATUS_PENDING ||
                      task.status ==
                          VerificationStatus.VERIFICATION_STATUS_IN_PROGRESS;
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      leading: Icon(
                        isPending
                            ? Icons.pending_outlined
                            : task.status ==
                                  VerificationStatus.VERIFICATION_STATUS_PASSED
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: isPending
                            ? Colors.orange
                            : task.status ==
                                  VerificationStatus.VERIFICATION_STATUS_PASSED
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(
                        task.verificationType.isNotEmpty
                            ? task.verificationType
                            : task.id,
                      ),
                      subtitle: Text(
                        '${_verificationStatusLabel(task.status)} \u2022 Assigned: ${task.assignedTo.isNotEmpty ? task.assignedTo : "Unassigned"}',
                      ),
                      trailing: isPending
                          ? RoleGuard(
                              requiredRoles: const {
                                LenderRole.owner,
                                LenderRole.admin,
                                LenderRole.verifier,
                              },
                              child: IconButton(
                                icon: const Icon(Icons.done_all),
                                tooltip: 'Complete Task',
                                onPressed: () =>
                                    _showCompleteDialog(context, ref, task),
                              ),
                            )
                          : null,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final typeCtrl = TextEditingController();
    final assignedToCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    var saving = false;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Verification Task'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: typeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Verification Type',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: assignedToCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Assigned To (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      setDialogState(() => saving = true);
                      try {
                        final task = VerificationTaskObject(
                          applicationId: applicationId,
                          verificationType: typeCtrl.text.trim(),
                          assignedTo: assignedToCtrl.text.trim(),
                          notes: notesCtrl.text.trim(),
                          status:
                              VerificationStatus.VERIFICATION_STATUS_PENDING,
                        );
                        await ref
                            .read(verificationTaskProvider.notifier)
                            .save(task);
                        if (ctx.mounted) Navigator.of(ctx).pop();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Verification task added'),
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() => saving = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to add task: $e'),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                          );
                        }
                      }
                    },
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompleteDialog(
    BuildContext context,
    WidgetRef ref,
    VerificationTaskObject task,
  ) {
    final notesCtrl = TextEditingController();
    var selectedStatus = VerificationStatus.VERIFICATION_STATUS_PASSED;
    var saving = false;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final auditAsync = ref.watch(auditContextProvider);
          final auditLabel = auditAsync.whenOrNull(
            data: (ac) => ac.displayLabel,
          );

          return AlertDialog(
            title: const Text('Complete Verification Task'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show who is completing this task
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Completed By',
                      suffixIcon: Icon(Icons.lock_outline, size: 18),
                    ),
                    child: Text(
                      auditLabel ?? 'Loading...',
                      style: Theme.of(ctx).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<VerificationStatus>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(labelText: 'Result'),
                    items:
                        [
                              VerificationStatus.VERIFICATION_STATUS_PASSED,
                              VerificationStatus.VERIFICATION_STATUS_FAILED,
                              VerificationStatus
                                  .VERIFICATION_STATUS_NEEDS_REVIEW,
                            ]
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(_verificationStatusLabel(s)),
                              ),
                            )
                            .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => selectedStatus = v);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesCtrl,
                    decoration: const InputDecoration(labelText: 'Notes'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: saving
                    ? null
                    : () async {
                        setDialogState(() => saving = true);
                        try {
                          // Get audit context and embed in results
                          final auditCtx = await ref.read(
                            auditContextProvider.future,
                          );
                          final auditMap = auditCtx.toMap();
                          final resultsStruct = struct_pb.Struct();
                          resultsStruct.fields['completed_by'] =
                              struct_pb.Value(
                                stringValue: auditCtx.displayLabel,
                              );
                          for (final entry in auditMap.entries) {
                            resultsStruct.fields[entry.key] = struct_pb.Value(
                              stringValue: entry.value,
                            );
                          }

                          await ref
                              .read(verificationTaskProvider.notifier)
                              .complete(
                                task.id,
                                selectedStatus,
                                notesCtrl.text.trim(),
                                results: resultsStruct,
                              );
                          if (ctx.mounted) Navigator.of(ctx).pop();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Task completed')),
                            );
                          }
                        } catch (e) {
                          setDialogState(() => saving = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to complete task: $e'),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                child: saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Complete'),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _verificationStatusLabel(VerificationStatus status) {
    return switch (status) {
      VerificationStatus.VERIFICATION_STATUS_PENDING => 'Pending',
      VerificationStatus.VERIFICATION_STATUS_IN_PROGRESS => 'In Progress',
      VerificationStatus.VERIFICATION_STATUS_PASSED => 'Passed',
      VerificationStatus.VERIFICATION_STATUS_FAILED => 'Failed',
      VerificationStatus.VERIFICATION_STATUS_NEEDS_REVIEW => 'Needs Review',
      _ => 'Unknown',
    };
  }
}

// ---------------------------------------------------------------------------
// Underwriting tab
// ---------------------------------------------------------------------------

class _UnderwritingTab extends ConsumerWidget {
  const _UnderwritingTab({required this.applicationId});

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionsAsync = ref.watch(
      underwritingDecisionListProvider(applicationId),
    );
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            children: [
              const Spacer(),
              RoleGuard(
                requiredRoles: const {
                  LenderRole.owner,
                  LenderRole.admin,
                  LenderRole.approver,
                },
                child: FilledButton.icon(
                  onPressed: () => _showAddDecisionDialog(context, ref),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Decision'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: decisionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
            data: (decisions) {
              if (decisions.isEmpty) {
                return Center(
                  child: Text(
                    'No underwriting decisions',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: decisions.length,
                itemBuilder: (context, index) {
                  final decision = decisions[index];
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      leading: Icon(
                        _outcomeIcon(decision.outcome),
                        color: _outcomeColor(decision.outcome),
                      ),
                      title: Text(
                        '${_outcomeLabel(decision.outcome)} \u2022 Score: ${decision.creditScore}',
                      ),
                      subtitle: Text(
                        'Risk: ${decision.riskGrade.isNotEmpty ? decision.riskGrade : "-"} \u2022 By: ${decision.decidedBy.isNotEmpty ? decision.decidedBy : "-"}${decision.hasApprovedAmount() ? " \u2022 Approved: ${formatMoney(decision.approvedAmount)}" : ""}',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddDecisionDialog(BuildContext context, WidgetRef ref) {
    final creditScoreCtrl = TextEditingController();
    final riskGradeCtrl = TextEditingController();
    final approvedAmountCtrl = TextEditingController();
    final approvedTermCtrl = TextEditingController();
    final approvedRateCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    var outcome = UnderwritingOutcome.UNDERWRITING_OUTCOME_APPROVE;
    var saving = false;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final auditAsync = ref.watch(auditContextProvider);
          final auditLabel = auditAsync.whenOrNull(
            data: (ac) => ac.displayLabel,
          );

          return AlertDialog(
            title: const Text('Add Underwriting Decision'),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<UnderwritingOutcome>(
                      initialValue: outcome,
                      decoration: const InputDecoration(labelText: 'Outcome'),
                      items: UnderwritingOutcome.values
                          .where(
                            (o) =>
                                o !=
                                UnderwritingOutcome
                                    .UNDERWRITING_OUTCOME_UNSPECIFIED,
                          )
                          .map(
                            (o) => DropdownMenuItem(
                              value: o,
                              child: Text(_outcomeLabel(o)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setDialogState(() => outcome = v);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Read-only decided-by from audit context
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Decided By',
                        suffixIcon: Icon(Icons.lock_outline, size: 18),
                      ),
                      child: Text(
                        auditLabel ?? 'Loading...',
                        style: Theme.of(ctx).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: creditScoreCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Credit Score',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: riskGradeCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Risk Grade',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: approvedAmountCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Approved Amount',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: approvedTermCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Approved Term (days)',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: approvedRateCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Approved Rate %',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: reasonCtrl,
                      decoration: const InputDecoration(labelText: 'Reason'),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: saving
                    ? null
                    : () async {
                        // Validate inputs before saving
                        final creditScore = int.tryParse(
                          creditScoreCtrl.text.trim(),
                        );
                        if (creditScore != null &&
                            (creditScore < 0 || creditScore > 999)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Credit score must be between 0 and 999',
                              ),
                            ),
                          );
                          return;
                        }

                        final rate = double.tryParse(
                          approvedRateCtrl.text.trim(),
                        );
                        if (rate != null && (rate < 0 || rate > 100)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Rate must be between 0 and 100'),
                            ),
                          );
                          return;
                        }

                        if (outcome ==
                                UnderwritingOutcome
                                    .UNDERWRITING_OUTCOME_APPROVE ||
                            outcome ==
                                UnderwritingOutcome
                                    .UNDERWRITING_OUTCOME_COUNTER_OFFER) {
                          final amount = double.tryParse(
                            approvedAmountCtrl.text.trim(),
                          );
                          final term = int.tryParse(
                            approvedTermCtrl.text.trim(),
                          );
                          if (amount == null ||
                              amount <= 0 ||
                              term == null ||
                              term <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Approved amount and term are required for approval',
                                ),
                              ),
                            );
                            return;
                          }
                        }

                        setDialogState(() => saving = true);
                        try {
                          // Get the audit context for decidedBy and properties
                          final auditCtx = await ref.read(
                            auditContextProvider.future,
                          );

                          // Build properties Struct from audit context
                          final auditMap = auditCtx.toMap();
                          final propsStruct = struct_pb.Struct();
                          for (final entry in auditMap.entries) {
                            propsStruct.fields[entry.key] = struct_pb.Value(
                              stringValue: entry.value,
                            );
                          }

                          final decision = UnderwritingDecisionObject(
                            applicationId: applicationId,
                            outcome: outcome,
                            decidedBy: auditCtx.displayLabel,
                            creditScore:
                                int.tryParse(creditScoreCtrl.text.trim()) ?? 0,
                            riskGrade: riskGradeCtrl.text.trim(),
                            approvedAmount: moneyFromString(
                              approvedAmountCtrl.text.trim(),
                              '',
                            ),
                            approvedTermDays:
                                int.tryParse(approvedTermCtrl.text.trim()) ?? 0,
                            approvedRate: approvedRateCtrl.text.trim(),
                            reason: reasonCtrl.text.trim(),
                            properties: propsStruct,
                          );
                          await ref
                              .read(underwritingDecisionProvider.notifier)
                              .save(decision);
                          if (ctx.mounted) Navigator.of(ctx).pop();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Decision added')),
                            );
                          }
                        } catch (e) {
                          setDialogState(() => saving = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to add decision: $e'),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                child: saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _outcomeLabel(UnderwritingOutcome outcome) {
    return switch (outcome) {
      UnderwritingOutcome.UNDERWRITING_OUTCOME_APPROVE => 'Approve',
      UnderwritingOutcome.UNDERWRITING_OUTCOME_REJECT => 'Reject',
      UnderwritingOutcome.UNDERWRITING_OUTCOME_REFER => 'Refer',
      UnderwritingOutcome.UNDERWRITING_OUTCOME_COUNTER_OFFER => 'Counter Offer',
      _ => 'Unknown',
    };
  }

  static IconData _outcomeIcon(UnderwritingOutcome outcome) {
    return switch (outcome) {
      UnderwritingOutcome.UNDERWRITING_OUTCOME_APPROVE => Icons.check_circle,
      UnderwritingOutcome.UNDERWRITING_OUTCOME_REJECT => Icons.cancel,
      UnderwritingOutcome.UNDERWRITING_OUTCOME_REFER => Icons.forward,
      UnderwritingOutcome.UNDERWRITING_OUTCOME_COUNTER_OFFER =>
        Icons.swap_horiz,
      _ => Icons.help_outline,
    };
  }

  static Color _outcomeColor(UnderwritingOutcome outcome) {
    return switch (outcome) {
      UnderwritingOutcome.UNDERWRITING_OUTCOME_APPROVE => Colors.green,
      UnderwritingOutcome.UNDERWRITING_OUTCOME_REJECT => Colors.red,
      UnderwritingOutcome.UNDERWRITING_OUTCOME_REFER => Colors.orange,
      UnderwritingOutcome.UNDERWRITING_OUTCOME_COUNTER_OFFER => Colors.blue,
      _ => Colors.grey,
    };
  }
}

// ---------------------------------------------------------------------------
// Timeline tab — chronological log of application lifecycle events
// ---------------------------------------------------------------------------

class _TimelineTab extends ConsumerWidget {
  const _TimelineTab({required this.app});
  final ApplicationObject app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Build timeline events from available data
    final events = <_TimelineEvent>[];

    // Status-based events we can infer
    if (app.submittedAt.isNotEmpty) {
      events.add(
        _TimelineEvent(
          timestamp: app.submittedAt,
          title: 'Application Submitted',
          subtitle: 'Entered origination pipeline',
          icon: Icons.send,
          color: Colors.blue,
        ),
      );
    }

    if (app.decidedAt.isNotEmpty) {
      final isApproved =
          app.status == ApplicationStatus.APPLICATION_STATUS_APPROVED ||
          app.status == ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED ||
          app.status == ApplicationStatus.APPLICATION_STATUS_OFFER_ACCEPTED ||
          app.status == ApplicationStatus.APPLICATION_STATUS_LOAN_CREATED;
      events.add(
        _TimelineEvent(
          timestamp: app.decidedAt,
          title: isApproved ? 'Application Approved' : 'Decision Made',
          subtitle: app.rejectionReason.isNotEmpty
              ? 'Reason: ${app.rejectionReason}'
              : 'Underwriting decision recorded',
          icon: isApproved ? Icons.check_circle : Icons.gavel,
          color: isApproved ? Colors.green : Colors.orange,
        ),
      );
    }

    if (app.rejectionReason.isNotEmpty &&
        (app.status == ApplicationStatus.APPLICATION_STATUS_REJECTED ||
            app.status == ApplicationStatus.APPLICATION_STATUS_CANCELLED)) {
      events.add(
        _TimelineEvent(
          timestamp: app.decidedAt.isNotEmpty ? app.decidedAt : '',
          title: app.status == ApplicationStatus.APPLICATION_STATUS_CANCELLED
              ? 'Application Cancelled'
              : 'Application Rejected',
          subtitle: app.rejectionReason,
          icon: Icons.cancel,
          color: Colors.red,
        ),
      );
    }

    // Current status
    events.add(
      _TimelineEvent(
        timestamp: '',
        title: 'Current Status',
        subtitle: applicationStatusLabel(app.status),
        icon: Icons.circle,
        color: theme.colorScheme.primary,
      ),
    );

    // Sort by timestamp (most recent first), empty timestamps last
    events.sort((a, b) {
      if (a.timestamp.isEmpty && b.timestamp.isEmpty) return 0;
      if (a.timestamp.isEmpty) return 1;
      if (b.timestamp.isEmpty) return -1;
      return b.timestamp.compareTo(a.timestamp);
    });

    if (events.isEmpty) {
      return Center(
        child: Text(
          'No timeline events available',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isLast = index == events.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line + dot
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: event.color,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Event content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(event.icon, size: 16, color: event.color),
                          const SizedBox(width: 6),
                          Text(
                            event.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (event.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          event.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (event.timestamp.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          event.timestamp,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(100),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimelineEvent {
  const _TimelineEvent({
    required this.timestamp,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String timestamp;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

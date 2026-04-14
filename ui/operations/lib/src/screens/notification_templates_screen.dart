import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Notification template management screen.
///
/// Shows all default notification templates organized by category.
/// Templates are registered with the notification service on backend startup.
/// This screen provides visibility into what templates exist and their content.
class NotificationTemplatesScreen extends StatelessWidget {
  const NotificationTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.mail_outlined, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notification Templates',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Default message templates used across the platform for agent onboarding, '
                            'loan notifications, application updates, and system messages.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
              ],
            ),
          ),
        ),
        for (final category in _templateCategories)
          ..._buildCategorySection(context, category),
      ],
    );
  }

  List<Widget> _buildCategorySection(
    BuildContext context,
    _TemplateCategory category,
  ) {
    final theme = Theme.of(context);
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            children: [
              Icon(category.icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                category.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${category.templates.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                _TemplateCard(template: category.templates[index]),
            childCount: category.templates.length,
          ),
        ),
      ),
    ];
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});
  final _TemplateDef template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Icon(
            Icons.description_outlined,
            size: 18,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(
          template.subject,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          template.description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                // Template name (ID)
                Row(
                  children: [
                    Text(
                      'Template ID',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      template.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: template.name));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Template ID copied'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.copy,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Subject
                Text(
                  'Subject',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(template.subject, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                // Body
                Text(
                  'Message Body',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    template.body,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                ),
                if (template.variables.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Template Variables',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: template.variables
                        .map(
                          (v) => Chip(
                            label: Text(
                              '{{.$v}}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Template definitions -- mirrors pkg/templates/defaults.go
// ---------------------------------------------------------------------------

class _TemplateCategory {
  const _TemplateCategory({
    required this.label,
    required this.icon,
    required this.templates,
  });
  final String label;
  final IconData icon;
  final List<_TemplateDef> templates;
}

class _TemplateDef {
  const _TemplateDef({
    required this.name,
    required this.subject,
    required this.body,
    required this.description,
    this.variables = const [],
  });
  final String name;
  final String subject;
  final String body;
  final String description;
  final List<String> variables;
}

const _templateCategories = [
  _TemplateCategory(
    label: 'Agent Management',
    icon: Icons.person_pin_outlined,
    templates: [
      _TemplateDef(
        name: 'template.fintech.agent.onboarding',
        subject: 'Welcome -- Accept Terms & Conditions',
        body:
            'Hello {{.agent_name}},\n\nYou have been registered as an agent. '
            'Please log in and accept the Terms & Conditions to activate your account.',
        description:
            'Sent when a new agent is created with T&C acceptance invitation.',
        variables: ['agent_name', 'agent_id'],
      ),
      _TemplateDef(
        name: 'template.fintech.agent.activated',
        subject: 'Agent Account Activated',
        body:
            'Hello {{.agent_name}},\n\nYour agent account is now active. '
            'You can begin onboarding clients and processing applications.',
        description:
            'Sent when an agent accepts T&C and their account becomes active.',
        variables: ['agent_name'],
      ),
      _TemplateDef(
        name: 'template.fintech.agent.deactivated',
        subject: 'Agent Account Deactivated',
        body:
            'Hello {{.agent_name}},\n\nYour agent account has been deactivated.',
        description:
            'Sent when an agent account is deactivated by an administrator.',
        variables: ['agent_name'],
      ),
    ],
  ),
  _TemplateCategory(
    label: 'Loan Lifecycle',
    icon: Icons.account_balance_wallet_outlined,
    templates: [
      _TemplateDef(
        name: 'loan_approved',
        subject: 'Loan Application Approved',
        body: 'Your loan of {{.loan_amount}} {{.currency}} has been approved.',
        description: 'Sent to the borrower when their loan is approved.',
        variables: ['loan_amount', 'currency'],
      ),
      _TemplateDef(
        name: 'template.fintech.loan.disbursed',
        subject: 'Loan Disbursed',
        body:
            'Your loan of {{.amount}} {{.currency}} has been disbursed. '
            'First repayment due on {{.first_payment_date}}.',
        description: 'Sent when the loan amount is disbursed to the borrower.',
        variables: ['amount', 'currency', 'reference', 'first_payment_date'],
      ),
      _TemplateDef(
        name: 'repayment_received',
        subject: 'Repayment Received',
        body:
            'Repayment of {{.amount}} {{.currency}} received. '
            'Remaining: {{.remaining_balance}} {{.currency}}.',
        description: 'Sent when a loan repayment is recorded.',
        variables: ['amount', 'currency', 'remaining_balance'],
      ),
      _TemplateDef(
        name: 'loan_fully_paid',
        subject: 'Loan Fully Repaid',
        body: 'Congratulations! Your loan has been fully repaid.',
        description: 'Sent when a loan is fully paid off.',
      ),
      _TemplateDef(
        name: 'template.fintech.loan.overdue',
        subject: 'Loan Payment Overdue',
        body:
            'Your payment of {{.amount}} {{.currency}} was due on {{.due_date}}.',
        description: 'Sent when a loan repayment is overdue.',
        variables: ['amount', 'currency', 'due_date'],
      ),
      _TemplateDef(
        name: 'template.fintech.loan.penalty',
        subject: 'Penalty Applied',
        body:
            'A penalty of {{.penalty_amount}} {{.currency}} has been applied.',
        description: 'Sent when a penalty is applied to a loan account.',
        variables: [
          'penalty_amount',
          'currency',
          'reason',
          'total_outstanding',
        ],
      ),
    ],
  ),
  _TemplateCategory(
    label: 'Loan Origination',
    icon: Icons.description_outlined,
    templates: [
      _TemplateDef(
        name: 'application_under_review',
        subject: 'Application Under Review',
        body: 'Your loan application has been submitted and is under review.',
        description: 'Sent when an application is submitted for review.',
      ),
      _TemplateDef(
        name: 'template.fintech.application.verified',
        subject: 'Verification Complete',
        body: 'Your application has passed verification and is being reviewed.',
        description: 'Sent when application verification is completed.',
      ),
      _TemplateDef(
        name: 'template.fintech.application.rejected',
        subject: 'Application Not Approved',
        body: 'Your loan application was not approved. Reason: {{.reason}}.',
        description: 'Sent when a loan application is rejected.',
        variables: ['reason', 'reapply_period'],
      ),
      _TemplateDef(
        name: 'template.fintech.loan_terms.generated',
        subject: 'Loan Terms Available',
        body:
            'Approved loan terms of {{.amount}} {{.currency}} at {{.interest_rate}}% '
            'for {{.term_days}} days is available.',
        description:
            'Sent when approved loan request terms are ready for the applicant.',
        variables: ['amount', 'currency', 'interest_rate', 'term_days'],
      ),
    ],
  ),
  _TemplateCategory(
    label: 'Savings',
    icon: Icons.savings_outlined,
    templates: [
      _TemplateDef(
        name: 'template.fintech.savings.deposit',
        subject: 'Deposit Received',
        body:
            'Deposit of {{.amount}} {{.currency}} credited. Balance: {{.balance}}.',
        description: 'Sent when a deposit is made to a savings account.',
        variables: ['amount', 'currency', 'balance'],
      ),
      _TemplateDef(
        name: 'template.fintech.savings.withdrawal',
        subject: 'Withdrawal Processed',
        body:
            'Withdrawal of {{.amount}} {{.currency}} processed. Balance: {{.balance}}.',
        description: 'Sent when a withdrawal is made from a savings account.',
        variables: ['amount', 'currency', 'balance'],
      ),
    ],
  ),
  _TemplateCategory(
    label: 'System',
    icon: Icons.settings_outlined,
    templates: [
      _TemplateDef(
        name: 'template.fintech.system.welcome',
        subject: 'Welcome to the Platform',
        body: 'Welcome to the lending platform, {{.name}}!',
        description: 'General welcome message for new platform users.',
        variables: ['name'],
      ),
      _TemplateDef(
        name: 'template.fintech.system.password_reset',
        subject: 'Password Reset Request',
        body:
            'Use code {{.code}} to reset your password. Expires in {{.expiry_minutes}} minutes.',
        description: 'Sent when a user requests a password reset.',
        variables: ['code', 'expiry_minutes'],
      ),
    ],
  ),
];

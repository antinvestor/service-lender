import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../sdk/src/origination/v1/origination.pbenum.dart';

/// Visual pipeline stepper showing application workflow progress.
class ApplicationWorkflowStepper extends StatelessWidget {
  const ApplicationWorkflowStepper({super.key, required this.status});
  final ApplicationStatus status;

  static const _steps = [
    ('Draft', ApplicationStatus.APPLICATION_STATUS_DRAFT),
    ('Submitted', ApplicationStatus.APPLICATION_STATUS_SUBMITTED),
    ('Verification', ApplicationStatus.APPLICATION_STATUS_VERIFICATION),
    ('Underwriting', ApplicationStatus.APPLICATION_STATUS_UNDERWRITING),
    ('Offer', ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED),
    ('Loan', ApplicationStatus.APPLICATION_STATUS_LOAN_CREATED),
  ];

  int get _currentIndex {
    // Map status to step index
    return switch (status) {
      ApplicationStatus.APPLICATION_STATUS_DRAFT => 0,
      ApplicationStatus.APPLICATION_STATUS_SUBMITTED => 1,
      ApplicationStatus.APPLICATION_STATUS_KYC_PENDING ||
      ApplicationStatus.APPLICATION_STATUS_DOCUMENTS_PENDING ||
      ApplicationStatus.APPLICATION_STATUS_VERIFICATION => 2,
      ApplicationStatus.APPLICATION_STATUS_UNDERWRITING => 3,
      ApplicationStatus.APPLICATION_STATUS_APPROVED ||
      ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED ||
      ApplicationStatus.APPLICATION_STATUS_OFFER_ACCEPTED => 4,
      ApplicationStatus.APPLICATION_STATUS_LOAN_CREATED => 5,
      ApplicationStatus.APPLICATION_STATUS_REJECTED ||
      ApplicationStatus.APPLICATION_STATUS_OFFER_DECLINED ||
      ApplicationStatus.APPLICATION_STATUS_CANCELLED ||
      ApplicationStatus.APPLICATION_STATUS_EXPIRED => -1, // Terminal/rejected
      _ => 0,
    };
  }

  bool get _isRejected => _currentIndex == -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isRejected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withAlpha(60),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              color: theme.colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _terminalLabel,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 56,
      child: Row(
        children: [
          for (int i = 0; i < _steps.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 2,
                  color: i <= _currentIndex
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.outlineVariant.withAlpha(80),
                ),
              ),
            _StepDot(
              label: _steps[i].$1,
              isCompleted: i < _currentIndex,
              isCurrent: i == _currentIndex,
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }

  String get _terminalLabel => switch (status) {
    ApplicationStatus.APPLICATION_STATUS_REJECTED => 'Rejected',
    ApplicationStatus.APPLICATION_STATUS_OFFER_DECLINED => 'Offer Declined',
    ApplicationStatus.APPLICATION_STATUS_CANCELLED => 'Cancelled',
    ApplicationStatus.APPLICATION_STATUS_EXPIRED => 'Expired',
    _ => 'Closed',
  };
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.isCompleted,
    required this.isCurrent,
    required this.theme,
  });

  final String label;
  final bool isCompleted;
  final bool isCurrent;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted || isCurrent
        ? theme.colorScheme.secondary
        : theme.colorScheme.outlineVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isCurrent ? 28 : 20,
          height: isCurrent ? 28 : 20,
          decoration: BoxDecoration(
            color: isCompleted
                ? color
                : isCurrent
                ? color.withAlpha(30)
                : Colors.transparent,
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle,
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : isCurrent
              ? Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
            color: isCompleted || isCurrent
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

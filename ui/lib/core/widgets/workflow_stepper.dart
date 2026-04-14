import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../sdk/src/loans/v1/loans.pbenum.dart';

/// Visual pipeline stepper showing loan request workflow progress.
class LoanRequestWorkflowStepper extends StatelessWidget {
  const LoanRequestWorkflowStepper({super.key, required this.status});
  final LoanRequestStatus status;

  static const _steps = [
    ('Draft', LoanRequestStatus.LOAN_REQUEST_STATUS_DRAFT),
    ('Submitted', LoanRequestStatus.LOAN_REQUEST_STATUS_SUBMITTED),
    ('Approved', LoanRequestStatus.LOAN_REQUEST_STATUS_APPROVED),
    ('Loan Created', LoanRequestStatus.LOAN_REQUEST_STATUS_LOAN_CREATED),
  ];

  int get _currentIndex {
    return switch (status) {
      LoanRequestStatus.LOAN_REQUEST_STATUS_DRAFT => 0,
      LoanRequestStatus.LOAN_REQUEST_STATUS_SUBMITTED => 1,
      LoanRequestStatus.LOAN_REQUEST_STATUS_APPROVED => 2,
      LoanRequestStatus.LOAN_REQUEST_STATUS_LOAN_CREATED => 3,
      LoanRequestStatus.LOAN_REQUEST_STATUS_REJECTED ||
      LoanRequestStatus.LOAN_REQUEST_STATUS_CANCELLED ||
      LoanRequestStatus.LOAN_REQUEST_STATUS_EXPIRED =>
        -1,
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
        LoanRequestStatus.LOAN_REQUEST_STATUS_REJECTED => 'Rejected',
        LoanRequestStatus.LOAN_REQUEST_STATUS_CANCELLED => 'Cancelled',
        LoanRequestStatus.LOAN_REQUEST_STATUS_EXPIRED => 'Expired',
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

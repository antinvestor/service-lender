import 'package:flutter/material.dart';

import '../../sdk/src/loans/v1/loans.pbenum.dart';

/// Displays a colored badge for loan status.
class LoanStatusBadge extends StatelessWidget {
  const LoanStatusBadge({super.key, required this.status});

  final LoanStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _statusInfo(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  static (String, Color) _statusInfo(LoanStatus status) {
    return switch (status) {
      LoanStatus.LOAN_STATUS_PENDING_DISBURSEMENT =>
        ('Pending Disbursement', Colors.orange),
      LoanStatus.LOAN_STATUS_ACTIVE => ('Active', Colors.green),
      LoanStatus.LOAN_STATUS_DELINQUENT => ('Delinquent', Colors.deepOrange),
      LoanStatus.LOAN_STATUS_DEFAULT => ('Default', Colors.red),
      LoanStatus.LOAN_STATUS_PAID_OFF => ('Paid Off', Colors.teal),
      LoanStatus.LOAN_STATUS_RESTRUCTURED => ('Restructured', Colors.purple),
      LoanStatus.LOAN_STATUS_WRITTEN_OFF => ('Written Off', Colors.brown),
      LoanStatus.LOAN_STATUS_CLOSED => ('Closed', Colors.grey),
      _ => ('Unknown', Colors.grey),
    };
  }
}

String loanStatusLabel(LoanStatus status) {
  return switch (status) {
    LoanStatus.LOAN_STATUS_PENDING_DISBURSEMENT => 'Pending Disbursement',
    LoanStatus.LOAN_STATUS_ACTIVE => 'Active',
    LoanStatus.LOAN_STATUS_DELINQUENT => 'Delinquent',
    LoanStatus.LOAN_STATUS_DEFAULT => 'Default',
    LoanStatus.LOAN_STATUS_PAID_OFF => 'Paid Off',
    LoanStatus.LOAN_STATUS_RESTRUCTURED => 'Restructured',
    LoanStatus.LOAN_STATUS_WRITTEN_OFF => 'Written Off',
    LoanStatus.LOAN_STATUS_CLOSED => 'Closed',
    _ => 'Unknown',
  };
}

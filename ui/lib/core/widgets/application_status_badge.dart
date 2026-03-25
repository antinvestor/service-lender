import 'package:flutter/material.dart';

import '../../sdk/src/origination/v1/origination.pbenum.dart';

/// Displays a colored badge for application status.
class ApplicationStatusBadge extends StatelessWidget {
  const ApplicationStatusBadge({super.key, required this.status});

  final ApplicationStatus status;

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

  static (String, Color) _statusInfo(ApplicationStatus status) {
    return switch (status) {
      ApplicationStatus.APPLICATION_STATUS_DRAFT => ('Draft', Colors.grey),
      ApplicationStatus.APPLICATION_STATUS_SUBMITTED =>
        ('Submitted', Colors.blue),
      ApplicationStatus.APPLICATION_STATUS_KYC_PENDING =>
        ('KYC Pending', Colors.orange),
      ApplicationStatus.APPLICATION_STATUS_DOCUMENTS_PENDING =>
        ('Documents Pending', Colors.orange),
      ApplicationStatus.APPLICATION_STATUS_VERIFICATION =>
        ('Verification', Colors.purple),
      ApplicationStatus.APPLICATION_STATUS_UNDERWRITING =>
        ('Underwriting', Colors.indigo),
      ApplicationStatus.APPLICATION_STATUS_APPROVED =>
        ('Approved', Colors.teal),
      ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED =>
        ('Offer Generated', Colors.teal),
      ApplicationStatus.APPLICATION_STATUS_OFFER_ACCEPTED =>
        ('Offer Accepted', Colors.green),
      ApplicationStatus.APPLICATION_STATUS_LOAN_CREATED =>
        ('Loan Created', Colors.green),
      ApplicationStatus.APPLICATION_STATUS_REJECTED =>
        ('Rejected', Colors.red),
      ApplicationStatus.APPLICATION_STATUS_OFFER_DECLINED =>
        ('Offer Declined', Colors.red),
      ApplicationStatus.APPLICATION_STATUS_CANCELLED =>
        ('Cancelled', Colors.red),
      ApplicationStatus.APPLICATION_STATUS_EXPIRED =>
        ('Expired', Colors.red),
      _ => ('Unknown', Colors.grey),
    };
  }
}

/// Returns a human-readable label for an ApplicationStatus.
String applicationStatusLabel(ApplicationStatus status) {
  return switch (status) {
    ApplicationStatus.APPLICATION_STATUS_DRAFT => 'Draft',
    ApplicationStatus.APPLICATION_STATUS_SUBMITTED => 'Submitted',
    ApplicationStatus.APPLICATION_STATUS_KYC_PENDING => 'KYC Pending',
    ApplicationStatus.APPLICATION_STATUS_DOCUMENTS_PENDING =>
      'Documents Pending',
    ApplicationStatus.APPLICATION_STATUS_VERIFICATION => 'Verification',
    ApplicationStatus.APPLICATION_STATUS_UNDERWRITING => 'Underwriting',
    ApplicationStatus.APPLICATION_STATUS_APPROVED => 'Approved',
    ApplicationStatus.APPLICATION_STATUS_OFFER_GENERATED => 'Offer Generated',
    ApplicationStatus.APPLICATION_STATUS_OFFER_ACCEPTED => 'Offer Accepted',
    ApplicationStatus.APPLICATION_STATUS_LOAN_CREATED => 'Loan Created',
    ApplicationStatus.APPLICATION_STATUS_REJECTED => 'Rejected',
    ApplicationStatus.APPLICATION_STATUS_OFFER_DECLINED => 'Offer Declined',
    ApplicationStatus.APPLICATION_STATUS_CANCELLED => 'Cancelled',
    ApplicationStatus.APPLICATION_STATUS_EXPIRED => 'Expired',
    _ => 'Unknown',
  };
}

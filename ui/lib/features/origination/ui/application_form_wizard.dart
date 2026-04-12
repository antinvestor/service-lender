import 'package:flutter/material.dart';

import '../../../core/widgets/form_requirement_wizard.dart';
import '../../../sdk/src/origination/v1/origination.pb.dart';

/// Multi-step wizard that walks an agent through each required form
/// in the "application" stage of a product's [requiredForms].
///
/// Thin wrapper around the generic [FormRequirementWizard] that binds
/// to loan origination's application and product objects.
class ApplicationFormWizard extends StatelessWidget {
  const ApplicationFormWizard({
    super.key,
    required this.application,
    required this.product,
    required this.onAllFormsCompleted,
  });

  final ApplicationObject application;
  final LoanProductObject product;
  final VoidCallback onAllFormsCompleted;

  @override
  Widget build(BuildContext context) {
    return FormRequirementWizard(
      entityId: application.id,
      requirements: product.requiredForms,
      stage: 'application',
      clientId: application.clientId.isNotEmpty ? application.clientId : null,
      submitLabel: 'Submit Application',
      onAllCompleted: onAllFormsCompleted,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_page.dart';

class SystemUsersScreen extends StatelessWidget {
  const SystemUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'System Users',
      icon: Icons.manage_accounts_outlined,
      description:
          'Manage system users including verifiers, approvers, administrators, and auditors.',
      actionLabel: 'Add System User',
    );
  }
}

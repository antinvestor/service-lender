import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_page.dart';

class BanksScreen extends StatelessWidget {
  const BanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Banks',
      icon: Icons.account_balance_outlined,
      description:
          'Manage your banking institutions. Create, edit, and configure bank entities and their settings.',
      actionLabel: 'Add Bank',
    );
  }
}

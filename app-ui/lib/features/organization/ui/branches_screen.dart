import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_page.dart';

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Branches',
      icon: Icons.store_outlined,
      description:
          'Manage branch offices under each bank. Configure locations, service areas, and operational settings.',
      actionLabel: 'Add Branch',
    );
  }
}

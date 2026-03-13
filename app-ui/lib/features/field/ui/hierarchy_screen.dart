import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_page.dart';

class HierarchyScreen extends StatelessWidget {
  const HierarchyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Agent Hierarchy',
      icon: Icons.account_tree_outlined,
      description:
          'View and manage the agent reporting hierarchy. Visualize team structures and reporting lines.',
    );
  }
}

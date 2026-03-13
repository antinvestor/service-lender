import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_page.dart';

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Agents',
      icon: Icons.person_pin_outlined,
      description:
          'Manage field agents assigned to branches. Create agents, assign territories, and track performance.',
      actionLabel: 'Add Agent',
    );
  }
}

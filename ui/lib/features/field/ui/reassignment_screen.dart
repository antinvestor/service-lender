import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_page.dart';

class ReassignmentScreen extends StatelessWidget {
  const ReassignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Client Reassignment',
      icon: Icons.swap_horiz_outlined,
      description:
          'Transfer clients between agents. Track reassignment history and manage bulk transfers.',
    );
  }
}

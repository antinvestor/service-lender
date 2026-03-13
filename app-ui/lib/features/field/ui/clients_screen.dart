import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_page.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Clients',
      icon: Icons.people_outline,
      description:
          'Manage client records. Onboard new clients, review profiles, and track client status.',
      actionLabel: 'Onboard Client',
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_page.dart';

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Roles & Permissions',
      icon: Icons.security_outlined,
      description:
          'Configure role-based access control. Define custom roles and manage permission assignments.',
    );
  }
}

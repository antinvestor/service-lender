import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Settings',
      icon: Icons.settings_outlined,
      description:
          'Configure application preferences, notifications, and account settings.',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/role_provider.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/auth_state_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileIdAsync = ref.watch(currentProfileIdProvider);
    final rolesAsync = ref.watch(currentUserRolesProvider);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Settings',
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),

        // Account section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.person,
                        color: theme.colorScheme.primary),
                  ),
                  title: profileIdAsync.when(
                    data: (id) => Text(id ?? 'Unknown'),
                    loading: () => const Text('Loading...'),
                    error: (_, _) => const Text('Unknown'),
                  ),
                  subtitle: const Text('Profile ID'),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.security_outlined,
                      color: theme.colorScheme.onSurfaceVariant),
                  title: const Text('Roles'),
                  subtitle: rolesAsync.when(
                    data: (roles) => Text(
                      roles.map((r) => r.name).join(', '),
                      style: theme.textTheme.bodySmall,
                    ),
                    loading: () => const Text('Loading...'),
                    error: (_, _) => const Text('Unknown'),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // App Info section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Application',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.info_outline,
                      color: theme.colorScheme.onSurfaceVariant),
                  title: const Text('Version'),
                  subtitle: const Text('1.0.0'),
                ),
                ListTile(
                  leading: Icon(Icons.account_balance_outlined,
                      color: theme.colorScheme.onSurfaceVariant),
                  title: const Text('Platform'),
                  subtitle: const Text('AntInvestor Lender'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Sign out
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
            icon: Icon(Icons.logout, color: theme.colorScheme.error),
            label: Text('Sign Out',
                style: TextStyle(color: theme.colorScheme.error)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.error.withAlpha(60)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

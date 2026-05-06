// Copyright 2023-2026 Ant Investor Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/policy_providers.dart';
import '../widgets/policy_detail_card.dart';
import '../widgets/policy_version_history.dart';

class PolicyDetailScreen extends ConsumerWidget {
  final String policyId;
  const PolicyDetailScreen({super.key, required this.policyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPolicy = ref.watch(policyDetailProvider(policyId));
    return Scaffold(
      appBar: AppBar(title: const Text('Policy')),
      body: asyncPolicy.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (policy) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PolicyDetailCard(policy: policy),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () => context.go('/limits/policies/${policy.id}/edit'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                    onPressed: () => _confirmDelete(context, ref, policy.id),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Version history', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              PolicyVersionHistory(policyId: policy.id),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext ctx, WidgetRef ref, String id) async {
    final ok = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete policy?'),
        content: const Text(
          'This soft-deletes the policy. It can be restored from the audit log.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(policyMutationProvider.notifier).delete(id);
      if (ctx.mounted) ctx.go('/limits/policies');
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Delete failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

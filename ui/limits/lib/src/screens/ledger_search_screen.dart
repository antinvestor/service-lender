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

import '../providers/ledger_providers.dart';
import '../widgets/ledger_search_filters.dart';
import '../widgets/ledger_timeline.dart';

class LedgerSearchScreen extends ConsumerStatefulWidget {
  const LedgerSearchScreen({super.key});

  @override
  ConsumerState<LedgerSearchScreen> createState() => _LedgerSearchScreenState();
}

class _LedgerSearchScreenState extends ConsumerState<LedgerSearchScreen> {
  LedgerSearchParams _params = const LedgerSearchParams();

  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(ledgerSearchProvider(_params));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(ledgerSearchProvider(_params)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          LedgerSearchFilters(
            params: _params,
            onChanged: (p) => setState(() => _params = p),
          ),
          const Divider(height: 24),
          asyncList.when(
            loading: () => const Center(child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )),
            error: (e, _) => Center(child: Text('Failed: $e')),
            data: (entries) => LedgerTimeline(entries: entries),
          ),
        ],
      ),
    );
  }
}

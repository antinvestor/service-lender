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
import 'package:antinvestor_api_limits/antinvestor_api_limits.dart' show Struct;

class AttributeFilterDisplay extends StatelessWidget {
  final Struct? filter;
  const AttributeFilterDisplay({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    if (filter == null || filter!.fields.isEmpty) {
      return const Text(
        'No attribute filter',
        style: TextStyle(color: Colors.grey),
      );
    }
    final entries = filter!.fields.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        entries,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}

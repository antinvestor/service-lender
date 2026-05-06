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

import '../providers/audit_providers.dart';

class AuditEventFilters extends StatelessWidget {
  final AuditSearchParams params;
  final ValueChanged<AuditSearchParams> onChanged;
  const AuditEventFilters({super.key, required this.params, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        SizedBox(
          width: 360,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Verbs (comma-separated; blank = all limits.*)',
              hintText: 'limits.breach.hard, limits.approval.required',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) {
              final actions = v
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              onChanged(AuditSearchParams(
                actions: actions,
                entityType: params.entityType,
                entityId: params.entityId,
                actorId: params.actorId,
              ));
            },
          ),
        ),
        SizedBox(
          width: 180,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Entity type',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) => onChanged(AuditSearchParams(
              actions: params.actions,
              entityType: v.trim(),
              entityId: params.entityId,
              actorId: params.actorId,
            )),
          ),
        ),
        SizedBox(
          width: 220,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Entity ID',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) => onChanged(AuditSearchParams(
              actions: params.actions,
              entityType: params.entityType,
              entityId: v.trim(),
              actorId: params.actorId,
            )),
          ),
        ),
        SizedBox(
          width: 200,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Actor ID',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) => onChanged(AuditSearchParams(
              actions: params.actions,
              entityType: params.entityType,
              entityId: params.entityId,
              actorId: v.trim(),
            )),
          ),
        ),
      ],
    );
  }
}

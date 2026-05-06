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

import 'package:antinvestor_api_limits/antinvestor_api_limits.dart';
import 'package:flutter/material.dart';

import '../providers/ledger_providers.dart';
import '../utils/enum_labels.dart';

class LedgerSearchFilters extends StatelessWidget {
  final LedgerSearchParams params;
  final ValueChanged<LedgerSearchParams> onChanged;
  const LedgerSearchFilters({super.key, required this.params, required this.onChanged});

  void _emit(LedgerSearchParams next) => onChanged(next);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<LimitAction>(
            initialValue: params.action,
            decoration: const InputDecoration(labelText: 'Action', isDense: true),
            items: LimitAction.values
                .map((a) => DropdownMenuItem(value: a, child: Text(limitActionLabel(a))))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                _emit(LedgerSearchParams(
                  action: v,
                  subjectType: params.subjectType,
                  subjectId: params.subjectId,
                  currencyCode: params.currencyCode,
                ));
              }
            },
          ),
        ),
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<SubjectType>(
            initialValue: params.subjectType,
            decoration: const InputDecoration(labelText: 'Subject', isDense: true),
            items: SubjectType.values
                .map((s) => DropdownMenuItem(value: s, child: Text(subjectTypeLabel(s))))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                _emit(LedgerSearchParams(
                  action: params.action,
                  subjectType: v,
                  subjectId: params.subjectId,
                  currencyCode: params.currencyCode,
                ));
              }
            },
          ),
        ),
        SizedBox(
          width: 220,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Subject ID',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) => _emit(LedgerSearchParams(
              action: params.action,
              subjectType: params.subjectType,
              subjectId: v,
              currencyCode: params.currencyCode,
            )),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Currency',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) => _emit(LedgerSearchParams(
              action: params.action,
              subjectType: params.subjectType,
              subjectId: params.subjectId,
              currencyCode: v.toUpperCase(),
            )),
          ),
        ),
      ],
    );
  }
}

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
import 'package:antinvestor_ui_core/api/stream_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'limits_transport_provider.dart';

class LedgerSearchParams {
  final LimitAction action;
  final SubjectType subjectType;
  final String subjectId;
  final String currencyCode;

  const LedgerSearchParams({
    this.action = LimitAction.LIMIT_ACTION_UNSPECIFIED,
    this.subjectType = SubjectType.SUBJECT_TYPE_UNSPECIFIED,
    this.subjectId = '',
    this.currencyCode = '',
  });

  @override
  bool operator ==(Object other) =>
      other is LedgerSearchParams &&
      other.action == action &&
      other.subjectType == subjectType &&
      other.subjectId == subjectId &&
      other.currencyCode == currencyCode;

  @override
  int get hashCode => Object.hash(action, subjectType, subjectId, currencyCode);
}

final ledgerSearchProvider =
    FutureProvider.family<List<LedgerEntryObject>, LedgerSearchParams>(
  (ref, params) async {
    final client = ref.watch(limitsAdminServiceClientProvider);
    final request = LedgerSearchRequest(
      action: params.action,
      subjectType: params.subjectType,
      subjectId: params.subjectId,
      currencyCode: params.currencyCode,
      cursor: PageCursor(limit: 100),
    );
    return collectStream(
      client.ledgerSearch(request),
      extract: (response) => response.data,
    );
  },
);

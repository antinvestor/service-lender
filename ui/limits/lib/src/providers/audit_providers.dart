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

class AuditSearchParams {
  final List<String> actions;
  final String entityType;
  final String entityId;
  final String actorId;

  const AuditSearchParams({
    this.actions = const [],
    this.entityType = '',
    this.entityId = '',
    this.actorId = '',
  });

  @override
  bool operator ==(Object other) =>
      other is AuditSearchParams &&
      _listEquals(other.actions, actions) &&
      other.entityType == entityType &&
      other.entityId == entityId &&
      other.actorId == actorId;

  @override
  int get hashCode =>
      Object.hashAll([...actions, entityType, entityId, actorId]);
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

final auditSearchProvider =
    FutureProvider.family<List<LimitsAuditEventObject>, AuditSearchParams>(
  (ref, params) async {
    final client = ref.watch(limitsAdminServiceClientProvider);
    final request = LimitsAuditSearchRequest(
      actions: params.actions,
      entityType: params.entityType,
      entityId: params.entityId,
      actorId: params.actorId,
      cursor: PageCursor(limit: 100),
    );
    return collectStream(
      client.limitsAuditSearch(request),
      extract: (response) => response.data,
    );
  },
);

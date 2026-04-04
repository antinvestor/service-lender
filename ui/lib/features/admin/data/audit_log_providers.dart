import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../../sdk/src/common/v1/common.pb.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';

part 'audit_log_providers.g.dart';

/// Fetches loan status change audit trail entries.
///
/// When [loanAccountId] is empty, returns all status changes across all loans.
/// Results are capped at 10 pages (1000 records) to prevent unbounded memory.
@riverpod
Future<List<LoanStatusChangeObject>> loanStatusChangeList(
  Ref ref, {
  String loanAccountId = '',
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = LoanStatusChangeSearchRequest(
    cursor: PageCursor(limit: 100),
  );
  if (loanAccountId.isNotEmpty) {
    request.loanAccountId = loanAccountId;
  }

  return collectStream(
    client.loanStatusChangeSearch(request),
    extract: (response) => response.data,
    maxPages: 10,
  );
}

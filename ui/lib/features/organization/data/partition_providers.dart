import 'package:antinvestor_api_tenancy/antinvestor_api_tenancy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../core/api/stream_helpers.dart';
import '../../auth/data/auth_repository.dart';

part 'partition_providers.g.dart';

@riverpod
Future<List<PartitionObject>> partitionList(Ref ref) async {
  final client = ref.watch(tenancyServiceClientProvider);
  final tenantId = await ref.watch(currentTenantIdProvider.future) ?? '';

  final request = ListPartitionRequest(
    query: tenantId,
    cursor: PageCursor(limit: 50),
  );

  return collectStream(
    client.listPartition(request),
    extract: (response) => response.data,
  );
}

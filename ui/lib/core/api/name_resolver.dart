import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/field/data/client_providers.dart';
import '../../features/loan_management/data/loan_product_providers.dart';

part 'name_resolver.g.dart';

/// Resolves a client ID to a display name.
/// Falls back to truncated ID if not found.
@riverpod
Future<String> clientName(Ref ref, String clientId) async {
  if (clientId.isEmpty) return '—';
  try {
    final clients = await ref.watch(
      clientListProvider(query: '', agentId: '').future,
    );
    final match = clients.where((c) => c.id == clientId).firstOrNull;
    if (match != null && match.name.isNotEmpty) return match.name;
  } catch (_) {
    // Fall through to truncated ID
  }
  return clientId.length > 12 ? '${clientId.substring(0, 12)}...' : clientId;
}

/// Resolves a loan product ID to a display name.
/// Falls back to truncated ID if not found.
@riverpod
Future<String> productName(Ref ref, String productId) async {
  if (productId.isEmpty) return '—';
  try {
    final products = await ref.watch(loanProductListProvider('').future);
    final match = products.where((p) => p.id == productId).firstOrNull;
    if (match != null && match.name.isNotEmpty) return match.name;
  } catch (_) {
    // Fall through to truncated ID
  }
  return productId.length > 12 ? '${productId.substring(0, 12)}...' : productId;
}

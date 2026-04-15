import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/name_resolver.dart';

/// Displays a resolved client name, falling back to truncated ID while loading.
class ClientNameText extends ConsumerWidget {
  const ClientNameText({
    super.key,
    required this.clientId,
    this.style,
    this.prefix = '',
  });

  final String clientId;
  final TextStyle? style;
  final String prefix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameAsync = ref.watch(clientNameProvider(clientId));
    final fallback = clientId.length > 12
        ? '${clientId.substring(0, 12)}...'
        : clientId;
    final resolved = nameAsync.when(
      data: (name) => name,
      loading: () => fallback,
      error: (_, _) => fallback,
    );
    return Text('$prefix$resolved', style: style);
  }
}

/// Displays a resolved product name, falling back to truncated ID while loading.
class ProductNameText extends ConsumerWidget {
  const ProductNameText({
    super.key,
    required this.productId,
    this.style,
    this.prefix = '',
  });

  final String productId;
  final TextStyle? style;
  final String prefix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameAsync = ref.watch(productNameProvider(productId));
    final fallback = productId.length > 12
        ? '${productId.substring(0, 12)}...'
        : productId;
    final resolved = nameAsync.when(
      data: (name) => name,
      loading: () => fallback,
      error: (_, _) => fallback,
    );
    return Text('$prefix$resolved', style: style);
  }
}

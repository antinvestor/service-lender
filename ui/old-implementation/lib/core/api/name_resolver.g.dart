// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_resolver.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves a client ID to a display name.
/// Falls back to truncated ID if not found.

@ProviderFor(clientName)
final clientNameProvider = ClientNameFamily._();

/// Resolves a client ID to a display name.
/// Falls back to truncated ID if not found.

final class ClientNameProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Resolves a client ID to a display name.
  /// Falls back to truncated ID if not found.
  ClientNameProvider._({
    required ClientNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clientNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientNameHash();

  @override
  String toString() {
    return r'clientNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return clientName(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientNameHash() => r'bbd9bd6842737d849006251d7ffbf3a241979759';

/// Resolves a client ID to a display name.
/// Falls back to truncated ID if not found.

final class ClientNameFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  ClientNameFamily._()
    : super(
        retry: null,
        name: r'clientNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolves a client ID to a display name.
  /// Falls back to truncated ID if not found.

  ClientNameProvider call(String clientId) =>
      ClientNameProvider._(argument: clientId, from: this);

  @override
  String toString() => r'clientNameProvider';
}

/// Resolves a loan product ID to a display name.
/// Falls back to truncated ID if not found.

@ProviderFor(productName)
final productNameProvider = ProductNameFamily._();

/// Resolves a loan product ID to a display name.
/// Falls back to truncated ID if not found.

final class ProductNameProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Resolves a loan product ID to a display name.
  /// Falls back to truncated ID if not found.
  ProductNameProvider._({
    required ProductNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productNameHash();

  @override
  String toString() {
    return r'productNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return productName(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productNameHash() => r'd3d6f5dc97d5f7a6c2e6eff34addb967106b1b84';

/// Resolves a loan product ID to a display name.
/// Falls back to truncated ID if not found.

final class ProductNameFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  ProductNameFamily._()
    : super(
        retry: null,
        name: r'productNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolves a loan product ID to a display name.
  /// Falls back to truncated ID if not found.

  ProductNameProvider call(String productId) =>
      ProductNameProvider._(argument: productId, from: this);

  @override
  String toString() => r'productNameProvider';
}

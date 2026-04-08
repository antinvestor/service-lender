// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenancy_context.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tenancyContext)
final tenancyContextProvider = TenancyContextProvider._();

final class TenancyContextProvider
    extends $FunctionalProvider<TenancyContext, TenancyContext, TenancyContext>
    with $Provider<TenancyContext> {
  TenancyContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tenancyContextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tenancyContextHash();

  @$internal
  @override
  $ProviderElement<TenancyContext> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TenancyContext create(Ref ref) {
    return tenancyContext(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TenancyContext value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TenancyContext>(value),
    );
  }
}

String _$tenancyContextHash() => r'afee3d138131c426e59ac666055602f2c6028655';

/// Convenience: the current user's partition ID from JWT.
/// Re-exported here so tenancy-related code has a single import.

@ProviderFor(activePartitionId)
final activePartitionIdProvider = ActivePartitionIdProvider._();

/// Convenience: the current user's partition ID from JWT.
/// Re-exported here so tenancy-related code has a single import.

final class ActivePartitionIdProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Convenience: the current user's partition ID from JWT.
  /// Re-exported here so tenancy-related code has a single import.
  ActivePartitionIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activePartitionIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activePartitionIdHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return activePartitionId(ref);
  }
}

String _$activePartitionIdHash() => r'2bfe292c1b17504bf217749d1a1aef1ac842f165';

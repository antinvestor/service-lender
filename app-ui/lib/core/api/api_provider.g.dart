// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiTransport)
final apiTransportProvider = ApiTransportProvider._();

final class ApiTransportProvider
    extends $FunctionalProvider<Transport, Transport, Transport>
    with $Provider<Transport> {
  ApiTransportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiTransportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiTransportHash();

  @$internal
  @override
  $ProviderElement<Transport> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Transport create(Ref ref) {
    return apiTransport(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Transport value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Transport>(value),
    );
  }
}

String _$apiTransportHash() => r'00cf8739daf46292be12daedb8f3ad72451d2a5d';

@ProviderFor(identityServiceClient)
final identityServiceClientProvider = IdentityServiceClientProvider._();

final class IdentityServiceClientProvider
    extends
        $FunctionalProvider<
          IdentityServiceClient,
          IdentityServiceClient,
          IdentityServiceClient
        >
    with $Provider<IdentityServiceClient> {
  IdentityServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'identityServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$identityServiceClientHash();

  @$internal
  @override
  $ProviderElement<IdentityServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IdentityServiceClient create(Ref ref) {
    return identityServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdentityServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdentityServiceClient>(value),
    );
  }
}

String _$identityServiceClientHash() =>
    r'02b2cb0078d4148e606d9bffb1d461a424d16bb8';

@ProviderFor(fieldServiceClient)
final fieldServiceClientProvider = FieldServiceClientProvider._();

final class FieldServiceClientProvider
    extends
        $FunctionalProvider<
          FieldServiceClient,
          FieldServiceClient,
          FieldServiceClient
        >
    with $Provider<FieldServiceClient> {
  FieldServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fieldServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fieldServiceClientHash();

  @$internal
  @override
  $ProviderElement<FieldServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FieldServiceClient create(Ref ref) {
    return fieldServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FieldServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FieldServiceClient>(value),
    );
  }
}

String _$fieldServiceClientHash() =>
    r'53c5253387dfb7db7e65f4afb6db0f14aed4717e';

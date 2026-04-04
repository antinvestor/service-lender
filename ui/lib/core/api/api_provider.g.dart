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

String _$apiTransportHash() => r'ff291759dc6536e97cc7532005985b8c7436ba14';

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

@ProviderFor(originationServiceClient)
final originationServiceClientProvider = OriginationServiceClientProvider._();

final class OriginationServiceClientProvider
    extends
        $FunctionalProvider<
          OriginationServiceClient,
          OriginationServiceClient,
          OriginationServiceClient
        >
    with $Provider<OriginationServiceClient> {
  OriginationServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'originationServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$originationServiceClientHash();

  @$internal
  @override
  $ProviderElement<OriginationServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OriginationServiceClient create(Ref ref) {
    return originationServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OriginationServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OriginationServiceClient>(value),
    );
  }
}

String _$originationServiceClientHash() =>
    r'984784ff518dea9e2ee9b9631876fded837103dd';

@ProviderFor(loanManagementServiceClient)
final loanManagementServiceClientProvider =
    LoanManagementServiceClientProvider._();

final class LoanManagementServiceClientProvider
    extends
        $FunctionalProvider<
          LoanManagementServiceClient,
          LoanManagementServiceClient,
          LoanManagementServiceClient
        >
    with $Provider<LoanManagementServiceClient> {
  LoanManagementServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanManagementServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanManagementServiceClientHash();

  @$internal
  @override
  $ProviderElement<LoanManagementServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoanManagementServiceClient create(Ref ref) {
    return loanManagementServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoanManagementServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoanManagementServiceClient>(value),
    );
  }
}

String _$loanManagementServiceClientHash() =>
    r'22b65e18e8d9b91396352f7cec51b61afcd6b5f9';

@ProviderFor(savingsServiceClient)
final savingsServiceClientProvider = SavingsServiceClientProvider._();

final class SavingsServiceClientProvider
    extends
        $FunctionalProvider<
          SavingsServiceClient,
          SavingsServiceClient,
          SavingsServiceClient
        >
    with $Provider<SavingsServiceClient> {
  SavingsServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savingsServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savingsServiceClientHash();

  @$internal
  @override
  $ProviderElement<SavingsServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SavingsServiceClient create(Ref ref) {
    return savingsServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SavingsServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SavingsServiceClient>(value),
    );
  }
}

String _$savingsServiceClientHash() =>
    r'1bfc16080d08fce552c74dede6a9639a94e6ec5a';

@ProviderFor(fundingServiceClient)
final fundingServiceClientProvider = FundingServiceClientProvider._();

final class FundingServiceClientProvider
    extends
        $FunctionalProvider<
          FundingServiceClient,
          FundingServiceClient,
          FundingServiceClient
        >
    with $Provider<FundingServiceClient> {
  FundingServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fundingServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fundingServiceClientHash();

  @$internal
  @override
  $ProviderElement<FundingServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FundingServiceClient create(Ref ref) {
    return fundingServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FundingServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FundingServiceClient>(value),
    );
  }
}

String _$fundingServiceClientHash() =>
    r'9da3a68c006a7ae8ffaa655ded82968d244dca9a';

@ProviderFor(operationsServiceClient)
final operationsServiceClientProvider = OperationsServiceClientProvider._();

final class OperationsServiceClientProvider
    extends
        $FunctionalProvider<
          OperationsServiceClient,
          OperationsServiceClient,
          OperationsServiceClient
        >
    with $Provider<OperationsServiceClient> {
  OperationsServiceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'operationsServiceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$operationsServiceClientHash();

  @$internal
  @override
  $ProviderElement<OperationsServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OperationsServiceClient create(Ref ref) {
    return operationsServiceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OperationsServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OperationsServiceClient>(value),
    );
  }
}

String _$operationsServiceClientHash() =>
    r'292c313e1de94a97710cc4d529c97de262d4cf36';

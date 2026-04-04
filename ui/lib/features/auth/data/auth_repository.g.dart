// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'd26038c840ed68416a6c6c1e180cb83944f94c33';

@ProviderFor(currentProfileId)
final currentProfileIdProvider = CurrentProfileIdProvider._();

final class CurrentProfileIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  CurrentProfileIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProfileIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProfileIdHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return currentProfileId(ref);
  }
}

String _$currentProfileIdHash() => r'8ad5de46d40d2ef6ed2b289aaac91824d12f38a7';

@ProviderFor(userRoles)
final userRolesProvider = UserRolesProvider._();

final class UserRolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  UserRolesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRolesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRolesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return userRoles(ref);
  }
}

String _$userRolesHash() => r'ef6f26b437642590bed3086dc456579e2b0bb0bb';

@ProviderFor(currentTenantId)
final currentTenantIdProvider = CurrentTenantIdProvider._();

final class CurrentTenantIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  CurrentTenantIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTenantIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTenantIdHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return currentTenantId(ref);
  }
}

String _$currentTenantIdHash() => r'81dce1e5c7ddafce8263aa46689bab80a1b949e5';

@ProviderFor(currentPartitionId)
final currentPartitionIdProvider = CurrentPartitionIdProvider._();

final class CurrentPartitionIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  CurrentPartitionIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPartitionIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPartitionIdHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return currentPartitionId(ref);
  }
}

String _$currentPartitionIdHash() =>
    r'6a0f0d1b2e465ce8684882f75e77716b390e30ec';

@ProviderFor(currentDisplayName)
final currentDisplayNameProvider = CurrentDisplayNameProvider._();

final class CurrentDisplayNameProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  CurrentDisplayNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDisplayNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDisplayNameHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return currentDisplayName(ref);
  }
}

String _$currentDisplayNameHash() =>
    r'3212f34ee7e519e91e80cdbe966ecc830d9abb71';

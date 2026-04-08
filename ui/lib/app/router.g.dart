// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authChange)
final authChangeProvider = AuthChangeProvider._();

final class AuthChangeProvider
    extends
        $FunctionalProvider<
          AuthChangeNotifier,
          AuthChangeNotifier,
          AuthChangeNotifier
        >
    with $Provider<AuthChangeNotifier> {
  AuthChangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authChangeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authChangeHash();

  @$internal
  @override
  $ProviderElement<AuthChangeNotifier> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthChangeNotifier create(Ref ref) {
    return authChange(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthChangeNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthChangeNotifier>(value),
    );
  }
}

String _$authChangeHash() => r'136ae107f858ad9f2ffc8931fa5a84cb7da6ec7e';

@ProviderFor(router)
final routerProvider = RouterProvider._();

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'7de85ef022cd46cace95d3b1ad49a35bf04b32a2';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_targets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches login targets (child orgs/branches) for a given OAuth client_id.
/// This is an unauthenticated call — used on the login page before sign-in.

@ProviderFor(loginTargets)
final loginTargetsProvider = LoginTargetsFamily._();

/// Fetches login targets (child orgs/branches) for a given OAuth client_id.
/// This is an unauthenticated call — used on the login page before sign-in.

final class LoginTargetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoginTargetsResponse>,
          LoginTargetsResponse,
          FutureOr<LoginTargetsResponse>
        >
    with
        $FutureModifier<LoginTargetsResponse>,
        $FutureProvider<LoginTargetsResponse> {
  /// Fetches login targets (child orgs/branches) for a given OAuth client_id.
  /// This is an unauthenticated call — used on the login page before sign-in.
  LoginTargetsProvider._({
    required LoginTargetsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loginTargetsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loginTargetsHash();

  @override
  String toString() {
    return r'loginTargetsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LoginTargetsResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoginTargetsResponse> create(Ref ref) {
    final argument = this.argument as String;
    return loginTargets(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoginTargetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loginTargetsHash() => r'83feab7f83fad4e066caed980b641322f6e87f79';

/// Fetches login targets (child orgs/branches) for a given OAuth client_id.
/// This is an unauthenticated call — used on the login page before sign-in.

final class LoginTargetsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LoginTargetsResponse>, String> {
  LoginTargetsFamily._()
    : super(
        retry: null,
        name: r'loginTargetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches login targets (child orgs/branches) for a given OAuth client_id.
  /// This is an unauthenticated call — used on the login page before sign-in.

  LoginTargetsProvider call(String clientId) =>
      LoginTargetsProvider._(argument: clientId, from: this);

  @override
  String toString() => r'loginTargetsProvider';
}

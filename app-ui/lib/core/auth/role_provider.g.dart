// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentUserRoles)
final currentUserRolesProvider = CurrentUserRolesProvider._();

final class CurrentUserRolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<LenderRole>>,
          Set<LenderRole>,
          FutureOr<Set<LenderRole>>
        >
    with $FutureModifier<Set<LenderRole>>, $FutureProvider<Set<LenderRole>> {
  CurrentUserRolesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserRolesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserRolesHash();

  @$internal
  @override
  $FutureProviderElement<Set<LenderRole>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<LenderRole>> create(Ref ref) {
    return currentUserRoles(ref);
  }
}

String _$currentUserRolesHash() => r'a5af15e840c5746ec0af16ced5b7d9b75a56810c';

/// Check if user has any of the specified roles

@ProviderFor(hasAnyRole)
final hasAnyRoleProvider = HasAnyRoleFamily._();

/// Check if user has any of the specified roles

final class HasAnyRoleProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Check if user has any of the specified roles
  HasAnyRoleProvider._({
    required HasAnyRoleFamily super.from,
    required List<LenderRole> super.argument,
  }) : super(
         retry: null,
         name: r'hasAnyRoleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hasAnyRoleHash();

  @override
  String toString() {
    return r'hasAnyRoleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as List<LenderRole>;
    return hasAnyRole(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HasAnyRoleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hasAnyRoleHash() => r'5759a380e49fc106b8e7f84203b20342cfe7e405';

/// Check if user has any of the specified roles

final class HasAnyRoleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, List<LenderRole>> {
  HasAnyRoleFamily._()
    : super(
        retry: null,
        name: r'hasAnyRoleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Check if user has any of the specified roles

  HasAnyRoleProvider call(List<LenderRole> requiredRoles) =>
      HasAnyRoleProvider._(argument: requiredRoles, from: this);

  @override
  String toString() => r'hasAnyRoleProvider';
}

/// Whether the current user can manage banks/branches

@ProviderFor(canManageBanks)
final canManageBanksProvider = CanManageBanksProvider._();

/// Whether the current user can manage banks/branches

final class CanManageBanksProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage banks/branches
  CanManageBanksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageBanksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageBanksHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageBanks(ref);
  }
}

String _$canManageBanksHash() => r'd541bdb80d9ab85d5362b004fc155c3968fe5c5c';

/// Whether the current user can manage agents

@ProviderFor(canManageAgents)
final canManageAgentsProvider = CanManageAgentsProvider._();

/// Whether the current user can manage agents

final class CanManageAgentsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage agents
  CanManageAgentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageAgentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageAgentsHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageAgents(ref);
  }
}

String _$canManageAgentsHash() => r'7d3d2dd5009d632ee4f89e3a2ed98ad23ed86743';

/// Whether the current user can manage clients

@ProviderFor(canManageClients)
final canManageClientsProvider = CanManageClientsProvider._();

/// Whether the current user can manage clients

final class CanManageClientsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage clients
  CanManageClientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageClientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageClientsHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageClients(ref);
  }
}

String _$canManageClientsHash() => r'44c453612d67b85a141349ccfab29235d6d770ae';

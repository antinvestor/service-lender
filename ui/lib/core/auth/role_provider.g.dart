// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Returns the current user's lender roles.
///
/// Lender-specific roles (owner, admin, etc.) are extracted from the JWT.
/// If no recognized roles are found, the user gets an empty set — they can
/// see the dashboard but no functional sections or action buttons. The
/// backend enforces the same restrictions via OPL relation tuples.

@ProviderFor(currentUserRoles)
final currentUserRolesProvider = CurrentUserRolesProvider._();

/// Returns the current user's lender roles.
///
/// Lender-specific roles (owner, admin, etc.) are extracted from the JWT.
/// If no recognized roles are found, the user gets an empty set — they can
/// see the dashboard but no functional sections or action buttons. The
/// backend enforces the same restrictions via OPL relation tuples.

final class CurrentUserRolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<LenderRole>>,
          Set<LenderRole>,
          FutureOr<Set<LenderRole>>
        >
    with $FutureModifier<Set<LenderRole>>, $FutureProvider<Set<LenderRole>> {
  /// Returns the current user's lender roles.
  ///
  /// Lender-specific roles (owner, admin, etc.) are extracted from the JWT.
  /// If no recognized roles are found, the user gets an empty set — they can
  /// see the dashboard but no functional sections or action buttons. The
  /// backend enforces the same restrictions via OPL relation tuples.
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

/// Whether the current user can manage organizations/branches

@ProviderFor(canManageOrganizations)
final canManageOrganizationsProvider = CanManageOrganizationsProvider._();

/// Whether the current user can manage organizations/branches

final class CanManageOrganizationsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage organizations/branches
  CanManageOrganizationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageOrganizationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageOrganizationsHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageOrganizations(ref);
  }
}

String _$canManageOrganizationsHash() =>
    r'99b25fe773a6ba5fc51edaa76af2005be8566554';

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

/// Whether the current user can manage investors

@ProviderFor(canManageInvestors)
final canManageInvestorsProvider = CanManageInvestorsProvider._();

/// Whether the current user can manage investors

final class CanManageInvestorsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage investors
  CanManageInvestorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageInvestorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageInvestorsHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageInvestors(ref);
  }
}

String _$canManageInvestorsHash() =>
    r'af0984dc2d40afcb71e11f809c994e7897b380fa';

/// Whether the current user can create loan applications

@ProviderFor(canCreateApplications)
final canCreateApplicationsProvider = CanCreateApplicationsProvider._();

/// Whether the current user can create loan applications

final class CanCreateApplicationsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can create loan applications
  CanCreateApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canCreateApplicationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canCreateApplicationsHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canCreateApplications(ref);
  }
}

String _$canCreateApplicationsHash() =>
    r'bd9185e97353b71d871f9a8b6b57f989e16318d0';

/// Whether the current user can manage loan products

@ProviderFor(canManageLoanProducts)
final canManageLoanProductsProvider = CanManageLoanProductsProvider._();

/// Whether the current user can manage loan products

final class CanManageLoanProductsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage loan products
  CanManageLoanProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageLoanProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageLoanProductsHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageLoanProducts(ref);
  }
}

String _$canManageLoanProductsHash() =>
    r'943648326905a635a18b0ea6dff4bff8fb61a64f';

/// Whether the current user can manage verification tasks

@ProviderFor(canManageVerification)
final canManageVerificationProvider = CanManageVerificationProvider._();

/// Whether the current user can manage verification tasks

final class CanManageVerificationProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage verification tasks
  CanManageVerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageVerificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageVerificationHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageVerification(ref);
  }
}

String _$canManageVerificationHash() =>
    r'2b7191104f1587800eea520255b71656f9d957f4';

/// Whether the current user can make underwriting decisions

@ProviderFor(canManageUnderwriting)
final canManageUnderwritingProvider = CanManageUnderwritingProvider._();

/// Whether the current user can make underwriting decisions

final class CanManageUnderwritingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can make underwriting decisions
  CanManageUnderwritingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageUnderwritingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageUnderwritingHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageUnderwriting(ref);
  }
}

String _$canManageUnderwritingHash() =>
    r'ce88e06b8d02fd5ed703008c477a2617506fb33b';

/// Whether the current user can manage loans (disbursements, etc.)

@ProviderFor(canManageLoans)
final canManageLoansProvider = CanManageLoansProvider._();

/// Whether the current user can manage loans (disbursements, etc.)

final class CanManageLoansProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage loans (disbursements, etc.)
  CanManageLoansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageLoansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageLoansHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageLoans(ref);
  }
}

String _$canManageLoansHash() => r'81788cf22dba49c3b81637d1a677d6e5c442ed5c';

/// Whether the current user can record repayments

@ProviderFor(canRecordRepayments)
final canRecordRepaymentsProvider = CanRecordRepaymentsProvider._();

/// Whether the current user can record repayments

final class CanRecordRepaymentsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can record repayments
  CanRecordRepaymentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canRecordRepaymentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canRecordRepaymentsHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canRecordRepayments(ref);
  }
}

String _$canRecordRepaymentsHash() =>
    r'b58a273644d6525f2f0876f7b54748de5509ff3f';

/// Whether the current user can manage system users

@ProviderFor(canManageSystemUsers)
final canManageSystemUsersProvider = CanManageSystemUsersProvider._();

/// Whether the current user can manage system users

final class CanManageSystemUsersProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage system users
  CanManageSystemUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageSystemUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageSystemUsersHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageSystemUsers(ref);
  }
}

String _$canManageSystemUsersHash() =>
    r'c4d5a826a88d219f9f85220c3b87905a767381b8';

/// Whether the current user can manage penalties

@ProviderFor(canManagePenalties)
final canManagePenaltiesProvider = CanManagePenaltiesProvider._();

/// Whether the current user can manage penalties

final class CanManagePenaltiesProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage penalties
  CanManagePenaltiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManagePenaltiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManagePenaltiesHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManagePenalties(ref);
  }
}

String _$canManagePenaltiesHash() =>
    r'39c8c7ee68728dbc5f88769ddbae26ab79ab666f';

/// Whether the current user can manage loan restructuring

@ProviderFor(canManageRestructuring)
final canManageRestructuringProvider = CanManageRestructuringProvider._();

/// Whether the current user can manage loan restructuring

final class CanManageRestructuringProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the current user can manage loan restructuring
  CanManageRestructuringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageRestructuringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageRestructuringHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canManageRestructuring(ref);
  }
}

String _$canManageRestructuringHash() =>
    r'3488f20507b8cab6a438529c97a7e3fede4797cb';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches count of loan requests in a given status.

@ProviderFor(loanRequestCountByStatus)
final loanRequestCountByStatusProvider = LoanRequestCountByStatusFamily._();

/// Fetches count of loan requests in a given status.

final class LoanRequestCountByStatusProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Fetches count of loan requests in a given status.
  LoanRequestCountByStatusProvider._({
    required LoanRequestCountByStatusFamily super.from,
    required LoanRequestStatus super.argument,
  }) : super(
         retry: null,
         name: r'loanRequestCountByStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanRequestCountByStatusHash();

  @override
  String toString() {
    return r'loanRequestCountByStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as LoanRequestStatus;
    return loanRequestCountByStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanRequestCountByStatusProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanRequestCountByStatusHash() =>
    r'8a0e89f60c7c922cce518230179ae2d28ca59f1e';

/// Fetches count of loan requests in a given status.

final class LoanRequestCountByStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, LoanRequestStatus> {
  LoanRequestCountByStatusFamily._()
    : super(
        retry: null,
        name: r'loanRequestCountByStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches count of loan requests in a given status.

  LoanRequestCountByStatusProvider call(LoanRequestStatus status) =>
      LoanRequestCountByStatusProvider._(argument: status, from: this);

  @override
  String toString() => r'loanRequestCountByStatusProvider';
}

/// Fetches count of loan accounts in a given status.

@ProviderFor(loanCountByStatus)
final loanCountByStatusProvider = LoanCountByStatusFamily._();

/// Fetches count of loan accounts in a given status.

final class LoanCountByStatusProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Fetches count of loan accounts in a given status.
  LoanCountByStatusProvider._({
    required LoanCountByStatusFamily super.from,
    required LoanStatus super.argument,
  }) : super(
         retry: null,
         name: r'loanCountByStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanCountByStatusHash();

  @override
  String toString() {
    return r'loanCountByStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as LoanStatus;
    return loanCountByStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanCountByStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanCountByStatusHash() => r'c3b07985f825e34f55808087f877c3168ae5bdcf';

/// Fetches count of loan accounts in a given status.

final class LoanCountByStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, LoanStatus> {
  LoanCountByStatusFamily._()
    : super(
        retry: null,
        name: r'loanCountByStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches count of loan accounts in a given status.

  LoanCountByStatusProvider call(LoanStatus status) =>
      LoanCountByStatusProvider._(argument: status, from: this);

  @override
  String toString() => r'loanCountByStatusProvider';
}

/// Convenience providers for specific dashboard metrics.

@ProviderFor(pendingApprovalCount)
final pendingApprovalCountProvider = PendingApprovalCountProvider._();

/// Convenience providers for specific dashboard metrics.

final class PendingApprovalCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Convenience providers for specific dashboard metrics.
  PendingApprovalCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingApprovalCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingApprovalCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return pendingApprovalCount(ref);
  }
}

String _$pendingApprovalCountHash() =>
    r'8100ff88d906a53a17f55f487766de670dcae806';

@ProviderFor(approvedRequestsCount)
final approvedRequestsCountProvider = ApprovedRequestsCountProvider._();

final class ApprovedRequestsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  ApprovedRequestsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approvedRequestsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approvedRequestsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return approvedRequestsCount(ref);
  }
}

String _$approvedRequestsCountHash() =>
    r'b62f764741de36a4acc538b776195517584b0613';

@ProviderFor(activeLoansCount)
final activeLoansCountProvider = ActiveLoansCountProvider._();

final class ActiveLoansCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  ActiveLoansCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeLoansCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeLoansCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return activeLoansCount(ref);
  }
}

String _$activeLoansCountHash() => r'273dd86b376e57c158609c31cfd9d13df3ecbb42';

@ProviderFor(pendingDisbursementCount)
final pendingDisbursementCountProvider = PendingDisbursementCountProvider._();

final class PendingDisbursementCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  PendingDisbursementCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingDisbursementCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingDisbursementCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return pendingDisbursementCount(ref);
  }
}

String _$pendingDisbursementCountHash() =>
    r'fdc508d888a37b267c5a758e4b7709351f1b0d6d';

@ProviderFor(delinquentLoansCount)
final delinquentLoansCountProvider = DelinquentLoansCountProvider._();

final class DelinquentLoansCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  DelinquentLoansCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'delinquentLoansCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$delinquentLoansCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return delinquentLoansCount(ref);
  }
}

String _$delinquentLoansCountHash() =>
    r'457f7539b837e2c803afc9313ab35c9ae9105ecd';

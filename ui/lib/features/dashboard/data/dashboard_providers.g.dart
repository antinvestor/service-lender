// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches count of applications in a given status.

@ProviderFor(applicationCountByStatus)
final applicationCountByStatusProvider = ApplicationCountByStatusFamily._();

/// Fetches count of applications in a given status.

final class ApplicationCountByStatusProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Fetches count of applications in a given status.
  ApplicationCountByStatusProvider._({
    required ApplicationCountByStatusFamily super.from,
    required ApplicationStatus super.argument,
  }) : super(
         retry: null,
         name: r'applicationCountByStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$applicationCountByStatusHash();

  @override
  String toString() {
    return r'applicationCountByStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as ApplicationStatus;
    return applicationCountByStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicationCountByStatusProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$applicationCountByStatusHash() =>
    r'8333ca293023b477afcf15d057539f8e2316c197';

/// Fetches count of applications in a given status.

final class ApplicationCountByStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, ApplicationStatus> {
  ApplicationCountByStatusFamily._()
    : super(
        retry: null,
        name: r'applicationCountByStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches count of applications in a given status.

  ApplicationCountByStatusProvider call(ApplicationStatus status) =>
      ApplicationCountByStatusProvider._(argument: status, from: this);

  @override
  String toString() => r'applicationCountByStatusProvider';
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

String _$loanCountByStatusHash() => r'748591a77dc65b5fe56cc50a971ed81106511dc3';

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

@ProviderFor(pendingVerificationCount)
final pendingVerificationCountProvider = PendingVerificationCountProvider._();

/// Convenience providers for specific dashboard metrics.

final class PendingVerificationCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Convenience providers for specific dashboard metrics.
  PendingVerificationCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingVerificationCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingVerificationCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return pendingVerificationCount(ref);
  }
}

String _$pendingVerificationCountHash() =>
    r'f21728859fa544c1e44e81cec882d00abcbba09b';

@ProviderFor(pendingUnderwritingCount)
final pendingUnderwritingCountProvider = PendingUnderwritingCountProvider._();

final class PendingUnderwritingCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  PendingUnderwritingCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingUnderwritingCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingUnderwritingCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return pendingUnderwritingCount(ref);
  }
}

String _$pendingUnderwritingCountHash() =>
    r'327e10486dfb1fff5f1d8cbbe01902da8fac854c';

@ProviderFor(offerPendingCount)
final offerPendingCountProvider = OfferPendingCountProvider._();

final class OfferPendingCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  OfferPendingCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offerPendingCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offerPendingCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return offerPendingCount(ref);
  }
}

String _$offerPendingCountHash() => r'c880932ad66e7f37526be74d9f0879036e1a00b0';

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

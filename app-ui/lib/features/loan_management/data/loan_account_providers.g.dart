// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loanAccountList)
final loanAccountListProvider = LoanAccountListFamily._();

final class LoanAccountListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LoanAccountObject>>,
          List<LoanAccountObject>,
          FutureOr<List<LoanAccountObject>>
        >
    with
        $FutureModifier<List<LoanAccountObject>>,
        $FutureProvider<List<LoanAccountObject>> {
  LoanAccountListProvider._({
    required LoanAccountListFamily super.from,
    required ({String query, LoanStatus? status}) super.argument,
  }) : super(
         retry: null,
         name: r'loanAccountListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanAccountListHash();

  @override
  String toString() {
    return r'loanAccountListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<LoanAccountObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LoanAccountObject>> create(Ref ref) {
    final argument = this.argument as ({String query, LoanStatus? status});
    return loanAccountList(ref, query: argument.query, status: argument.status);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanAccountListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanAccountListHash() => r'b7561287415608708e1029a0923e0b201e926492';

final class LoanAccountListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<LoanAccountObject>>,
          ({String query, LoanStatus? status})
        > {
  LoanAccountListFamily._()
    : super(
        retry: null,
        name: r'loanAccountListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanAccountListProvider call({required String query, LoanStatus? status}) =>
      LoanAccountListProvider._(
        argument: (query: query, status: status),
        from: this,
      );

  @override
  String toString() => r'loanAccountListProvider';
}

@ProviderFor(loanAccountDetail)
final loanAccountDetailProvider = LoanAccountDetailFamily._();

final class LoanAccountDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoanAccountObject>,
          LoanAccountObject,
          FutureOr<LoanAccountObject>
        >
    with
        $FutureModifier<LoanAccountObject>,
        $FutureProvider<LoanAccountObject> {
  LoanAccountDetailProvider._({
    required LoanAccountDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loanAccountDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanAccountDetailHash();

  @override
  String toString() {
    return r'loanAccountDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LoanAccountObject> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoanAccountObject> create(Ref ref) {
    final argument = this.argument as String;
    return loanAccountDetail(ref, id: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanAccountDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanAccountDetailHash() => r'97f1182878b446ceadf5ce3eec76414d4ff75aad';

final class LoanAccountDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LoanAccountObject>, String> {
  LoanAccountDetailFamily._()
    : super(
        retry: null,
        name: r'loanAccountDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanAccountDetailProvider call({required String id}) =>
      LoanAccountDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'loanAccountDetailProvider';
}

@ProviderFor(loanBalanceDetail)
final loanBalanceDetailProvider = LoanBalanceDetailFamily._();

final class LoanBalanceDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoanBalanceObject>,
          LoanBalanceObject,
          FutureOr<LoanBalanceObject>
        >
    with
        $FutureModifier<LoanBalanceObject>,
        $FutureProvider<LoanBalanceObject> {
  LoanBalanceDetailProvider._({
    required LoanBalanceDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loanBalanceDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanBalanceDetailHash();

  @override
  String toString() {
    return r'loanBalanceDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LoanBalanceObject> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoanBalanceObject> create(Ref ref) {
    final argument = this.argument as String;
    return loanBalanceDetail(ref, loanAccountId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanBalanceDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanBalanceDetailHash() => r'8cfb28d521899b8846579632d75201ae00fead2a';

final class LoanBalanceDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LoanBalanceObject>, String> {
  LoanBalanceDetailFamily._()
    : super(
        retry: null,
        name: r'loanBalanceDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanBalanceDetailProvider call({required String loanAccountId}) =>
      LoanBalanceDetailProvider._(argument: loanAccountId, from: this);

  @override
  String toString() => r'loanBalanceDetailProvider';
}

@ProviderFor(LoanAccountNotifier)
final loanAccountProvider = LoanAccountNotifierProvider._();

final class LoanAccountNotifierProvider
    extends $AsyncNotifierProvider<LoanAccountNotifier, void> {
  LoanAccountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanAccountNotifierHash();

  @$internal
  @override
  LoanAccountNotifier create() => LoanAccountNotifier();
}

String _$loanAccountNotifierHash() =>
    r'4fb88d10d31a0d04d0d7cf4e4cb13bd549ffd574';

abstract class _$LoanAccountNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

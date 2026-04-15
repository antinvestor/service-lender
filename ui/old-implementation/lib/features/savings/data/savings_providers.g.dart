// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(savingsProductList)
final savingsProductListProvider = SavingsProductListFamily._();

final class SavingsProductListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SavingsProductObject>>,
          List<SavingsProductObject>,
          FutureOr<List<SavingsProductObject>>
        >
    with
        $FutureModifier<List<SavingsProductObject>>,
        $FutureProvider<List<SavingsProductObject>> {
  SavingsProductListProvider._({
    required SavingsProductListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'savingsProductListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$savingsProductListHash();

  @override
  String toString() {
    return r'savingsProductListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SavingsProductObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SavingsProductObject>> create(Ref ref) {
    final argument = this.argument as String;
    return savingsProductList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SavingsProductListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$savingsProductListHash() =>
    r'3dda0293b976322e3fbfa437c1116f3af7d293e7';

final class SavingsProductListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SavingsProductObject>>,
          String
        > {
  SavingsProductListFamily._()
    : super(
        retry: null,
        name: r'savingsProductListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SavingsProductListProvider call(String query) =>
      SavingsProductListProvider._(argument: query, from: this);

  @override
  String toString() => r'savingsProductListProvider';
}

@ProviderFor(SavingsProductNotifier)
final savingsProductProvider = SavingsProductNotifierProvider._();

final class SavingsProductNotifierProvider
    extends $AsyncNotifierProvider<SavingsProductNotifier, void> {
  SavingsProductNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savingsProductProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savingsProductNotifierHash();

  @$internal
  @override
  SavingsProductNotifier create() => SavingsProductNotifier();
}

String _$savingsProductNotifierHash() =>
    r'b025d70423225418a0fe06e9710f9389e194e65a';

abstract class _$SavingsProductNotifier extends $AsyncNotifier<void> {
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

@ProviderFor(savingsAccountList)
final savingsAccountListProvider = SavingsAccountListFamily._();

final class SavingsAccountListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SavingsAccountObject>>,
          List<SavingsAccountObject>,
          FutureOr<List<SavingsAccountObject>>
        >
    with
        $FutureModifier<List<SavingsAccountObject>>,
        $FutureProvider<List<SavingsAccountObject>> {
  SavingsAccountListProvider._({
    required SavingsAccountListFamily super.from,
    required ({String query, String ownerId}) super.argument,
  }) : super(
         retry: null,
         name: r'savingsAccountListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$savingsAccountListHash();

  @override
  String toString() {
    return r'savingsAccountListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SavingsAccountObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SavingsAccountObject>> create(Ref ref) {
    final argument = this.argument as ({String query, String ownerId});
    return savingsAccountList(
      ref,
      query: argument.query,
      ownerId: argument.ownerId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SavingsAccountListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$savingsAccountListHash() =>
    r'7daa62ae440e31d48c6b01098d64e39ebb9ce73d';

final class SavingsAccountListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SavingsAccountObject>>,
          ({String query, String ownerId})
        > {
  SavingsAccountListFamily._()
    : super(
        retry: null,
        name: r'savingsAccountListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SavingsAccountListProvider call({
    required String query,
    String ownerId = '',
  }) => SavingsAccountListProvider._(
    argument: (query: query, ownerId: ownerId),
    from: this,
  );

  @override
  String toString() => r'savingsAccountListProvider';
}

@ProviderFor(savingsAccountDetail)
final savingsAccountDetailProvider = SavingsAccountDetailFamily._();

final class SavingsAccountDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SavingsAccountObject>,
          SavingsAccountObject,
          FutureOr<SavingsAccountObject>
        >
    with
        $FutureModifier<SavingsAccountObject>,
        $FutureProvider<SavingsAccountObject> {
  SavingsAccountDetailProvider._({
    required SavingsAccountDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'savingsAccountDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$savingsAccountDetailHash();

  @override
  String toString() {
    return r'savingsAccountDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SavingsAccountObject> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SavingsAccountObject> create(Ref ref) {
    final argument = this.argument as String;
    return savingsAccountDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SavingsAccountDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$savingsAccountDetailHash() =>
    r'5a42cf477d532a8177dda77efb20421228414d23';

final class SavingsAccountDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SavingsAccountObject>, String> {
  SavingsAccountDetailFamily._()
    : super(
        retry: null,
        name: r'savingsAccountDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SavingsAccountDetailProvider call(String id) =>
      SavingsAccountDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'savingsAccountDetailProvider';
}

@ProviderFor(savingsBalance)
final savingsBalanceProvider = SavingsBalanceFamily._();

final class SavingsBalanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<SavingsBalanceObject>,
          SavingsBalanceObject,
          FutureOr<SavingsBalanceObject>
        >
    with
        $FutureModifier<SavingsBalanceObject>,
        $FutureProvider<SavingsBalanceObject> {
  SavingsBalanceProvider._({
    required SavingsBalanceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'savingsBalanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$savingsBalanceHash();

  @override
  String toString() {
    return r'savingsBalanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SavingsBalanceObject> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SavingsBalanceObject> create(Ref ref) {
    final argument = this.argument as String;
    return savingsBalance(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SavingsBalanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$savingsBalanceHash() => r'9d7b5242247dfda5d0a998f0f63a984c5d99bb0d';

final class SavingsBalanceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SavingsBalanceObject>, String> {
  SavingsBalanceFamily._()
    : super(
        retry: null,
        name: r'savingsBalanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SavingsBalanceProvider call(String accountId) =>
      SavingsBalanceProvider._(argument: accountId, from: this);

  @override
  String toString() => r'savingsBalanceProvider';
}

@ProviderFor(SavingsAccountNotifier)
final savingsAccountProvider = SavingsAccountNotifierProvider._();

final class SavingsAccountNotifierProvider
    extends $AsyncNotifierProvider<SavingsAccountNotifier, void> {
  SavingsAccountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savingsAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savingsAccountNotifierHash();

  @$internal
  @override
  SavingsAccountNotifier create() => SavingsAccountNotifier();
}

String _$savingsAccountNotifierHash() =>
    r'7723fd46008eba68a5ddd171619f8c0169452ada';

abstract class _$SavingsAccountNotifier extends $AsyncNotifier<void> {
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

@ProviderFor(depositList)
final depositListProvider = DepositListFamily._();

final class DepositListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DepositObject>>,
          List<DepositObject>,
          FutureOr<List<DepositObject>>
        >
    with
        $FutureModifier<List<DepositObject>>,
        $FutureProvider<List<DepositObject>> {
  DepositListProvider._({
    required DepositListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'depositListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$depositListHash();

  @override
  String toString() {
    return r'depositListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DepositObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DepositObject>> create(Ref ref) {
    final argument = this.argument as String;
    return depositList(ref, savingsAccountId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DepositListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$depositListHash() => r'f3b3429b8e00cdbaa77823b6b5416bec566a53eb';

final class DepositListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DepositObject>>, String> {
  DepositListFamily._()
    : super(
        retry: null,
        name: r'depositListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DepositListProvider call({required String savingsAccountId}) =>
      DepositListProvider._(argument: savingsAccountId, from: this);

  @override
  String toString() => r'depositListProvider';
}

@ProviderFor(DepositNotifier)
final depositProvider = DepositNotifierProvider._();

final class DepositNotifierProvider
    extends $AsyncNotifierProvider<DepositNotifier, void> {
  DepositNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'depositProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$depositNotifierHash();

  @$internal
  @override
  DepositNotifier create() => DepositNotifier();
}

String _$depositNotifierHash() => r'4b72e3fc873ecf4b3ae137c955212a80cf096a57';

abstract class _$DepositNotifier extends $AsyncNotifier<void> {
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

@ProviderFor(withdrawalList)
final withdrawalListProvider = WithdrawalListFamily._();

final class WithdrawalListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WithdrawalObject>>,
          List<WithdrawalObject>,
          FutureOr<List<WithdrawalObject>>
        >
    with
        $FutureModifier<List<WithdrawalObject>>,
        $FutureProvider<List<WithdrawalObject>> {
  WithdrawalListProvider._({
    required WithdrawalListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'withdrawalListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$withdrawalListHash();

  @override
  String toString() {
    return r'withdrawalListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WithdrawalObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WithdrawalObject>> create(Ref ref) {
    final argument = this.argument as String;
    return withdrawalList(ref, savingsAccountId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WithdrawalListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$withdrawalListHash() => r'4b60b4a671e1cc56b2fb850f403e7ccb65f8222c';

final class WithdrawalListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<WithdrawalObject>>, String> {
  WithdrawalListFamily._()
    : super(
        retry: null,
        name: r'withdrawalListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WithdrawalListProvider call({required String savingsAccountId}) =>
      WithdrawalListProvider._(argument: savingsAccountId, from: this);

  @override
  String toString() => r'withdrawalListProvider';
}

@ProviderFor(WithdrawalNotifier)
final withdrawalProvider = WithdrawalNotifierProvider._();

final class WithdrawalNotifierProvider
    extends $AsyncNotifierProvider<WithdrawalNotifier, void> {
  WithdrawalNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'withdrawalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$withdrawalNotifierHash();

  @$internal
  @override
  WithdrawalNotifier create() => WithdrawalNotifier();
}

String _$withdrawalNotifierHash() =>
    r'2a180120112778c1c7d8e6ea37c8d8046e120d7f';

abstract class _$WithdrawalNotifier extends $AsyncNotifier<void> {
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

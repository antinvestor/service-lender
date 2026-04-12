// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(investorAccountList)
final investorAccountListProvider = InvestorAccountListFamily._();

final class InvestorAccountListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InvestorAccountObject>>,
          List<InvestorAccountObject>,
          FutureOr<List<InvestorAccountObject>>
        >
    with
        $FutureModifier<List<InvestorAccountObject>>,
        $FutureProvider<List<InvestorAccountObject>> {
  InvestorAccountListProvider._({
    required InvestorAccountListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'investorAccountListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$investorAccountListHash();

  @override
  String toString() {
    return r'investorAccountListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<InvestorAccountObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InvestorAccountObject>> create(Ref ref) {
    final argument = this.argument as String;
    return investorAccountList(ref, investorId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InvestorAccountListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$investorAccountListHash() =>
    r'a9a422ffcb3b15248632d5ca31b17f5987e7549f';

final class InvestorAccountListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<InvestorAccountObject>>,
          String
        > {
  InvestorAccountListFamily._()
    : super(
        retry: null,
        name: r'investorAccountListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InvestorAccountListProvider call({String investorId = ''}) =>
      InvestorAccountListProvider._(argument: investorId, from: this);

  @override
  String toString() => r'investorAccountListProvider';
}

@ProviderFor(investorAccountDetail)
final investorAccountDetailProvider = InvestorAccountDetailFamily._();

final class InvestorAccountDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<InvestorAccountObject>,
          InvestorAccountObject,
          FutureOr<InvestorAccountObject>
        >
    with
        $FutureModifier<InvestorAccountObject>,
        $FutureProvider<InvestorAccountObject> {
  InvestorAccountDetailProvider._({
    required InvestorAccountDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'investorAccountDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$investorAccountDetailHash();

  @override
  String toString() {
    return r'investorAccountDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<InvestorAccountObject> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InvestorAccountObject> create(Ref ref) {
    final argument = this.argument as String;
    return investorAccountDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InvestorAccountDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$investorAccountDetailHash() =>
    r'eac995e0c3a8580be494fab76efef80f7e809524';

final class InvestorAccountDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<InvestorAccountObject>, String> {
  InvestorAccountDetailFamily._()
    : super(
        retry: null,
        name: r'investorAccountDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InvestorAccountDetailProvider call(String id) =>
      InvestorAccountDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'investorAccountDetailProvider';
}

@ProviderFor(InvestorAccountNotifier)
final investorAccountProvider = InvestorAccountNotifierProvider._();

final class InvestorAccountNotifierProvider
    extends $AsyncNotifierProvider<InvestorAccountNotifier, void> {
  InvestorAccountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'investorAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$investorAccountNotifierHash();

  @$internal
  @override
  InvestorAccountNotifier create() => InvestorAccountNotifier();
}

String _$investorAccountNotifierHash() =>
    r'60b7794bbf3119902c6824c649ec2809f63f1027';

abstract class _$InvestorAccountNotifier extends $AsyncNotifier<void> {
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

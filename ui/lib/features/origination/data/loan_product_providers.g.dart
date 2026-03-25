// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoanProductList)
final loanProductListProvider = LoanProductListFamily._();

final class LoanProductListProvider
    extends $AsyncNotifierProvider<LoanProductList, List<LoanProductObject>> {
  LoanProductListProvider._({
    required LoanProductListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loanProductListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanProductListHash();

  @override
  String toString() {
    return r'loanProductListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LoanProductList create() => LoanProductList();

  @override
  bool operator ==(Object other) {
    return other is LoanProductListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanProductListHash() => r'c4ed136934289c2f880c3b79b2ce2e4b63d67368';

final class LoanProductListFamily extends $Family
    with
        $ClassFamilyOverride<
          LoanProductList,
          AsyncValue<List<LoanProductObject>>,
          List<LoanProductObject>,
          FutureOr<List<LoanProductObject>>,
          String
        > {
  LoanProductListFamily._()
    : super(
        retry: null,
        name: r'loanProductListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanProductListProvider call(String query) =>
      LoanProductListProvider._(argument: query, from: this);

  @override
  String toString() => r'loanProductListProvider';
}

abstract class _$LoanProductList
    extends $AsyncNotifier<List<LoanProductObject>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<List<LoanProductObject>> build(String query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<LoanProductObject>>,
              List<LoanProductObject>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LoanProductObject>>,
                List<LoanProductObject>
              >,
              AsyncValue<List<LoanProductObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(LoanProductNotifier)
final loanProductProvider = LoanProductNotifierProvider._();

final class LoanProductNotifierProvider
    extends $AsyncNotifierProvider<LoanProductNotifier, void> {
  LoanProductNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanProductProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanProductNotifierHash();

  @$internal
  @override
  LoanProductNotifier create() => LoanProductNotifier();
}

String _$loanProductNotifierHash() =>
    r'87a817711b3570ba8f03db49f099a35a2076163e';

abstract class _$LoanProductNotifier extends $AsyncNotifier<void> {
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

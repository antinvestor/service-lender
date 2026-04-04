// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BankList)
final bankListProvider = BankListFamily._();

final class BankListProvider
    extends $AsyncNotifierProvider<BankList, List<BankObject>> {
  BankListProvider._({
    required BankListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bankListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bankListHash();

  @override
  String toString() {
    return r'bankListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BankList create() => BankList();

  @override
  bool operator ==(Object other) {
    return other is BankListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bankListHash() => r'21d1a8bd1e839c45f258284112f392b46e2faf90';

final class BankListFamily extends $Family
    with
        $ClassFamilyOverride<
          BankList,
          AsyncValue<List<BankObject>>,
          List<BankObject>,
          FutureOr<List<BankObject>>,
          String
        > {
  BankListFamily._()
    : super(
        retry: null,
        name: r'bankListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BankListProvider call(String query) =>
      BankListProvider._(argument: query, from: this);

  @override
  String toString() => r'bankListProvider';
}

abstract class _$BankList extends $AsyncNotifier<List<BankObject>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<List<BankObject>> build(String query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<BankObject>>, List<BankObject>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BankObject>>, List<BankObject>>,
              AsyncValue<List<BankObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(BankNotifier)
final bankProvider = BankNotifierProvider._();

final class BankNotifierProvider
    extends $AsyncNotifierProvider<BankNotifier, void> {
  BankNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bankProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bankNotifierHash();

  @$internal
  @override
  BankNotifier create() => BankNotifier();
}

String _$bankNotifierHash() => r'7ea5da517016c4854516190db435350d8b2ec853';

abstract class _$BankNotifier extends $AsyncNotifier<void> {
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

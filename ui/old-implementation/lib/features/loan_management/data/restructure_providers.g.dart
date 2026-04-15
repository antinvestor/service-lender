// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restructure_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RestructureList)
final restructureListProvider = RestructureListFamily._();

final class RestructureListProvider
    extends
        $AsyncNotifierProvider<RestructureList, List<LoanRestructureObject>> {
  RestructureListProvider._({
    required RestructureListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'restructureListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$restructureListHash();

  @override
  String toString() {
    return r'restructureListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RestructureList create() => RestructureList();

  @override
  bool operator ==(Object other) {
    return other is RestructureListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$restructureListHash() => r'c5499cd7366100fbebd76ff0e28329585f223414';

final class RestructureListFamily extends $Family
    with
        $ClassFamilyOverride<
          RestructureList,
          AsyncValue<List<LoanRestructureObject>>,
          List<LoanRestructureObject>,
          FutureOr<List<LoanRestructureObject>>,
          String
        > {
  RestructureListFamily._()
    : super(
        retry: null,
        name: r'restructureListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RestructureListProvider call(String loanAccountId) =>
      RestructureListProvider._(argument: loanAccountId, from: this);

  @override
  String toString() => r'restructureListProvider';
}

abstract class _$RestructureList
    extends $AsyncNotifier<List<LoanRestructureObject>> {
  late final _$args = ref.$arg as String;
  String get loanAccountId => _$args;

  FutureOr<List<LoanRestructureObject>> build(String loanAccountId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<LoanRestructureObject>>,
              List<LoanRestructureObject>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LoanRestructureObject>>,
                List<LoanRestructureObject>
              >,
              AsyncValue<List<LoanRestructureObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(RestructureNotifier)
final restructureProvider = RestructureNotifierProvider._();

final class RestructureNotifierProvider
    extends $AsyncNotifierProvider<RestructureNotifier, void> {
  RestructureNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restructureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restructureNotifierHash();

  @$internal
  @override
  RestructureNotifier create() => RestructureNotifier();
}

String _$restructureNotifierHash() =>
    r'617eda9edc163ffd895629b1ac6df40d123a042c';

abstract class _$RestructureNotifier extends $AsyncNotifier<void> {
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

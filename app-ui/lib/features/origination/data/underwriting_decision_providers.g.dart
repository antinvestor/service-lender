// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'underwriting_decision_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UnderwritingDecisionList)
final underwritingDecisionListProvider = UnderwritingDecisionListFamily._();

final class UnderwritingDecisionListProvider
    extends
        $AsyncNotifierProvider<
          UnderwritingDecisionList,
          List<UnderwritingDecisionObject>
        > {
  UnderwritingDecisionListProvider._({
    required UnderwritingDecisionListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'underwritingDecisionListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$underwritingDecisionListHash();

  @override
  String toString() {
    return r'underwritingDecisionListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UnderwritingDecisionList create() => UnderwritingDecisionList();

  @override
  bool operator ==(Object other) {
    return other is UnderwritingDecisionListProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$underwritingDecisionListHash() =>
    r'5fadfc172f7c8cd9e9cbd3737c50800c8b22d6af';

final class UnderwritingDecisionListFamily extends $Family
    with
        $ClassFamilyOverride<
          UnderwritingDecisionList,
          AsyncValue<List<UnderwritingDecisionObject>>,
          List<UnderwritingDecisionObject>,
          FutureOr<List<UnderwritingDecisionObject>>,
          String
        > {
  UnderwritingDecisionListFamily._()
    : super(
        retry: null,
        name: r'underwritingDecisionListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnderwritingDecisionListProvider call(String applicationId) =>
      UnderwritingDecisionListProvider._(argument: applicationId, from: this);

  @override
  String toString() => r'underwritingDecisionListProvider';
}

abstract class _$UnderwritingDecisionList
    extends $AsyncNotifier<List<UnderwritingDecisionObject>> {
  late final _$args = ref.$arg as String;
  String get applicationId => _$args;

  FutureOr<List<UnderwritingDecisionObject>> build(String applicationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<UnderwritingDecisionObject>>,
              List<UnderwritingDecisionObject>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UnderwritingDecisionObject>>,
                List<UnderwritingDecisionObject>
              >,
              AsyncValue<List<UnderwritingDecisionObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(UnderwritingDecisionNotifier)
final underwritingDecisionProvider = UnderwritingDecisionNotifierProvider._();

final class UnderwritingDecisionNotifierProvider
    extends $AsyncNotifierProvider<UnderwritingDecisionNotifier, void> {
  UnderwritingDecisionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'underwritingDecisionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$underwritingDecisionNotifierHash();

  @$internal
  @override
  UnderwritingDecisionNotifier create() => UnderwritingDecisionNotifier();
}

String _$underwritingDecisionNotifierHash() =>
    r'a5f8724634609dc982a0088e0e87e7f6fb38dd1d';

abstract class _$UnderwritingDecisionNotifier extends $AsyncNotifier<void> {
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

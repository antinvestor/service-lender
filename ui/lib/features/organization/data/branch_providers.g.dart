// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(branchList)
final branchListProvider = BranchListFamily._();

final class BranchListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BranchObject>>,
          List<BranchObject>,
          FutureOr<List<BranchObject>>
        >
    with
        $FutureModifier<List<BranchObject>>,
        $FutureProvider<List<BranchObject>> {
  BranchListProvider._({
    required BranchListFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'branchListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$branchListHash();

  @override
  String toString() {
    return r'branchListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<BranchObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BranchObject>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return branchList(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BranchListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$branchListHash() => r'aa9beba3cc745afe4827d101da861ad92a5a07b5';

final class BranchListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<BranchObject>>,
          (String, String)
        > {
  BranchListFamily._()
    : super(
        retry: null,
        name: r'branchListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BranchListProvider call(String query, String organizationId) =>
      BranchListProvider._(argument: (query, organizationId), from: this);

  @override
  String toString() => r'branchListProvider';
}

@ProviderFor(BranchNotifier)
final branchProvider = BranchNotifierProvider._();

final class BranchNotifierProvider
    extends $AsyncNotifierProvider<BranchNotifier, void> {
  BranchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'branchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$branchNotifierHash();

  @$internal
  @override
  BranchNotifier create() => BranchNotifier();
}

String _$branchNotifierHash() => r'030be18352f90db083511c6c8659e72dd3bfeccf';

abstract class _$BranchNotifier extends $AsyncNotifier<void> {
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

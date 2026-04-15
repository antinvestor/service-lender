// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disbursement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(disbursementList)
final disbursementListProvider = DisbursementListFamily._();

final class DisbursementListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DisbursementObject>>,
          List<DisbursementObject>,
          FutureOr<List<DisbursementObject>>
        >
    with
        $FutureModifier<List<DisbursementObject>>,
        $FutureProvider<List<DisbursementObject>> {
  DisbursementListProvider._({
    required DisbursementListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'disbursementListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$disbursementListHash();

  @override
  String toString() {
    return r'disbursementListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DisbursementObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DisbursementObject>> create(Ref ref) {
    final argument = this.argument as String;
    return disbursementList(ref, loanAccountId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DisbursementListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$disbursementListHash() => r'ff33568a43613e03e91558f58ddc38e27a97b0c1';

final class DisbursementListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DisbursementObject>>, String> {
  DisbursementListFamily._()
    : super(
        retry: null,
        name: r'disbursementListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DisbursementListProvider call({required String loanAccountId}) =>
      DisbursementListProvider._(argument: loanAccountId, from: this);

  @override
  String toString() => r'disbursementListProvider';
}

@ProviderFor(DisbursementNotifier)
final disbursementProvider = DisbursementNotifierProvider._();

final class DisbursementNotifierProvider
    extends $AsyncNotifierProvider<DisbursementNotifier, void> {
  DisbursementNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disbursementProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disbursementNotifierHash();

  @$internal
  @override
  DisbursementNotifier create() => DisbursementNotifier();
}

String _$disbursementNotifierHash() =>
    r'8bb5d6177a9c2d32e08abf350d701da518403737';

abstract class _$DisbursementNotifier extends $AsyncNotifier<void> {
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

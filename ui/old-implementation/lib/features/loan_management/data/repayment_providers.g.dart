// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repayment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(repaymentList)
final repaymentListProvider = RepaymentListFamily._();

final class RepaymentListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RepaymentObject>>,
          List<RepaymentObject>,
          FutureOr<List<RepaymentObject>>
        >
    with
        $FutureModifier<List<RepaymentObject>>,
        $FutureProvider<List<RepaymentObject>> {
  RepaymentListProvider._({
    required RepaymentListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'repaymentListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$repaymentListHash();

  @override
  String toString() {
    return r'repaymentListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RepaymentObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RepaymentObject>> create(Ref ref) {
    final argument = this.argument as String;
    return repaymentList(ref, loanAccountId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RepaymentListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$repaymentListHash() => r'f839a9bec9ea6311ac1b2f7d47d13c05f1521df4';

final class RepaymentListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RepaymentObject>>, String> {
  RepaymentListFamily._()
    : super(
        retry: null,
        name: r'repaymentListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RepaymentListProvider call({required String loanAccountId}) =>
      RepaymentListProvider._(argument: loanAccountId, from: this);

  @override
  String toString() => r'repaymentListProvider';
}

@ProviderFor(RepaymentNotifier)
final repaymentProvider = RepaymentNotifierProvider._();

final class RepaymentNotifierProvider
    extends $AsyncNotifierProvider<RepaymentNotifier, void> {
  RepaymentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repaymentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repaymentNotifierHash();

  @$internal
  @override
  RepaymentNotifier create() => RepaymentNotifier();
}

String _$repaymentNotifierHash() => r'5891257b7740f735f5a9aa169483f3c3e7c64047';

abstract class _$RepaymentNotifier extends $AsyncNotifier<void> {
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(borrowerList)
final borrowerListProvider = BorrowerListFamily._();

final class BorrowerListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BorrowerObject>>,
          List<BorrowerObject>,
          FutureOr<List<BorrowerObject>>
        >
    with
        $FutureModifier<List<BorrowerObject>>,
        $FutureProvider<List<BorrowerObject>> {
  BorrowerListProvider._({
    required BorrowerListFamily super.from,
    required ({String query, String agentId}) super.argument,
  }) : super(
         retry: null,
         name: r'borrowerListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$borrowerListHash();

  @override
  String toString() {
    return r'borrowerListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<BorrowerObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BorrowerObject>> create(Ref ref) {
    final argument = this.argument as ({String query, String agentId});
    return borrowerList(ref, query: argument.query, agentId: argument.agentId);
  }

  @override
  bool operator ==(Object other) {
    return other is BorrowerListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$borrowerListHash() => r'2cad8fb816220232f6f38d7025795d7da420fa44';

final class BorrowerListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<BorrowerObject>>,
          ({String query, String agentId})
        > {
  BorrowerListFamily._()
    : super(
        retry: null,
        name: r'borrowerListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BorrowerListProvider call({required String query, required String agentId}) =>
      BorrowerListProvider._(
        argument: (query: query, agentId: agentId),
        from: this,
      );

  @override
  String toString() => r'borrowerListProvider';
}

@ProviderFor(BorrowerNotifier)
final borrowerProvider = BorrowerNotifierProvider._();

final class BorrowerNotifierProvider
    extends $AsyncNotifierProvider<BorrowerNotifier, void> {
  BorrowerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'borrowerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$borrowerNotifierHash();

  @$internal
  @override
  BorrowerNotifier create() => BorrowerNotifier();
}

String _$borrowerNotifierHash() => r'109a90365038a755b4e4073e4c88549f2ebe5343';

abstract class _$BorrowerNotifier extends $AsyncNotifier<void> {
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penalty_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(penaltyList)
final penaltyListProvider = PenaltyListFamily._();

final class PenaltyListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PenaltyObject>>,
          List<PenaltyObject>,
          FutureOr<List<PenaltyObject>>
        >
    with
        $FutureModifier<List<PenaltyObject>>,
        $FutureProvider<List<PenaltyObject>> {
  PenaltyListProvider._({
    required PenaltyListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'penaltyListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$penaltyListHash();

  @override
  String toString() {
    return r'penaltyListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PenaltyObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PenaltyObject>> create(Ref ref) {
    final argument = this.argument as String;
    return penaltyList(ref, loanAccountId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PenaltyListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$penaltyListHash() => r'673b702dd9e612f46520da37e5aa0b76fcbf66bd';

final class PenaltyListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<PenaltyObject>>, String> {
  PenaltyListFamily._()
    : super(
        retry: null,
        name: r'penaltyListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PenaltyListProvider call({required String loanAccountId}) =>
      PenaltyListProvider._(argument: loanAccountId, from: this);

  @override
  String toString() => r'penaltyListProvider';
}

@ProviderFor(PenaltyNotifier)
final penaltyProvider = PenaltyNotifierProvider._();

final class PenaltyNotifierProvider
    extends $AsyncNotifierProvider<PenaltyNotifier, void> {
  PenaltyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'penaltyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$penaltyNotifierHash();

  @$internal
  @override
  PenaltyNotifier create() => PenaltyNotifier();
}

String _$penaltyNotifierHash() => r'37ee151de6d4eed416d91d4cb76d9c8ca682fe50';

abstract class _$PenaltyNotifier extends $AsyncNotifier<void> {
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

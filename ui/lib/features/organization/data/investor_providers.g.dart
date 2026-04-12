// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investor_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(investorList)
final investorListProvider = InvestorListFamily._();

final class InvestorListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InvestorObject>>,
          List<InvestorObject>,
          FutureOr<List<InvestorObject>>
        >
    with
        $FutureModifier<List<InvestorObject>>,
        $FutureProvider<List<InvestorObject>> {
  InvestorListProvider._({
    required InvestorListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'investorListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$investorListHash();

  @override
  String toString() {
    return r'investorListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<InvestorObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InvestorObject>> create(Ref ref) {
    final argument = this.argument as String;
    return investorList(ref, query: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InvestorListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$investorListHash() => r'3094b9e5e52a9c45788b79ea2f4f5e50605420bd';

final class InvestorListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<InvestorObject>>, String> {
  InvestorListFamily._()
    : super(
        retry: null,
        name: r'investorListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InvestorListProvider call({required String query}) =>
      InvestorListProvider._(argument: query, from: this);

  @override
  String toString() => r'investorListProvider';
}

@ProviderFor(InvestorNotifier)
final investorProvider = InvestorNotifierProvider._();

final class InvestorNotifierProvider
    extends $AsyncNotifierProvider<InvestorNotifier, void> {
  InvestorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'investorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$investorNotifierHash();

  @$internal
  @override
  InvestorNotifier create() => InvestorNotifier();
}

String _$investorNotifierHash() => r'106765bcbfacaace2afd4df81134371574630b41';

abstract class _$InvestorNotifier extends $AsyncNotifier<void> {
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

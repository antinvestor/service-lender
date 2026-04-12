// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(agentList)
final agentListProvider = AgentListFamily._();

final class AgentListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AgentObject>>,
          List<AgentObject>,
          FutureOr<List<AgentObject>>
        >
    with
        $FutureModifier<List<AgentObject>>,
        $FutureProvider<List<AgentObject>> {
  AgentListProvider._({
    required AgentListFamily super.from,
    required ({String query, String branchId}) super.argument,
  }) : super(
         retry: null,
         name: r'agentListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$agentListHash();

  @override
  String toString() {
    return r'agentListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AgentObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AgentObject>> create(Ref ref) {
    final argument = this.argument as ({String query, String branchId});
    return agentList(ref, query: argument.query, branchId: argument.branchId);
  }

  @override
  bool operator ==(Object other) {
    return other is AgentListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$agentListHash() => r'89eff667c4f0afefd25c4fc72bba3c0a6cf7bb3e';

final class AgentListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AgentObject>>,
          ({String query, String branchId})
        > {
  AgentListFamily._()
    : super(
        retry: null,
        name: r'agentListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AgentListProvider call({required String query, required String branchId}) =>
      AgentListProvider._(
        argument: (query: query, branchId: branchId),
        from: this,
      );

  @override
  String toString() => r'agentListProvider';
}

@ProviderFor(AgentNotifier)
final agentProvider = AgentNotifierProvider._();

final class AgentNotifierProvider
    extends $AsyncNotifierProvider<AgentNotifier, void> {
  AgentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agentNotifierHash();

  @$internal
  @override
  AgentNotifier create() => AgentNotifier();
}

String _$agentNotifierHash() => r'126147187bcb540e16f6105b82510235d26fdde3';

abstract class _$AgentNotifier extends $AsyncNotifier<void> {
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

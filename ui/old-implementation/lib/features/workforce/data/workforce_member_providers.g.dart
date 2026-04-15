// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workforce_member_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workforceMemberList)
final workforceMemberListProvider = WorkforceMemberListFamily._();

final class WorkforceMemberListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkforceMemberObject>>,
          List<WorkforceMemberObject>,
          FutureOr<List<WorkforceMemberObject>>
        >
    with
        $FutureModifier<List<WorkforceMemberObject>>,
        $FutureProvider<List<WorkforceMemberObject>> {
  WorkforceMemberListProvider._({
    required WorkforceMemberListFamily super.from,
    required ({String query, String organizationId, String homeOrgUnitId})
    super.argument,
  }) : super(
         retry: null,
         name: r'workforceMemberListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workforceMemberListHash();

  @override
  String toString() {
    return r'workforceMemberListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<WorkforceMemberObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WorkforceMemberObject>> create(Ref ref) {
    final argument =
        this.argument
            as ({String query, String organizationId, String homeOrgUnitId});
    return workforceMemberList(
      ref,
      query: argument.query,
      organizationId: argument.organizationId,
      homeOrgUnitId: argument.homeOrgUnitId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WorkforceMemberListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workforceMemberListHash() =>
    r'ff677ae7326b8fd6a6392534f844e21b7178b4a9';

final class WorkforceMemberListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<WorkforceMemberObject>>,
          ({String query, String organizationId, String homeOrgUnitId})
        > {
  WorkforceMemberListFamily._()
    : super(
        retry: null,
        name: r'workforceMemberListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkforceMemberListProvider call({
    required String query,
    String organizationId = '',
    String homeOrgUnitId = '',
  }) => WorkforceMemberListProvider._(
    argument: (
      query: query,
      organizationId: organizationId,
      homeOrgUnitId: homeOrgUnitId,
    ),
    from: this,
  );

  @override
  String toString() => r'workforceMemberListProvider';
}

@ProviderFor(WorkforceMemberNotifier)
final workforceMemberProvider = WorkforceMemberNotifierProvider._();

final class WorkforceMemberNotifierProvider
    extends $AsyncNotifierProvider<WorkforceMemberNotifier, void> {
  WorkforceMemberNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workforceMemberProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workforceMemberNotifierHash();

  @$internal
  @override
  WorkforceMemberNotifier create() => WorkforceMemberNotifier();
}

String _$workforceMemberNotifierHash() =>
    r'b64912ba61aad265c8db09bb8a1d482f3dffcc4c';

abstract class _$WorkforceMemberNotifier extends $AsyncNotifier<void> {
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

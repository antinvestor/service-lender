// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_role_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accessRoleAssignmentList)
final accessRoleAssignmentListProvider = AccessRoleAssignmentListFamily._();

final class AccessRoleAssignmentListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AccessRoleAssignmentObject>>,
          List<AccessRoleAssignmentObject>,
          FutureOr<List<AccessRoleAssignmentObject>>
        >
    with
        $FutureModifier<List<AccessRoleAssignmentObject>>,
        $FutureProvider<List<AccessRoleAssignmentObject>> {
  AccessRoleAssignmentListProvider._({
    required AccessRoleAssignmentListFamily super.from,
    required ({String query, String roleKey, String scopeId}) super.argument,
  }) : super(
         retry: null,
         name: r'accessRoleAssignmentListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$accessRoleAssignmentListHash();

  @override
  String toString() {
    return r'accessRoleAssignmentListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AccessRoleAssignmentObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AccessRoleAssignmentObject>> create(Ref ref) {
    final argument =
        this.argument as ({String query, String roleKey, String scopeId});
    return accessRoleAssignmentList(
      ref,
      query: argument.query,
      roleKey: argument.roleKey,
      scopeId: argument.scopeId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccessRoleAssignmentListProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accessRoleAssignmentListHash() =>
    r'c633debaee0b8384221a4be387202255f1061d84';

final class AccessRoleAssignmentListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AccessRoleAssignmentObject>>,
          ({String query, String roleKey, String scopeId})
        > {
  AccessRoleAssignmentListFamily._()
    : super(
        retry: null,
        name: r'accessRoleAssignmentListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AccessRoleAssignmentListProvider call({
    required String query,
    String roleKey = '',
    String scopeId = '',
  }) => AccessRoleAssignmentListProvider._(
    argument: (query: query, roleKey: roleKey, scopeId: scopeId),
    from: this,
  );

  @override
  String toString() => r'accessRoleAssignmentListProvider';
}

@ProviderFor(AccessRoleAssignmentNotifier)
final accessRoleAssignmentProvider = AccessRoleAssignmentNotifierProvider._();

final class AccessRoleAssignmentNotifierProvider
    extends $AsyncNotifierProvider<AccessRoleAssignmentNotifier, void> {
  AccessRoleAssignmentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessRoleAssignmentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessRoleAssignmentNotifierHash();

  @$internal
  @override
  AccessRoleAssignmentNotifier create() => AccessRoleAssignmentNotifier();
}

String _$accessRoleAssignmentNotifierHash() =>
    r'753811780ba3d2d66d8e23301a4151124f931c30';

abstract class _$AccessRoleAssignmentNotifier extends $AsyncNotifier<void> {
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

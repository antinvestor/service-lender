// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'org_unit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orgUnitList)
final orgUnitListProvider = OrgUnitListFamily._();

final class OrgUnitListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrgUnitObject>>,
          List<OrgUnitObject>,
          FutureOr<List<OrgUnitObject>>
        >
    with
        $FutureModifier<List<OrgUnitObject>>,
        $FutureProvider<List<OrgUnitObject>> {
  OrgUnitListProvider._({
    required OrgUnitListFamily super.from,
    required ({
      String query,
      String organizationId,
      String parentId,
      bool rootOnly,
      OrgUnitType type,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'orgUnitListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orgUnitListHash();

  @override
  String toString() {
    return r'orgUnitListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<OrgUnitObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OrgUnitObject>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String query,
              String organizationId,
              String parentId,
              bool rootOnly,
              OrgUnitType type,
            });
    return orgUnitList(
      ref,
      query: argument.query,
      organizationId: argument.organizationId,
      parentId: argument.parentId,
      rootOnly: argument.rootOnly,
      type: argument.type,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OrgUnitListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orgUnitListHash() => r'a9d72ca46d97c3930ea52bf99b0857cc95c0f9e7';

final class OrgUnitListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<OrgUnitObject>>,
          ({
            String query,
            String organizationId,
            String parentId,
            bool rootOnly,
            OrgUnitType type,
          })
        > {
  OrgUnitListFamily._()
    : super(
        retry: null,
        name: r'orgUnitListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrgUnitListProvider call({
    String query = '',
    String organizationId = '',
    String parentId = '',
    bool rootOnly = false,
    OrgUnitType type = OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED,
  }) => OrgUnitListProvider._(
    argument: (
      query: query,
      organizationId: organizationId,
      parentId: parentId,
      rootOnly: rootOnly,
      type: type,
    ),
    from: this,
  );

  @override
  String toString() => r'orgUnitListProvider';
}

@ProviderFor(OrgUnitNotifier)
final orgUnitProvider = OrgUnitNotifierProvider._();

final class OrgUnitNotifierProvider
    extends $AsyncNotifierProvider<OrgUnitNotifier, void> {
  OrgUnitNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orgUnitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orgUnitNotifierHash();

  @$internal
  @override
  OrgUnitNotifier create() => OrgUnitNotifier();
}

String _$orgUnitNotifierHash() => r'85102cbebd73b4699aabbce29af4e2b9653b7f94';

abstract class _$OrgUnitNotifier extends $AsyncNotifier<void> {
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

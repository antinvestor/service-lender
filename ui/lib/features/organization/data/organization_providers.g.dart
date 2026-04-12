// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrganizationList)
final organizationListProvider = OrganizationListFamily._();

final class OrganizationListProvider
    extends $AsyncNotifierProvider<OrganizationList, List<OrganizationObject>> {
  OrganizationListProvider._({
    required OrganizationListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'organizationListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$organizationListHash();

  @override
  String toString() {
    return r'organizationListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrganizationList create() => OrganizationList();

  @override
  bool operator ==(Object other) {
    return other is OrganizationListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$organizationListHash() => r'f0bde1e9f64d881558128ba9fe0f232b4b9b1d45';

final class OrganizationListFamily extends $Family
    with
        $ClassFamilyOverride<
          OrganizationList,
          AsyncValue<List<OrganizationObject>>,
          List<OrganizationObject>,
          FutureOr<List<OrganizationObject>>,
          String
        > {
  OrganizationListFamily._()
    : super(
        retry: null,
        name: r'organizationListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrganizationListProvider call(String query) =>
      OrganizationListProvider._(argument: query, from: this);

  @override
  String toString() => r'organizationListProvider';
}

abstract class _$OrganizationList
    extends $AsyncNotifier<List<OrganizationObject>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<List<OrganizationObject>> build(String query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<OrganizationObject>>,
              List<OrganizationObject>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<OrganizationObject>>,
                List<OrganizationObject>
              >,
              AsyncValue<List<OrganizationObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(OrganizationNotifier)
final organizationProvider = OrganizationNotifierProvider._();

final class OrganizationNotifierProvider
    extends $AsyncNotifierProvider<OrganizationNotifier, void> {
  OrganizationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationNotifierHash();

  @$internal
  @override
  OrganizationNotifier create() => OrganizationNotifier();
}

String _$organizationNotifierHash() =>
    r'5bdc64c081473a58f05aa002cd28817cd3c85d9a';

abstract class _$OrganizationNotifier extends $AsyncNotifier<void> {
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

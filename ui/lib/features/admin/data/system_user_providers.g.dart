// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(systemUserList)
final systemUserListProvider = SystemUserListFamily._();

final class SystemUserListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SystemUserObject>>,
          List<SystemUserObject>,
          FutureOr<List<SystemUserObject>>
        >
    with
        $FutureModifier<List<SystemUserObject>>,
        $FutureProvider<List<SystemUserObject>> {
  SystemUserListProvider._({
    required SystemUserListFamily super.from,
    required ({String query, String branchId, SystemUserRole role})
    super.argument,
  }) : super(
         retry: null,
         name: r'systemUserListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$systemUserListHash();

  @override
  String toString() {
    return r'systemUserListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SystemUserObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SystemUserObject>> create(Ref ref) {
    final argument =
        this.argument as ({String query, String branchId, SystemUserRole role});
    return systemUserList(
      ref,
      query: argument.query,
      branchId: argument.branchId,
      role: argument.role,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SystemUserListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$systemUserListHash() => r'aeac3016ff3a8671140abc8cda9064abfe6374c6';

final class SystemUserListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SystemUserObject>>,
          ({String query, String branchId, SystemUserRole role})
        > {
  SystemUserListFamily._()
    : super(
        retry: null,
        name: r'systemUserListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SystemUserListProvider call({
    required String query,
    required String branchId,
    SystemUserRole role = SystemUserRole.SYSTEM_USER_ROLE_UNSPECIFIED,
  }) => SystemUserListProvider._(
    argument: (query: query, branchId: branchId, role: role),
    from: this,
  );

  @override
  String toString() => r'systemUserListProvider';
}

@ProviderFor(SystemUserNotifier)
final systemUserProvider = SystemUserNotifierProvider._();

final class SystemUserNotifierProvider
    extends $AsyncNotifierProvider<SystemUserNotifier, void> {
  SystemUserNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemUserNotifierHash();

  @$internal
  @override
  SystemUserNotifier create() => SystemUserNotifier();
}

String _$systemUserNotifierHash() =>
    r'449f7459c10a65d34015d3a425ebe96a3eae80be';

abstract class _$SystemUserNotifier extends $AsyncNotifier<void> {
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

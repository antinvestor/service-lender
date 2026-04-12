// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ApplicationList)
final applicationListProvider = ApplicationListFamily._();

final class ApplicationListProvider
    extends $AsyncNotifierProvider<ApplicationList, List<ApplicationObject>> {
  ApplicationListProvider._({
    required ApplicationListFamily super.from,
    required (String, {String statusFilter, String agentId, String clientId})
    super.argument,
  }) : super(
         retry: null,
         name: r'applicationListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$applicationListHash();

  @override
  String toString() {
    return r'applicationListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ApplicationList create() => ApplicationList();

  @override
  bool operator ==(Object other) {
    return other is ApplicationListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$applicationListHash() => r'587b460f354e655dfe365ff844144ea28d8b2651';

final class ApplicationListFamily extends $Family
    with
        $ClassFamilyOverride<
          ApplicationList,
          AsyncValue<List<ApplicationObject>>,
          List<ApplicationObject>,
          FutureOr<List<ApplicationObject>>,
          (String, {String statusFilter, String agentId, String clientId})
        > {
  ApplicationListFamily._()
    : super(
        retry: null,
        name: r'applicationListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ApplicationListProvider call(
    String query, {
    String statusFilter = '',
    String agentId = '',
    String clientId = '',
  }) => ApplicationListProvider._(
    argument: (
      query,
      statusFilter: statusFilter,
      agentId: agentId,
      clientId: clientId,
    ),
    from: this,
  );

  @override
  String toString() => r'applicationListProvider';
}

abstract class _$ApplicationList
    extends $AsyncNotifier<List<ApplicationObject>> {
  late final _$args =
      ref.$arg
          as (String, {String statusFilter, String agentId, String clientId});
  String get query => _$args.$1;
  String get statusFilter => _$args.statusFilter;
  String get agentId => _$args.agentId;
  String get clientId => _$args.clientId;

  FutureOr<List<ApplicationObject>> build(
    String query, {
    String statusFilter = '',
    String agentId = '',
    String clientId = '',
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ApplicationObject>>,
              List<ApplicationObject>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ApplicationObject>>,
                List<ApplicationObject>
              >,
              AsyncValue<List<ApplicationObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        _$args.$1,
        statusFilter: _$args.statusFilter,
        agentId: _$args.agentId,
        clientId: _$args.clientId,
      ),
    );
  }
}

@ProviderFor(ApplicationDetail)
final applicationDetailProvider = ApplicationDetailFamily._();

final class ApplicationDetailProvider
    extends $AsyncNotifierProvider<ApplicationDetail, ApplicationObject> {
  ApplicationDetailProvider._({
    required ApplicationDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'applicationDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$applicationDetailHash();

  @override
  String toString() {
    return r'applicationDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ApplicationDetail create() => ApplicationDetail();

  @override
  bool operator ==(Object other) {
    return other is ApplicationDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$applicationDetailHash() => r'd0eacb6b70b5553bdbaf3a1af649f0686aa184c4';

final class ApplicationDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          ApplicationDetail,
          AsyncValue<ApplicationObject>,
          ApplicationObject,
          FutureOr<ApplicationObject>,
          String
        > {
  ApplicationDetailFamily._()
    : super(
        retry: null,
        name: r'applicationDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ApplicationDetailProvider call(String id) =>
      ApplicationDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'applicationDetailProvider';
}

abstract class _$ApplicationDetail extends $AsyncNotifier<ApplicationObject> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<ApplicationObject> build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ApplicationObject>, ApplicationObject>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ApplicationObject>, ApplicationObject>,
              AsyncValue<ApplicationObject>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(ApplicationNotifier)
final applicationProvider = ApplicationNotifierProvider._();

final class ApplicationNotifierProvider
    extends $AsyncNotifierProvider<ApplicationNotifier, void> {
  ApplicationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationNotifierHash();

  @$internal
  @override
  ApplicationNotifier create() => ApplicationNotifier();
}

String _$applicationNotifierHash() =>
    r'5e1e7bd0e27068c8a75624b47fc500c61ad0072f';

abstract class _$ApplicationNotifier extends $AsyncNotifier<void> {
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches clients using an offline-first strategy:
/// 1. Return local Drift data immediately.
/// 2. If online, sync from backend in the background and refresh.

@ProviderFor(clientList)
final clientListProvider = ClientListFamily._();

/// Fetches clients using an offline-first strategy:
/// 1. Return local Drift data immediately.
/// 2. If online, sync from backend in the background and refresh.

final class ClientListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ClientObject>>,
          List<ClientObject>,
          FutureOr<List<ClientObject>>
        >
    with
        $FutureModifier<List<ClientObject>>,
        $FutureProvider<List<ClientObject>> {
  /// Fetches clients using an offline-first strategy:
  /// 1. Return local Drift data immediately.
  /// 2. If online, sync from backend in the background and refresh.
  ClientListProvider._({
    required ClientListFamily super.from,
    required ({String query, String agentId}) super.argument,
  }) : super(
         retry: null,
         name: r'clientListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientListHash();

  @override
  String toString() {
    return r'clientListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClientObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClientObject>> create(Ref ref) {
    final argument = this.argument as ({String query, String agentId});
    return clientList(ref, query: argument.query, agentId: argument.agentId);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientListHash() => r'e9e8c235ba89655b613022c8a388b5075803d480';

/// Fetches clients using an offline-first strategy:
/// 1. Return local Drift data immediately.
/// 2. If online, sync from backend in the background and refresh.

final class ClientListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ClientObject>>,
          ({String query, String agentId})
        > {
  ClientListFamily._()
    : super(
        retry: null,
        name: r'clientListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches clients using an offline-first strategy:
  /// 1. Return local Drift data immediately.
  /// 2. If online, sync from backend in the background and refresh.

  ClientListProvider call({required String query, required String agentId}) =>
      ClientListProvider._(
        argument: (query: query, agentId: agentId),
        from: this,
      );

  @override
  String toString() => r'clientListProvider';
}

/// Provides the count of clients pending sync.

@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = PendingSyncCountProvider._();

/// Provides the count of clients pending sync.

final class PendingSyncCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Provides the count of clients pending sync.
  PendingSyncCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingSyncCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingSyncCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return pendingSyncCount(ref);
  }
}

String _$pendingSyncCountHash() => r'ce36a2caecc7787dc866184865d0cefb4110e5dc';

@ProviderFor(ClientNotifier)
final clientProvider = ClientNotifierProvider._();

final class ClientNotifierProvider
    extends $AsyncNotifierProvider<ClientNotifier, void> {
  ClientNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientNotifierHash();

  @$internal
  @override
  ClientNotifier create() => ClientNotifier();
}

String _$clientNotifierHash() => r'e5ad44ab238ea5e341dd244fb9e4660030e424ab';

abstract class _$ClientNotifier extends $AsyncNotifier<void> {
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

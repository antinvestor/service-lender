// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientDataList)
final clientDataListProvider = ClientDataListFamily._();

final class ClientDataListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ClientDataEntryObject>>,
          List<ClientDataEntryObject>,
          FutureOr<List<ClientDataEntryObject>>
        >
    with
        $FutureModifier<List<ClientDataEntryObject>>,
        $FutureProvider<List<ClientDataEntryObject>> {
  ClientDataListProvider._({
    required ClientDataListFamily super.from,
    required ({String clientId}) super.argument,
  }) : super(
         retry: null,
         name: r'clientDataListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientDataListHash();

  @override
  String toString() {
    return r'clientDataListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClientDataEntryObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClientDataEntryObject>> create(Ref ref) {
    final argument = this.argument as ({String clientId});
    return clientDataList(ref, clientId: argument.clientId);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientDataListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientDataListHash() => r'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0';

final class ClientDataListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ClientDataEntryObject>>,
          ({String clientId})
        > {
  ClientDataListFamily._()
    : super(
        retry: null,
        name: r'clientDataListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientDataListProvider call({required String clientId}) =>
      ClientDataListProvider._(
        argument: (clientId: clientId),
        from: this,
      );

  @override
  String toString() => r'clientDataListProvider';
}

@ProviderFor(ClientDataNotifier)
final clientDataNotifierProvider = ClientDataNotifierProvider._();

final class ClientDataNotifierProvider
    extends $AsyncNotifierProvider<ClientDataNotifier, void> {
  ClientDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientDataNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientDataNotifierHash();

  @$internal
  @override
  ClientDataNotifier create() => ClientDataNotifier();
}

String _$clientDataNotifierHash() =>
    r'b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1';

abstract class _$ClientDataNotifier extends $AsyncNotifier<void> {
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

@ProviderFor(clientDataHistory)
final clientDataHistoryProvider = ClientDataHistoryFamily._();

final class ClientDataHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ClientDataEntryHistoryObject>>,
          List<ClientDataEntryHistoryObject>,
          FutureOr<List<ClientDataEntryHistoryObject>>
        >
    with
        $FutureModifier<List<ClientDataEntryHistoryObject>>,
        $FutureProvider<List<ClientDataEntryHistoryObject>> {
  ClientDataHistoryProvider._({
    required ClientDataHistoryFamily super.from,
    required ({String entryId}) super.argument,
  }) : super(
         retry: null,
         name: r'clientDataHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientDataHistoryHash();

  @override
  String toString() {
    return r'clientDataHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClientDataEntryHistoryObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClientDataEntryHistoryObject>> create(Ref ref) {
    final argument = this.argument as ({String entryId});
    return clientDataHistory(ref, entryId: argument.entryId);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientDataHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientDataHistoryHash() =>
    r'c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2';

final class ClientDataHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ClientDataEntryHistoryObject>>,
          ({String entryId})
        > {
  ClientDataHistoryFamily._()
    : super(
        retry: null,
        name: r'clientDataHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientDataHistoryProvider call({required String entryId}) =>
      ClientDataHistoryProvider._(
        argument: (entryId: entryId),
        from: this,
      );

  @override
  String toString() => r'clientDataHistoryProvider';
}

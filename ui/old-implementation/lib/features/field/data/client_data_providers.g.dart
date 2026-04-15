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
    required String super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClientDataEntryObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClientDataEntryObject>> create(Ref ref) {
    final argument = this.argument as String;
    return clientDataList(ref, clientId: argument);
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

String _$clientDataListHash() => r'2159767887da22ad7156246bec21d1cdaa5fa35c';

final class ClientDataListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ClientDataEntryObject>>,
          String
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
      ClientDataListProvider._(argument: clientId, from: this);

  @override
  String toString() => r'clientDataListProvider';
}

@ProviderFor(ClientDataNotifier)
final clientDataProvider = ClientDataNotifierProvider._();

final class ClientDataNotifierProvider
    extends $AsyncNotifierProvider<ClientDataNotifier, void> {
  ClientDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientDataProvider',
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
    r'041580ddaba53cf214ee1a9376e107817dba65fe';

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
    required String super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClientDataEntryHistoryObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClientDataEntryHistoryObject>> create(Ref ref) {
    final argument = this.argument as String;
    return clientDataHistory(ref, entryId: argument);
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

String _$clientDataHistoryHash() => r'61056a6aaf469a1dd926f7ba720fe886f8225df2';

final class ClientDataHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ClientDataEntryHistoryObject>>,
          String
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
      ClientDataHistoryProvider._(argument: entryId, from: this);

  @override
  String toString() => r'clientDataHistoryProvider';
}

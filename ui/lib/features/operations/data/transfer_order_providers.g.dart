// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transferOrderList)
final transferOrderListProvider = TransferOrderListFamily._();

final class TransferOrderListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransferOrderObject>>,
          List<TransferOrderObject>,
          FutureOr<List<TransferOrderObject>>
        >
    with
        $FutureModifier<List<TransferOrderObject>>,
        $FutureProvider<List<TransferOrderObject>> {
  TransferOrderListProvider._({
    required TransferOrderListFamily super.from,
    required ({String query, int? orderType}) super.argument,
  }) : super(
         retry: null,
         name: r'transferOrderListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transferOrderListHash();

  @override
  String toString() {
    return r'transferOrderListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TransferOrderObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TransferOrderObject>> create(Ref ref) {
    final argument = this.argument as ({String query, int? orderType});
    return transferOrderList(
      ref,
      query: argument.query,
      orderType: argument.orderType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransferOrderListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transferOrderListHash() => r'13fbc773141d1635af6d1c4e178b38d88625e01c';

final class TransferOrderListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TransferOrderObject>>,
          ({String query, int? orderType})
        > {
  TransferOrderListFamily._()
    : super(
        retry: null,
        name: r'transferOrderListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransferOrderListProvider call({String query = '', int? orderType}) =>
      TransferOrderListProvider._(
        argument: (query: query, orderType: orderType),
        from: this,
      );

  @override
  String toString() => r'transferOrderListProvider';
}

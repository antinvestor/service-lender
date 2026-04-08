// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partition_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(partitionList)
final partitionListProvider = PartitionListProvider._();

final class PartitionListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PartitionObject>>,
          List<PartitionObject>,
          FutureOr<List<PartitionObject>>
        >
    with
        $FutureModifier<List<PartitionObject>>,
        $FutureProvider<List<PartitionObject>> {
  PartitionListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partitionListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partitionListHash();

  @$internal
  @override
  $FutureProviderElement<List<PartitionObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PartitionObject>> create(Ref ref) {
    return partitionList(ref);
  }
}

String _$partitionListHash() => r'd6f0c1bcae9de99237805da6735a2fe56c0a7db3';

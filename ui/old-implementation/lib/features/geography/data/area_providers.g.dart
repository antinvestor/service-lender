// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(areaSearch)
final areaSearchProvider = AreaSearchFamily._();

final class AreaSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AreaObject>>,
          List<AreaObject>,
          FutureOr<List<AreaObject>>
        >
    with $FutureModifier<List<AreaObject>>, $FutureProvider<List<AreaObject>> {
  AreaSearchProvider._({
    required AreaSearchFamily super.from,
    required ({String query, int limit}) super.argument,
  }) : super(
         retry: null,
         name: r'areaSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$areaSearchHash();

  @override
  String toString() {
    return r'areaSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AreaObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AreaObject>> create(Ref ref) {
    final argument = this.argument as ({String query, int limit});
    return areaSearch(ref, query: argument.query, limit: argument.limit);
  }

  @override
  bool operator ==(Object other) {
    return other is AreaSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$areaSearchHash() => r'1d7e781b1ed7d7af1c206bd64d41d402e8bf5ad4';

final class AreaSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AreaObject>>,
          ({String query, int limit})
        > {
  AreaSearchFamily._()
    : super(
        retry: null,
        name: r'areaSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AreaSearchProvider call({String query = '', int limit = 20}) =>
      AreaSearchProvider._(argument: (query: query, limit: limit), from: this);

  @override
  String toString() => r'areaSearchProvider';
}

@ProviderFor(areaById)
final areaByIdProvider = AreaByIdFamily._();

final class AreaByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<AreaObject?>,
          AreaObject?,
          FutureOr<AreaObject?>
        >
    with $FutureModifier<AreaObject?>, $FutureProvider<AreaObject?> {
  AreaByIdProvider._({
    required AreaByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'areaByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$areaByIdHash();

  @override
  String toString() {
    return r'areaByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AreaObject?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AreaObject?> create(Ref ref) {
    final argument = this.argument as String;
    return areaById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AreaByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$areaByIdHash() => r'da24e324801956e44538c78789223e15746b14a8';

final class AreaByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AreaObject?>, String> {
  AreaByIdFamily._()
    : super(
        retry: null,
        name: r'areaByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AreaByIdProvider call(String id) =>
      AreaByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'areaByIdProvider';
}

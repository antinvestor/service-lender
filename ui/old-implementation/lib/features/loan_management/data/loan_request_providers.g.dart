// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_request_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoanRequestList)
final loanRequestListProvider = LoanRequestListFamily._();

final class LoanRequestListProvider
    extends $AsyncNotifierProvider<LoanRequestList, List<LoanRequestObject>> {
  LoanRequestListProvider._({
    required LoanRequestListFamily super.from,
    required ({String query, int? statusFilter, String? sourceService})
    super.argument,
  }) : super(
         retry: null,
         name: r'loanRequestListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanRequestListHash();

  @override
  String toString() {
    return r'loanRequestListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LoanRequestList create() => LoanRequestList();

  @override
  bool operator ==(Object other) {
    return other is LoanRequestListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanRequestListHash() => r'28c05663cd770d15562193b9989294b7e5afff64';

final class LoanRequestListFamily extends $Family
    with
        $ClassFamilyOverride<
          LoanRequestList,
          AsyncValue<List<LoanRequestObject>>,
          List<LoanRequestObject>,
          FutureOr<List<LoanRequestObject>>,
          ({String query, int? statusFilter, String? sourceService})
        > {
  LoanRequestListFamily._()
    : super(
        retry: null,
        name: r'loanRequestListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanRequestListProvider call({
    String query = '',
    int? statusFilter,
    String? sourceService,
  }) => LoanRequestListProvider._(
    argument: (
      query: query,
      statusFilter: statusFilter,
      sourceService: sourceService,
    ),
    from: this,
  );

  @override
  String toString() => r'loanRequestListProvider';
}

abstract class _$LoanRequestList
    extends $AsyncNotifier<List<LoanRequestObject>> {
  late final _$args =
      ref.$arg as ({String query, int? statusFilter, String? sourceService});
  String get query => _$args.query;
  int? get statusFilter => _$args.statusFilter;
  String? get sourceService => _$args.sourceService;

  FutureOr<List<LoanRequestObject>> build({
    String query = '',
    int? statusFilter,
    String? sourceService,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<LoanRequestObject>>,
              List<LoanRequestObject>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LoanRequestObject>>,
                List<LoanRequestObject>
              >,
              AsyncValue<List<LoanRequestObject>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        query: _$args.query,
        statusFilter: _$args.statusFilter,
        sourceService: _$args.sourceService,
      ),
    );
  }
}

@ProviderFor(loanRequestDetail)
final loanRequestDetailProvider = LoanRequestDetailFamily._();

final class LoanRequestDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoanRequestObject>,
          LoanRequestObject,
          FutureOr<LoanRequestObject>
        >
    with
        $FutureModifier<LoanRequestObject>,
        $FutureProvider<LoanRequestObject> {
  LoanRequestDetailProvider._({
    required LoanRequestDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loanRequestDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanRequestDetailHash();

  @override
  String toString() {
    return r'loanRequestDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LoanRequestObject> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoanRequestObject> create(Ref ref) {
    final argument = this.argument as String;
    return loanRequestDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanRequestDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanRequestDetailHash() => r'a7fd3df4b117d3957e67651a05beba9ba8c1dc4f';

final class LoanRequestDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LoanRequestObject>, String> {
  LoanRequestDetailFamily._()
    : super(
        retry: null,
        name: r'loanRequestDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoanRequestDetailProvider call(String requestId) =>
      LoanRequestDetailProvider._(argument: requestId, from: this);

  @override
  String toString() => r'loanRequestDetailProvider';
}

@ProviderFor(LoanRequestNotifier)
final loanRequestProvider = LoanRequestNotifierProvider._();

final class LoanRequestNotifierProvider
    extends $AsyncNotifierProvider<LoanRequestNotifier, void> {
  LoanRequestNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanRequestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanRequestNotifierHash();

  @$internal
  @override
  LoanRequestNotifier create() => LoanRequestNotifier();
}

String _$loanRequestNotifierHash() =>
    r'6dc13aed58d3da6224c572db05d87b5d7ec56195';

abstract class _$LoanRequestNotifier extends $AsyncNotifier<void> {
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

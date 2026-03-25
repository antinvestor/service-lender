// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches loan status change audit trail entries.
///
/// When [loanAccountId] is empty, returns all status changes across all loans.

@ProviderFor(loanStatusChangeList)
final loanStatusChangeListProvider = LoanStatusChangeListFamily._();

/// Fetches loan status change audit trail entries.
///
/// When [loanAccountId] is empty, returns all status changes across all loans.

final class LoanStatusChangeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LoanStatusChangeObject>>,
          List<LoanStatusChangeObject>,
          FutureOr<List<LoanStatusChangeObject>>
        >
    with
        $FutureModifier<List<LoanStatusChangeObject>>,
        $FutureProvider<List<LoanStatusChangeObject>> {
  /// Fetches loan status change audit trail entries.
  ///
  /// When [loanAccountId] is empty, returns all status changes across all loans.
  LoanStatusChangeListProvider._({
    required LoanStatusChangeListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loanStatusChangeListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loanStatusChangeListHash();

  @override
  String toString() {
    return r'loanStatusChangeListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LoanStatusChangeObject>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LoanStatusChangeObject>> create(Ref ref) {
    final argument = this.argument as String;
    return loanStatusChangeList(ref, loanAccountId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoanStatusChangeListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loanStatusChangeListHash() =>
    r'7ca957d24e0885b9d216a45c8be014696d2b2ef6';

/// Fetches loan status change audit trail entries.
///
/// When [loanAccountId] is empty, returns all status changes across all loans.

final class LoanStatusChangeListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<LoanStatusChangeObject>>,
          String
        > {
  LoanStatusChangeListFamily._()
    : super(
        retry: null,
        name: r'loanStatusChangeListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches loan status change audit trail entries.
  ///
  /// When [loanAccountId] is empty, returns all status changes across all loans.

  LoanStatusChangeListProvider call({String loanAccountId = ''}) =>
      LoanStatusChangeListProvider._(argument: loanAccountId, from: this);

  @override
  String toString() => r'loanStatusChangeListProvider';
}

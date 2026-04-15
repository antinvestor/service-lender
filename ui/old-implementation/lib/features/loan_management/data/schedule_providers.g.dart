// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(repaymentScheduleDetail)
final repaymentScheduleDetailProvider = RepaymentScheduleDetailFamily._();

final class RepaymentScheduleDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<RepaymentScheduleObject>,
          RepaymentScheduleObject,
          FutureOr<RepaymentScheduleObject>
        >
    with
        $FutureModifier<RepaymentScheduleObject>,
        $FutureProvider<RepaymentScheduleObject> {
  RepaymentScheduleDetailProvider._({
    required RepaymentScheduleDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'repaymentScheduleDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$repaymentScheduleDetailHash();

  @override
  String toString() {
    return r'repaymentScheduleDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RepaymentScheduleObject> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RepaymentScheduleObject> create(Ref ref) {
    final argument = this.argument as String;
    return repaymentScheduleDetail(ref, loanAccountId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RepaymentScheduleDetailProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$repaymentScheduleDetailHash() =>
    r'45f6dc17bbb614b42d06cc0f1735fe25940cce8f';

final class RepaymentScheduleDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RepaymentScheduleObject>, String> {
  RepaymentScheduleDetailFamily._()
    : super(
        retry: null,
        name: r'repaymentScheduleDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RepaymentScheduleDetailProvider call({required String loanAccountId}) =>
      RepaymentScheduleDetailProvider._(argument: loanAccountId, from: this);

  @override
  String toString() => r'repaymentScheduleDetailProvider';
}

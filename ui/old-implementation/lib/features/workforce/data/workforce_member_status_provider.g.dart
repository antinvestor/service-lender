// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workforce_member_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workforceMemberStatus)
final workforceMemberStatusProvider = WorkforceMemberStatusProvider._();

final class WorkforceMemberStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkforceMemberOnboardingStatus>,
          WorkforceMemberOnboardingStatus,
          FutureOr<WorkforceMemberOnboardingStatus>
        >
    with
        $FutureModifier<WorkforceMemberOnboardingStatus>,
        $FutureProvider<WorkforceMemberOnboardingStatus> {
  WorkforceMemberStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workforceMemberStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workforceMemberStatusHash();

  @$internal
  @override
  $FutureProviderElement<WorkforceMemberOnboardingStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkforceMemberOnboardingStatus> create(Ref ref) {
    return workforceMemberStatus(ref);
  }
}

String _$workforceMemberStatusHash() =>
    r'9363d09ca7df0e30ba40145286ada83e7d5d367f';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(agentOnboardingStatus)
final agentOnboardingStatusProvider = AgentOnboardingStatusProvider._();

final class AgentOnboardingStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<AgentOnboardingStatus>,
          AgentOnboardingStatus,
          FutureOr<AgentOnboardingStatus>
        >
    with
        $FutureModifier<AgentOnboardingStatus>,
        $FutureProvider<AgentOnboardingStatus> {
  AgentOnboardingStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agentOnboardingStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agentOnboardingStatusHash();

  @$internal
  @override
  $FutureProviderElement<AgentOnboardingStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AgentOnboardingStatus> create(Ref ref) {
    return agentOnboardingStatus(ref);
  }
}

String _$agentOnboardingStatusHash() =>
    r'35f14eb38a787f8c31e7835798e9d0641af45bca';

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
    r'8d266a7ee28089e54b9cf6b03e4e7ba828349477';

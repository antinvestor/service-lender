// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_agent_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves the current user's agent record by searching for an agent
/// whose profileId matches the logged-in user's profile ID.
///
/// Returns the agent ID, or null if the user is not an agent.

@ProviderFor(currentAgentId)
final currentAgentIdProvider = CurrentAgentIdProvider._();

/// Resolves the current user's agent record by searching for an agent
/// whose profileId matches the logged-in user's profile ID.
///
/// Returns the agent ID, or null if the user is not an agent.

final class CurrentAgentIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Resolves the current user's agent record by searching for an agent
  /// whose profileId matches the logged-in user's profile ID.
  ///
  /// Returns the agent ID, or null if the user is not an agent.
  CurrentAgentIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAgentIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAgentIdHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return currentAgentId(ref);
  }
}

String _$currentAgentIdHash() => r'd9df0753a7954c57d291a06312dd88aa0912c673';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_agent_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentAgentId)
final currentAgentIdProvider = CurrentAgentIdProvider._();

final class CurrentAgentIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<String?>,
          String?,
          FutureOr<String?>
        >
    with
        $FutureModifier<String?>,
        $FutureProvider<String?> {
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
  $FutureProviderElement<String?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return currentAgentId(ref);
  }
}

String _$currentAgentIdHash() =>
    r'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0';

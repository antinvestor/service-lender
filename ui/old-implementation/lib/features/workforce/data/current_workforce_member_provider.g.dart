// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_workforce_member_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves the current user's workforce member record by searching for a
/// member whose profileId matches the logged-in user's profile ID.
///
/// Returns the member ID, or null if the user is not a workforce member.

@ProviderFor(currentWorkforceMemberId)
final currentWorkforceMemberIdProvider = CurrentWorkforceMemberIdProvider._();

/// Resolves the current user's workforce member record by searching for a
/// member whose profileId matches the logged-in user's profile ID.
///
/// Returns the member ID, or null if the user is not a workforce member.

final class CurrentWorkforceMemberIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Resolves the current user's workforce member record by searching for a
  /// member whose profileId matches the logged-in user's profile ID.
  ///
  /// Returns the member ID, or null if the user is not a workforce member.
  CurrentWorkforceMemberIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentWorkforceMemberIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentWorkforceMemberIdHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return currentWorkforceMemberId(ref);
  }
}

String _$currentWorkforceMemberIdHash() =>
    r'0698959c5e27bc37179de2ad04fa17869ac83b9c';

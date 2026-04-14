// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentUserRoles)
final currentUserRolesProvider = CurrentUserRolesProvider._();

final class CurrentUserRolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<LenderRole>>,
          Set<LenderRole>,
          FutureOr<Set<LenderRole>>
        >
    with $FutureModifier<Set<LenderRole>>, $FutureProvider<Set<LenderRole>> {
  CurrentUserRolesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserRolesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserRolesHash();

  @$internal
  @override
  $FutureProviderElement<Set<LenderRole>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<LenderRole>> create(Ref ref) {
    return currentUserRoles(ref);
  }
}

String _$currentUserRolesHash() => r'0b1c12247e2a6fe0e93455d94b389b67897da028';

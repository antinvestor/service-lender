// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nav_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the filtered navigation items based on current user roles.

@ProviderFor(filteredNavItems)
final filteredNavItemsProvider = FilteredNavItemsProvider._();

/// Provides the filtered navigation items based on current user roles.

final class FilteredNavItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NavItem>>,
          List<NavItem>,
          FutureOr<List<NavItem>>
        >
    with $FutureModifier<List<NavItem>>, $FutureProvider<List<NavItem>> {
  /// Provides the filtered navigation items based on current user roles.
  FilteredNavItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredNavItemsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredNavItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<NavItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NavItem>> create(Ref ref) {
    return filteredNavItems(ref);
  }
}

String _$filteredNavItemsHash() => r'bc6fc2671f9ec88b066995284fe15ce41ffd1ad1';

@ProviderFor(sidebarExpansion)
final sidebarExpansionProvider = SidebarExpansionProvider._();

final class SidebarExpansionProvider
    extends
        $FunctionalProvider<
          SidebarExpansionState,
          SidebarExpansionState,
          SidebarExpansionState
        >
    with $Provider<SidebarExpansionState> {
  SidebarExpansionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sidebarExpansionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sidebarExpansionHash();

  @$internal
  @override
  $ProviderElement<SidebarExpansionState> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SidebarExpansionState create(Ref ref) {
    return sidebarExpansion(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SidebarExpansionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SidebarExpansionState>(value),
    );
  }
}

String _$sidebarExpansionHash() => r'36edc02f6476be404f6ae11d76fe94f4bc00ebc4';

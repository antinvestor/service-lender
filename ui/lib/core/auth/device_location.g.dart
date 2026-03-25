// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_location.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves the current device location with reverse geocoding.
/// Handles permission requests and gracefully degrades if location is unavailable.

@ProviderFor(deviceLocation)
final deviceLocationProvider = DeviceLocationProvider._();

/// Resolves the current device location with reverse geocoding.
/// Handles permission requests and gracefully degrades if location is unavailable.

final class DeviceLocationProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeviceLocation>,
          DeviceLocation,
          FutureOr<DeviceLocation>
        >
    with $FutureModifier<DeviceLocation>, $FutureProvider<DeviceLocation> {
  /// Resolves the current device location with reverse geocoding.
  /// Handles permission requests and gracefully degrades if location is unavailable.
  DeviceLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceLocationHash();

  @$internal
  @override
  $FutureProviderElement<DeviceLocation> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DeviceLocation> create(Ref ref) {
    return deviceLocation(ref);
  }
}

String _$deviceLocationHash() => r'fd5e082b51b2774631c32ad9533063f87675fcea';

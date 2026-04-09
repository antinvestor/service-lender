import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';
import 'device_location.dart';

part 'audit_context.g.dart';

/// AuditContext captures the full context of an authenticated action:
/// who (user identity claims), when (timestamp), where (device location),
/// and the tenancy context (tenant + partition).
class AuditContext {
  const AuditContext({
    required this.profileId,
    this.tenantId,
    this.partitionId,
    this.contactId,
    this.accessId,
    this.sessionId,
    this.deviceId,
    this.displayName,
    this.location,
  });

  // Tenancy — multi-tenant isolation context
  final String? tenantId;
  final String? partitionId;

  // Who — authenticated user claims
  final String profileId;
  final String? contactId;
  final String? accessId;
  final String? sessionId;
  final String? deviceId;
  final String? displayName;

  // Where — device location at time of action
  final DeviceLocation? location;

  /// Serializes to a flat map for embedding in proto Properties/ExtraData fields.
  Map<String, String> toMap() {
    final map = <String, String>{
      'profile_id': profileId,
      'tenant_id': ?tenantId,
      'partition_id': ?partitionId,
      'contact_id': ?contactId,
      'access_id': ?accessId,
      'session_id': ?sessionId,
      'device_id': ?deviceId,
      'display_name': ?displayName,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };

    if (location != null) {
      map.addAll(location!.toMap());
    }

    return map;
  }

  String get displayLabel => displayName != null && displayName!.isNotEmpty
      ? '$displayName ($profileId)'
      : profileId;

  String get locationLabel => location?.displayLabel ?? 'Unknown location';

  String get fullLabel => '$displayLabel — $locationLabel';
}

@Riverpod(keepAlive: true)
Future<AuditContext> auditContext(Ref ref) async {
  final claimsFuture = ref.watch(authRepositoryProvider).getUserInfo();
  final locationFuture = ref.watch(deviceLocationProvider.future);

  final results = await Future.wait([
    claimsFuture,
    locationFuture.catchError(
      (_) => const DeviceLocation(error: 'unavailable'),
    ),
  ]);

  final claims = results[0] as Map<String, dynamic>?;
  final location = results[1] as DeviceLocation;

  if (claims == null) {
    throw StateError('No authenticated user — cannot create audit context');
  }

  return AuditContext(
    profileId: claims['sub'] as String? ?? '',
    tenantId: claims['tenant_id'] as String?,
    partitionId: claims['partition_id'] as String?,
    contactId: claims['contact_id'] as String? ?? claims['email'] as String?,
    accessId: claims['azp'] as String? ?? claims['client_id'] as String?,
    sessionId: claims['sid'] as String? ?? claims['session_state'] as String?,
    deviceId: claims['device_id'] as String?,
    displayName:
        claims['name'] as String? ?? claims['preferred_username'] as String?,
    location: location,
  );
}

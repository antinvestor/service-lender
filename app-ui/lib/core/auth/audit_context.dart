import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';
import 'device_location.dart';

part 'audit_context.g.dart';

/// AuditContext captures the full context of an authenticated action:
/// who (user identity claims), when (timestamp), and where (device location).
///
/// Every action that modifies state should include this context in its
/// audit trail properties.
class AuditContext {
  const AuditContext({
    required this.profileId,
    this.contactId,
    this.accessId,
    this.sessionId,
    this.displayName,
    this.location,
  });

  // Who — authenticated user claims
  final String profileId; // sub claim
  final String? contactId; // contact_id or email claim
  final String? accessId; // azp or client_id claim
  final String? sessionId; // sid or session_state claim
  final String? displayName; // name or preferred_username claim

  // Where — device location at time of action
  final DeviceLocation? location;

  /// Serializes the full audit context (identity + location) to a flat map
  /// for embedding in Properties/ExtraData proto fields.
  Map<String, String> toMap() {
    final map = <String, String>{
      'profile_id': profileId,
      if (contactId != null) 'contact_id': contactId!,
      if (accessId != null) 'access_id': accessId!,
      if (sessionId != null) 'session_id': sessionId!,
      if (displayName != null) 'display_name': displayName!,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };

    // Merge device location details
    if (location != null) {
      map.addAll(location!.toMap());
    }

    return map;
  }

  /// Returns a display string like "John Doe (profile123)"
  String get displayLabel => displayName != null && displayName!.isNotEmpty
      ? '$displayName ($profileId)'
      : profileId;

  /// Returns a location display string like "Nairobi, Kenya"
  String get locationLabel => location?.displayLabel ?? 'Unknown location';

  /// Returns a full display string like "John Doe — Nairobi, Kenya"
  String get fullLabel {
    final who = displayLabel;
    final where = locationLabel;
    return '$who — $where';
  }
}

/// Provider that builds an AuditContext from current JWT claims and device location.
/// The location is fetched in parallel with auth claims for speed.
@riverpod
Future<AuditContext> auditContext(Ref ref) async {
  // Fetch identity and location in parallel
  final claimsFuture = ref.watch(authRepositoryProvider).getUserInfo();
  final locationFuture = ref.watch(deviceLocationProvider.future);

  final results = await Future.wait([
    claimsFuture,
    locationFuture.catchError((_) => const DeviceLocation(error: 'unavailable')),
  ]);

  final claims = results[0] as Map<String, dynamic>?;
  final location = results[1] as DeviceLocation;

  if (claims == null) {
    throw StateError('No authenticated user — cannot create audit context');
  }

  return AuditContext(
    profileId: claims['sub'] as String? ?? '',
    contactId:
        claims['contact_id'] as String? ?? claims['email'] as String?,
    accessId:
        claims['azp'] as String? ?? claims['client_id'] as String?,
    sessionId:
        claims['sid'] as String? ?? claims['session_state'] as String?,
    displayName: claims['name'] as String? ??
        claims['preferred_username'] as String?,
    location: location,
  );
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/data/auth_repository.dart';

part 'audit_context.g.dart';

/// AuditContext captures authenticated user claims for audit trails.
/// Every action that modifies state should include this context.
class AuditContext {
  const AuditContext({
    required this.profileId,
    this.contactId,
    this.accessId,
    this.sessionId,
    this.displayName,
  });

  final String profileId;     // sub claim — who
  final String? contactId;    // contact_id claim
  final String? accessId;     // azp or access_id claim
  final String? sessionId;    // sid or session_id claim
  final String? displayName;  // name or preferred_username claim

  /// Serializes to a map for embedding in Properties/ExtraData proto fields.
  Map<String, String> toMap() {
    return {
      'profile_id': profileId,
      if (contactId != null) 'contact_id': contactId!,
      if (accessId != null) 'access_id': accessId!,
      if (sessionId != null) 'session_id': sessionId!,
      if (displayName != null) 'display_name': displayName!,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }

  /// Returns a display string like "John Doe (profile123)"
  String get displayLabel => displayName != null && displayName!.isNotEmpty
      ? '$displayName ($profileId)'
      : profileId;
}

/// Provider that builds an AuditContext from current JWT claims.
@riverpod
Future<AuditContext> auditContext(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final claims = await authRepo.getUserInfo();

  if (claims == null) {
    throw StateError('No authenticated user — cannot create audit context');
  }

  return AuditContext(
    profileId: claims['sub'] as String? ?? '',
    contactId: claims['contact_id'] as String? ?? claims['email'] as String?,
    accessId: claims['azp'] as String? ?? claims['client_id'] as String?,
    sessionId: claims['sid'] as String? ?? claims['session_state'] as String?,
    displayName: claims['name'] as String? ?? claims['preferred_username'] as String?,
  );
}

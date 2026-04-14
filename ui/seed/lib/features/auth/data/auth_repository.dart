import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:antinvestor_ui_core/auth/tenancy_context.dart';
import '../../../core/config/app_config.dart';
import 'auth_service.dart';

part 'auth_repository.g.dart';

/// Stores the login context (level + selected org/branch) for session restoration.
class StoredLoginContext {
  const StoredLoginContext({
    required this.level,
    this.orgId,
    this.orgName,
    this.branchId,
    this.branchName,
  });

  factory StoredLoginContext.fromJson(Map<String, dynamic> json) {
    return StoredLoginContext(
      level: LoginLevel.values.firstWhere(
        (l) => l.name == json['level'],
        orElse: () => LoginLevel.root,
      ),
      orgId: json['org_id'] as String?,
      orgName: json['org_name'] as String?,
      branchId: json['branch_id'] as String?,
      branchName: json['branch_name'] as String?,
    );
  }

  final LoginLevel level;
  final String? orgId;
  final String? orgName;
  final String? branchId;
  final String? branchName;

  Map<String, dynamic> toJson() => {
    'level': level.name,
    'org_id': orgId,
    'org_name': orgName,
    'branch_id': branchId,
    'branch_name': branchName,
  };
}

class AuthRepository {
  AuthRepository(this._authService);
  final AuthService _authService;

  Future<void> login({String? clientId}) async {
    if (clientId != null) {
      await _authService.switchClient(clientId);
    }
    await _authService.authenticate();
  }

  Future<void> logout() async => _authService.logout();

  bool? get isLoggedInSync => _authService.isAuthenticatedSync;

  Future<bool> isLoggedIn() async {
    final cached = _authService.isAuthenticatedSync;
    if (cached != null) return cached;
    return _authService.isAuthenticated();
  }

  Future<String?> getAccessToken() async => _authService.getAccessToken();

  Future<String?> ensureValidAccessToken() async =>
      _authService.ensureValidAccessToken();

  Future<String?> forceRefreshAccessToken() async =>
      _authService.forceRefreshAccessToken();

  Future<Map<String, dynamic>?> getUserInfo() async =>
      _authService.getUserInfo();

  Future<String?> getCurrentProfileId() async {
    final claims = await getUserInfo();
    return claims?['sub'] as String?;
  }

  Future<String?> getCurrentContactId() async {
    final claims = await getUserInfo();
    return claims?['contact_id'] as String? ?? claims?['email'] as String?;
  }

  Future<String?> getCurrentSessionId() async {
    final claims = await getUserInfo();
    return claims?['sid'] as String? ?? claims?['session_state'] as String?;
  }

  Future<List<String>> getUserRoles() async => _authService.getUserRoles();

  Future<String?> getCurrentTenantId() async {
    final claims = await getUserInfo();
    return claims?['tenant_id'] as String?;
  }

  Future<String?> getCurrentPartitionId() async {
    final claims = await getUserInfo();
    return claims?['partition_id'] as String?;
  }

  Future<String?> getDisplayName() async {
    final claims = await getUserInfo();
    return claims?['name'] as String? ??
        claims?['preferred_username'] as String?;
  }

  Future<void> storeLoginContext(StoredLoginContext context) async {
    await _authService.storeLoginContext(jsonEncode(context.toJson()));
  }

  Future<StoredLoginContext?> getStoredLoginContext() async {
    final json = await _authService.getStoredLoginContext();
    if (json == null) return null;
    try {
      return StoredLoginContext.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  const issuerUrl = AppConfig.oauthIssuerUrl;
  const clientId = AppConfig.oauthClientId;

  const storage = FlutterSecureStorage();
  final authService = AuthService(
    storage,
    issuerUrl: issuerUrl,
    clientId: clientId,
  );

  authService.restoreSelectedClient().ignore();

  return AuthRepository(authService);
}

@Riverpod(keepAlive: true)
Future<String?> currentProfileId(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getCurrentProfileId();
}

@Riverpod(keepAlive: true)
Future<List<String>> userRoles(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getUserRoles();
}

@Riverpod(keepAlive: true)
Future<String?> currentTenantId(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getCurrentTenantId();
}

@Riverpod(keepAlive: true)
Future<String?> currentPartitionId(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getCurrentPartitionId();
}

@Riverpod(keepAlive: true)
Future<String?> currentDisplayName(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getDisplayName();
}

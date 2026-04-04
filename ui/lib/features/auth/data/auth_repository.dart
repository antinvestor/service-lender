import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import 'auth_service.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._authService);
  final AuthService _authService;

  Future<void> login() async {
    // On web, authenticate() initiates a redirect and returns null.
    // The token exchange happens on redirect back via isLoggedIn() → _handleRedirectResult().
    await _authService.authenticate();
  }

  Future<void> logout() async => _authService.logout();

  /// Returns cached auth state synchronously if warm, else async check.
  /// This keeps the GoRouter redirect fast after the first check.
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

  /// Returns the current user's contact ID from JWT claims.
  Future<String?> getCurrentContactId() async {
    final claims = await getUserInfo();
    return claims?['contact_id'] as String? ?? claims?['email'] as String?;
  }

  /// Returns the current session ID from JWT claims.
  Future<String?> getCurrentSessionId() async {
    final claims = await getUserInfo();
    return claims?['sid'] as String? ?? claims?['session_state'] as String?;
  }

  Future<List<String>> getUserRoles() async => _authService.getUserRoles();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  const issuerUrl = AppConfig.oauthIssuerUrl;
  const clientId = AppConfig.oauthClientId;

  const storage = FlutterSecureStorage();
  final authService = AuthService(
    storage,
    issuerUrl: issuerUrl,
    clientId: clientId,
  );

  return AuthRepository(authService);
}

@riverpod
Future<String?> currentProfileId(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getCurrentProfileId();
}

@riverpod
Future<List<String>> userRoles(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getUserRoles();
}

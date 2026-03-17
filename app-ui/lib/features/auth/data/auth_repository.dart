import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  Future<bool> isLoggedIn() async => _authService.isAuthenticated();

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

  Future<List<String>> getUserRoles() async => _authService.getUserRoles();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  // TODO: Configure these for your environment
  const issuerUrl = 'https://oauth2.stawi.org';
  const clientId = 'd6qbqdkpf2t52mcunf60';

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

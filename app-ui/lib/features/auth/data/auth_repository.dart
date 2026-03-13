import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_service.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._authService);
  final AuthService _authService;

  Future<void> login() async {
    final token = await _authService.authenticate();
    if (token == null) {
      throw Exception('Authentication did not return a token');
    }
  }

  Future<void> logout() async => _authService.logout();

  Future<bool> isLoggedIn() async => _authService.isAuthenticated();

  Future<String?> getAccessToken() async => _authService.getAccessToken();

  Future<String?> ensureValidAccessToken() async =>
      _authService.ensureValidAccessToken();

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
  const clientId = 'd6q1aekpf2taeg5iovpg';

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

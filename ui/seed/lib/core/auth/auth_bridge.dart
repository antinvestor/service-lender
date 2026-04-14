import 'package:antinvestor_ui_core/auth/auth_token_provider.dart';

import '../../features/auth/data/auth_repository.dart';

/// Bridges [AuthRepository] to ui_core's [AuthTokenProvider] interface.
///
/// This allows all shared UI library providers (profile, notification, etc.)
/// to authenticate API calls using the app's token management.
class LenderAuthTokenBridge implements AuthTokenProvider {
  LenderAuthTokenBridge(this._authRepo);

  final AuthRepository _authRepo;

  @override
  Future<String?> ensureValidAccessToken() =>
      _authRepo.ensureValidAccessToken();

  @override
  Future<String?> forceRefreshAccessToken() =>
      _authRepo.forceRefreshAccessToken();

  @override
  Future<void> logout() => _authRepo.logout();
}

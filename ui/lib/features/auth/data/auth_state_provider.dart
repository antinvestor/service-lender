import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logging/app_logger.dart';
import 'auth_repository.dart';

part 'auth_state_provider.g.dart';

enum AuthState { authenticated, unauthenticated, loading }

@Riverpod(keepAlive: true)
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  Future<AuthState> build() async {
    final authRepo = ref.watch(authRepositoryProvider);
    final isLoggedIn = await authRepo.isLoggedIn();

    if (isLoggedIn) {
      final token = await authRepo.ensureValidAccessToken();
      if (token != null) {
        return AuthState.authenticated;
      }
      // Transient failure - keep session alive
      return AuthState.authenticated;
    }

    return AuthState.unauthenticated;
  }

  Future<void> login() async {
    state = const AsyncValue.loading();

    try {
      final authRepo = ref.read(authRepositoryProvider);
      // On web, this triggers a full-page redirect and never returns.
      // On desktop/mobile, this blocks until the OAuth flow completes.
      await authRepo.login();

      if (!ref.mounted) return;

      // Only reached on desktop/mobile (web redirects away).
      final isLoggedIn = await authRepo.isLoggedIn();
      if (!isLoggedIn) {
        state = const AsyncValue.data(AuthState.unauthenticated);
        return;
      }

      state = const AsyncValue.data(AuthState.authenticated);
      AppLogger.info('Login successful');
    } catch (e, stack) {
      AppLogger.error('Login failed', error: e, stackTrace: stack);
      if (ref.mounted) {
        state = AsyncValue.error(e, stack);
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.logout();

      if (!ref.mounted) return;

      state = const AsyncValue.data(AuthState.unauthenticated);
      AppLogger.info('Logout successful');
    } catch (e, stack) {
      AppLogger.error('Logout failed', error: e, stackTrace: stack);
      if (ref.mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }
}

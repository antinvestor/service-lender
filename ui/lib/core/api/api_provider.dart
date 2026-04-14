import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/auth_state_provider.dart';
import '../logging/app_logger.dart';
import '../../sdk/src/identity/v1/identity.connect.client.dart';
import '../../sdk/src/field/v1/field.connect.client.dart';
import '../../sdk/src/loans/v1/loans.connect.client.dart';
import '../../sdk/src/savings/v1/savings.connect.client.dart';
import '../../sdk/src/funding/v1/funding.connect.client.dart';
import '../../sdk/src/operations/v1/operations.connect.client.dart';
import 'package:antinvestor_api_geolocation/antinvestor_api_geolocation.dart'
    show GeolocationServiceClient;
import 'package:antinvestor_api_profile/antinvestor_api_profile.dart'
    show ProfileServiceClient;
import 'package:antinvestor_api_notification/antinvestor_api_notification.dart'
    show NotificationServiceClient;
import 'package:antinvestor_api_tenancy/antinvestor_api_tenancy.dart'
    show TenancyServiceClient;
import 'http_client_native.dart'
    if (dart.library.js_interop) 'http_client_web.dart';
import '../config/app_config.dart';
part 'api_provider.g.dart';

/// Interceptor that injects the Bearer token into every request.
///
/// Strategy:
/// 1. Before request: get a valid token (refresh proactively if near expiry).
/// 2. If request fails with unauthenticated: force-refresh and retry once.
///    permissionDenied is an authorization error (valid token, missing role)
///    and must NOT trigger token refresh or logout.
/// 3. If retry also fails with unauthenticated: trigger logout so user is
///    redirected to login.
class AuthInterceptor {
  AuthInterceptor(this._authRepository, this._onAuthFailure);
  final AuthRepository _authRepository;
  final void Function() _onAuthFailure;
  bool _authFailureFired = false;

  void _triggerAuthFailure() {
    // Only fire once — multiple concurrent API calls can all fail after
    // the first logout clears the token, but we only need to redirect once.
    if (_authFailureFired) return;
    _authFailureFired = true;
    _onAuthFailure();
  }

  AnyFn<I, O> call<I extends Object, O extends Object>(AnyFn<I, O> next) {
    return (req) async {
      // Get a token, refreshing if expired.
      var token = await _authRepository.ensureValidAccessToken();
      if (token != null) {
        req.headers['authorization'] = 'Bearer $token';
      }
      try {
        return await next(req);
      } on ConnectException catch (e) {
        // Only retry on unauthenticated (token expired/invalid).
        // permissionDenied means the token is valid but the user lacks
        // the required role — retrying with a new token won't help.
        if (e.code != Code.unauthenticated) {
          rethrow;
        }

        AppLogger.warning(
          'Token rejected (unauthenticated), attempting refresh',
          data: {'code': '${e.code}'},
        );

        // Token was rejected by the server — force a fresh token from the
        // OAuth server (ignores cached expiry) and retry once.
        final newToken = await _authRepository.forceRefreshAccessToken();
        if (newToken == null) {
          // Refresh token is dead — session is truly over.
          AppLogger.error(
            'Token refresh failed (no refresh token) — logging out',
          );
          _triggerAuthFailure();
          rethrow;
        }
        req.headers['authorization'] = 'Bearer $newToken';
        try {
          return await next(req);
        } on ConnectException catch (retryError) {
          // Retry with a freshly obtained token also failed.
          // Do NOT log out — the refresh token is still valid (we just used it),
          // so the issue is server-side (audience mismatch, token format, etc.).
          // Logging out and re-logging in would get the same kind of token.
          // Let the error propagate to the UI layer.
          if (retryError.code == Code.unauthenticated) {
            AppLogger.warning(
              'Retry with fresh token also rejected — server may not accept this token type',
              data: {'code': '${retryError.code}'},
            );
          }
          rethrow;
        }
      }
    };
  }
}

/// Global guard: ensures logout fires at most once per session across all
/// transports. Uses a generation counter so stale interceptors from a prior
/// session cannot trigger logout on a newly-authenticated session.
int _authSessionGeneration = 0;
bool _globalAuthFailureFired = false;

/// Reset the global auth failure guard after a successful login.
/// Increments the session generation so stale interceptors are ignored.
void resetAuthFailureGuard() {
  _globalAuthFailureFired = false;
  _authSessionGeneration++;
}

/// Creates a Connect RPC transport for the given [baseUrl].
///
/// Watches [authStateProvider] so the transport (and its interceptor) is
/// recreated whenever the authentication state changes (login/logout).
Transport _createTransport(Ref ref, String baseUrl) {
  final authRepo = ref.watch(authRepositoryProvider);
  // Ensure transport is recreated on auth state changes so the captured
  // session generation stays in sync.
  ref.watch(authStateProvider);
  final capturedGeneration = _authSessionGeneration;
  final authInterceptor = AuthInterceptor(authRepo, () {
    // Ignore if this interceptor was created for a stale session.
    if (capturedGeneration != _authSessionGeneration) return;
    if (_globalAuthFailureFired) return;
    _globalAuthFailureFired = true;
    AppLogger.error('Auth failure — logging out and redirecting to login');
    authRepo.logout();
    ref.invalidate(authStateProvider);
  });

  return protocol.Transport(
    baseUrl: baseUrl,
    codec: const ProtoCodec(),
    httpClient: createPlatformHttpClient(),
    interceptors: [authInterceptor.call],
    useHttpGet: false,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Per-service transports
// ─────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Transport loansTransport(Ref ref) =>
    _createTransport(ref, AppConfig.loansBaseUrl);

@Riverpod(keepAlive: true)
Transport identityTransport(Ref ref) =>
    _createTransport(ref, AppConfig.identityBaseUrl);

@Riverpod(keepAlive: true)
Transport savingsTransport(Ref ref) =>
    _createTransport(ref, AppConfig.savingsBaseUrl);

@Riverpod(keepAlive: true)
Transport fundingTransport(Ref ref) =>
    _createTransport(ref, AppConfig.fundingBaseUrl);

@Riverpod(keepAlive: true)
Transport operationsTransport(Ref ref) =>
    _createTransport(ref, AppConfig.operationsBaseUrl);

@Riverpod(keepAlive: true)
Transport geolocationTransport(Ref ref) =>
    _createTransport(ref, AppConfig.geolocationBaseUrl);

// ─────────────────────────────────────────────────────────────────────────────
// Service clients
// ─────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
IdentityServiceClient identityServiceClient(Ref ref) {
  final transport = ref.watch(identityTransportProvider);
  return IdentityServiceClient(transport);
}

@Riverpod(keepAlive: true)
FieldServiceClient fieldServiceClient(Ref ref) {
  final transport = ref.watch(identityTransportProvider);
  return FieldServiceClient(transport);
}

@Riverpod(keepAlive: true)
GeolocationServiceClient geolocationServiceClient(Ref ref) {
  final transport = ref.watch(geolocationTransportProvider);
  return GeolocationServiceClient(transport);
}

@Riverpod(keepAlive: true)
LoanManagementServiceClient loanManagementServiceClient(Ref ref) {
  final transport = ref.watch(loansTransportProvider);
  return LoanManagementServiceClient(transport);
}

@Riverpod(keepAlive: true)
SavingsServiceClient savingsServiceClient(Ref ref) {
  final transport = ref.watch(savingsTransportProvider);
  return SavingsServiceClient(transport);
}

@Riverpod(keepAlive: true)
FundingServiceClient fundingServiceClient(Ref ref) {
  final transport = ref.watch(fundingTransportProvider);
  return FundingServiceClient(transport);
}

@Riverpod(keepAlive: true)
OperationsServiceClient operationsServiceClient(Ref ref) {
  final transport = ref.watch(operationsTransportProvider);
  return OperationsServiceClient(transport);
}

// ─────────────────────────────────────────────────────────────────────────────
// Platform service clients (profile, notification)
// ─────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Transport profileTransport(Ref ref) =>
    _createTransport(ref, AppConfig.profileBaseUrl);

@Riverpod(keepAlive: true)
Transport notificationTransport(Ref ref) =>
    _createTransport(ref, AppConfig.notificationBaseUrl);

@Riverpod(keepAlive: true)
ProfileServiceClient profileServiceClient(Ref ref) {
  final transport = ref.watch(profileTransportProvider);
  return ProfileServiceClient(transport);
}

@Riverpod(keepAlive: true)
NotificationServiceClient notificationServiceClient(Ref ref) {
  final transport = ref.watch(notificationTransportProvider);
  return NotificationServiceClient(transport);
}

@Riverpod(keepAlive: true)
Transport tenancyTransport(Ref ref) =>
    _createTransport(ref, AppConfig.tenancyBaseUrl);

@Riverpod(keepAlive: true)
TenancyServiceClient tenancyServiceClient(Ref ref) {
  final transport = ref.watch(tenancyTransportProvider);
  return TenancyServiceClient(transport);
}

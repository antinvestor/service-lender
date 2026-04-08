import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/auth_state_provider.dart';
import '../../sdk/src/identity/v1/identity.connect.client.dart';
import '../../sdk/src/field/v1/field.connect.client.dart';
import '../../sdk/src/origination/v1/origination.connect.client.dart';
import '../../sdk/src/loans/v1/loans.connect.client.dart';
import '../../sdk/src/savings/v1/savings.connect.client.dart';
import '../../sdk/src/funding/v1/funding.connect.client.dart';
import '../../sdk/src/operations/v1/operations.connect.client.dart';
import 'package:antinvestor_api_profile/antinvestor_api_profile.dart'
    show ProfileServiceClient;
import 'package:antinvestor_api_notification/antinvestor_api_notification.dart'
    show NotificationServiceClient;
import 'http_client_native.dart'
    if (dart.library.js_interop) 'http_client_web.dart';
part 'api_provider.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Per-service base URLs.
//
// Each deployed service gets its own gateway path prefix on
// api.antinvestor.com, following the same pattern as other Antinvestor
// products (tenancy, profile, payment, etc.).
//
// Override at build time with --dart-define for local development.
// ─────────────────────────────────────────────────────────────────────────────

const _loansUrl = String.fromEnvironment(
  'LOANS_URL',
  defaultValue: 'https://api.antinvestor.com/loans',
);

const _originationUrl = String.fromEnvironment(
  'ORIGINATION_URL',
  defaultValue: 'https://api.antinvestor.com/origination',
);

const _identityUrl = String.fromEnvironment(
  'IDENTITY_URL',
  defaultValue: 'https://api.antinvestor.com/identity',
);

const _savingsUrl = String.fromEnvironment(
  'SAVINGS_URL',
  defaultValue: 'https://api.antinvestor.com/savings',
);

const _fundingUrl = String.fromEnvironment(
  'FUNDING_URL',
  defaultValue: 'https://api.antinvestor.com/funding',
);

const _operationsUrl = String.fromEnvironment(
  'OPERATIONS_URL',
  defaultValue: 'https://api.antinvestor.com/operations',
);

const _profileUrl = String.fromEnvironment(
  'PROFILE_URL',
  defaultValue: 'https://api.antinvestor.com/profile',
);

const _notificationUrl = String.fromEnvironment(
  'NOTIFICATION_URL',
  defaultValue: 'https://api.antinvestor.com/notification',
);

/// Interceptor that injects the Bearer token into every request.
///
/// Strategy:
/// 1. Before request: get a valid token (refresh proactively if near expiry).
/// 2. If request fails with unauthenticated/permissionDenied: force-refresh
///    and retry exactly once.
/// 3. If retry also fails: trigger logout so user is redirected to login.
class AuthInterceptor {
  AuthInterceptor(this._authRepository, this._onAuthFailure);
  final AuthRepository _authRepository;
  final void Function() _onAuthFailure;

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
        if (e.code != Code.unauthenticated &&
            e.code != Code.permissionDenied) {
          rethrow;
        }
        // Token was rejected by the server — force a fresh token from the
        // OAuth server (ignores cached expiry) and retry once.
        final newToken = await _authRepository.forceRefreshAccessToken();
        if (newToken == null) {
          _onAuthFailure();
          rethrow;
        }
        req.headers['authorization'] = 'Bearer $newToken';
        try {
          return await next(req);
        } on ConnectException catch (retryError) {
          // Retry also failed — session is truly dead.
          if (retryError.code == Code.unauthenticated ||
              retryError.code == Code.permissionDenied) {
            _onAuthFailure();
          }
          rethrow;
        }
      }
    };
  }
}

/// Creates a Connect RPC transport for the given [baseUrl].
Transport _createTransport(Ref ref, String baseUrl) {
  final authRepo = ref.watch(authRepositoryProvider);
  final authInterceptor = AuthInterceptor(authRepo, () {
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
Transport loansTransport(Ref ref) => _createTransport(ref, _loansUrl);

@Riverpod(keepAlive: true)
Transport originationTransport(Ref ref) =>
    _createTransport(ref, _originationUrl);

@Riverpod(keepAlive: true)
Transport identityTransport(Ref ref) =>
    _createTransport(ref, _identityUrl);

@Riverpod(keepAlive: true)
Transport savingsTransport(Ref ref) =>
    _createTransport(ref, _savingsUrl);

@Riverpod(keepAlive: true)
Transport fundingTransport(Ref ref) =>
    _createTransport(ref, _fundingUrl);

@Riverpod(keepAlive: true)
Transport operationsTransport(Ref ref) =>
    _createTransport(ref, _operationsUrl);

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
OriginationServiceClient originationServiceClient(Ref ref) {
  final transport = ref.watch(originationTransportProvider);
  return OriginationServiceClient(transport);
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
Transport profileTransport(Ref ref) => _createTransport(ref, _profileUrl);

@Riverpod(keepAlive: true)
Transport notificationTransport(Ref ref) =>
    _createTransport(ref, _notificationUrl);

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

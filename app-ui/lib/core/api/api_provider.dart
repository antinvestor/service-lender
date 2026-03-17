import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/auth_state_provider.dart';
import '../../sdk/src/lender/v1/field.connect.client.dart';
import '../../sdk/src/lender/v1/identity.connect.client.dart';
import 'http_client_native.dart'
    if (dart.library.js_interop) 'http_client_web.dart';

part 'api_provider.g.dart';

// TODO: Configure for your environment
const _defaultBaseUrl = 'https://api.antinvestor.com/lender';

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

@riverpod
Transport apiTransport(Ref ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final authInterceptor = AuthInterceptor(authRepo, () {
    authRepo.logout();
    ref.invalidate(authStateProvider);
  });

  return protocol.Transport(
    baseUrl: _defaultBaseUrl,
    codec: const ProtoCodec(),
    httpClient: createPlatformHttpClient(),
    interceptors: [authInterceptor.call],
    useHttpGet: true,
  );
}

@riverpod
IdentityServiceClient identityServiceClient(Ref ref) {
  final transport = ref.watch(apiTransportProvider);
  return IdentityServiceClient(transport);
}

@riverpod
FieldServiceClient fieldServiceClient(Ref ref) {
  final transport = ref.watch(apiTransportProvider);
  return FieldServiceClient(transport);
}

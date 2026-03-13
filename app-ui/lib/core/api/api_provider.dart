import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../sdk/src/lender/v1/field.connect.client.dart';
import '../../sdk/src/lender/v1/identity.connect.client.dart';
import 'http_client_native.dart'
    if (dart.library.js_interop) 'http_client_web.dart';

part 'api_provider.g.dart';

// TODO: Configure for your environment
const _defaultBaseUrl = 'https://lender.antinvestor.com';

/// Interceptor that injects the Bearer token into every request.
class AuthInterceptor {
  AuthInterceptor(this._authRepository);
  final AuthRepository _authRepository;

  AnyFn<I, O> call<I extends Object, O extends Object>(AnyFn<I, O> next) {
    return (req) async {
      final token = await _authRepository.ensureValidAccessToken();
      if (token != null) {
        req.headers['authorization'] = 'Bearer $token';
      }
      return next(req);
    };
  }
}

@riverpod
Transport apiTransport(Ref ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final authInterceptor = AuthInterceptor(authRepo);

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

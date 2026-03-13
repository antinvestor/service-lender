import 'package:antinvestor_api_common/antinvestor_api_common.dart';
import 'package:connectrpc/connect.dart' show Interceptor;
import '../lender_sdk.dart';

const String defaultLenderEndpoint = 'https://lender.antinvestor.com';

/// Creates a new Identity service client.
Future<ConnectClientBase<IdentityServiceClient>> newIdentityClient({
  required TransportFactory createTransport,
  String? endpoint,
  TokenManager? tokenManager,
  TokenRefreshCallback? onTokenRefresh,
  List<Interceptor>? additionalInterceptors,
  bool noAuth = false,
}) {
  return newClient<IdentityServiceClient>(
    defaultEndpoint: defaultLenderEndpoint,
    createServiceClient: IdentityServiceClient.new,
    createTransport: createTransport,
    endpoint: endpoint,
    tokenManager: tokenManager,
    onTokenRefresh: onTokenRefresh,
    additionalInterceptors: additionalInterceptors,
    noAuth: noAuth,
  );
}

typedef IdentityClient = ConnectClientBase<IdentityServiceClient>;

/// Creates a new Field service client.
Future<ConnectClientBase<FieldServiceClient>> newFieldClient({
  required TransportFactory createTransport,
  String? endpoint,
  TokenManager? tokenManager,
  TokenRefreshCallback? onTokenRefresh,
  List<Interceptor>? additionalInterceptors,
  bool noAuth = false,
}) {
  return newClient<FieldServiceClient>(
    defaultEndpoint: defaultLenderEndpoint,
    createServiceClient: FieldServiceClient.new,
    createTransport: createTransport,
    endpoint: endpoint,
    tokenManager: tokenManager,
    onTokenRefresh: onTokenRefresh,
    additionalInterceptors: additionalInterceptors,
    noAuth: noAuth,
  );
}

typedef FieldClient = ConnectClientBase<FieldServiceClient>;

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

/// Creates a new Loan Management service client.
Future<ConnectClientBase<LoanManagementServiceClient>> newLoanManagementClient({
  required TransportFactory createTransport,
  String? endpoint,
  TokenManager? tokenManager,
  TokenRefreshCallback? onTokenRefresh,
  List<Interceptor>? additionalInterceptors,
  bool noAuth = false,
}) {
  return newClient<LoanManagementServiceClient>(
    defaultEndpoint: defaultLenderEndpoint,
    createServiceClient: LoanManagementServiceClient.new,
    createTransport: createTransport,
    endpoint: endpoint,
    tokenManager: tokenManager,
    onTokenRefresh: onTokenRefresh,
    additionalInterceptors: additionalInterceptors,
    noAuth: noAuth,
  );
}

typedef LoanManagementClient = ConnectClientBase<LoanManagementServiceClient>;

/// Creates a new Savings service client.
Future<ConnectClientBase<SavingsServiceClient>> newSavingsClient({
  required TransportFactory createTransport,
  String? endpoint,
  TokenManager? tokenManager,
  TokenRefreshCallback? onTokenRefresh,
  List<Interceptor>? additionalInterceptors,
  bool noAuth = false,
}) {
  return newClient<SavingsServiceClient>(
    defaultEndpoint: defaultLenderEndpoint,
    createServiceClient: SavingsServiceClient.new,
    createTransport: createTransport,
    endpoint: endpoint,
    tokenManager: tokenManager,
    onTokenRefresh: onTokenRefresh,
    additionalInterceptors: additionalInterceptors,
    noAuth: noAuth,
  );
}

typedef SavingsClient = ConnectClientBase<SavingsServiceClient>;

/// Creates a new Funding service client.
Future<ConnectClientBase<FundingServiceClient>> newFundingClient({
  required TransportFactory createTransport,
  String? endpoint,
  TokenManager? tokenManager,
  TokenRefreshCallback? onTokenRefresh,
  List<Interceptor>? additionalInterceptors,
  bool noAuth = false,
}) {
  return newClient<FundingServiceClient>(
    defaultEndpoint: defaultLenderEndpoint,
    createServiceClient: FundingServiceClient.new,
    createTransport: createTransport,
    endpoint: endpoint,
    tokenManager: tokenManager,
    onTokenRefresh: onTokenRefresh,
    additionalInterceptors: additionalInterceptors,
    noAuth: noAuth,
  );
}

typedef FundingClient = ConnectClientBase<FundingServiceClient>;

/// Creates a new Operations service client.
Future<ConnectClientBase<OperationsServiceClient>> newOperationsClient({
  required TransportFactory createTransport,
  String? endpoint,
  TokenManager? tokenManager,
  TokenRefreshCallback? onTokenRefresh,
  List<Interceptor>? additionalInterceptors,
  bool noAuth = false,
}) {
  return newClient<OperationsServiceClient>(
    defaultEndpoint: defaultLenderEndpoint,
    createServiceClient: OperationsServiceClient.new,
    createTransport: createTransport,
    endpoint: endpoint,
    tokenManager: tokenManager,
    onTokenRefresh: onTokenRefresh,
    additionalInterceptors: additionalInterceptors,
    noAuth: noAuth,
  );
}

typedef OperationsClient = ConnectClientBase<OperationsServiceClient>;

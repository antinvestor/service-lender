import 'package:antinvestor_api_field/antinvestor_api_field.dart'
    show FieldServiceClient;
import 'package:antinvestor_api_identity/antinvestor_api_identity.dart'
    show IdentityServiceClient;
import 'package:antinvestor_ui_core/api/api_base.dart';
import 'package:connectrpc/connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _identityUrl = String.fromEnvironment(
  'IDENTITY_URL',
  defaultValue: 'https://api.antinvestor.com/identity',
);

/// Transport for the Identity + Field services (co-located).
/// Override in host app's ProviderScope to use a different endpoint.
final identityTransportProvider = Provider<Transport>((ref) {
  final tokenProvider = ref.watch(authTokenProviderProvider);
  return createTransport(tokenProvider, baseUrl: _identityUrl);
});

final identityServiceClientProvider = Provider<IdentityServiceClient>((ref) {
  final transport = ref.watch(identityTransportProvider);
  return IdentityServiceClient(transport);
});

final fieldServiceClientProvider = Provider<FieldServiceClient>((ref) {
  final transport = ref.watch(identityTransportProvider);
  return FieldServiceClient(transport);
});

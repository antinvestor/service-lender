import 'package:antinvestor_api_funding/antinvestor_api_funding.dart';
import 'package:antinvestor_ui_core/api/api_base.dart';
import 'package:connectrpc/connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _fundingUrl = String.fromEnvironment(
  'FUNDING_URL',
  defaultValue: 'https://api.antinvestor.com/funding',
);

final fundingTransportProvider = Provider<Transport>((ref) {
  final tokenProvider = ref.watch(authTokenProviderProvider);
  return createTransport(tokenProvider, baseUrl: _fundingUrl);
});

final fundingServiceClientProvider = Provider<FundingServiceClient>((ref) {
  final transport = ref.watch(fundingTransportProvider);
  return FundingServiceClient(transport);
});

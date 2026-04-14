import 'package:antinvestor_api_savings/antinvestor_api_savings.dart';
import 'package:antinvestor_ui_core/api/api_base.dart';
import 'package:connectrpc/connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _savingsUrl = String.fromEnvironment(
  'SAVINGS_URL',
  defaultValue: 'https://api.antinvestor.com/savings',
);

final savingsTransportProvider = Provider<Transport>((ref) {
  final tokenProvider = ref.watch(authTokenProviderProvider);
  return createTransport(tokenProvider, baseUrl: _savingsUrl);
});

final savingsServiceClientProvider = Provider<SavingsServiceClient>((ref) {
  final transport = ref.watch(savingsTransportProvider);
  return SavingsServiceClient(transport);
});

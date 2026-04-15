import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../../../sdk/src/loans/v1/loans.pb.dart';

part 'portfolio_providers.g.dart';

/// Fetches the portfolio summary with optional filters.
@riverpod
Future<PortfolioSummaryResponse> portfolioSummary(
  Ref ref, {
  String organizationId = '',
  String branchId = '',
  String agentId = '',
  String productId = '',
  String clientId = '',
  String currencyCode = '',
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = PortfolioSummaryRequest(
    organizationId: organizationId,
    branchId: branchId,
    agentId: agentId,
    productId: productId,
    clientId: clientId,
    currencyCode: currencyCode,
  );
  return client.portfolioSummary(request);
}

/// Exports the loan book as CSV bytes with optional filters.
@riverpod
Future<PortfolioExportResponse> portfolioExport(
  Ref ref, {
  String organizationId = '',
  String branchId = '',
  String agentId = '',
  String productId = '',
  String clientId = '',
  String currencyCode = '',
  String format = 'CSV',
}) async {
  final client = ref.watch(loanManagementServiceClientProvider);
  final request = PortfolioExportRequest(
    organizationId: organizationId,
    branchId: branchId,
    agentId: agentId,
    productId: productId,
    clientId: clientId,
    currencyCode: currencyCode,
    format: format,
  );
  return client.portfolioExport(request);
}

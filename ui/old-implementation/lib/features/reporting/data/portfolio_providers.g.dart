// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches the portfolio summary with optional filters.

@ProviderFor(portfolioSummary)
final portfolioSummaryProvider = PortfolioSummaryFamily._();

/// Fetches the portfolio summary with optional filters.

final class PortfolioSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<PortfolioSummaryResponse>,
          PortfolioSummaryResponse,
          FutureOr<PortfolioSummaryResponse>
        >
    with
        $FutureModifier<PortfolioSummaryResponse>,
        $FutureProvider<PortfolioSummaryResponse> {
  /// Fetches the portfolio summary with optional filters.
  PortfolioSummaryProvider._({
    required PortfolioSummaryFamily super.from,
    required ({
      String organizationId,
      String branchId,
      String agentId,
      String productId,
      String clientId,
      String currencyCode,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'portfolioSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$portfolioSummaryHash();

  @override
  String toString() {
    return r'portfolioSummaryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PortfolioSummaryResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PortfolioSummaryResponse> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String organizationId,
              String branchId,
              String agentId,
              String productId,
              String clientId,
              String currencyCode,
            });
    return portfolioSummary(
      ref,
      organizationId: argument.organizationId,
      branchId: argument.branchId,
      agentId: argument.agentId,
      productId: argument.productId,
      clientId: argument.clientId,
      currencyCode: argument.currencyCode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PortfolioSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$portfolioSummaryHash() => r'90567f3627eab1a91899401ac3a92f6697fc1459';

/// Fetches the portfolio summary with optional filters.

final class PortfolioSummaryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PortfolioSummaryResponse>,
          ({
            String organizationId,
            String branchId,
            String agentId,
            String productId,
            String clientId,
            String currencyCode,
          })
        > {
  PortfolioSummaryFamily._()
    : super(
        retry: null,
        name: r'portfolioSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches the portfolio summary with optional filters.

  PortfolioSummaryProvider call({
    String organizationId = '',
    String branchId = '',
    String agentId = '',
    String productId = '',
    String clientId = '',
    String currencyCode = '',
  }) => PortfolioSummaryProvider._(
    argument: (
      organizationId: organizationId,
      branchId: branchId,
      agentId: agentId,
      productId: productId,
      clientId: clientId,
      currencyCode: currencyCode,
    ),
    from: this,
  );

  @override
  String toString() => r'portfolioSummaryProvider';
}

/// Exports the loan book as CSV bytes with optional filters.

@ProviderFor(portfolioExport)
final portfolioExportProvider = PortfolioExportFamily._();

/// Exports the loan book as CSV bytes with optional filters.

final class PortfolioExportProvider
    extends
        $FunctionalProvider<
          AsyncValue<PortfolioExportResponse>,
          PortfolioExportResponse,
          FutureOr<PortfolioExportResponse>
        >
    with
        $FutureModifier<PortfolioExportResponse>,
        $FutureProvider<PortfolioExportResponse> {
  /// Exports the loan book as CSV bytes with optional filters.
  PortfolioExportProvider._({
    required PortfolioExportFamily super.from,
    required ({
      String organizationId,
      String branchId,
      String agentId,
      String productId,
      String clientId,
      String currencyCode,
      String format,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'portfolioExportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$portfolioExportHash();

  @override
  String toString() {
    return r'portfolioExportProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PortfolioExportResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PortfolioExportResponse> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String organizationId,
              String branchId,
              String agentId,
              String productId,
              String clientId,
              String currencyCode,
              String format,
            });
    return portfolioExport(
      ref,
      organizationId: argument.organizationId,
      branchId: argument.branchId,
      agentId: argument.agentId,
      productId: argument.productId,
      clientId: argument.clientId,
      currencyCode: argument.currencyCode,
      format: argument.format,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PortfolioExportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$portfolioExportHash() => r'da1a2e53ce02fb11eb64de0e54fcc58b63612d2a';

/// Exports the loan book as CSV bytes with optional filters.

final class PortfolioExportFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PortfolioExportResponse>,
          ({
            String organizationId,
            String branchId,
            String agentId,
            String productId,
            String clientId,
            String currencyCode,
            String format,
          })
        > {
  PortfolioExportFamily._()
    : super(
        retry: null,
        name: r'portfolioExportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Exports the loan book as CSV bytes with optional filters.

  PortfolioExportProvider call({
    String organizationId = '',
    String branchId = '',
    String agentId = '',
    String productId = '',
    String clientId = '',
    String currencyCode = '',
    String format = 'CSV',
  }) => PortfolioExportProvider._(
    argument: (
      organizationId: organizationId,
      branchId: branchId,
      agentId: agentId,
      productId: productId,
      clientId: clientId,
      currencyCode: currencyCode,
      format: format,
    ),
    from: this,
  );

  @override
  String toString() => r'portfolioExportProvider';
}

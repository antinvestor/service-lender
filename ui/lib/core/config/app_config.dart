/// Environment-aware application configuration.
///
/// Values are injected at build time via `--dart-define` flags.
/// Defaults are set to **development** so `flutter run` works out of the box.
///
/// The define keys match the shared Makefile.common variables so that
/// `make ui-build-prod` passes the right values automatically:
///   OIDC_CLIENT_ID  → AppConfig.oauthClientId
///   OIDC_ISSUER     → AppConfig.oauthIssuerUrl
///   BFF_BASE_URL    → AppConfig.apiBaseUrl
///
/// Production build example:
/// ```
/// make ui-build-prod \
///   OIDC_CLIENT_ID=d6qbqdkpf2t52mcunf60 \
///   BFF_BASE_URL=https://api.antinvestor.com/lender \
///   OIDC_ISSUER=https://oauth2.stawi.org
/// ```
///
/// Development (default — no flags needed):
///   clientId:  d6qbqdkpf2t52mcunf6g  (dev tenant)
///   apiUrl:    https://api-dev.antinvestor.com/lender
///   issuerUrl: https://oauth2.stawi.org
abstract final class AppConfig {
  /// OAuth2 client ID for the current environment.
  /// Makefile passes this as OIDC_CLIENT_ID.
  static const oauthClientId = String.fromEnvironment(
    'OIDC_CLIENT_ID',
    defaultValue: 'd6qbqdkpf2t52mcunf6g', // dev client
  );

  /// OAuth2 issuer URL (OIDC discovery endpoint).
  /// Makefile passes this as OIDC_ISSUER.
  static const oauthIssuerUrl = String.fromEnvironment(
    'OIDC_ISSUER',
    defaultValue: 'https://oauth2.stawi.org',
  );

  /// Base URL for the lender gRPC/Connect API.
  /// Makefile passes this as BFF_BASE_URL.
  static const apiBaseUrl = String.fromEnvironment(
    'BFF_BASE_URL',
    defaultValue: 'https://api-dev.antinvestor.com/lender',
  );
}

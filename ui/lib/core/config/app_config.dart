/// Environment-aware application configuration.
///
/// Values are injected at build time via `--dart-define` flags.
/// Defaults are set to **development** so `flutter run` works out of the box.
///
/// Production build example:
/// ```
/// flutter build web \
///   --dart-define=OAUTH_CLIENT_ID=d6qbqdkpf2t52mcunf60 \
///   --dart-define=API_BASE_URL=https://api.antinvestor.com/lender \
///   --dart-define=OAUTH_ISSUER_URL=https://oauth2.stawi.org
/// ```
///
/// Development (default — no flags needed):
///   clientId:  d6qbqdkpf2t52mcunf6g  (dev tenant)
///   apiUrl:    https://api-dev.antinvestor.com/lender
///   issuerUrl: https://oauth2.stawi.org
abstract final class AppConfig {
  /// OAuth2 client ID for the current environment.
  static const oauthClientId = String.fromEnvironment(
    'OAUTH_CLIENT_ID',
    defaultValue: 'd6qbqdkpf2t52mcunf6g', // dev client
  );

  /// OAuth2 issuer URL (OIDC discovery endpoint).
  static const oauthIssuerUrl = String.fromEnvironment(
    'OAUTH_ISSUER_URL',
    defaultValue: 'https://oauth2.stawi.org',
  );

  /// Base URL for the lender gRPC/Connect API.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-dev.antinvestor.com/lender',
  );
}

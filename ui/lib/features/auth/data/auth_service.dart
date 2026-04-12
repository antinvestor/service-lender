import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openid_client/openid_client.dart';

import '../../../core/config/auth_constants.dart';
import '../../../core/logging/app_logger.dart';
import 'platform/auth_platform.dart';
import 'platform/auth_platform_stub.dart'
    if (dart.library.io) 'platform/auth_platform_io.dart'
    if (dart.library.js_interop) 'platform/auth_platform_web.dart';

class AuthService {
  AuthService(
    this._storage, {
    required String issuerUrl,
    required String clientId,
  }) : _issuerUrl = issuerUrl,
       _activeClientId = clientId,
       _defaultClientId = clientId;

  final FlutterSecureStorage _storage;
  final String _issuerUrl;
  final String _defaultClientId;
  String _activeClientId;
  final AuthPlatform _platform = getAuthPlatform();

  static const _defaultTokenLifetime = Duration(hours: 1);

  // ── In-memory cache ──────────────────────────────────────────────────────
  // Avoids async storage reads on every navigation redirect check.
  bool? _cachedIsAuthenticated;
  String? _cachedAccessToken;
  DateTime? _cachedExpiresAt;
  Timer? _refreshTimer;

  Completer<bool>? _redirectCompleter;
  Completer<TokenResponse?>? _refreshCompleter;

  // ── Initialization ───────────────────────────────────────────────────────

  Future<void> _ensureInitialized() async {
    await _platform.initialize(_issuerUrl, _activeClientId);
  }

  /// Switch to a different OAuth client for login.
  /// Reinitializes the OIDC client and persists the selection.
  Future<void> switchClient(String clientId) async {
    if (clientId == _activeClientId) return;
    // Validate format to prevent injection via deep links.
    if (!clientIdPattern.hasMatch(clientId)) {
      AppLogger.warning('Invalid clientId format rejected: $clientId');
      return;
    }
    _activeClientId = clientId;
    // Force reinitialize with the new client_id
    _platform.reset();
    await _storage.write(key: 'selected_client_id', value: clientId);
  }

  /// Restore the previously selected client_id from storage.
  Future<void> restoreSelectedClient() async {
    final stored = await _storage.read(key: 'selected_client_id');
    if (stored != null && stored.isNotEmpty) {
      _activeClientId = stored;
    }
  }

  /// The currently active client_id.
  String get activeClientId => _activeClientId;

  // ── Authentication ───────────────────────────────────────────────────────

  Future<TokenResponse?> authenticate() async {
    try {
      await _ensureInitialized();

      final token = await _platform.authenticate([
        'openid',
        'profile',
        'offline_access',
      ]);

      if (token != null) {
        if (token.accessToken == null || token.accessToken!.isEmpty) {
          throw Exception('Authentication failed: No access token received');
        }
        await _saveTokens(token);
        return token;
      }
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Authentication failed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> cancelAuthentication() async {
    try {
      await _platform.cancelAuthentication();
    } catch (_) {}
  }

  // ── Token storage ────────────────────────────────────────────────────────

  Future<void> _saveTokens(TokenResponse token) async {
    final expiresAt =
        token.expiresAt ?? DateTime.now().add(_defaultTokenLifetime);

    // Update in-memory cache first (instant for subsequent reads).
    _cachedAccessToken = token.accessToken;
    _cachedExpiresAt = expiresAt;
    _cachedIsAuthenticated = true;

    // Persist to secure storage.
    await _storage.write(key: 'access_token', value: token.accessToken);
    await _storage.write(key: 'refresh_token', value: token.refreshToken);
    try {
      await _storage.write(
        key: 'id_token',
        value: token.idToken.toCompactSerialization(),
      );
    } catch (_) {}
    await _storage.write(
      key: 'token_expires_at',
      value: expiresAt.millisecondsSinceEpoch.toString(),
    );

    // Schedule proactive refresh before the token expires.
    _scheduleRefresh(expiresAt);
  }

  /// Schedules a background refresh 2 minutes before the token expires.
  void _scheduleRefresh(DateTime expiresAt) {
    _refreshTimer?.cancel();
    final refreshAt = expiresAt
        .subtract(const Duration(minutes: 2))
        .difference(DateTime.now());
    if (refreshAt.isNegative) {
      // Already past the refresh window — refresh immediately.
      refreshToken();
      return;
    }
    _refreshTimer = Timer(refreshAt, () {
      refreshToken();
    });
  }

  // ── Token reads (cache-first) ────────────────────────────────────────────

  Future<String?> getAccessToken() async {
    if (_cachedAccessToken != null) return _cachedAccessToken;
    final token = await _storage.read(key: 'access_token');
    _cachedAccessToken = token;
    return token;
  }

  Future<String?> getRefreshToken() async =>
      _storage.read(key: 'refresh_token');

  Future<String?> getIdToken() async => _storage.read(key: 'id_token');

  bool _isTokenExpiredSync() {
    if (_cachedExpiresAt == null) return true;
    return DateTime.now().isAfter(
      _cachedExpiresAt!.subtract(const Duration(minutes: 2)),
    );
  }

  Future<bool> isTokenExpired({
    Duration buffer = const Duration(minutes: 2),
  }) async {
    // Use cached expiry if available.
    if (_cachedExpiresAt != null) {
      return DateTime.now().isAfter(_cachedExpiresAt!.subtract(buffer));
    }
    final expiresAtStr = await _storage.read(key: 'token_expires_at');
    if (expiresAtStr == null) return true;
    try {
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        int.parse(expiresAtStr),
      );
      _cachedExpiresAt = expiresAt;
      return DateTime.now().isAfter(expiresAt.subtract(buffer));
    } catch (_) {
      return true;
    }
  }

  // ── Token refresh ────────────────────────────────────────────────────────

  Future<TokenResponse?> refreshToken() async {
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<TokenResponse?>();

    try {
      final refreshTokenValue = await getRefreshToken();
      if (refreshTokenValue == null) {
        _refreshCompleter!.complete(null);
        return null;
      }

      await _ensureInitialized();

      if (_platform.client == null) {
        _refreshCompleter!.complete(null);
        return null;
      }

      final credential = _platform.client!.createCredential(
        accessToken: await getAccessToken(),
        refreshToken: refreshTokenValue,
      );

      final newCredential = await credential
          .getTokenResponse(true)
          .timeout(const Duration(seconds: 30));

      if (newCredential.accessToken == null ||
          newCredential.accessToken!.isEmpty) {
        _refreshCompleter!.complete(null);
        return null;
      }

      await _saveTokens(newCredential);
      _refreshCompleter!.complete(newCredential);
      return newCredential;
    } catch (e, stackTrace) {
      AppLogger.error('Token refresh failed', error: e, stackTrace: stackTrace);

      final errorStr = e.toString().toLowerCase();
      final isPermanent = _isPermanentRefreshError(errorStr);

      if (isPermanent) {
        await logout();
      }

      _refreshCompleter!.complete(null);
      return null;
    } finally {
      if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
        _refreshCompleter!.complete(null);
      }
      _refreshCompleter = null;
    }
  }

  bool _isPermanentRefreshError(String errorStr) {
    const transientPatterns = [
      'timeout',
      'connection refused',
      'connection reset',
      'network is unreachable',
      'host not found',
      'dns',
      'socket',
      '500',
      '502',
      '503',
      '504',
      '429',
      'service unavailable',
    ];
    for (final pattern in transientPatterns) {
      if (errorStr.contains(pattern)) return false;
    }

    const permanentErrors = [
      'invalid_grant',
      'invalid_client',
      'unauthorized_client',
      'access_denied',
    ];
    for (final error in permanentErrors) {
      if (errorStr.contains(error)) return true;
    }
    return false;
  }

  /// Returns a valid access token, refreshing if expired.
  Future<String?> ensureValidAccessToken() async {
    final accessToken = _cachedAccessToken ?? await getAccessToken();
    if (accessToken != null && !_isTokenExpiredSync()) {
      return accessToken;
    }

    // Cached expiry not available — fall back to storage check.
    if (accessToken != null && _cachedExpiresAt == null) {
      final expired = await isTokenExpired();
      if (!expired) return accessToken;
    }

    final refreshTokenValue = await getRefreshToken();
    if (refreshTokenValue == null) return null;

    final result = await refreshToken();
    return result?.accessToken ?? await getAccessToken();
  }

  /// Force-refresh the access token regardless of expiry.
  /// Clears the in-memory cache so stale tokens are never reused.
  Future<String?> forceRefreshAccessToken() async {
    _cachedAccessToken = null;
    _cachedExpiresAt = null;
    final result = await refreshToken();
    return result?.accessToken ?? await getAccessToken();
  }

  // ── Auth state check (cached) ────────────────────────────────────────────

  /// Fast synchronous check when cache is warm. Returns null if cache is cold.
  bool? get isAuthenticatedSync => _cachedIsAuthenticated;

  Future<bool> isAuthenticated() async {
    // Return cached state instantly if available.
    if (_cachedIsAuthenticated != null) return _cachedIsAuthenticated!;

    // Handle OAuth redirect callback if present.
    if (_platform.hasRedirectResult()) {
      await _handleRedirectResult();
    }

    final accessToken = await getAccessToken();
    if (accessToken != null) {
      _cachedIsAuthenticated = true;
      // Warm expiry cache and schedule proactive refresh.
      await isTokenExpired();
      if (_cachedExpiresAt != null) {
        _scheduleRefresh(_cachedExpiresAt!);
      }
      // Eagerly initialize OIDC client so refresh works when needed.
      _ensureInitialized().ignore();
      return true;
    }

    final refreshTokenValue = await getRefreshToken();
    if (refreshTokenValue != null) {
      _cachedIsAuthenticated = true;
      // Have a refresh token — try to get an access token proactively.
      _ensureInitialized().then((_) => refreshToken()).ignore();
      return true;
    }

    _cachedIsAuthenticated = false;
    return false;
  }

  /// Handles the OAuth redirect result, protected by a completer.
  Future<bool> _handleRedirectResult() async {
    if (_redirectCompleter != null && !_redirectCompleter!.isCompleted) {
      return _redirectCompleter!.future;
    }

    _redirectCompleter = Completer<bool>();

    try {
      await _ensureInitialized();
      final token = await _platform.getRedirectResult();
      if (token != null) {
        await _saveTokens(token);
        _redirectCompleter!.complete(true);
        return true;
      }
      _redirectCompleter!.complete(false);
      return false;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Redirect result handling failed',
        error: e,
        stackTrace: stackTrace,
      );
      _redirectCompleter!.complete(false);
      return false;
    } finally {
      if (_redirectCompleter != null && !_redirectCompleter!.isCompleted) {
        _redirectCompleter!.complete(false);
      }
    }
  }

  // ── User info ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getUserInfo() async {
    final idToken = await getIdToken();
    if (idToken == null) return null;

    try {
      final parts = idToken.split('.');
      if (parts.length != 3) return null;
      final normalized = base64.normalize(parts[1]);
      final decoded = utf8.decode(base64.decode(normalized));
      return json.decode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Extract roles from JWT claims
  Future<List<String>> getUserRoles() async {
    final claims = await getUserInfo();
    if (claims == null) return [];

    final roles = claims['roles'] ?? claims['realm_access']?['roles'];
    if (roles is List) {
      return roles.cast<String>();
    }
    return [];
  }

  // ── Logout ───────────────────────────────────────────────────────────────

  Future<void> logout() async {
    _refreshTimer?.cancel();
    _cachedIsAuthenticated = null;
    _cachedAccessToken = null;
    _cachedExpiresAt = null;

    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'id_token');
    await _storage.delete(key: 'token_expires_at');
    await _storage.delete(key: 'selected_client_id');
    await _storage.delete(key: 'login_context');
    _activeClientId = _defaultClientId;
    _platform.reset();
  }

  /// Store the login context JSON for session restoration.
  Future<void> storeLoginContext(String json) async {
    await _storage.write(key: 'login_context', value: json);
  }

  /// Retrieve the stored login context JSON.
  Future<String?> getStoredLoginContext() async {
    return _storage.read(key: 'login_context');
  }
}

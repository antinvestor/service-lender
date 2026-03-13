import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:openid_client/openid_client.dart';

import '../../../core/logging/app_logger.dart';
import 'platform/auth_platform.dart';
import 'platform/auth_platform_stub.dart'
    if (dart.library.io) 'platform/auth_platform_io.dart'
    if (dart.library.html) 'platform/auth_platform_web.dart';

class AuthService {
  AuthService(
    this._storage, {
    required String issuerUrl,
    required String clientId,
  })  : _issuerUrl = issuerUrl,
        _clientId = clientId;

  final FlutterSecureStorage _storage;
  final String _issuerUrl;
  final String _clientId;
  final AuthPlatform _platform = getAuthPlatform();

  static const _defaultTokenLifetime = Duration(hours: 1);

  Future<void> _ensureInitialized() async {
    await _platform.initialize(_issuerUrl, _clientId);
  }

  Future<TokenResponse?> authenticate() async {
    try {
      await _ensureInitialized();

      final token = await _platform.authenticate([
        'openid',
        'profile',
        'contact',
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
      AppLogger.error('Authentication failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> cancelAuthentication() async {
    try {
      await _platform.cancelAuthentication();
    } catch (_) {}
  }

  Future<void> _saveTokens(TokenResponse token) async {
    await _storage.write(key: 'access_token', value: token.accessToken);
    await _storage.write(key: 'refresh_token', value: token.refreshToken);
    try {
      await _storage.write(
        key: 'id_token',
        value: token.idToken.toCompactSerialization(),
      );
    } catch (_) {}

    final expiresAt =
        token.expiresAt ?? DateTime.now().add(_defaultTokenLifetime);
    await _storage.write(
      key: 'token_expires_at',
      value: expiresAt.millisecondsSinceEpoch.toString(),
    );
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async =>
      _storage.read(key: 'refresh_token');

  Future<String?> getIdToken() async => _storage.read(key: 'id_token');

  Future<bool> isTokenExpired({
    Duration buffer = const Duration(minutes: 2),
  }) async {
    final expiresAtStr = await _storage.read(key: 'token_expires_at');
    if (expiresAtStr == null) return true;

    try {
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        int.parse(expiresAtStr),
      );
      return DateTime.now().isAfter(expiresAt.subtract(buffer));
    } catch (_) {
      return true;
    }
  }

  Completer<TokenResponse?>? _refreshCompleter;

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
      'timeout', 'connection refused', 'connection reset',
      'network is unreachable', 'host not found', 'dns', 'socket',
      '500', '502', '503', '504', '429', 'service unavailable',
    ];

    for (final pattern in transientPatterns) {
      if (errorStr.contains(pattern)) return false;
    }

    const permanentErrors = [
      'invalid_grant', 'invalid_client', 'unauthorized_client', 'access_denied',
    ];

    for (final error in permanentErrors) {
      if (errorStr.contains(error)) return true;
    }

    return false;
  }

  Future<String?> ensureValidAccessToken() async {
    final accessToken = await getAccessToken();
    if (accessToken != null) {
      final expired = await isTokenExpired();
      if (!expired) return accessToken;
    }

    final refreshTokenValue = await getRefreshToken();
    if (refreshTokenValue == null) return null;

    final result = await refreshToken();
    return result?.accessToken ?? await getAccessToken();
  }

  Future<bool> isAuthenticated() async {
    await _handleRedirectResult();
    final accessToken = await getAccessToken();
    if (accessToken != null) return true;
    final refreshTokenValue = await getRefreshToken();
    return refreshTokenValue != null;
  }

  Future<bool> _handleRedirectResult() async {
    try {
      await _ensureInitialized();
      final token = await _platform.getRedirectResult();
      if (token != null) {
        await _saveTokens(token);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

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

    // Try common role claim locations
    final roles = claims['roles'] ?? claims['realm_access']?['roles'];
    if (roles is List) {
      return roles.cast<String>();
    }
    return [];
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'id_token');
    await _storage.delete(key: 'token_expires_at');
  }
}

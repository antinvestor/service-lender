import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:openid_client/openid_client.dart';
import 'package:web/web.dart' as web;

import 'auth_platform.dart';

AuthPlatform getAuthPlatform() => AuthPlatformWeb();

class AuthPlatformWeb implements AuthPlatform {
  static const String _stateKey = 'openid_client:state';
  static const String _codeVerifierKey = 'openid_client:code_verifier';
  static const String _timestampKey = 'openid_client:timestamp';
  static const Duration _stateExpiry = Duration(minutes: 10);
  static const Duration _tokenExchangeTimeout = Duration(seconds: 30);

  Issuer? _issuer;
  Client? _client;

  @override
  Client? get client => _client;

  @override
  Future<void> initialize(String issuerUrl, String clientId) async {
    if (_issuer == null || _client == null) {
      _issuer = await Issuer.discover(Uri.parse(issuerUrl));
      _client = Client(_issuer!, clientId);
    }
  }

  @override
  Future<TokenResponse?> authenticate(List<String> scopes) async {
    if (_client == null) {
      throw StateError('AuthPlatformWeb not initialized');
    }

    _cleanupStaleState();

    final currentUri = Uri.parse(web.window.location.href);
    final redirectUri = Uri(
      scheme: currentUri.scheme,
      host: currentUri.host,
      port: currentUri.port,
      path: currentUri.path,
    );

    final codeVerifier = _generateCodeVerifier();
    final flow =
        Flow.authorizationCodeWithPKCE(_client!, codeVerifier: codeVerifier)
          ..scopes.addAll(scopes)
          ..redirectUri = redirectUri;

    web.window.localStorage.setItem(_stateKey, flow.state);
    web.window.localStorage.setItem(_codeVerifierKey, codeVerifier);
    web.window.localStorage.setItem(
      _timestampKey,
      DateTime.now().millisecondsSinceEpoch.toString(),
    );

    web.window.location.href = flow.authenticationUri.toString();
    return null;
  }

  @override
  Future<TokenResponse?> getRedirectResult() async {
    if (_client == null) return null;

    final uri = Uri.parse(web.window.location.href);
    final code = uri.queryParameters['code'];
    final state = uri.queryParameters['state'];
    final error = uri.queryParameters['error'];
    final errorDescription = uri.queryParameters['error_description'];

    if (error != null) {
      _clearAuthState();
      _cleanUrl(uri);
      throw Exception('Authentication failed: ${errorDescription ?? error}');
    }

    if (code == null || state == null) return null;

    final storedState = web.window.localStorage.getItem(_stateKey);
    final storedCodeVerifier = web.window.localStorage.getItem(_codeVerifierKey);
    final storedTimestamp = web.window.localStorage.getItem(_timestampKey);

    if (storedState != state || storedCodeVerifier == null) {
      _clearAuthState();
      _cleanUrl(uri);
      return null;
    }

    if (storedTimestamp != null) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(storedTimestamp) ?? 0,
      );
      if (DateTime.now().difference(timestamp) > _stateExpiry) {
        _clearAuthState();
        _cleanUrl(uri);
        return null;
      }
    }

    try {
      _cleanUrl(uri);

      final redirectUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: uri.path,
      );

      final flow = Flow.authorizationCodeWithPKCE(
        _client!,
        state: storedState,
        codeVerifier: storedCodeVerifier,
      )..redirectUri = redirectUri;

      final credential = await flow
          .callback({'code': code, 'state': state})
          .timeout(_tokenExchangeTimeout);

      final tokenResponse = await credential
          .getTokenResponse()
          .timeout(_tokenExchangeTimeout);

      _clearAuthState();
      return tokenResponse;
    } catch (e) {
      _clearAuthState();
      rethrow;
    }
  }

  void _cleanUrl(Uri uri) {
    final cleanUri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: uri.path,
    );
    web.window.history.replaceState(null, '', cleanUri.toString());
  }

  void _clearAuthState() {
    web.window.localStorage.removeItem(_stateKey);
    web.window.localStorage.removeItem(_codeVerifierKey);
    web.window.localStorage.removeItem(_timestampKey);
  }

  void _cleanupStaleState() {
    final storedTimestamp = web.window.localStorage.getItem(_timestampKey);
    if (storedTimestamp != null) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(storedTimestamp) ?? 0,
      );
      if (DateTime.now().difference(timestamp) > _stateExpiry) {
        _clearAuthState();
      }
    }
  }

  @override
  Future<void> cancelAuthentication() async {
    _clearAuthState();
  }

  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }
}

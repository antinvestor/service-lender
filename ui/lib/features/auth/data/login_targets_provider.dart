import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/config/auth_constants.dart';
import 'login_target.dart';

part 'login_targets_provider.g.dart';

const _identityUrl = String.fromEnvironment(
  'IDENTITY_URL',
  defaultValue: 'https://api.antinvestor.com/identity',
);

/// Fetches login targets (child orgs/branches) for a given OAuth client_id.
/// This is an unauthenticated call — used on the login page before sign-in.
@riverpod
Future<LoginTargetsResponse> loginTargets(Ref ref, String clientId) async {
  // Validate clientId format to prevent path traversal or injection.
  if (!clientIdPattern.hasMatch(clientId)) {
    debugPrint('Invalid clientId format: $clientId');
    return const LoginTargetsResponse(
      targets: [],
      currentName: '',
      currentType: 'root',
    );
  }

  final url = Uri.parse('$_identityUrl/api/v1/login-targets/$clientId');

  try {
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      debugPrint('Login targets request failed: ${response.statusCode}');
      return const LoginTargetsResponse(
        targets: [],
        currentName: '',
        currentType: 'root',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return LoginTargetsResponse.fromJson(json);
  } catch (e) {
    debugPrint('Failed to fetch login targets: $e');
    return const LoginTargetsResponse(
      targets: [],
      currentName: '',
      currentType: 'root',
    );
  }
}

/// The root client_id from build config — starting point for drill-down.
String get rootClientId => AppConfig.oauthClientId;

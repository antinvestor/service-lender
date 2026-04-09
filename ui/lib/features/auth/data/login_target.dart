/// A login target representing an organization or branch that a user can authenticate into.
class LoginTarget {
  const LoginTarget({
    required this.name,
    required this.code,
    required this.clientId,
    required this.type,
  });

  factory LoginTarget.fromJson(Map<String, dynamic> json) {
    return LoginTarget(
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      clientId: json['client_id'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  final String name;
  final String code;
  final String clientId;

  /// "organization" or "branch"
  final String type;

  bool get isOrganization => type == 'organization';
  bool get isBranch => type == 'branch';
}

/// Response from the login targets endpoint.
class LoginTargetsResponse {
  const LoginTargetsResponse({
    required this.targets,
    required this.currentName,
    required this.currentType,
  });

  factory LoginTargetsResponse.fromJson(Map<String, dynamic> json) {
    final targetsJson = json['targets'] as List<dynamic>? ?? [];
    final current = json['current'] as Map<String, dynamic>? ?? {};
    return LoginTargetsResponse(
      targets: targetsJson
          .map((e) => LoginTarget.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentName: current['name'] as String? ?? '',
      currentType: current['type'] as String? ?? 'root',
    );
  }

  final List<LoginTarget> targets;
  final String currentName;

  /// "root", "organization", or "branch"
  final String currentType;
}

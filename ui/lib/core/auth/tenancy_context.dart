import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';

part 'tenancy_context.g.dart';

/// The level at which the user authenticated.
/// Determines which tenancy selectors are available post-login.
enum LoginLevel {
  /// Authenticated at the root/platform level — can select org then branch.
  root,

  /// Authenticated at the organization level — can only select a branch.
  organization,

  /// Authenticated at the branch level — fully scoped, no selection needed.
  branch,
}

/// The active tenancy context for the current user session.
///
/// Tracks the selected organization and branch within the user's partition.
/// This context cascades through the hierarchy:
///   partition (from JWT) → organization → branch → agent
///
/// The [loginLevel] determines which selections the user can make:
///   - root: pick org → pick branch
///   - organization: pick branch (org is fixed from login)
///   - branch: fully scoped (nothing to pick)
///
/// Screens that create entities should read from this context to auto-populate
/// the parent references (organization_id, branch_id, etc.).
class TenancyContext extends ChangeNotifier {
  String _partitionId = '';
  String _partitionName = '';
  String _organizationId = '';
  String _organizationName = '';
  String _branchId = '';
  String _branchName = '';
  LoginLevel _loginLevel = LoginLevel.root;

  String get partitionId => _partitionId;
  String get partitionName => _partitionName;
  String get organizationId => _organizationId;
  String get organizationName => _organizationName;
  String get branchId => _branchId;
  String get branchName => _branchName;
  LoginLevel get loginLevel => _loginLevel;

  bool get hasPartition => _partitionId.isNotEmpty;
  bool get hasOrganization => _organizationId.isNotEmpty;
  bool get hasBranch => _branchId.isNotEmpty;

  /// Whether the user can select an organization (only at root level).
  bool get canSelectOrganization => _loginLevel == LoginLevel.root;

  /// Whether the user can select a branch (root or org level).
  bool get canSelectBranch => _loginLevel != LoginLevel.branch;

  /// Initialize tenancy context from the login level.
  /// For org/branch level logins, pre-populates the fixed context.
  void initializeFromLogin(
    LoginLevel level, {
    String? partitionId,
    String? partitionName,
    String? orgId,
    String? orgName,
    String? branchId,
    String? branchName,
  }) {
    _loginLevel = level;
    if (partitionId != null) {
      _partitionId = partitionId;
      _partitionName = partitionName ?? '';
    }
    if (orgId != null) {
      _organizationId = orgId;
      _organizationName = orgName ?? '';
    }
    if (branchId != null) {
      _branchId = branchId;
      _branchName = branchName ?? '';
    }
    notifyListeners();
  }

  void selectPartition(String id, String name) {
    if (!canSelectOrganization) return; // locked by login level
    if (_partitionId != id) {
      _partitionId = id;
      _partitionName = name;
      // Clear child selections when partition changes
      _organizationId = '';
      _organizationName = '';
      _branchId = '';
      _branchName = '';
      notifyListeners();
    }
  }

  void selectOrganization(String id, String name,
      {String? partitionId, String? partitionName}) {
    if (!canSelectOrganization) return; // locked by login level
    if (_organizationId != id) {
      _organizationId = id;
      _organizationName = name;
      // Update partition context when an organization is selected
      if (partitionId != null && partitionId.isNotEmpty) {
        _partitionId = partitionId;
        _partitionName = partitionName ?? '';
      }
      // Clear child selections when parent changes
      _branchId = '';
      _branchName = '';
      notifyListeners();
    }
  }

  void selectBranch(String id, String name,
      {String? partitionId, String? partitionName}) {
    if (!canSelectBranch) return; // locked by login level
    if (_branchId != id) {
      _branchId = id;
      _branchName = name;
      // Update partition context when a branch is selected
      if (partitionId != null && partitionId.isNotEmpty) {
        _partitionId = partitionId;
        _partitionName = partitionName ?? '';
      }
      notifyListeners();
    }
  }

  void clear() {
    _partitionId = '';
    _partitionName = '';
    _organizationId = '';
    _organizationName = '';
    _branchId = '';
    _branchName = '';
    _loginLevel = LoginLevel.root;
    notifyListeners();
  }

  /// Breadcrumb trail for display.
  List<String> get breadcrumbs {
    final trail = <String>[];
    if (_partitionName.isNotEmpty) trail.add(_partitionName);
    if (_organizationName.isNotEmpty) trail.add(_organizationName);
    if (_branchName.isNotEmpty) trail.add(_branchName);
    return trail;
  }
}

@Riverpod(keepAlive: true)
TenancyContext tenancyContext(Ref ref) {
  return TenancyContext();
}

/// Convenience: the current user's partition ID from JWT.
/// Re-exported here so tenancy-related code has a single import.
@Riverpod(keepAlive: true)
Future<String> activePartitionId(Ref ref) async {
  final id = await ref.watch(currentPartitionIdProvider.future);
  return id ?? '';
}

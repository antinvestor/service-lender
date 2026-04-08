import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/auth_repository.dart';

part 'tenancy_context.g.dart';

/// The active tenancy context for the current user session.
///
/// Tracks the selected organization and branch within the user's partition.
/// This context cascades through the hierarchy:
///   partition (from JWT) → organization → branch → agent
///
/// Screens that create entities should read from this context to auto-populate
/// the parent references (organization_id, branch_id, etc.).
class TenancyContext extends ChangeNotifier {
  String _organizationId = '';
  String _organizationName = '';
  String _branchId = '';
  String _branchName = '';

  String get organizationId => _organizationId;
  String get organizationName => _organizationName;
  String get branchId => _branchId;
  String get branchName => _branchName;

  bool get hasOrganization => _organizationId.isNotEmpty;
  bool get hasBranch => _branchId.isNotEmpty;

  void selectOrganization(String id, String name) {
    if (_organizationId != id) {
      _organizationId = id;
      _organizationName = name;
      // Clear child selections when parent changes
      _branchId = '';
      _branchName = '';
      notifyListeners();
    }
  }

  void selectBranch(String id, String name) {
    if (_branchId != id) {
      _branchId = id;
      _branchName = name;
      notifyListeners();
    }
  }

  void clear() {
    _organizationId = '';
    _organizationName = '';
    _branchId = '';
    _branchName = '';
    notifyListeners();
  }

  /// Breadcrumb trail for display.
  List<String> get breadcrumbs {
    final trail = <String>[];
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

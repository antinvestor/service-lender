import 'package:antinvestor_api_identity/antinvestor_api_identity.dart';

/// Human-readable label for an OrgUnitType.
String orgUnitTypeLabel(OrgUnitType type) {
  switch (type) {
    case OrgUnitType.ORG_UNIT_TYPE_REGION:
      return 'Region';
    case OrgUnitType.ORG_UNIT_TYPE_ZONE:
      return 'Zone';
    case OrgUnitType.ORG_UNIT_TYPE_AREA:
      return 'Area';
    case OrgUnitType.ORG_UNIT_TYPE_CLUSTER:
      return 'Cluster';
    case OrgUnitType.ORG_UNIT_TYPE_BRANCH:
      return 'Branch';
    case OrgUnitType.ORG_UNIT_TYPE_OTHER:
      return 'Other';
    case OrgUnitType.ORG_UNIT_TYPE_UNSPECIFIED:
      return 'Unspecified';
  }
  return 'Unspecified';
}

/// Editable org unit types for dropdowns.
const editableOrgUnitTypes = <OrgUnitType>[
  OrgUnitType.ORG_UNIT_TYPE_REGION,
  OrgUnitType.ORG_UNIT_TYPE_ZONE,
  OrgUnitType.ORG_UNIT_TYPE_AREA,
  OrgUnitType.ORG_UNIT_TYPE_CLUSTER,
  OrgUnitType.ORG_UNIT_TYPE_BRANCH,
  OrgUnitType.ORG_UNIT_TYPE_OTHER,
];

/// Human-readable label for a WorkforceEngagementType.
String engagementLabel(WorkforceEngagementType type) => switch (type) {
      WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_EMPLOYEE => 'Employee',
      WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_CONTRACTOR =>
        'Contractor',
      WorkforceEngagementType.WORKFORCE_ENGAGEMENT_TYPE_SERVICE_ACCOUNT =>
        'Service Account',
      _ => 'Unspecified',
    };

/// Human-readable label for a TeamMembershipRole.
String teamRoleLabel(TeamMembershipRole role) => switch (role) {
      TeamMembershipRole.TEAM_MEMBERSHIP_ROLE_LEAD => 'Lead',
      TeamMembershipRole.TEAM_MEMBERSHIP_ROLE_DEPUTY => 'Deputy',
      TeamMembershipRole.TEAM_MEMBERSHIP_ROLE_MEMBER => 'Member',
      TeamMembershipRole.TEAM_MEMBERSHIP_ROLE_SPECIALIST => 'Specialist',
      _ => 'Unspecified',
    };

/// Human-readable label for an AccessScopeType.
String scopeLabel(AccessScopeType scope) => switch (scope) {
      AccessScopeType.ACCESS_SCOPE_TYPE_GLOBAL => 'Global',
      AccessScopeType.ACCESS_SCOPE_TYPE_ORGANIZATION => 'Organization',
      AccessScopeType.ACCESS_SCOPE_TYPE_ORG_UNIT => 'Org Unit',
      AccessScopeType.ACCESS_SCOPE_TYPE_TEAM => 'Team',
      _ => 'Unspecified',
    };

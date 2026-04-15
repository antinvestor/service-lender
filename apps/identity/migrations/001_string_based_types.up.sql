-- Migration: Convert enum-backed int columns to organization-defined string columns
-- These fields were hardcoded enums (WorkforceEngagementType, TeamType, TeamMembershipRole)
-- and are now organization-defined strings.

-- workforce_members.engagement_type: int → varchar(50)
-- Map existing values: 0→'', 1→'employee', 2→'contractor', 3→'service_account', 4→'agent', 5→'volunteer', 6→'intern'
ALTER TABLE workforce_members
  ADD COLUMN IF NOT EXISTS engagement_type_new VARCHAR(50) DEFAULT '';

UPDATE workforce_members SET engagement_type_new = CASE
  WHEN engagement_type = 1 THEN 'employee'
  WHEN engagement_type = 2 THEN 'contractor'
  WHEN engagement_type = 3 THEN 'service_account'
  WHEN engagement_type = 4 THEN 'agent'
  WHEN engagement_type = 5 THEN 'volunteer'
  WHEN engagement_type = 6 THEN 'intern'
  ELSE ''
END;

ALTER TABLE workforce_members DROP COLUMN IF EXISTS engagement_type;
ALTER TABLE workforce_members RENAME COLUMN engagement_type_new TO engagement_type;

-- internal_teams.team_type: int → varchar(50)
-- Map existing values: 0→'', 1→'portfolio', 2→'servicing', 3→'collections', 4→'sales', 5→'pilot', 6→'shared_service'
ALTER TABLE internal_teams
  ADD COLUMN IF NOT EXISTS team_type_new VARCHAR(50) DEFAULT '';

UPDATE internal_teams SET team_type_new = CASE
  WHEN team_type = 1 THEN 'portfolio'
  WHEN team_type = 2 THEN 'servicing'
  WHEN team_type = 3 THEN 'collections'
  WHEN team_type = 4 THEN 'sales'
  WHEN team_type = 5 THEN 'pilot'
  WHEN team_type = 6 THEN 'shared_service'
  ELSE ''
END;

ALTER TABLE internal_teams DROP COLUMN IF EXISTS team_type;
ALTER TABLE internal_teams RENAME COLUMN team_type_new TO team_type;

-- team_memberships.membership_role: int → varchar(50)
-- Map existing values: 0→'', 1→'lead', 2→'deputy', 3→'member', 4→'specialist', 5→'supervisor', 6→'coordinator'
ALTER TABLE team_memberships
  ADD COLUMN IF NOT EXISTS membership_role_new VARCHAR(50) DEFAULT '';

UPDATE team_memberships SET membership_role_new = CASE
  WHEN membership_role = 1 THEN 'lead'
  WHEN membership_role = 2 THEN 'deputy'
  WHEN membership_role = 3 THEN 'member'
  WHEN membership_role = 4 THEN 'specialist'
  WHEN membership_role = 5 THEN 'supervisor'
  WHEN membership_role = 6 THEN 'coordinator'
  ELSE ''
END;

ALTER TABLE team_memberships DROP COLUMN IF EXISTS membership_role;
ALTER TABLE team_memberships RENAME COLUMN membership_role_new TO membership_role;

-- Add new fields from proto changes
ALTER TABLE organizations ADD COLUMN IF NOT EXISTS domain VARCHAR(255) DEFAULT '';
ALTER TABLE organizations ADD COLUMN IF NOT EXISTS organization_type INTEGER DEFAULT 0;
ALTER TABLE org_units ADD COLUMN IF NOT EXISTS profile_id VARCHAR(50) DEFAULT '';

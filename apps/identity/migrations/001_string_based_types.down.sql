-- Rollback: Convert string columns back to integer enum columns

-- workforce_members.engagement_type: varchar → int
ALTER TABLE workforce_members
  ADD COLUMN IF NOT EXISTS engagement_type_old INTEGER DEFAULT 0;

UPDATE workforce_members SET engagement_type_old = CASE
  WHEN engagement_type = 'employee' THEN 1
  WHEN engagement_type = 'contractor' THEN 2
  WHEN engagement_type = 'service_account' THEN 3
  WHEN engagement_type = 'agent' THEN 4
  WHEN engagement_type = 'volunteer' THEN 5
  WHEN engagement_type = 'intern' THEN 6
  ELSE 0
END;

ALTER TABLE workforce_members DROP COLUMN IF EXISTS engagement_type;
ALTER TABLE workforce_members RENAME COLUMN engagement_type_old TO engagement_type;

-- internal_teams.team_type: varchar → int
ALTER TABLE internal_teams
  ADD COLUMN IF NOT EXISTS team_type_old INTEGER DEFAULT 0;

UPDATE internal_teams SET team_type_old = CASE
  WHEN team_type = 'portfolio' THEN 1
  WHEN team_type = 'servicing' THEN 2
  WHEN team_type = 'collections' THEN 3
  WHEN team_type = 'sales' THEN 4
  WHEN team_type = 'pilot' THEN 5
  WHEN team_type = 'shared_service' THEN 6
  ELSE 0
END;

ALTER TABLE internal_teams DROP COLUMN IF EXISTS team_type;
ALTER TABLE internal_teams RENAME COLUMN team_type_old TO team_type;

-- team_memberships.membership_role: varchar → int
ALTER TABLE team_memberships
  ADD COLUMN IF NOT EXISTS membership_role_old INTEGER DEFAULT 0;

UPDATE team_memberships SET membership_role_old = CASE
  WHEN membership_role = 'lead' THEN 1
  WHEN membership_role = 'deputy' THEN 2
  WHEN membership_role = 'member' THEN 3
  WHEN membership_role = 'specialist' THEN 4
  WHEN membership_role = 'supervisor' THEN 5
  WHEN membership_role = 'coordinator' THEN 6
  ELSE 0
END;

ALTER TABLE team_memberships DROP COLUMN IF EXISTS membership_role;
ALTER TABLE team_memberships RENAME COLUMN membership_role_old TO membership_role;

-- Remove new fields
ALTER TABLE organizations DROP COLUMN IF EXISTS domain;
ALTER TABLE organizations DROP COLUMN IF EXISTS organization_type;
ALTER TABLE org_units DROP COLUMN IF EXISTS profile_id;

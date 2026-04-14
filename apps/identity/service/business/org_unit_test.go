package business

import (
	"context"
	"testing"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"github.com/golang-jwt/jwt/v5"
	"github.com/pitabwire/frame"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/frametests"
	"github.com/pitabwire/frame/frametests/definition"
	"github.com/pitabwire/frame/frametests/deps/testpostgres"
	"github.com/pitabwire/frame/security"
	"github.com/pitabwire/util"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"

	identityevents "github.com/antinvestor/service-fintech/apps/identity/service/events"
	"github.com/antinvestor/service-fintech/apps/identity/service/models"
	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type orgUnitSuite struct {
	frametests.FrameBaseTestSuite
}

type orgUnitTestEnv struct {
	t                *testing.T
	ctx              context.Context
	organizationRepo repository.OrganizationRepository
	orgUnitRepo      repository.OrgUnitRepository
	orgUnitBusiness  OrgUnitBusiness
	orgBusiness      OrganizationBusiness
}

func TestOrgUnitSuite(t *testing.T) {
	suite.Run(t, new(orgUnitSuite))
}

func (s *orgUnitSuite) SetupSuite() {
	s.InitResourceFunc = func(_ context.Context) []definition.TestResource {
		return []definition.TestResource{
			testpostgres.NewWithOpts(
				"identity_org_unit",
				definition.WithUserName("ant"),
				definition.WithCredential("s3cr3t"),
				definition.WithEnableLogging(false),
			),
		}
	}
	s.FrameBaseTestSuite.SetupSuite()
}

func (s *orgUnitSuite) newEnv() *orgUnitTestEnv {
	s.T().Helper()

	ctx := s.T().Context()
	ctx = (&security.AuthenticationClaims{
		TenantID:    "tenant-test",
		PartitionID: "partition-test",
		RegisteredClaims: jwt.RegisteredClaims{
			Subject: "profile-requestor",
		},
	}).ClaimsToContext(ctx)

	db := s.databaseResource(ctx)
	dsn, cleanup, err := db.GetRandomisedDS(ctx, util.RandomAlphaNumericString(8))
	s.Require().NoError(err)
	s.T().Cleanup(func() { cleanup(ctx) })

	ctx, svc := frame.NewServiceWithContext(
		ctx,
		frame.WithName("identity-org-unit-test"),
		frame.WithDatastore(pool.WithConnection(dsn.String(), false)),
	)
	s.T().Cleanup(func() { svc.Stop(ctx) })

	svc.Init(ctx)

	dbPool := svc.DatastoreManager().GetPool(ctx, datastore.DefaultPoolName)
	s.Require().NotNil(dbPool)
	workMan := svc.WorkManager()

	s.Require().NoError(dbPool.DB(ctx, false).AutoMigrate(
		&models.Organization{},
		&models.Branch{},
		&models.ApprovalCase{},
	))

	organizationRepo := repository.NewOrganizationRepository(ctx, dbPool, workMan)
	orgUnitRepo := repository.NewOrgUnitRepository(ctx, dbPool, workMan)
	branchRepo := repository.NewBranchRepository(ctx, dbPool, workMan)
	approvalCaseRepo := repository.NewApprovalCaseRepository(ctx, dbPool, workMan)

	evtsMan := newImmediateEventsManager(
		identityevents.NewOrganizationSave(ctx, organizationRepo),
		identityevents.NewBranchSave(ctx, branchRepo),
		identityevents.NewApprovalCaseSave(ctx, approvalCaseRepo),
	)

	approvalCaseBusiness := NewApprovalCaseBusiness(ctx, evtsMan, approvalCaseRepo, nil)
	orgUnitBusiness := NewOrgUnitBusiness(
		ctx,
		evtsMan,
		organizationRepo,
		orgUnitRepo,
		nil,
		approvalCaseBusiness,
	)
	orgBusiness := NewOrganizationBusiness(ctx, evtsMan, organizationRepo, nil)

	return &orgUnitTestEnv{
		t:                s.T(),
		ctx:              ctx,
		organizationRepo: organizationRepo,
		orgUnitRepo:      orgUnitRepo,
		orgUnitBusiness:  orgUnitBusiness,
		orgBusiness:      orgBusiness,
	}
}

func (s *orgUnitSuite) databaseResource(ctx context.Context) definition.DependancyConn {
	s.T().Helper()
	for _, resource := range s.Resources() {
		if resource.Name() == testpostgres.PostgresqlDBImage && resource.GetDS(ctx).IsDB() {
			return resource
		}
	}
	s.T().Fatal("postgres test resource not found")
	return nil
}

func (e *orgUnitTestEnv) createOrganization(name, code, geoID string) *models.Organization {
	e.t.Helper()
	claims := security.ClaimsFromContext(e.ctx)
	org := &models.Organization{
		Name:       name,
		Code:       code,
		GeoID:      geoID,
		State:      int32(commonv1.STATE_ACTIVE),
		ProfileID:  util.IDString(),
		ClientID:   util.IDString(),
		Properties: data.JSONMap{},
	}
	org.GenID(e.ctx)
	if claims != nil {
		org.TenantID = claims.GetTenantID()
		org.PartitionID = claims.GetPartitionID()
	}
	require.NoError(e.t, e.organizationRepo.Create(e.ctx, org))
	return org
}

func (e *orgUnitTestEnv) createOrgUnit(
	org *models.Organization,
	name, code, geoID, parentID string,
	unitType identityv1.OrgUnitType,
) *models.Branch {
	e.t.Helper()
	claims := security.ClaimsFromContext(e.ctx)
	unit := &models.Branch{
		OrganizationID: org.GetID(),
		ParentID:       parentID,
		Name:           name,
		Code:           code,
		GeoID:          geoID,
		UnitType:       int32(unitType),
		State:          int32(commonv1.STATE_ACTIVE),
		Properties:     data.JSONMap{},
	}
	unit.GenID(e.ctx)
	if claims != nil {
		unit.TenantID = claims.GetTenantID()
		unit.PartitionID = claims.GetPartitionID()
	}
	require.NoError(e.t, e.orgUnitRepo.Create(e.ctx, unit))
	return unit
}

// --- Test 1: OrgUnitSearch rootOnly returns only root org units ---

func (s *orgUnitSuite) TestOrgUnitSearchRootOnlyReturnsOnlyRootUnits() {
	env := s.newEnv()
	org := env.createOrganization("Org Root Search", "org-root-search", "nairobi")

	// Create a root unit (no parent).
	root := env.createOrgUnit(org, "HQ", "hq-root", "nairobi", "", identityv1.OrgUnitType_ORG_UNIT_TYPE_REGION)

	// Create a child unit under the root.
	env.createOrgUnit(
		org,
		"Sub Branch",
		"sub-branch",
		"mombasa",
		root.GetID(),
		identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH,
	)

	var results []*identityv1.OrgUnitObject
	err := env.orgUnitBusiness.Search(env.ctx, &identityv1.OrgUnitSearchRequest{
		OrganizationId: org.GetID(),
		RootOnly:       true,
	}, func(_ context.Context, batch []*identityv1.OrgUnitObject) error {
		results = append(results, batch...)
		return nil
	})
	s.Require().NoError(err)

	// Only the root unit should be returned.
	s.Require().Len(results, 1)
	s.Equal(root.GetID(), results[0].GetId())
	s.Equal("HQ", results[0].GetName())
}

func (s *orgUnitSuite) TestOrgUnitSearchWithoutRootOnlyReturnsAllUnits() {
	env := s.newEnv()
	org := env.createOrganization("Org All Search", "org-all-search", "kampala")

	root := env.createOrgUnit(
		org,
		"Head Office",
		"head-office",
		"kampala",
		"",
		identityv1.OrgUnitType_ORG_UNIT_TYPE_REGION,
	)
	env.createOrgUnit(
		org,
		"Field Office",
		"field-office",
		"gulu",
		root.GetID(),
		identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH,
	)

	var results []*identityv1.OrgUnitObject
	err := env.orgUnitBusiness.Search(env.ctx, &identityv1.OrgUnitSearchRequest{
		OrganizationId: org.GetID(),
	}, func(_ context.Context, batch []*identityv1.OrgUnitObject) error {
		results = append(results, batch...)
		return nil
	})
	s.Require().NoError(err)

	// Both units should be returned.
	s.Require().Len(results, 2)
}

// --- Test 2: OrganizationSave requires geoId ---

func (s *orgUnitSuite) TestOrganizationSaveWithoutGeoIdReturnsError() {
	env := s.newEnv()

	_, err := env.orgBusiness.Save(env.ctx, &identityv1.OrganizationObject{
		Name: "Missing Geo Org",
		Code: "missing-geo-org",
		// GeoId intentionally omitted.
	})
	s.Require().Error(err)
	s.ErrorIs(err, ErrCoverageAreaRequired)
}

func (s *orgUnitSuite) TestOrganizationSaveWithEmptyGeoIdReturnsError() {
	env := s.newEnv()

	_, err := env.orgBusiness.Save(env.ctx, &identityv1.OrganizationObject{
		Name:  "Empty Geo Org",
		Code:  "empty-geo-org",
		GeoId: "   ", // whitespace-only should also be rejected.
	})
	s.Require().Error(err)
	s.ErrorIs(err, ErrCoverageAreaRequired)
}

func (s *orgUnitSuite) TestOrganizationSaveWithValidGeoIdSucceeds() {
	env := s.newEnv()

	result, err := env.orgBusiness.Save(env.ctx, &identityv1.OrganizationObject{
		Name:  "Valid Geo Org",
		Code:  "valid-geo-org",
		GeoId: "nairobi",
	})
	s.Require().NoError(err)
	s.Require().NotNil(result)
	s.NotEmpty(result.GetId())
	s.Equal("nairobi", result.GetGeoId())
}

// --- Test 3: OrganizationSave with properties round-trips ---

func (s *orgUnitSuite) TestOrganizationSaveWithPropertiesRoundTrips() {
	env := s.newEnv()

	props := propertiesStruct(map[string]any{
		"description": "A leading microfinance institution",
		"contacts":    "info@example.com",
		"address":     "123 Main Street, Nairobi",
	})

	result, err := env.orgBusiness.Save(env.ctx, &identityv1.OrganizationObject{
		Name:       "Props Org",
		Code:       "props-org",
		GeoId:      "nairobi",
		Properties: props,
	})
	s.Require().NoError(err)
	s.Require().NotNil(result)

	// Fetch the saved organization and verify properties are stored.
	fetched, err := env.orgBusiness.Get(env.ctx, result.GetId())
	s.Require().NoError(err)
	s.Require().NotNil(fetched.GetProperties())

	fetchedProps := fetched.GetProperties().AsMap()
	s.Equal("A leading microfinance institution", fetchedProps["description"])
	s.Equal("info@example.com", fetchedProps["contacts"])
	s.Equal("123 Main Street, Nairobi", fetchedProps["address"])
}

// --- Test 4: OrgUnitSave requires geoId ---

func (s *orgUnitSuite) TestOrgUnitSaveWithoutGeoIdReturnsError() {
	env := s.newEnv()
	org := env.createOrganization("Org Unit Geo Test", "org-unit-geo-test", "kampala")

	_, err := env.orgUnitBusiness.Save(env.ctx, &identityv1.OrgUnitObject{
		OrganizationId: org.GetID(),
		Name:           "No Geo Unit",
		Code:           "no-geo-unit",
		Type:           identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH,
		// GeoId intentionally omitted.
	})
	s.Require().Error(err)
	s.ErrorIs(err, ErrCoverageAreaRequired)
}

func (s *orgUnitSuite) TestOrgUnitSaveWithEmptyGeoIdReturnsError() {
	env := s.newEnv()
	org := env.createOrganization("Org Unit Empty Geo", "org-unit-empty-geo", "kampala")

	_, err := env.orgUnitBusiness.Save(env.ctx, &identityv1.OrgUnitObject{
		OrganizationId: org.GetID(),
		Name:           "Empty Geo Unit",
		Code:           "empty-geo-unit",
		GeoId:          "  ",
		Type:           identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH,
	})
	s.Require().Error(err)
	s.ErrorIs(err, ErrCoverageAreaRequired)
}

func (s *orgUnitSuite) TestOrgUnitSaveWithValidGeoIdSucceeds() {
	env := s.newEnv()
	org := env.createOrganization("Org Unit Valid Geo", "org-unit-valid-geo", "kampala")

	result, err := env.orgUnitBusiness.Save(env.ctx, &identityv1.OrgUnitObject{
		OrganizationId: org.GetID(),
		Name:           "Kampala Branch",
		Code:           "kampala-branch",
		GeoId:          "kampala",
		Type:           identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH,
	})
	s.Require().NoError(err)
	s.Require().NotNil(result)
	s.NotEmpty(result.GetId())
	s.Equal("kampala", result.GetGeoId())
}

func (s *orgUnitSuite) TestOrgUnitSaveInheritsOrganizationPartition() {
	env := s.newEnv()
	org := env.createOrganization("Org Inherit Partition", "org-inherit-partition", "kampala")

	result, err := env.orgUnitBusiness.Save(env.ctx, &identityv1.OrgUnitObject{
		OrganizationId: org.GetID(),
		Name:           "Inherited Partition Unit",
		Code:           "inherited-partition-unit",
		GeoId:          "kampala",
		Type:           identityv1.OrgUnitType_ORG_UNIT_TYPE_BRANCH,
	})
	s.Require().NoError(err)
	s.Require().NotNil(result)

	// The org unit should inherit the organization's partition since no partition client is configured.
	s.Equal(org.PartitionID, result.GetPartitionId())
}

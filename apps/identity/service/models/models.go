package models

import (
	"context"
	"time"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"github.com/pitabwire/frame/data"
	"github.com/pitabwire/util/decimalx"
	money "google.golang.org/genproto/googleapis/type/money"
)

const (
	// decimalPrecision is the number of decimal places for minor unit conversions (cents).
	decimalPrecision = 2
	// percentageDivisor is the number of minor units per major currency unit (e.g. 100 cents per dollar).
	percentageDivisor = 100
	// moneyNanosFactor converts minor-unit remainders to protobuf nanos (1e9 / 100).
	moneyNanosFactor = 10_000_000
	// extraPropertiesCount is the number of extra properties added when converting to API.
	extraPropertiesCount = 3
)

// MinorUnitsToString converts an int64 minor-unit amount (e.g. cents) to a
// decimal string with two fractional digits. 123456 -> "1234.56".
func MinorUnitsToString(v int64) string {
	return decimalx.FromMinorUnits(v, decimalPrecision).String()
}

// StringToMinorUnits parses a decimal string (e.g. "1234.56") into int64 minor
// units. Uses string splitting to avoid float precision issues. Returns 0 on
// parse error.
func StringToMinorUnits(s string) int64 {
	d, err := decimalx.NewFromString(s)
	if err != nil {
		return 0
	}
	return d.ToMinorUnits(decimalPrecision)
}

// MinorUnitsToMoney converts minor units and a currency code to a *money.Money.
func MinorUnitsToMoney(v int64, currencyCode string) *money.Money {
	units := v / percentageDivisor
	nanos := (v % percentageDivisor) * moneyNanosFactor
	return &money.Money{
		CurrencyCode: currencyCode,
		Units:        units,
		Nanos:        int32(nanos),
	}
}

// MoneyToMinorUnits converts a *money.Money to minor units and currency code.
func MoneyToMinorUnits(m *money.Money) (int64, string) {
	if m == nil {
		return 0, ""
	}
	return m.GetUnits()*percentageDivisor + int64(m.GetNanos())/moneyNanosFactor, m.GetCurrencyCode()
}

// Organization represents a top-level lending institution mapped to a partition.
type Organization struct {
	data.BaseModel
	Name       string `gorm:"type:varchar(255)"`
	Code       string `gorm:"type:varchar(50);uniqueIndex:uq_organization_code"`
	ProfileID  string `gorm:"type:varchar(50)"`
	ClientID   string `gorm:"type:varchar(50)"` // OAuth client ID for partition-scoped login
	State      int32
	Properties data.JSONMap
}

func (m *Organization) TableName() string { return "organizations" }

func (m *Organization) ToAPI() *identityv1.OrganizationObject {
	return &identityv1.OrganizationObject{
		Id:          m.GetID(),
		PartitionId: m.PartitionID,
		Name:        m.Name,
		Code:        m.Code,
		ProfileId:   m.ProfileID,
		State:       commonv1.STATE(m.State),
		Properties:  m.Properties.ToProtoStruct(),
		ClientId:    m.ClientID,
	}
}

func OrganizationFromAPI(ctx context.Context, obj *identityv1.OrganizationObject) *Organization {
	if obj == nil {
		return nil
	}

	model := &Organization{
		Name:      obj.GetName(),
		Code:      obj.GetCode(),
		ProfileID: obj.GetProfileId(),
		ClientID:  obj.GetClientId(),
		State:     int32(obj.GetState()),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	model.PartitionID = obj.GetPartitionId()
	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// Branch represents a branch within an organization, mapped to a child partition with a geographic area.
type Branch struct {
	data.BaseModel
	OrganizationID string `gorm:"type:varchar(50);index:idx_branch_organization"`
	Name           string `gorm:"type:varchar(255)"`
	Code           string `gorm:"type:varchar(50);uniqueIndex:uq_branch_code"`
	GeoID          string `gorm:"type:varchar(50)"`
	ClientID       string `gorm:"type:varchar(50)"` // OAuth client ID for partition-scoped login
	State          int32
	Properties     data.JSONMap
}

func (m *Branch) TableName() string { return "branches" }

func (m *Branch) ToAPI() *identityv1.BranchObject {
	return &identityv1.BranchObject{
		Id:             m.GetID(),
		OrganizationId: m.OrganizationID,
		PartitionId:    m.PartitionID,
		Name:           m.Name,
		Code:           m.Code,
		GeoId:          m.GeoID,
		State:          commonv1.STATE(m.State),
		Properties:     m.Properties.ToProtoStruct(),
		ClientId:       m.ClientID,
	}
}

func BranchFromAPI(ctx context.Context, obj *identityv1.BranchObject) *Branch {
	if obj == nil {
		return nil
	}

	model := &Branch{
		OrganizationID: obj.GetOrganizationId(),
		Name:           obj.GetName(),
		Code:           obj.GetCode(),
		GeoID:          obj.GetGeoId(),
		ClientID:       obj.GetClientId(),
		State:          int32(obj.GetState()),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	model.PartitionID = obj.GetPartitionId()
	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// Agent represents a field agent in the lending hierarchy.
// Agents belong to an organization and can be assigned to multiple branches via AgentBranch.
type Agent struct {
	data.BaseModel
	OrganizationID string `gorm:"type:varchar(50);index:idx_agent_organization;not null"`
	ParentAgentID  string `gorm:"type:varchar(50);index:idx_agent_parent"`
	ProfileID      string `gorm:"type:varchar(50)"`
	AgentType      int32
	Name           string `gorm:"type:varchar(255)"`
	GeoID          string `gorm:"type:varchar(50)"`
	Depth          int32
	State          int32
	Properties     data.JSONMap
}

func (m *Agent) TableName() string { return "agents" }

func (m *Agent) ToAPI() *fieldv1.AgentObject {
	return &fieldv1.AgentObject{
		Id:             m.GetID(),
		OrganizationId: m.OrganizationID,
		ParentAgentId:  m.ParentAgentID,
		ProfileId:      m.ProfileID,
		AgentType:      fieldv1.AgentType(m.AgentType),
		Name:           m.Name,
		GeoId:          m.GeoID,
		Depth:          m.Depth,
		State:          commonv1.STATE(m.State),
		Properties:     m.Properties.ToProtoStruct(),
	}
}

func AgentFromAPI(ctx context.Context, obj *fieldv1.AgentObject) *Agent {
	if obj == nil {
		return nil
	}

	model := &Agent{
		OrganizationID: obj.GetOrganizationId(),
		ParentAgentID:  obj.GetParentAgentId(),
		ProfileID:      obj.GetProfileId(),
		AgentType:      int32(obj.GetAgentType()),
		Name:           obj.GetName(),
		GeoID:          obj.GetGeoId(),
		Depth:          obj.GetDepth(),
		State:          int32(obj.GetState()),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// AgentBranch links an agent to a branch (many-to-many).
// Each assignment can carry its own state and properties (e.g. commission structure).
type AgentBranch struct {
	data.BaseModel
	AgentID    string `gorm:"type:varchar(50);uniqueIndex:uq_agent_branch,priority:1;not null"`
	BranchID   string `gorm:"type:varchar(50);uniqueIndex:uq_agent_branch,priority:2;index:idx_ab_branch;not null"`
	State      int32
	Properties data.JSONMap
}

func (m *AgentBranch) TableName() string { return "agent_branches" }

func (m *AgentBranch) ToAPI() *fieldv1.AgentBranchObject {
	return &fieldv1.AgentBranchObject{
		Id:         m.GetID(),
		AgentId:    m.AgentID,
		BranchId:   m.BranchID,
		State:      commonv1.STATE(m.State),
		Properties: m.Properties.ToProtoStruct(),
	}
}

func AgentBranchFromAPI(ctx context.Context, obj *fieldv1.AgentBranchObject) *AgentBranch {
	if obj == nil {
		return nil
	}

	model := &AgentBranch{
		AgentID:  obj.GetAgentId(),
		BranchID: obj.GetBranchId(),
		State:    int32(obj.GetState()),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// Client represents a loan recipient always assigned to an agent.
// Clients exist independently of groups. Product-level code links
// clients to memberships where needed.
//
// Credit limits:
//   - SystemCreditLimit: hard maximum that evolves with client performance.
//     Can only be changed through a verified CreditLimitChangeRequest.
//   - AgentCreditLimit: set by the responsible agent, between 0 and SystemCreditLimit.
//     Controls what the agent is willing to issue to this client.
//   - Effective limit = min(SystemCreditLimit, AgentCreditLimit).
type Client struct {
	data.BaseModel
	AgentID           string `gorm:"type:varchar(50);index:idx_client_agent;not null"`
	ProfileID         string `gorm:"type:varchar(50);uniqueIndex:uq_client_profile"`
	Name              string `gorm:"type:varchar(255)"`
	CurrencyCode      string `gorm:"type:varchar(3)"`
	SystemCreditLimit int64  // minor units — hard max, performance-based
	AgentCreditLimit  int64  // minor units — agent-controlled, 0 to SystemCreditLimit
	State             int32
	Properties        data.JSONMap
}

func (m *Client) TableName() string { return "clients" }

// EffectiveCreditLimit returns the lower of the two limits.
// If either limit is zero, the other applies. If both are zero, no credit.
func (m *Client) EffectiveCreditLimit() int64 {
	sys := m.SystemCreditLimit
	agent := m.AgentCreditLimit
	if sys <= 0 {
		return 0
	}
	if agent <= 0 {
		return 0
	}
	if agent < sys {
		return agent
	}
	return sys
}

func (m *Client) ToAPI() *fieldv1.ClientObject {
	// Copy properties so we don't mutate the model's map
	props := make(data.JSONMap, len(m.Properties)+extraPropertiesCount)
	for k, v := range m.Properties {
		props[k] = v
	}
	if phone, ok := props["phone"].(string); ok && phone != "" {
		if _, hasCanonical := props["phone_number"]; !hasCanonical {
			props["phone_number"] = phone
		}
		delete(props, "phone")
	}
	// Ensure credit limits are visible in properties for downstream consumers
	props["system_credit_limit"] = float64(m.SystemCreditLimit)
	props["agent_credit_limit"] = float64(m.AgentCreditLimit)
	props["currency_code"] = m.CurrencyCode

	return &fieldv1.ClientObject{
		Id:         m.GetID(),
		AgentId:    m.AgentID,
		ProfileId:  m.ProfileID,
		Name:       m.Name,
		State:      commonv1.STATE(m.State),
		Properties: props.ToProtoStruct(),
	}
}

func ClientFromAPI(ctx context.Context, obj *fieldv1.ClientObject) *Client {
	if obj == nil {
		return nil
	}

	model := &Client{
		AgentID:   obj.GetAgentId(),
		ProfileID: obj.GetProfileId(),
		Name:      obj.GetName(),
		State:     int32(obj.GetState()),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}
	if phone, ok := model.Properties["phone"].(string); ok && phone != "" {
		if _, hasCanonical := model.Properties["phone_number"]; !hasCanonical {
			model.Properties["phone_number"] = phone
		}
		delete(model.Properties, "phone")
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// CreditLimitChangeRequest records a request to change the system credit limit.
// Changes to the hard limit must go through a verification and approval process.
type CreditLimitChangeRequest struct {
	data.BaseModel
	ClientID       string `gorm:"type:varchar(50);index:idx_clcr_client;not null"`
	CurrentLimit   int64  // minor units — limit at time of request
	RequestedLimit int64  // minor units — proposed new limit
	CurrencyCode   string `gorm:"type:varchar(3)"`
	Reason         string `gorm:"type:text"`
	RequestedBy    string `gorm:"type:varchar(50)"` // agent or system user who initiated
	ReviewedBy     string `gorm:"type:varchar(50)"` // who approved/rejected
	ReviewNotes    string `gorm:"type:text"`
	Status         int32  // 1=pending, 3=approved, 5=rejected
	Properties     data.JSONMap
}

func (m *CreditLimitChangeRequest) TableName() string { return "credit_limit_change_requests" }

// ApprovalCase captures a reusable verification and approval workflow for any
// pending business action whose end state must not be actualized immediately.
type ApprovalCase struct {
	data.BaseModel
	SubjectType string `gorm:"type:varchar(50);index:idx_approval_case_subject;not null"`
	SubjectID   string `gorm:"type:varchar(50);index:idx_approval_case_subject;not null"`
	CaseType    string `gorm:"type:varchar(100);index:idx_approval_case_type;not null"`
	Status      string `gorm:"type:varchar(50);index:idx_approval_case_status;not null"`
	Summary     string `gorm:"type:text"`
	RequestedBy string `gorm:"type:varchar(50);index:idx_approval_case_requested_by"`
	VerifiedBy  string `gorm:"type:varchar(50)"`
	ApprovedBy  string `gorm:"type:varchar(50)"`
	RejectedBy  string `gorm:"type:varchar(50)"`
	VerifiedAt  *time.Time
	ApprovedAt  *time.Time
	RejectedAt  *time.Time
	Comment     string `gorm:"type:text"`
	Payload     data.JSONMap
	Properties  data.JSONMap
}

func (m *ApprovalCase) TableName() string { return "approval_cases" }

// GroupType defines the type of customer group.
type GroupType int32

const (
	GroupTypeUnspecified  GroupType = 0
	GroupTypeProduct      GroupType = 1
	GroupTypeGrameen      GroupType = 2
	GroupTypeFunding      GroupType = 3
	GroupTypeTemporary    GroupType = 4
	GroupTypeMerryGoRound GroupType = 5
	GroupTypeVoluntary    GroupType = 6
)

// GroupState defines the lifecycle state of a group.
type GroupState int32

const (
	GroupStateJustCreated  GroupState = 1
	GroupStateCheckCreated GroupState = 2
	GroupStateActive       GroupState = 3
	GroupStateInactive     GroupState = 4
	GroupStateDeleted      GroupState = 5
	GroupStateShutdown     GroupState = 6
)

// MembershipRole defines the role of a member in a group.
type MembershipRole int32

const (
	MembershipRoleUnspecified MembershipRole = 0
	MembershipRoleMember      MembershipRole = 1
	MembershipRoleLeader      MembershipRole = 2
	MembershipRoleAgent       MembershipRole = 3
)

// MembershipType defines the type of membership.
type MembershipType int32

const (
	MembershipTypeUnspecified MembershipType = 0
	MembershipTypeRegistra    MembershipType = 1
	MembershipTypeAgent       MembershipType = 2
	MembershipTypeMember      MembershipType = 3
	MembershipTypeFunder      MembershipType = 4
)

// ClientGroup represents a collective entity (e.g. SACCO group) in the lending hierarchy.
type ClientGroup struct {
	data.BaseModel
	ProductID     string `gorm:"type:varchar(50);index:idx_group_product"`
	ParentID      string `gorm:"type:varchar(50);index:idx_group_parent"`
	AgentID       string `gorm:"type:varchar(50);index:idx_group_agent"`
	BranchID      string `gorm:"type:varchar(50);index:idx_group_branch"`
	ProfileID     string `gorm:"type:varchar(50)"`
	Name          string `gorm:"type:varchar(255)"`
	GroupType     int32
	CurrencyCode  string `gorm:"type:varchar(10)"`
	SavingAmount  int64
	TimeZone      string `gorm:"type:varchar(50)"`
	MinMembers    int32
	MaxMembers    int32
	DateActive    *time.Time
	DateChecked   *time.Time
	DateInspected *time.Time
	State         int32
	Properties    data.JSONMap
}

func (m *ClientGroup) TableName() string { return "client_groups" }

// SetVersion implements the versioned model interface for event upsert.
func (m *ClientGroup) SetVersion(v uint) { m.Version = v }

func (m *ClientGroup) ToAPI() *identityv1.ClientGroupObject {
	return &identityv1.ClientGroupObject{
		Id:           m.GetID(),
		ProductId:    m.ProductID,
		ParentId:     m.ParentID,
		AgentId:      m.AgentID,
		BranchId:     m.BranchID,
		ProfileId:    m.ProfileID,
		Name:         m.Name,
		GroupType:    m.GroupType,
		CurrencyCode: m.CurrencyCode,
		SavingAmount: m.SavingAmount,
		TimeZone:     m.TimeZone,
		MinMembers:   m.MinMembers,
		MaxMembers:   m.MaxMembers,
		State:        commonv1.STATE(m.State),
		Properties:   m.Properties.ToProtoStruct(),
	}
}

func ClientGroupFromAPI(ctx context.Context, obj *identityv1.ClientGroupObject) *ClientGroup {
	if obj == nil {
		return nil
	}

	model := &ClientGroup{
		ProductID:    obj.GetProductId(),
		ParentID:     obj.GetParentId(),
		AgentID:      obj.GetAgentId(),
		BranchID:     obj.GetBranchId(),
		ProfileID:    obj.GetProfileId(),
		Name:         obj.GetName(),
		GroupType:    obj.GetGroupType(),
		CurrencyCode: obj.GetCurrencyCode(),
		SavingAmount: obj.GetSavingAmount(),
		TimeZone:     obj.GetTimeZone(),
		MinMembers:   obj.GetMinMembers(),
		MaxMembers:   obj.GetMaxMembers(),
		State:        int32(obj.GetState()),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// Membership tracks a profile's affiliation with a group.
type Membership struct {
	data.BaseModel
	GroupID         string `gorm:"type:varchar(50);index:idx_membership_group"`
	ProfileID       string `gorm:"type:varchar(50);index:idx_membership_profile"`
	Name            string `gorm:"type:varchar(255)"`
	ContactID       string `gorm:"type:varchar(50);index:idx_membership_contact"`
	Role            int32
	MembershipType  int32
	OrderNo         int32
	TimeZone        string `gorm:"type:varchar(50)"`
	PrevLoanReqDate *time.Time
	NextLoanReqDate *time.Time
	State           int32
	Properties      data.JSONMap
}

func (m *Membership) TableName() string { return "memberships" }

// SetVersion implements the versioned model interface for event upsert.
func (m *Membership) SetVersion(v uint) { m.Version = v }

func (m *Membership) ToAPI() *identityv1.MembershipObject {
	return &identityv1.MembershipObject{
		Id:             m.GetID(),
		GroupId:        m.GroupID,
		ProfileId:      m.ProfileID,
		Name:           m.Name,
		ContactId:      m.ContactID,
		Role:           m.Role,
		MembershipType: m.MembershipType,
		OrderNo:        m.OrderNo,
		State:          commonv1.STATE(m.State),
		Properties:     m.Properties.ToProtoStruct(),
	}
}

func MembershipFromAPI(ctx context.Context, obj *identityv1.MembershipObject) *Membership {
	if obj == nil {
		return nil
	}

	model := &Membership{
		GroupID:        obj.GetGroupId(),
		ProfileID:      obj.GetProfileId(),
		Name:           obj.GetName(),
		ContactID:      obj.GetContactId(),
		Role:           obj.GetRole(),
		MembershipType: obj.GetMembershipType(),
		OrderNo:        obj.GetOrderNo(),
		State:          int32(obj.GetState()),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// ClientAssignmentHistory records client reassignment events.
type ClientAssignmentHistory struct {
	data.BaseModel
	ClientID        string `gorm:"type:varchar(50);index:idx_cah_client"`
	PreviousAgentID string `gorm:"type:varchar(50)"`
	NewAgentID      string `gorm:"type:varchar(50)"`
	Reason          string `gorm:"type:text"`
}

func (m *ClientAssignmentHistory) TableName() string { return "client_assignment_history" }

// Investor represents an independent investor linked to a profile.
type Investor struct {
	data.BaseModel
	ProfileID  string `gorm:"type:varchar(50);uniqueIndex:uq_investor_profile"`
	Name       string `gorm:"type:varchar(255)"`
	State      int32
	Properties data.JSONMap
}

func (m *Investor) TableName() string { return "investors" }

func (m *Investor) ToAPI() *identityv1.InvestorObject {
	return &identityv1.InvestorObject{
		Id:         m.GetID(),
		ProfileId:  m.ProfileID,
		Name:       m.Name,
		State:      commonv1.STATE(m.State),
		Properties: m.Properties.ToProtoStruct(),
	}
}

func InvestorFromAPI(ctx context.Context, obj *identityv1.InvestorObject) *Investor {
	if obj == nil {
		return nil
	}

	model := &Investor{
		ProfileID: obj.GetProfileId(),
		Name:      obj.GetName(),
		State:     int32(obj.GetState()),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// SystemUser represents a user with a specific role in the lending workflow.
type SystemUser struct {
	data.BaseModel
	ProfileID        string `gorm:"type:varchar(50);index:idx_su_profile"`
	BranchID         string `gorm:"type:varchar(50);index:idx_su_branch"`
	Role             int32
	ServiceAccountID string `gorm:"type:varchar(50)"`
	State            int32
	Properties       data.JSONMap
}

func (m *SystemUser) TableName() string { return "system_users" }

func (m *SystemUser) ToAPI() *identityv1.SystemUserObject {
	return &identityv1.SystemUserObject{
		Id:               m.GetID(),
		ProfileId:        m.ProfileID,
		BranchId:         m.BranchID,
		Role:             identityv1.SystemUserRole(m.Role),
		ServiceAccountId: m.ServiceAccountID,
		State:            commonv1.STATE(m.State),
		Properties:       m.Properties.ToProtoStruct(),
	}
}

// ClientDataEntry stores a single piece of client KYC data.
// The (ClientID, FieldKey) pair is unique — resubmissions increment Revision.
type ClientDataEntry struct {
	data.BaseModel
	ClientID            string `gorm:"type:varchar(50);uniqueIndex:uq_cde_client_key,priority:1;not null"`
	FieldKey            string `gorm:"type:varchar(100);uniqueIndex:uq_cde_client_key,priority:2;not null"`
	Value               string `gorm:"type:text"`
	ValueType           string `gorm:"type:varchar(20)"`
	VerificationStatus  int32  // matches DataVerificationStatus enum
	ReviewerID          string `gorm:"type:varchar(50)"`
	ReviewerComment     string `gorm:"type:text"`
	SourceApplicationID string `gorm:"type:varchar(50)"`
	Revision            int32
	VerifiedAt          *time.Time
	ExpiresAt           *time.Time
	Properties          data.JSONMap
}

func (m *ClientDataEntry) TableName() string { return "client_data_entries" }

func (m *ClientDataEntry) ToAPI() *identityv1.ClientDataEntryObject {
	obj := &identityv1.ClientDataEntryObject{
		Id:                  m.GetID(),
		ClientId:            m.ClientID,
		FieldKey:            m.FieldKey,
		Value:               m.Value,
		ValueType:           m.ValueType,
		VerificationStatus:  identityv1.DataVerificationStatus(m.VerificationStatus),
		ReviewerId:          m.ReviewerID,
		ReviewerComment:     m.ReviewerComment,
		SourceApplicationId: m.SourceApplicationID,
		Revision:            m.Revision,
		Properties:          m.Properties.ToProtoStruct(),
	}
	if m.VerifiedAt != nil {
		obj.VerifiedAt = m.VerifiedAt.Format(time.RFC3339)
	}
	if m.ExpiresAt != nil {
		obj.ExpiresAt = m.ExpiresAt.Format(time.RFC3339)
	}
	return obj
}

func ClientDataEntryFromAPI(ctx context.Context, obj *identityv1.ClientDataEntryObject) *ClientDataEntry {
	if obj == nil {
		return nil
	}

	model := &ClientDataEntry{
		ClientID:            obj.GetClientId(),
		FieldKey:            obj.GetFieldKey(),
		Value:               obj.GetValue(),
		ValueType:           obj.GetValueType(),
		VerificationStatus:  int32(obj.GetVerificationStatus()),
		ReviewerID:          obj.GetReviewerId(),
		ReviewerComment:     obj.GetReviewerComment(),
		SourceApplicationID: obj.GetSourceApplicationId(),
		Revision:            obj.GetRevision(),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	if obj.GetVerifiedAt() != "" {
		if t, err := time.Parse(time.RFC3339, obj.GetVerifiedAt()); err == nil {
			model.VerifiedAt = &t
		}
	}
	if obj.GetExpiresAt() != "" {
		if t, err := time.Parse(time.RFC3339, obj.GetExpiresAt()); err == nil {
			model.ExpiresAt = &t
		}
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

// ClientDataEntryHistory tracks every action on a data entry.
type ClientDataEntryHistory struct {
	data.BaseModel
	EntryID  string `gorm:"type:varchar(50);index:idx_cdeh_entry;not null"`
	Revision int32
	Value    string `gorm:"type:text"`
	Action   string `gorm:"type:varchar(20)"` // submitted, verified, rejected, more_info, expired
	ActorID  string `gorm:"type:varchar(50)"`
	Comment  string `gorm:"type:text"`
}

func (m *ClientDataEntryHistory) TableName() string { return "client_data_entry_history" }

func (m *ClientDataEntryHistory) ToAPI() *identityv1.ClientDataEntryHistoryObject {
	return &identityv1.ClientDataEntryHistoryObject{
		Id:        m.GetID(),
		EntryId:   m.EntryID,
		Revision:  m.Revision,
		Value:     m.Value,
		Action:    m.Action,
		ActorId:   m.ActorID,
		Comment:   m.Comment,
		CreatedAt: m.CreatedAt.Format(time.RFC3339),
	}
}

func ClientDataEntryHistoryFromAPI(
	ctx context.Context,
	obj *identityv1.ClientDataEntryHistoryObject,
) *ClientDataEntryHistory {
	if obj == nil {
		return nil
	}

	model := &ClientDataEntryHistory{
		EntryID:  obj.GetEntryId(),
		Revision: obj.GetRevision(),
		Value:    obj.GetValue(),
		Action:   obj.GetAction(),
		ActorID:  obj.GetActorId(),
		Comment:  obj.GetComment(),
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

func SystemUserFromAPI(ctx context.Context, obj *identityv1.SystemUserObject) *SystemUser {
	if obj == nil {
		return nil
	}

	model := &SystemUser{
		ProfileID:        obj.GetProfileId(),
		BranchID:         obj.GetBranchId(),
		Role:             int32(obj.GetRole()),
		ServiceAccountID: obj.GetServiceAccountId(),
		State:            int32(obj.GetState()),
	}

	if obj.GetProperties() != nil {
		model.Properties = (&data.JSONMap{}).FromProtoStruct(obj.GetProperties())
	}

	model.GenID(ctx)
	if model.ValidXID(obj.GetId()) {
		model.ID = obj.GetId()
	}

	return model
}

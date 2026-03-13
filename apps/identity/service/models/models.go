package models

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	lenderv1 "buf.build/gen/go/antinvestor/lender/protocolbuffers/go/lender/v1"
	"github.com/pitabwire/frame/data"
)

// Bank represents a top-level lending institution mapped to a partition.
type Bank struct {
	data.BaseModel
	Name       string   `gorm:"type:varchar(255)"`
	Code       string   `gorm:"type:varchar(50);uniqueIndex:uq_bank_code"`
	ProfileID  string   `gorm:"type:varchar(50)"`
	State      int32
	Properties data.JSONMap
}

func (m *Bank) TableName() string { return "banks" }

func (m *Bank) ToAPI() *lenderv1.BankObject {
	return &lenderv1.BankObject{
		Id:          m.GetID(),
		PartitionId: m.PartitionID,
		Name:        m.Name,
		Code:        m.Code,
		ProfileId:   m.ProfileID,
		State:       commonv1.STATE(m.State),
		Properties:  m.Properties.ToProtoStruct(),
	}
}

func BankFromAPI(ctx context.Context, obj *lenderv1.BankObject) *Bank {
	if obj == nil {
		return nil
	}

	model := &Bank{
		Name:      obj.GetName(),
		Code:      obj.GetCode(),
		ProfileID: obj.GetProfileId(),
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

// Branch represents a branch within a bank, mapped to a child partition with a geographic area.
type Branch struct {
	data.BaseModel
	BankID     string   `gorm:"type:varchar(50);index:idx_branch_bank"`
	Name       string   `gorm:"type:varchar(255)"`
	Code       string   `gorm:"type:varchar(50);uniqueIndex:uq_branch_code"`
	GeoID      string   `gorm:"type:varchar(50)"`
	State      int32
	Properties data.JSONMap
}

func (m *Branch) TableName() string { return "branches" }

func (m *Branch) ToAPI() *lenderv1.BranchObject {
	return &lenderv1.BranchObject{
		Id:          m.GetID(),
		BankId:      m.BankID,
		PartitionId: m.PartitionID,
		Name:        m.Name,
		Code:        m.Code,
		GeoId:       m.GeoID,
		State:       commonv1.STATE(m.State),
		Properties:  m.Properties.ToProtoStruct(),
	}
}

func BranchFromAPI(ctx context.Context, obj *lenderv1.BranchObject) *Branch {
	if obj == nil {
		return nil
	}

	model := &Branch{
		BankID: obj.GetBankId(),
		Name:   obj.GetName(),
		Code:   obj.GetCode(),
		GeoID:  obj.GetGeoId(),
		State:  int32(obj.GetState()),
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
type Agent struct {
	data.BaseModel
	BranchID      string   `gorm:"type:varchar(50);index:idx_agent_branch"`
	ParentAgentID string   `gorm:"type:varchar(50);index:idx_agent_parent"`
	ProfileID     string   `gorm:"type:varchar(50)"`
	AgentType     int32
	Name          string   `gorm:"type:varchar(255)"`
	GeoID         string   `gorm:"type:varchar(50)"`
	Depth         int32
	State         int32
	Properties    data.JSONMap
}

func (m *Agent) TableName() string { return "agents" }

func (m *Agent) ToAPI() *lenderv1.AgentObject {
	return &lenderv1.AgentObject{
		Id:            m.GetID(),
		BranchId:      m.BranchID,
		ParentAgentId: m.ParentAgentID,
		ProfileId:     m.ProfileID,
		AgentType:     lenderv1.AgentType(m.AgentType),
		Name:          m.Name,
		GeoId:         m.GeoID,
		Depth:         m.Depth,
		State:         commonv1.STATE(m.State),
		Properties:    m.Properties.ToProtoStruct(),
	}
}

func AgentFromAPI(ctx context.Context, obj *lenderv1.AgentObject) *Agent {
	if obj == nil {
		return nil
	}

	model := &Agent{
		BranchID:      obj.GetBranchId(),
		ParentAgentID: obj.GetParentAgentId(),
		ProfileID:     obj.GetProfileId(),
		AgentType:     int32(obj.GetAgentType()),
		Name:          obj.GetName(),
		GeoID:         obj.GetGeoId(),
		Depth:         obj.GetDepth(),
		State:         int32(obj.GetState()),
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

// Client represents a loan recipient assigned to an agent.
type Client struct {
	data.BaseModel
	AgentID    string   `gorm:"type:varchar(50);index:idx_client_agent"`
	ProfileID  string   `gorm:"type:varchar(50);uniqueIndex:uq_client_profile"`
	Name       string   `gorm:"type:varchar(255)"`
	State      int32
	Properties data.JSONMap
}

func (m *Client) TableName() string { return "clients" }

func (m *Client) ToAPI() *lenderv1.ClientObject {
	return &lenderv1.ClientObject{
		Id:         m.GetID(),
		AgentId:    m.AgentID,
		ProfileId:  m.ProfileID,
		Name:       m.Name,
		State:      commonv1.STATE(m.State),
		Properties: m.Properties.ToProtoStruct(),
	}
}

func ClientFromAPI(ctx context.Context, obj *lenderv1.ClientObject) *Client {
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

// SystemUser represents a user with a specific role in the lending workflow.
type SystemUser struct {
	data.BaseModel
	ProfileID        string   `gorm:"type:varchar(50);index:idx_su_profile"`
	BranchID         string   `gorm:"type:varchar(50);index:idx_su_branch"`
	Role             int32
	ServiceAccountID string   `gorm:"type:varchar(50)"`
	State            int32
	Properties       data.JSONMap
}

func (m *SystemUser) TableName() string { return "system_users" }

func (m *SystemUser) ToAPI() *lenderv1.SystemUserObject {
	return &lenderv1.SystemUserObject{
		Id:               m.GetID(),
		ProfileId:        m.ProfileID,
		BranchId:         m.BranchID,
		Role:             lenderv1.SystemUserRole(m.Role),
		ServiceAccountId: m.ServiceAccountID,
		State:            commonv1.STATE(m.State),
		Properties:       m.Properties.ToProtoStruct(),
	}
}

func SystemUserFromAPI(ctx context.Context, obj *lenderv1.SystemUserObject) *SystemUser {
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

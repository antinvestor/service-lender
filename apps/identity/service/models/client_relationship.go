package models

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	fieldv1 "buf.build/gen/go/antinvestor/field/protocolbuffers/go/field/v1"
	"github.com/pitabwire/frame/data"
)

// ClientRelationship assigns a workforce member to a client.
type ClientRelationship struct {
	data.BaseModel
	ClientID    string `gorm:"type:varchar(50);index:idx_cr_client;uniqueIndex:uq_cr_client_member,priority:1;not null"`
	MemberID    string `gorm:"type:varchar(50);index:idx_cr_member;uniqueIndex:uq_cr_client_member,priority:2;not null"`
	Name        string `gorm:"type:varchar(255);not null"`
	Description string `gorm:"type:text"`
	IsPrimary   bool   `gorm:"index:idx_cr_primary"`
	State       int32
	Properties  data.JSONMap
}

func (m *ClientRelationship) TableName() string { return "client_relationships" }

func (m *ClientRelationship) ToAPI() *fieldv1.ClientRelationshipObject {
	return &fieldv1.ClientRelationshipObject{
		Id:          m.GetID(),
		ClientId:    m.ClientID,
		MemberId:    m.MemberID,
		Name:        m.Name,
		Description: m.Description,
		IsPrimary:   m.IsPrimary,
		State:       commonv1.STATE(m.State),
		Properties:  m.Properties.ToProtoStruct(),
	}
}

func ClientRelationshipFromAPI(ctx context.Context, obj *fieldv1.ClientRelationshipObject) *ClientRelationship {
	if obj == nil {
		return nil
	}

	model := &ClientRelationship{
		ClientID:    obj.GetClientId(),
		MemberID:    obj.GetMemberId(),
		Name:        obj.GetName(),
		Description: obj.GetDescription(),
		IsPrimary:   obj.GetIsPrimary(),
		State:       int32(obj.GetState()),
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

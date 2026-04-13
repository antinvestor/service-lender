package models

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"github.com/pitabwire/frame/data"
)

// ---------------------------------------------------------------------------
// FormTemplate
// ---------------------------------------------------------------------------

type FormTemplate struct {
	data.BaseModel
	OrganizationID  string `gorm:"type:varchar(50);index:idx_ft_organization"`
	Name            string `gorm:"type:varchar(255);not null"`
	Description     string `gorm:"type:text"`
	Version         int32
	Status          int32  `gorm:"index:idx_ft_status"`
	EntityType      string `gorm:"type:varchar(50);index:idx_ft_entity_type"`
	Fields          data.JSONMap
	Sections        data.JSONMap
	ValidationRules data.JSONMap
	Properties      data.JSONMap
}

func (m *FormTemplate) TableName() string { return "form_templates" }

func (m *FormTemplate) ToAPI() *identityv1.FormTemplateObject {
	obj := &identityv1.FormTemplateObject{
		Id:              m.GetID(),
		OrganizationId:  m.OrganizationID,
		Name:            m.Name,
		Description:     m.Description,
		Version:         m.Version,
		Status:          identityv1.FormTemplateStatus(m.Status),
		EntityType:      m.EntityType,
		ValidationRules: m.ValidationRules.ToProtoStruct(),
		Properties:      m.Properties.ToProtoStruct(),
	}

	obj.Fields = fieldsToAPI(m.Fields)
	obj.Sections = sectionsToAPI(m.Sections)

	return obj
}

func FormTemplateFromAPI(ctx context.Context, obj *identityv1.FormTemplateObject) *FormTemplate {
	if obj == nil {
		return nil
	}

	model := &FormTemplate{
		OrganizationID: obj.GetOrganizationId(),
		Name:           obj.GetName(),
		Description:    obj.GetDescription(),
		Version:        obj.GetVersion(),
		Status:         int32(obj.GetStatus()),
		EntityType:     obj.GetEntityType(),
		Fields:         fieldsFromAPI(obj.GetFields()),
		Sections:       sectionsFromAPI(obj.GetSections()),
	}

	if obj.GetValidationRules() != nil {
		model.ValidationRules = (&data.JSONMap{}).FromProtoStruct(obj.GetValidationRules())
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

// ---------------------------------------------------------------------------
// FormSubmission
// ---------------------------------------------------------------------------

type FormSubmission struct {
	data.BaseModel
	EntityID        string `gorm:"type:varchar(50);index:idx_fs_entity"`
	EntityType      string `gorm:"type:varchar(50);index:idx_fs_entity_type"`
	TemplateID      string `gorm:"type:varchar(50);index:idx_fs_template"`
	TemplateVersion int32
	SubmittedBy     string `gorm:"type:varchar(50)"`
	Data            data.JSONMap
	FileRefs        data.JSONMap
	State           int32
	Properties      data.JSONMap
}

func (m *FormSubmission) TableName() string { return "form_submissions" }

func (m *FormSubmission) ToAPI() *identityv1.FormSubmissionObject {
	return &identityv1.FormSubmissionObject{
		Id:              m.GetID(),
		EntityId:        m.EntityID,
		EntityType:      m.EntityType,
		TemplateId:      m.TemplateID,
		TemplateVersion: m.TemplateVersion,
		SubmittedBy:     m.SubmittedBy,
		Data:            m.Data.ToProtoStruct(),
		FileRefs:        m.FileRefs.ToProtoStruct(),
		State:           commonv1.STATE(m.State),
		Properties:      m.Properties.ToProtoStruct(),
	}
}

func FormSubmissionFromAPI(ctx context.Context, obj *identityv1.FormSubmissionObject) *FormSubmission {
	if obj == nil {
		return nil
	}

	model := &FormSubmission{
		EntityID:        obj.GetEntityId(),
		EntityType:      obj.GetEntityType(),
		TemplateID:      obj.GetTemplateId(),
		TemplateVersion: obj.GetTemplateVersion(),
		SubmittedBy:     obj.GetSubmittedBy(),
		State:           int32(obj.GetState()),
	}

	if obj.GetData() != nil {
		model.Data = (&data.JSONMap{}).FromProtoStruct(obj.GetData())
	}
	if obj.GetFileRefs() != nil {
		model.FileRefs = (&data.JSONMap{}).FromProtoStruct(obj.GetFileRefs())
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

// ---------------------------------------------------------------------------
// Field conversion helpers
// ---------------------------------------------------------------------------

func fieldsToAPI(jm data.JSONMap) []*identityv1.FormFieldDefinition {
	if jm == nil {
		return nil
	}
	raw, ok := jm["items"]
	if !ok {
		return nil
	}
	items, ok := raw.([]any)
	if !ok {
		return nil
	}

	var result []*identityv1.FormFieldDefinition
	for _, item := range items {
		m, ok := item.(map[string]any)
		if !ok {
			continue
		}
		fd := &identityv1.FormFieldDefinition{}
		if v, ok := m["key"].(string); ok {
			fd.Key = v
		}
		if v, ok := m["label"].(string); ok {
			fd.Label = v
		}
		if v, ok := m["field_type"].(float64); ok {
			fd.FieldType = identityv1.FormFieldType(int32(v))
		}
		if v, ok := m["group"].(float64); ok {
			fd.Group = identityv1.FormFieldGroup(int32(v))
		}
		if v, ok := m["required"].(bool); ok {
			fd.Required = v
		}
		if v, ok := m["description"].(string); ok {
			fd.Description = v
		}
		if v, ok := m["section"].(string); ok {
			fd.Section = v
		}
		if v, ok := m["order"].(float64); ok {
			fd.Order = int32(v)
		}
		if v, ok := m["encrypted"].(bool); ok {
			fd.Encrypted = v
		}
		result = append(result, fd)
	}
	return result
}

func fieldsFromAPI(fields []*identityv1.FormFieldDefinition) data.JSONMap {
	if len(fields) == 0 {
		return nil
	}
	var items []map[string]any
	for _, f := range fields {
		items = append(items, map[string]any{
			"key":         f.GetKey(),
			"label":       f.GetLabel(),
			"field_type":  int32(f.GetFieldType()),
			"group":       int32(f.GetGroup()),
			"required":    f.GetRequired(),
			"description": f.GetDescription(),
			"section":     f.GetSection(),
			"order":       f.GetOrder(),
			"encrypted":   f.GetEncrypted(),
		})
	}
	return data.JSONMap{"items": items}
}

func sectionsToAPI(jm data.JSONMap) []string {
	if jm == nil {
		return nil
	}
	raw, ok := jm["items"]
	if !ok {
		return nil
	}
	items, ok := raw.([]any)
	if !ok {
		return nil
	}
	var result []string
	for _, item := range items {
		if s, ok := item.(string); ok {
			result = append(result, s)
		}
	}
	return result
}

func sectionsFromAPI(sections []string) data.JSONMap {
	if len(sections) == 0 {
		return nil
	}
	items := make([]any, 0, len(sections))
	for _, s := range sections {
		items = append(items, s)
	}
	return data.JSONMap{"items": items}
}

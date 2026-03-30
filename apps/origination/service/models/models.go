package models

import (
	"context"
	"time"

	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"github.com/pitabwire/frame/data"
)

// Application represents a client's loan application.
type Application struct {
	data.BaseModel
	ProductID          string `gorm:"type:varchar(50);index:idx_app_product"`
	ClientID           string `gorm:"type:varchar(50);index:idx_app_client"`
	AgentID            string `gorm:"type:varchar(50);index:idx_app_agent"`
	BranchID           string `gorm:"type:varchar(50);index:idx_app_branch"`
	BankID             string `gorm:"type:varchar(50);index:idx_app_bank"`
	Status             int32
	RequestedAmount    int64 // minor units
	ApprovedAmount     int64 // minor units
	RequestedTermDays  int32
	ApprovedTermDays   int32
	InterestRate       int64  // basis points
	CurrencyCode       string `gorm:"type:varchar(3)"`
	KycData            data.JSONMap
	Purpose            string `gorm:"type:text"`
	RejectionReason    string `gorm:"type:text"`
	WorkflowInstanceID string `gorm:"type:varchar(50)"`
	OfferExpiresAt     *time.Time
	SubmittedAt        *time.Time
	DecidedAt          *time.Time
	LoanAccountID      string `gorm:"type:varchar(50)"`
	Properties         data.JSONMap
}

func (m *Application) TableName() string { return "applications" }

func (m *Application) ToAPI() *originationv1.ApplicationObject {
	obj := &originationv1.ApplicationObject{
		Id:                 m.GetID(),
		ProductId:          m.ProductID,
		BorrowerId:         m.ClientID,
		AgentId:            m.AgentID,
		BranchId:           m.BranchID,
		BankId:             m.BankID,
		Status:             originationv1.ApplicationStatus(m.Status),
		RequestedAmount:    MinorUnitsToMoney(m.RequestedAmount, m.CurrencyCode),
		ApprovedAmount:     MinorUnitsToMoney(m.ApprovedAmount, m.CurrencyCode),
		RequestedTermDays:  m.RequestedTermDays,
		ApprovedTermDays:   m.ApprovedTermDays,
		InterestRate:       BasisPointsToString(m.InterestRate),
		KycData:            m.KycData.ToProtoStruct(),
		Purpose:            m.Purpose,
		RejectionReason:    m.RejectionReason,
		WorkflowInstanceId: m.WorkflowInstanceID,
		OfferExpiresAt:     TimeToString(m.OfferExpiresAt),
		SubmittedAt:        TimeToString(m.SubmittedAt),
		DecidedAt:          TimeToString(m.DecidedAt),
		LoanAccountId:      m.LoanAccountID,
		Properties:         m.Properties.ToProtoStruct(),
	}

	return obj
}

func ApplicationFromAPI(ctx context.Context, obj *originationv1.ApplicationObject) *Application {
	if obj == nil {
		return nil
	}

	reqAmount, reqCurrency := MoneyToMinorUnits(obj.GetRequestedAmount())
	appAmount, _ := MoneyToMinorUnits(obj.GetApprovedAmount())
	currencyCode := reqCurrency

	model := &Application{
		ProductID:          obj.GetProductId(),
		ClientID:           obj.GetBorrowerId(),
		AgentID:            obj.GetAgentId(),
		BranchID:           obj.GetBranchId(),
		BankID:             obj.GetBankId(),
		Status:             int32(obj.GetStatus()),
		RequestedAmount:    reqAmount,
		ApprovedAmount:     appAmount,
		RequestedTermDays:  obj.GetRequestedTermDays(),
		ApprovedTermDays:   obj.GetApprovedTermDays(),
		InterestRate:       StringToBasisPoints(obj.GetInterestRate()),
		CurrencyCode:       currencyCode,
		Purpose:            obj.GetPurpose(),
		RejectionReason:    obj.GetRejectionReason(),
		WorkflowInstanceID: obj.GetWorkflowInstanceId(),
		OfferExpiresAt:     StringToTime(obj.GetOfferExpiresAt()),
		SubmittedAt:        StringToTime(obj.GetSubmittedAt()),
		DecidedAt:          StringToTime(obj.GetDecidedAt()),
		LoanAccountID:      obj.GetLoanAccountId(),
	}

	if obj.GetKycData() != nil {
		model.KycData = (&data.JSONMap{}).FromProtoStruct(obj.GetKycData())
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

// ApplicationDocument represents a document attached to an application.
type ApplicationDocument struct {
	data.BaseModel
	ApplicationID      string `gorm:"type:varchar(50);index:idx_appdoc_app"`
	DocumentType       int32
	FileID             string `gorm:"type:varchar(50)"`
	FileName           string `gorm:"type:varchar(255)"`
	MimeType           string `gorm:"type:varchar(100)"`
	VerificationStatus int32
	VerifiedBy         string `gorm:"type:varchar(50)"`
	VerifiedAt         *time.Time
	RejectionReason    string `gorm:"type:text"`
	Properties         data.JSONMap
}

func (m *ApplicationDocument) TableName() string { return "application_documents" }

func (m *ApplicationDocument) ToAPI() *originationv1.ApplicationDocumentObject {
	return &originationv1.ApplicationDocumentObject{
		Id:                 m.GetID(),
		ApplicationId:      m.ApplicationID,
		DocumentType:       originationv1.DocumentType(m.DocumentType),
		FileId:             m.FileID,
		FileName:           m.FileName,
		MimeType:           m.MimeType,
		VerificationStatus: originationv1.VerificationStatus(m.VerificationStatus),
		VerifiedBy:         m.VerifiedBy,
		VerifiedAt:         TimeToString(m.VerifiedAt),
		RejectionReason:    m.RejectionReason,
		Properties:         m.Properties.ToProtoStruct(),
	}
}

func ApplicationDocumentFromAPI(
	ctx context.Context,
	obj *originationv1.ApplicationDocumentObject,
) *ApplicationDocument {
	if obj == nil {
		return nil
	}

	model := &ApplicationDocument{
		ApplicationID:      obj.GetApplicationId(),
		DocumentType:       int32(obj.GetDocumentType()),
		FileID:             obj.GetFileId(),
		FileName:           obj.GetFileName(),
		MimeType:           obj.GetMimeType(),
		VerificationStatus: int32(obj.GetVerificationStatus()),
		VerifiedBy:         obj.GetVerifiedBy(),
		VerifiedAt:         StringToTime(obj.GetVerifiedAt()),
		RejectionReason:    obj.GetRejectionReason(),
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

// VerificationTask represents a verification task assigned to a verifier.
type VerificationTask struct {
	data.BaseModel
	ApplicationID    string `gorm:"type:varchar(50);index:idx_vt_app"`
	AssignedTo       string `gorm:"type:varchar(50);index:idx_vt_assignee"`
	VerificationType string `gorm:"type:varchar(100)"`
	Status           int32
	Notes            string `gorm:"type:text"`
	Checklist        data.JSONMap
	Results          data.JSONMap
	CompletedAt      *time.Time
	Properties       data.JSONMap
}

func (m *VerificationTask) TableName() string { return "verification_tasks" }

func (m *VerificationTask) ToAPI() *originationv1.VerificationTaskObject {
	return &originationv1.VerificationTaskObject{
		Id:               m.GetID(),
		ApplicationId:    m.ApplicationID,
		AssignedTo:       m.AssignedTo,
		VerificationType: m.VerificationType,
		Status:           originationv1.VerificationStatus(m.Status),
		Notes:            m.Notes,
		Checklist:        m.Checklist.ToProtoStruct(),
		Results:          m.Results.ToProtoStruct(),
		CompletedAt:      TimeToString(m.CompletedAt),
		Properties:       m.Properties.ToProtoStruct(),
	}
}

func VerificationTaskFromAPI(ctx context.Context, obj *originationv1.VerificationTaskObject) *VerificationTask {
	if obj == nil {
		return nil
	}

	model := &VerificationTask{
		ApplicationID:    obj.GetApplicationId(),
		AssignedTo:       obj.GetAssignedTo(),
		VerificationType: obj.GetVerificationType(),
		Status:           int32(obj.GetStatus()),
		Notes:            obj.GetNotes(),
		CompletedAt:      StringToTime(obj.GetCompletedAt()),
	}

	if obj.GetChecklist() != nil {
		model.Checklist = (&data.JSONMap{}).FromProtoStruct(obj.GetChecklist())
	}
	if obj.GetResults() != nil {
		model.Results = (&data.JSONMap{}).FromProtoStruct(obj.GetResults())
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

// UnderwritingDecision represents a credit assessment decision.
type UnderwritingDecision struct {
	data.BaseModel
	ApplicationID    string `gorm:"type:varchar(50);index:idx_ud_app"`
	DecidedBy        string `gorm:"type:varchar(50)"`
	Outcome          int32
	CreditScore      int32
	RiskGrade        string `gorm:"type:varchar(10)"`
	CurrencyCode     string `gorm:"type:varchar(3)"`
	ApprovedAmount   int64  // minor units
	ApprovedTermDays int32
	ApprovedRate     int64  // basis points
	Reason           string `gorm:"type:text"`
	ScoringDetails   data.JSONMap
	Conditions       data.JSONMap
	Properties       data.JSONMap
}

func (m *UnderwritingDecision) TableName() string { return "underwriting_decisions" }

func (m *UnderwritingDecision) ToAPI() *originationv1.UnderwritingDecisionObject {
	return &originationv1.UnderwritingDecisionObject{
		Id:               m.GetID(),
		ApplicationId:    m.ApplicationID,
		DecidedBy:        m.DecidedBy,
		Outcome:          originationv1.UnderwritingOutcome(m.Outcome),
		CreditScore:      m.CreditScore,
		RiskGrade:        m.RiskGrade,
		ApprovedAmount:   MinorUnitsToMoney(m.ApprovedAmount, m.CurrencyCode),
		ApprovedTermDays: m.ApprovedTermDays,
		ApprovedRate:     BasisPointsToString(m.ApprovedRate),
		Reason:           m.Reason,
		ScoringDetails:   m.ScoringDetails.ToProtoStruct(),
		Conditions:       m.Conditions.ToProtoStruct(),
		Properties:       m.Properties.ToProtoStruct(),
	}
}

func UnderwritingDecisionFromAPI(
	ctx context.Context,
	obj *originationv1.UnderwritingDecisionObject,
) *UnderwritingDecision {
	if obj == nil {
		return nil
	}

	approvedAmount, approvedCurrency := MoneyToMinorUnits(obj.GetApprovedAmount())

	model := &UnderwritingDecision{
		ApplicationID:    obj.GetApplicationId(),
		DecidedBy:        obj.GetDecidedBy(),
		Outcome:          int32(obj.GetOutcome()),
		CreditScore:      obj.GetCreditScore(),
		RiskGrade:        obj.GetRiskGrade(),
		CurrencyCode:     approvedCurrency,
		ApprovedAmount:   approvedAmount,
		ApprovedTermDays: obj.GetApprovedTermDays(),
		ApprovedRate:     StringToBasisPoints(obj.GetApprovedRate()),
		Reason:           obj.GetReason(),
	}

	if obj.GetScoringDetails() != nil {
		model.ScoringDetails = (&data.JSONMap{}).FromProtoStruct(obj.GetScoringDetails())
	}
	if obj.GetConditions() != nil {
		model.Conditions = (&data.JSONMap{}).FromProtoStruct(obj.GetConditions())
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

// ApplicationStatusHistory records application status changes (internal audit only, no API).
type ApplicationStatusHistory struct {
	data.BaseModel
	ApplicationID  string `gorm:"type:varchar(50);index:idx_ash_app"`
	PreviousStatus int32
	NewStatus      int32
	ChangedBy      string `gorm:"type:varchar(50)"`
	Reason         string `gorm:"type:text"`
}

func (m *ApplicationStatusHistory) TableName() string { return "application_status_history" }

// ClientProductAccess controls which loan products a client is allowed to apply for.
// An empty table means unrestricted access (all products). When rows exist for a
// client, only the listed products are available.
type ClientProductAccess struct {
	data.BaseModel
	ClientID  string `gorm:"type:varchar(50);uniqueIndex:uq_cpa_client_product,priority:1;index:idx_cpa_client;not null"`
	ProductID string `gorm:"type:varchar(50);uniqueIndex:uq_cpa_client_product,priority:2;not null"`
	GrantedBy string `gorm:"type:varchar(50)"`
	State     int32
}

func (m *ClientProductAccess) TableName() string { return "client_product_access" }

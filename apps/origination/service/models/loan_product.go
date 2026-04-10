package models

import (
	"context"

	commonv1 "buf.build/gen/go/antinvestor/common/protocolbuffers/go/common/v1"
	originationv1 "buf.build/gen/go/antinvestor/origination/protocolbuffers/go/origination/v1"
	"github.com/pitabwire/frame/data"
)

// LoanProduct represents a loan product configuration in the origination service.
type LoanProduct struct {
	data.BaseModel
	OrganizationID       string `gorm:"type:varchar(50);index:idx_olp_org"`
	Name                 string `gorm:"type:varchar(255)"`
	Code                 string `gorm:"type:varchar(50);uniqueIndex:uq_olp_code"`
	Description          string `gorm:"type:text"`
	ProductType          int32
	CurrencyCode         string `gorm:"type:varchar(3)"`
	InterestMethod       int32
	RepaymentFrequency   int32
	MinAmount            int64
	MaxAmount            int64
	MinTermDays          int32
	MaxTermDays          int32
	AnnualInterestRate   int64 // basis points
	ProcessingFeePercent int64 // basis points
	InsuranceFeePercent  int64 // basis points
	LatePenaltyRate      int64 // basis points
	GracePeriodDays      int32
	KycSchema            data.JSONMap
	FeeStructure         data.JSONMap
	EligibilityCriteria  data.JSONMap
	RequiredDocuments    data.JSONMap
	State                int32
	Properties           data.JSONMap
}

func (m *LoanProduct) TableName() string { return "origination_loan_products" }

func (m *LoanProduct) ToAPI() *originationv1.LoanProductObject {
	return &originationv1.LoanProductObject{
		Id:                   m.GetID(),
		OrganizationId:       m.OrganizationID,
		Name:                 m.Name,
		Code:                 m.Code,
		Description:          m.Description,
		ProductType:          originationv1.LoanProductType(m.ProductType),
		CurrencyCode:         m.CurrencyCode,
		InterestMethod:       originationv1.InterestMethod(m.InterestMethod),
		RepaymentFrequency:   originationv1.RepaymentFrequency(m.RepaymentFrequency),
		MinAmount:            MinorUnitsToMoney(m.MinAmount, m.CurrencyCode),
		MaxAmount:            MinorUnitsToMoney(m.MaxAmount, m.CurrencyCode),
		MinTermDays:          m.MinTermDays,
		MaxTermDays:          m.MaxTermDays,
		AnnualInterestRate:   BasisPointsToString(m.AnnualInterestRate),
		ProcessingFeePercent: BasisPointsToString(m.ProcessingFeePercent),
		InsuranceFeePercent:  BasisPointsToString(m.InsuranceFeePercent),
		LatePenaltyRate:      BasisPointsToString(m.LatePenaltyRate),
		GracePeriodDays:      m.GracePeriodDays,
		KycSchema:            m.KycSchema.ToProtoStruct(),
		FeeStructure:         m.FeeStructure.ToProtoStruct(),
		EligibilityCriteria:  m.EligibilityCriteria.ToProtoStruct(),
		RequiredDocuments:    jsonMapToStringSlice(m.RequiredDocuments),
		State:                commonv1.STATE(m.State),
		Properties:           m.Properties.ToProtoStruct(),
	}
}

func LoanProductFromAPI(ctx context.Context, obj *originationv1.LoanProductObject) *LoanProduct {
	if obj == nil {
		return nil
	}

	lpMin, _ := MoneyToMinorUnits(obj.GetMinAmount())
	lpMax, _ := MoneyToMinorUnits(obj.GetMaxAmount())

	model := &LoanProduct{
		OrganizationID:       obj.GetOrganizationId(),
		Name:                 obj.GetName(),
		Code:                 obj.GetCode(),
		Description:          obj.GetDescription(),
		ProductType:          int32(obj.GetProductType()),
		CurrencyCode:         obj.GetCurrencyCode(),
		InterestMethod:       int32(obj.GetInterestMethod()),
		RepaymentFrequency:   int32(obj.GetRepaymentFrequency()),
		MinAmount:            lpMin,
		MaxAmount:            lpMax,
		MinTermDays:          obj.GetMinTermDays(),
		MaxTermDays:          obj.GetMaxTermDays(),
		AnnualInterestRate:   StringToBasisPoints(obj.GetAnnualInterestRate()),
		ProcessingFeePercent: StringToBasisPoints(obj.GetProcessingFeePercent()),
		InsuranceFeePercent:  StringToBasisPoints(obj.GetInsuranceFeePercent()),
		LatePenaltyRate:      StringToBasisPoints(obj.GetLatePenaltyRate()),
		GracePeriodDays:      obj.GetGracePeriodDays(),
		State:                int32(obj.GetState()),
	}

	if obj.GetKycSchema() != nil {
		model.KycSchema = (&data.JSONMap{}).FromProtoStruct(obj.GetKycSchema())
	}
	if obj.GetFeeStructure() != nil {
		model.FeeStructure = (&data.JSONMap{}).FromProtoStruct(obj.GetFeeStructure())
	}
	if obj.GetEligibilityCriteria() != nil {
		model.EligibilityCriteria = (&data.JSONMap{}).FromProtoStruct(obj.GetEligibilityCriteria())
	}
	if len(obj.GetRequiredDocuments()) > 0 {
		model.RequiredDocuments = stringSliceToJSONMap(obj.GetRequiredDocuments())
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

package models

import (
	"time"

	"github.com/pitabwire/frame/data"
)

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

// PeriodType defines the period frequency.
type PeriodType int32

const (
	PeriodTypeUnspecified PeriodType = 0
	PeriodTypeWeekly      PeriodType = 1
	PeriodTypeBiweekly    PeriodType = 2
	PeriodTypeMonthly     PeriodType = 3
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

// InfractionType defines types of infractions.
type InfractionType int32

const (
	InfractionTypeUnspecified               InfractionType = 0
	InfractionTypeGroupClosedOwesMoney      InfractionType = 1
	InfractionTypeGroupInactivated          InfractionType = 2
	InfractionTypeGroupClosedVoluntarily    InfractionType = 3
	InfractionTypeAccountInvalid            InfractionType = 4
	InfractionTypeSavingsLowerThanExpected  InfractionType = 5
	InfractionTypeLoanPaymentsNotAsExpected InfractionType = 6
	InfractionTypeSystemError               InfractionType = 7
)

// CustomerGroup represents a SACCO savings/lending group.
type CustomerGroup struct {
	data.BaseModel
	ProductID     string `gorm:"type:varchar(50);index:idx_grp_product"`
	ParentID      string `gorm:"type:varchar(50);index:idx_grp_parent"`
	Name          string `gorm:"type:varchar(255);not null"`
	GroupType     int32  `gorm:"column:group_type"`
	SavingAmount  int64  // minor units
	Currency      string `gorm:"type:varchar(3)"`
	TimeZone      string `gorm:"type:varchar(50)"`
	State         int32
	LenderGroupID string `gorm:"type:varchar(50)"` // cross-ref to Identity GroupObject
	DateActive    *time.Time
	DateChecked   *time.Time
	DateInspected *time.Time
	Properties    data.JSONMap
}

func (m *CustomerGroup) TableName() string { return "customer_groups" }
func (m *CustomerGroup) SetVersion(v uint) { m.Version = v }

// Membership represents a member's subscription to a group.
type Membership struct {
	data.BaseModel
	Name                 string `gorm:"type:varchar(255)"`
	ContactID            string `gorm:"type:varchar(50);index:idx_mem_contact"`
	ProfileID            string `gorm:"type:varchar(50);index:idx_mem_profile"`
	GroupID              string `gorm:"type:varchar(50);index:idx_mem_group;not null"`
	MembershipType       int32  `gorm:"column:membership_type"`
	Role                 int32
	OrderNo              int32
	TimeZone             string `gorm:"type:varchar(50)"`
	State                int32
	IdentityMembershipID string `gorm:"type:varchar(50)"` // cross-ref to Identity MembershipObject
	IdentityClientID     string `gorm:"type:varchar(50)"` // cross-ref to Identity ClientObject
	PrevLoanReqDate      *time.Time
	NextLoanReqDate      *time.Time
	Properties           data.JSONMap
}

func (m *Membership) TableName() string { return "memberships" }
func (m *Membership) SetVersion(v uint) { m.Version = v }

// Tenure represents a group's lifecycle period (e.g. 52 weeks).
type Tenure struct {
	data.BaseModel
	GroupID    string `gorm:"type:varchar(50);index:idx_ten_group;not null"`
	StartDate  *time.Time
	EndDate    *time.Time
	Duration   int32 // number of periods
	Position   int32
	Welcomed   bool
	State      int32
	Properties data.JSONMap
}

func (m *Tenure) TableName() string { return "tenures" }
func (m *Tenure) SetVersion(v uint) { m.Version = v }

// Period represents a single time period within a tenure (e.g. 1 week).
type Period struct {
	data.BaseModel
	GroupID        string `gorm:"type:varchar(50);index:idx_per_group;not null"`
	TenureID       string `gorm:"type:varchar(50);index:idx_per_tenure;not null"`
	StartDate      *time.Time
	EndDate        *time.Time
	PeriodType     int32 `gorm:"column:period_type"`
	Position       int32
	ParentPeriodID string `gorm:"type:varchar(50);uniqueIndex:uq_per_parent"`
	State          int32
	Properties     data.JSONMap
}

func (m *Period) TableName() string { return "periods" }
func (m *Period) SetVersion(v uint) { m.Version = v }

// Motion represents a group voting/decision motion.
type Motion struct {
	data.BaseModel
	GroupID     string `gorm:"type:varchar(50);index:idx_mot_group;not null"`
	MotionType  int32
	Agenda      string `gorm:"type:text"`
	Threshold   int32  // minimum votes needed
	ExpiryDate  *time.Time
	Description string `gorm:"type:text"`
	State       int32
	Properties  data.JSONMap
}

func (m *Motion) TableName() string { return "motions" }
func (m *Motion) SetVersion(v uint) { m.Version = v }

// MotionVote represents a member's vote on a motion.
type MotionVote struct {
	data.BaseModel
	MotionID     string `gorm:"type:varchar(50);index:idx_mv_motion;not null"`
	MembershipID string `gorm:"type:varchar(50);index:idx_mv_member;not null"`
	Choice       int32
	Properties   data.JSONMap
}

func (m *MotionVote) TableName() string { return "motion_votes" }

// Infraction represents a rule violation by a member.
type Infraction struct {
	data.BaseModel
	OwnerID        string `gorm:"type:varchar(50);index:idx_inf_owner"`
	OwnerType      string `gorm:"type:varchar(50)"`
	GroupID        string `gorm:"type:varchar(50);index:idx_inf_group"`
	InfractionType int32  `gorm:"column:infraction_type"`
	Amount         int64  // minor units
	Currency       string `gorm:"type:varchar(3)"`
	Message        string `gorm:"type:text"`
	Canceled       bool
	State          int32
	Properties     data.JSONMap
}

func (m *Infraction) TableName() string { return "infractions" }
func (m *Infraction) SetVersion(v uint) { m.Version = v }

// GroupWarning represents a warning issued to a group.
type GroupWarning struct {
	data.BaseModel
	GroupID     string `gorm:"type:varchar(50);index:idx_gw_group;not null"`
	WarningType int32
	Message     string `gorm:"type:text"`
	State       int32
	Properties  data.JSONMap
}

func (m *GroupWarning) TableName() string { return "group_warnings" }

// MemberScore represents a member's compliance/creditworthiness score.
type MemberScore struct {
	data.BaseModel
	MembershipID string `gorm:"type:varchar(50);index:idx_ms_member;not null"`
	Score        int32
	ScoreType    int32
	Description  string `gorm:"type:text"`
	Properties   data.JSONMap
}

func (m *MemberScore) TableName() string { return "member_scores" }

// Occurrence represents a notable event in a group's lifecycle.
type Occurrence struct {
	data.BaseModel
	GroupID     string `gorm:"type:varchar(50);index:idx_occ_group"`
	OccurType   int32
	Description string `gorm:"type:text"`
	Properties  data.JSONMap
}

func (m *Occurrence) TableName() string { return "occurrences" }

// Report represents a system-generated report.
type Report struct {
	data.BaseModel
	GroupID    string `gorm:"type:varchar(50);index:idx_rpt_group"`
	ReportType int32
	Title      string `gorm:"type:varchar(255)"`
	Content    string `gorm:"type:text"`
	State      int32
	Properties data.JSONMap
}

func (m *Report) TableName() string { return "reports" }

// ReportRecipient represents a recipient of a report.
type ReportRecipient struct {
	data.BaseModel
	ReportID    string `gorm:"type:varchar(50);index:idx_rr_report;not null"`
	RecipientID string `gorm:"type:varchar(50)"`
	Channel     string `gorm:"type:varchar(50)"`
	State       int32
}

func (m *ReportRecipient) TableName() string { return "report_recipients" }

// RequestLog represents an audit log of API requests.
type RequestLog struct {
	data.BaseModel
	GroupID     string `gorm:"type:varchar(50);index:idx_rl_group"`
	RequestType int32
	Details     string `gorm:"type:text"`
	State       int32
	Properties  data.JSONMap
}

func (m *RequestLog) TableName() string { return "request_logs" }

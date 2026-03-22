package constants

// Entity states matching Java GrameenBase.STATE values.
const (
	StateJustCreated  = 1
	StateCheckCreated = 2
	StateActive       = 3
	StateInactive     = 4
	StateDeleted      = 5
	StateShutdown     = 6
)

// Entity status values.
const (
	StatusUnknown    = 0
	StatusSuccessful = 1
	StatusPreprocess = 2
)

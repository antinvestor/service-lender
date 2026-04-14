// Copyright 2023-2026 Ant Investor Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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

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

package business

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

func TestLockKeysDeterministicOrder(t *testing.T) {
	subjects := []repository.SubjectFilter{
		{Type: models.SubjectClient, ID: "c1"},
		{Type: models.SubjectAccount, ID: "a1"},
		{Type: models.SubjectOrganization, ID: "o1"},
	}
	a := LockKeys(models.ActionLoanDisbursement, "KES", subjects)
	b := LockKeys(models.ActionLoanDisbursement, "KES", subjects)
	assert.Equal(t, a, b, "same input must produce same keys")
	assert.True(t, sortedAscending(a), "keys must be ascending")
}

func TestLockKeysOrderIndependent(t *testing.T) {
	s1 := []repository.SubjectFilter{
		{Type: models.SubjectClient, ID: "c1"},
		{Type: models.SubjectAccount, ID: "a1"},
	}
	s2 := []repository.SubjectFilter{
		{Type: models.SubjectAccount, ID: "a1"},
		{Type: models.SubjectClient, ID: "c1"},
	}
	assert.Equal(t, LockKeys(models.ActionLoanDisbursement, "KES", s1),
		LockKeys(models.ActionLoanDisbursement, "KES", s2))
}

func sortedAscending(keys []int64) bool {
	for i := 1; i < len(keys); i++ {
		if keys[i] < keys[i-1] {
			return false
		}
	}
	return true
}

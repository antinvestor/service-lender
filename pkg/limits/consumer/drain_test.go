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

package consumer

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestDrain_RejectsGET(t *testing.T) {
	h := newDrainHandler(nil)
	w := httptest.NewRecorder()
	r := httptest.NewRequest(http.MethodGet, "/admin/limits-outbox/drain", nil)
	h.ServeHTTP(w, r)
	assert.Equal(t, http.StatusMethodNotAllowed, w.Result().StatusCode)
}

func TestDrain_NilWorker_503(t *testing.T) {
	h := newDrainHandler(nil)
	w := httptest.NewRecorder()
	r := httptest.NewRequest(http.MethodPost, "/admin/limits-outbox/drain", nil)
	h.ServeHTTP(w, r)
	assert.Equal(t, http.StatusServiceUnavailable, w.Result().StatusCode)
}

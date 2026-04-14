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

package handlers

import (
	"encoding/json"
	"net/http"
	"strings"

	"github.com/antinvestor/service-fintech/apps/identity/service/business"
)

// LoginTargetsHandler serves the unauthenticated login-targets REST endpoint.
// GET /api/v1/login-targets/{client_id} — returns child login targets for drill-down.
type LoginTargetsHandler struct {
	loginClientBusiness business.LoginClientBusiness
}

func NewLoginTargetsHandler(lcb business.LoginClientBusiness) *LoginTargetsHandler {
	return &LoginTargetsHandler{loginClientBusiness: lcb}
}

func (h *LoginTargetsHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Extract client_id from path: /api/v1/login-targets/{client_id}
	path := strings.TrimPrefix(r.URL.Path, "/api/v1/login-targets/")
	clientID := strings.TrimRight(path, "/")
	if clientID == "" {
		http.Error(w, "client_id is required", http.StatusBadRequest)
		return
	}

	resp, err := h.loginClientBusiness.GetLoginTargets(r.Context(), clientID)
	if err != nil {
		http.Error(w, "failed to resolve login targets", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if encErr := json.NewEncoder(w).Encode(resp); encErr != nil {
		http.Error(w, "failed to encode response", http.StatusInternalServerError)
	}
}

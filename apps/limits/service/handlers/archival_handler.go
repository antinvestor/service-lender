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

	"github.com/pitabwire/util"

	"github.com/antinvestor/service-fintech/apps/limits/service/business"
)

// ArchivalHandler serves POST /admin/archive. It hard-deletes terminal
// reservations and old ledger entries via the Archival business job.
type ArchivalHandler struct {
	archival *business.Archival
}

// NewArchivalHandler constructs the handler.
func NewArchivalHandler(archival *business.Archival) *ArchivalHandler {
	return &ArchivalHandler{archival: archival}
}

// ServeHTTP implements http.Handler.
func (h *ArchivalHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	resvN, ledgerN, err := h.archival.Run(r.Context())
	if err != nil {
		util.Log(r.Context()).WithError(err).Error("archival run failed")
		http.Error(w, "archival failed", http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]int{
		"reservations_deleted": resvN,
		"ledger_deleted":       ledgerN,
	})
}

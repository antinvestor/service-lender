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

	"github.com/antinvestor/service-fintech/pkg/limits/outbox"
)

// LimitsOutboxDrainHandler exposes the limits-outbox drain as a non-Connect
// HTTP endpoint. It is intentionally not part of the LoanManagementService
// proto — it's an internal admin trigger called by the platform's Trustage
// workflow scheduler, not by user-facing clients.
type LimitsOutboxDrainHandler struct {
	worker *outbox.Worker
}

// NewLimitsOutboxDrainHandler constructs the handler around an existing
// outbox.Worker. The worker is configured in main.go.
func NewLimitsOutboxDrainHandler(w *outbox.Worker) *LimitsOutboxDrainHandler {
	return &LimitsOutboxDrainHandler{worker: w}
}

// ServeHTTP responds to POST requests by draining one batch of outbox
// rows. Returns 200 with {drained: N} on success, 405 for non-POST,
// 503 if the worker isn't configured, 500 on drain error.
func (h *LimitsOutboxDrainHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	if h.worker == nil {
		http.Error(w, "outbox worker not configured", http.StatusServiceUnavailable)
		return
	}
	count, err := h.worker.Drain(r.Context())
	if err != nil {
		util.Log(r.Context()).WithError(err).Error("limits outbox drain failed")
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]int{"drained": count})
}

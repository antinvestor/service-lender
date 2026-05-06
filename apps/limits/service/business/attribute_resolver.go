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
	"context"
	"encoding/json"
	"sync"
	"time"

	"buf.build/gen/go/antinvestor/identity/connectrpc/go/identity/v1/identityv1connect"
	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	"connectrpc.com/connect"
	"github.com/pitabwire/util"
	"gorm.io/datatypes"

	"github.com/antinvestor/service-fintech/apps/limits/service/models"
	"github.com/antinvestor/service-fintech/apps/limits/service/repository"
)

// AttributeResolver fetches a subject's attributes for predicate evaluation.
//
// Read-through cache order:
//  1. In-process LRU map (configurable TTL, default 60 s). Hit → return.
//  2. SubjectAttributeRepository (DB-backed snapshot). Fresh hit → populate LRU + return.
//  3. Identity service. Success → persist to DB, populate LRU, return.
//
// For non-client subjects (account, product, organization, org_unit,
// workforce_member) the resolver returns an empty attribute map for v1.
// These subject types do not yet have queryable attributes in identity.
//
// On identity fetch failure the resolver returns (nil, nil). The evaluator
// interprets nil as "no attributes", so any AttributeFilter predicate
// evaluates to FALSE — policies don't fire when attributes are unavailable.
// This is the safe failure mode.
type AttributeResolver interface {
	Get(ctx context.Context, subjectType models.Subject, subjectID string) (map[string]any, error)
	Invalidate(subjectType models.Subject, subjectID string)
}

type attributeResolver struct {
	repo           repository.SubjectAttributeRepository
	identityClient identityv1connect.IdentityServiceClient
	cache          map[string]cachedAttrs
	cacheMu        sync.RWMutex
	ttl            time.Duration
}

type cachedAttrs struct {
	attrs     map[string]any
	expiresAt time.Time
}

// NewAttributeResolver constructs a resolver. A nil identity client makes
// the resolver "DB-only" — useful in tests and as a graceful fallback when
// the identity service is misconfigured.
func NewAttributeResolver(
	repo repository.SubjectAttributeRepository,
	identityClient identityv1connect.IdentityServiceClient,
	ttl time.Duration,
) AttributeResolver {
	if ttl == 0 {
		ttl = 60 * time.Second
	}
	return &attributeResolver{
		repo:           repo,
		identityClient: identityClient,
		cache:          make(map[string]cachedAttrs),
		ttl:            ttl,
	}
}

// Get returns the attribute map for the given subject.
func (r *attributeResolver) Get(
	ctx context.Context,
	subjectType models.Subject,
	subjectID string,
) (map[string]any, error) {
	if subjectType != models.SubjectClient {
		// v1: only client subjects have queryable attributes in identity.
		return map[string]any{}, nil
	}

	key := string(subjectType) + ":" + subjectID

	// 1. LRU check.
	r.cacheMu.RLock()
	if c, ok := r.cache[key]; ok && time.Now().Before(c.expiresAt) {
		r.cacheMu.RUnlock()
		return c.attrs, nil
	}
	r.cacheMu.RUnlock()

	// 2. DB snapshot check.
	snap, err := r.repo.Get(ctx, subjectType, subjectID)
	if err == nil && snap != nil && time.Since(snap.FetchedAt) < r.ttl {
		attrs := decodeAttrs(snap.Attributes)
		r.populate(key, attrs)
		return attrs, nil
	}

	// 3. Identity fetch.
	attrs, fetchErr := r.fetchFromIdentity(ctx, subjectID)
	if fetchErr != nil {
		util.Log(ctx).
			WithError(fetchErr).
			WithField("subject_type", string(subjectType)).
			WithField("subject_id", subjectID).
			Warn("attribute resolver: identity fetch failed; falling back to empty attributes")
		return nil, nil
	}

	// Persist + populate LRU.
	if attrs != nil {
		j, _ := json.Marshal(attrs)
		_ = r.repo.Upsert(ctx, &models.SubjectAttributeSnapshot{
			SubjectType: subjectType,
			SubjectID:   subjectID,
			Attributes:  datatypes.JSON(j),
			FetchedAt:   time.Now().UTC(),
		})
		r.populate(key, attrs)
	}
	return attrs, nil
}

// Invalidate removes the LRU entry for the given subject. The next call to
// Get will re-check the DB and identity service.
func (r *attributeResolver) Invalidate(subjectType models.Subject, subjectID string) {
	key := string(subjectType) + ":" + subjectID
	r.cacheMu.Lock()
	delete(r.cache, key)
	r.cacheMu.Unlock()
}

func (r *attributeResolver) populate(key string, attrs map[string]any) {
	r.cacheMu.Lock()
	r.cache[key] = cachedAttrs{attrs: attrs, expiresAt: time.Now().Add(r.ttl)}
	r.cacheMu.Unlock()
}

func decodeAttrs(j datatypes.JSON) map[string]any {
	if len(j) == 0 {
		return map[string]any{}
	}
	var m map[string]any
	_ = json.Unmarshal(j, &m)
	return m
}

// fetchFromIdentity pulls the subject's attributes from the identity service
// and projects them into a flat map.
//
// Identity model mapping:
//   - "client" subjects in the limits service map to InvestorObject in
//     the identity service (InvestorGet RPC).
//   - InvestorObject exposes: id, profile_id, name, state, properties.
//   - kyc_tier and country_code are not first-class proto fields on
//     InvestorObject in the current identity API version; they may be stored
//     in the Properties structpb if populated by the identity service.
//     TODO(plan-4): once identity exposes dedicated kyc_tier / country_code
//     fields on InvestorObject (or a dedicated ClientGet RPC is available),
//     update this projection to extract those fields directly.
//
// Returns (nil, nil) when the client isn't configured (graceful degradation).
func (r *attributeResolver) fetchFromIdentity(ctx context.Context, clientID string) (map[string]any, error) {
	if r.identityClient == nil {
		return nil, nil
	}

	resp, err := r.identityClient.InvestorGet(
		ctx,
		connect.NewRequest(&identityv1.InvestorGetRequest{Id: clientID}),
	)
	if err != nil {
		return nil, err
	}

	inv := resp.Msg.GetData()
	if inv == nil {
		return map[string]any{}, nil
	}

	attrs := map[string]any{
		"state":      inv.GetState().String(),
		"name":       inv.GetName(),
		"profile_id": inv.GetProfileId(),
	}

	// Merge any entries from the properties bag. This covers dynamic
	// attributes such as kyc_tier / country_code that identity services
	// may store there until first-class proto fields are added.
	if props := inv.GetProperties(); props != nil {
		for k, v := range props.GetFields() {
			attrs[k] = v.AsInterface()
		}
	}

	return attrs, nil
}

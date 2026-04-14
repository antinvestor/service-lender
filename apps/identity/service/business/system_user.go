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

	identityv1 "buf.build/gen/go/antinvestor/identity/protocolbuffers/go/identity/v1"
	fevents "github.com/pitabwire/frame/events"

	"github.com/antinvestor/service-fintech/apps/identity/service/repository"
)

type SystemUserBusiness interface {
	Save(ctx context.Context, obj *identityv1.SystemUserObject) (*identityv1.SystemUserObject, error)
	Get(ctx context.Context, id string) (*identityv1.SystemUserObject, error)
	Search(
		ctx context.Context,
		req *identityv1.SystemUserSearchRequest,
		consumer func(ctx context.Context, batch []*identityv1.SystemUserObject) error,
	) error
}

type systemUserBusiness struct {
	eventsMan      fevents.Manager
	branchRepo     repository.BranchRepository
	systemUserRepo repository.SystemUserRepository
}

func NewSystemUserBusiness(
	_ context.Context,
	eventsMan fevents.Manager,
	branchRepo repository.BranchRepository,
	systemUserRepo repository.SystemUserRepository,
) SystemUserBusiness {
	return &systemUserBusiness{
		eventsMan:      eventsMan,
		branchRepo:     branchRepo,
		systemUserRepo: systemUserRepo,
	}
}

func (b *systemUserBusiness) Save(context.Context, *identityv1.SystemUserObject) (*identityv1.SystemUserObject, error) {
	return nil, ErrDeprecatedSystemUserModel
}

func (b *systemUserBusiness) Get(context.Context, string) (*identityv1.SystemUserObject, error) {
	return nil, ErrDeprecatedSystemUserModel
}

func (b *systemUserBusiness) Search(
	context.Context,
	*identityv1.SystemUserSearchRequest,
	func(context.Context, []*identityv1.SystemUserObject) error,
) error {
	return ErrDeprecatedSystemUserModel
}

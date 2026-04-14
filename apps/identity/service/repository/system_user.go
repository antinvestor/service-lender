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

package repository

import (
	"context"

	"github.com/pitabwire/frame/datastore"
	"github.com/pitabwire/frame/datastore/pool"
	"github.com/pitabwire/frame/workerpool"

	"github.com/antinvestor/service-fintech/apps/identity/service/models"
)

type SystemUserRepository interface {
	datastore.BaseRepository[*models.SystemUser]
	GetByProfileID(ctx context.Context, profileID string) (*models.SystemUser, error)
	GetByRole(ctx context.Context, role int32, offset, limit int) ([]*models.SystemUser, error)
	GetByBranchAndRole(
		ctx context.Context,
		branchID string,
		role int32,
		offset, limit int,
	) ([]*models.SystemUser, error)
}

type systemUserRepository struct {
	datastore.BaseRepository[*models.SystemUser]
}

func NewSystemUserRepository(ctx context.Context, dbPool pool.Pool, workMan workerpool.Manager) SystemUserRepository {
	return &systemUserRepository{
		BaseRepository: datastore.NewBaseRepository[*models.SystemUser](
			ctx, dbPool, workMan, func() *models.SystemUser { return &models.SystemUser{} },
		),
	}
}

func (repo *systemUserRepository) GetByProfileID(ctx context.Context, profileID string) (*models.SystemUser, error) {
	su := models.SystemUser{}
	err := repo.Pool().DB(ctx, true).First(&su, "profile_id = ?", profileID).Error
	if err != nil {
		return nil, err
	}
	return &su, nil
}

func (repo *systemUserRepository) GetByRole(
	ctx context.Context,
	role int32,
	offset, limit int,
) ([]*models.SystemUser, error) {
	var users []*models.SystemUser
	err := repo.Pool().DB(ctx, true).
		Where("role = ?", role).
		Offset(offset).Limit(limit).
		Find(&users).Error
	if err != nil {
		return nil, err
	}
	return users, nil
}

func (repo *systemUserRepository) GetByBranchAndRole(
	ctx context.Context,
	branchID string,
	role int32,
	offset, limit int,
) ([]*models.SystemUser, error) {
	var users []*models.SystemUser
	err := repo.Pool().DB(ctx, true).
		Where("branch_id = ? AND role = ?", branchID, role).
		Offset(offset).Limit(limit).
		Find(&users).Error
	if err != nil {
		return nil, err
	}
	return users, nil
}

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

// Package authz provides authorization namespace constants.
//
// Permissions and role bindings are defined in the proto service descriptor
// (identity.proto → service_permissions option) and registered at startup
// via frame.WithPermissionRegistration. This file only holds namespace
// identifiers needed by code outside the auto-registration path.
package authz

const (
	// NamespaceLenderIdentity is the Keto namespace for the identity service.
	NamespaceLenderIdentity = "service_identity"

	// NamespaceField is the Keto namespace for the field service.
	NamespaceField = "service_field"

	// NamespaceTenancyAccess is the Keto namespace for tenancy-level access checks.
	NamespaceTenancyAccess = "tenancy_access"

	// NamespaceProfile is the Keto namespace for profile-level access checks.
	NamespaceProfile = "profile_user"

	// RoleService is the Keto relation for service bot access.
	// Used in tuple building for service account inheritance.
	RoleService = "service"
)

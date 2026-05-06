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

import 'package:antinvestor_ui_limits/antinvestor_ui_limits.dart';
import 'package:go_router/go_router.dart';

/// LimitsFeature mounts the limits operator surface into the seed app.
/// Routes are exported from `antinvestor_ui_limits`; this thin wrapper
/// gives the seed app a uniform handle for sidebar/menu wiring per the
/// existing per-feature convention.
class LimitsFeature {
  static List<GoRoute> routes() => limitsRoutes();
  static const String sidebarLabel = 'Limits';
  static const String defaultRoute = '/limits/policies';
}

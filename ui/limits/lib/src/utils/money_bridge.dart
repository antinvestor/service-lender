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

// Bridges proto types from service-specific API packages to the common
// types expected by antinvestor_ui_core.

import 'package:antinvestor_api_common/antinvestor_api_common.dart'
    show Money, STATE;
import 'package:fixnum/fixnum.dart';

/// Converts any proto Money object to the common [Money] type.
Money? bridgeMoney(dynamic money) {
  if (money == null) return null;
  final m = Money();
  m.currencyCode = money.currencyCode as String;
  m.units = money.units as Int64;
  m.nanos = money.nanos as int;
  return m;
}

/// Converts any proto STATE enum to the common [STATE] type.
STATE bridgeState(dynamic state) {
  return STATE.valueOf((state as dynamic).value as int) ?? STATE.CREATED;
}

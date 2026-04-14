// Bridges proto types from service-specific API packages to the common
// types expected by antinvestor_ui_core.
//
// This is needed because each API package generates its own copy of
// shared proto types (google.type.Money, common.STATE), creating distinct
// Dart types that are structurally identical but not assignable to each other.

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

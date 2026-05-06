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

/// Format an integer second-count as a human string like "24h", "7d", "30m".
/// Used for displaying google.protobuf.Duration values stored as seconds.
String formatDuration(int seconds) {
  if (seconds <= 0) return '—';
  if (seconds % 86400 == 0) return '${seconds ~/ 86400}d';
  if (seconds % 3600 == 0) return '${seconds ~/ 3600}h';
  if (seconds % 60 == 0) return '${seconds ~/ 60}m';
  return '${seconds}s';
}

/// Parse a friendly duration string ("24h", "7d", "1800s", "30m") into seconds.
/// Returns null on parse error.
int? parseDuration(String s) {
  s = s.trim().toLowerCase();
  if (s.isEmpty) return null;
  final unit = s[s.length - 1];
  final n = int.tryParse(s.substring(0, s.length - 1));
  if (n == null) return int.tryParse(s); // raw seconds
  switch (unit) {
    case 'd':
      return n * 86400;
    case 'h':
      return n * 3600;
    case 'm':
      return n * 60;
    case 's':
      return n;
    default:
      return int.tryParse(s); // raw seconds (no unit suffix)
  }
}

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

import 'package:flutter/material.dart';

import '../utils/duration_format.dart';

class WindowDurationField extends StatefulWidget {
  final int initialSeconds;
  final ValueChanged<int> onChanged;
  const WindowDurationField({super.key, this.initialSeconds = 0, required this.onChanged});

  @override
  State<WindowDurationField> createState() => _WindowDurationFieldState();
}

class _WindowDurationFieldState extends State<WindowDurationField> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: widget.initialSeconds == 0 ? '' : formatDuration(widget.initialSeconds),
    );
  }

  void _emit() {
    final s = parseDuration(_ctrl.text);
    if (s != null) widget.onChanged(s);
  }

  void _setPreset(String preset) {
    setState(() => _ctrl.text = preset);
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _ctrl,
          decoration: const InputDecoration(
            labelText: 'Window',
            hintText: 'e.g. 24h, 7d, 30d',
          ),
          onChanged: (_) => _emit(),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          children: [
            for (final p in ['1h', '24h', '7d', '30d'])
              ActionChip(label: Text(p), onPressed: () => _setPreset(p)),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

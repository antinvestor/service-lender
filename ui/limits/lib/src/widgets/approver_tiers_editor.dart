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
import 'package:antinvestor_api_limits/antinvestor_api_limits.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class ApproverTiersEditor extends StatefulWidget {
  final List<ApproverTier> initial;
  final ValueChanged<List<ApproverTier>> onChanged;
  const ApproverTiersEditor({super.key, required this.initial, required this.onChanged});

  @override
  State<ApproverTiersEditor> createState() => _ApproverTiersEditorState();
}

class _ApproverTiersEditorState extends State<ApproverTiersEditor> {
  late List<ApproverTier> _tiers;

  @override
  void initState() {
    super.initState();
    _tiers = [...widget.initial];
  }

  void _addTier() {
    setState(() {
      _tiers.add(ApproverTier()
        ..upTo = Int64.ZERO
        ..role = ''
        ..approvers = 1);
    });
    widget.onChanged(_tiers);
  }

  void _removeTier(int i) {
    setState(() => _tiers.removeAt(i));
    widget.onChanged(_tiers);
  }

  void _updateTier(int i, ApproverTier updated) {
    setState(() => _tiers[i] = updated);
    widget.onChanged(_tiers);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Approver tiers', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        for (var i = 0; i < _tiers.length; i++) ...[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _tiers[i].upTo == Int64.ZERO ? '' : _tiers[i].upTo.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Up to (minor units, blank = catch-all)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    final n = v.isEmpty ? Int64.ZERO : Int64.parseInt(v);
                    _updateTier(i, _tiers[i].deepCopy()..upTo = n);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: _tiers[i].role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  onChanged: (v) => _updateTier(i, _tiers[i].deepCopy()..role = v),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: '${_tiers[i].approvers}',
                  decoration: const InputDecoration(labelText: 'Count'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _updateTier(
                    i,
                    _tiers[i].deepCopy()..approvers = int.tryParse(v) ?? 1,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _removeTier(i),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add tier'),
          onPressed: _addTier,
        ),
      ],
    );
  }
}

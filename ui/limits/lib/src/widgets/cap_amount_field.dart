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
import 'package:antinvestor_api_common/antinvestor_api_common.dart' show Money;
import 'package:fixnum/fixnum.dart';

const _commonCurrencies = ['KES', 'USD', 'EUR', 'GBP', 'UGX', 'TZS', 'JPY', 'KWD'];

class CapAmountField extends StatefulWidget {
  final Money? initial;
  final ValueChanged<Money?> onChanged;
  final String label;
  const CapAmountField({super.key, this.initial, required this.onChanged, this.label = 'Cap'});

  @override
  State<CapAmountField> createState() => _CapAmountFieldState();
}

class _CapAmountFieldState extends State<CapAmountField> {
  late TextEditingController _amountCtrl;
  late String _currency;

  @override
  void initState() {
    super.initState();
    _currency = widget.initial?.currencyCode ?? 'KES';
    _amountCtrl = TextEditingController(text: _formatInitial());
  }

  String _formatInitial() {
    final m = widget.initial;
    if (m == null) return '';
    final units = m.units.toInt();
    final nanos = m.nanos;
    if (nanos == 0) return units.toString();
    return '$units.${(nanos.abs() ~/ 10000000).toString().padLeft(2, '0')}';
  }

  void _emit() {
    final raw = _amountCtrl.text.trim();
    if (raw.isEmpty) {
      widget.onChanged(null);
      return;
    }
    final parts = raw.split('.');
    final units = int.tryParse(parts[0]) ?? 0;
    var nanos = 0;
    if (parts.length > 1) {
      final frac = parts[1].padRight(9, '0').substring(0, 9);
      nanos = int.tryParse(frac) ?? 0;
    }
    widget.onChanged(Money()
      ..currencyCode = _currency
      ..units = Int64(units)
      ..nanos = nanos);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: widget.label),
            onChanged: (_) => _emit(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<String>(
            initialValue: _currency,
            decoration: const InputDecoration(labelText: 'Currency'),
            items: _commonCurrencies
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => _currency = v);
                _emit();
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }
}

// Money compatibility helpers.
//
// The loans SDK bundles its own copy of Money and common proto types, which
// are different Dart classes from antinvestor_api_common despite having
// identical proto structure. These helpers use dynamic dispatch to bridge
// the gap.

/// Formats a Money proto message for display. Accepts any Money-like object.
String formatLoanMoney(dynamic money) {
  if (money == null) return '\u2014';
  try {
    final units = (money.units as dynamic).toInt() as int;
    final nanos = money.nanos as int;
    final currency = money.currencyCode as String;

    if (units == 0 && nanos == 0) return '\u2014';

    final cents = nanos ~/ 10000000;
    final formatted = '$units.${cents.toString().padLeft(2, '0')}';

    if (currency.isEmpty) return formatted;
    return '$currency $formatted';
  } catch (_) {
    return '\u2014';
  }
}

/// Extracts the amount string from a Money proto message.
String loanMoneyToAmountString(dynamic money) {
  if (money == null) return '';
  try {
    final units = (money.units as dynamic).toInt() as int;
    final nanos = money.nanos as int;
    if (units == 0 && nanos == 0) return '0';
    final cents = nanos ~/ 10000000;
    if (cents == 0) return '$units';
    return '$units.${cents.toString().padLeft(2, '0')}';
  } catch (_) {
    return '';
  }
}

/// Extracts the currency code from a Money proto message.
String loanMoneyCurrency(dynamic money, [String fallback = '']) {
  if (money == null) return fallback;
  try {
    final code = money.currencyCode as String;
    return code.isNotEmpty ? code : fallback;
  } catch (_) {
    return fallback;
  }
}

/// Validates an amount string.
String? validateAmount(String? value) {
  if (value == null || value.trim().isEmpty) return 'Amount is required';
  final parsed = double.tryParse(value.trim());
  if (parsed == null || parsed <= 0) return 'Enter a valid positive amount';
  return null;
}

/// Validates a phone number.
String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) return 'Phone number is required';
  final cleaned = value.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
  if (cleaned.length < 9) return 'Enter a valid phone number';
  return null;
}

/// Validates a required field.
String? validateRequired(String? value, [String field = 'This field']) {
  if (value == null || value.trim().isEmpty) return '$field is required';
  return null;
}

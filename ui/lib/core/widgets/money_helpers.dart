import 'package:fixnum/fixnum.dart';
import 'package:lender_ui/sdk/lender_sdk.dart';

/// Formats a [Money] object for display. Returns "—" if null or zero.
String formatMoney(Money? money) {
  if (money == null) return '—';
  final units = money.units.toInt();
  final nanos = money.nanos;
  final currency = money.currencyCode;

  if (units == 0 && nanos == 0) return '—';

  // Format with 2 decimal places for display
  final cents = (nanos / 10000000).round();
  final formatted = '$units.${cents.toString().padLeft(2, '0')}';

  if (currency.isEmpty) return formatted;
  return '$currency $formatted';
}

/// Creates a [Money] object from a decimal string and currency code.
/// e.g. "50000.00" with "KES" → Money(currencyCode: "KES", units: 50000, nanos: 0)
Money moneyFromString(String amount, String currencyCode) {
  final money = Money();
  money.currencyCode = currencyCode;

  final parts = amount.split('.');
  money.units = Int64.parseInt(parts[0].isEmpty ? '0' : parts[0]);
  if (parts.length > 1) {
    // Pad or truncate to 9 digits (nanos)
    final fracStr = parts[1].padRight(9, '0').substring(0, 9);
    money.nanos = int.parse(fracStr);
  }

  return money;
}

/// Extracts the display amount from a Money as a plain string (no currency).
String moneyToAmountString(Money? money) {
  if (money == null) return '0';
  final units = money.units.toInt();
  final nanos = money.nanos;
  if (nanos == 0) return '$units';
  final cents = (nanos / 10000000).round();
  return '$units.${cents.toString().padLeft(2, '0')}';
}

/// Extracts currency code from Money, with fallback.
String moneyCurrency(Money? money, [String fallback = '']) {
  if (money == null || money.currencyCode.isEmpty) return fallback;
  return money.currencyCode;
}

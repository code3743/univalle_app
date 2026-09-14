import 'package:intl/intl.dart';

abstract final class LunchMoneyFormatter {
  static final _currency = NumberFormat.currency(
    locale: 'es_CO',
    symbol: r'$',
    decimalDigits: 0,
  );

  static String format(num amount) => _currency.format(amount);
}

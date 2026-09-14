import 'package:intl/intl.dart';

abstract final class AppDateFormatter {
  static final _shortDate = DateFormat('dd/MM/yyyy', 'es');
  static final _longDate = DateFormat("d 'de' MMMM 'de' y", 'es');

  static String short(DateTime date) => _shortDate.format(date);
  static String long(DateTime date) => _longDate.format(date);

  static DateTime? tryParse(String input, {String pattern = 'dd/MM/yyyy'}) {
    try {
      return DateFormat(pattern, 'es').parseStrict(input);
    } on FormatException {
      return null;
    }
  }
}

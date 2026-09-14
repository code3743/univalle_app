abstract final class SiraPeriodFormatter {
  static const _monthAbbreviations = <String, String>{
    'ENERO': 'Ene',
    'FEBRERO': 'Feb',
    'MARZO': 'Mar',
    'ABRIL': 'Abr',
    'MAYO': 'May',
    'JUNIO': 'Jun',
    'JULIO': 'Jul',
    'AGOSTO': 'Ago',
    'SEPTIEMBRE': 'Sep',
    'OCTUBRE': 'Oct',
    'NOVIEMBRE': 'Nov',
    'DICIEMBRE': 'Dic',
  };

  /// Formats a raw SIRA period, e.g. "FEBRERO/2022 - JUNIO/2022", into a
  /// shorter form, e.g. "Feb/22 – Jun/22". Returns [rawPeriod] unchanged if
  /// it doesn't match the expected "MONTH/YEAR - MONTH/YEAR" shape.
  static String format(String rawPeriod) {
    final range = rawPeriod.split('-').map((part) => part.trim()).toList();
    if (range.length != 2) return rawPeriod;

    final start = _formatMonthYear(range[0]);
    final end = _formatMonthYear(range[1]);
    if (start == null || end == null) return rawPeriod;

    return '$start – $end';
  }

  /// Derives a short "year-semester" code, e.g. "2022-1", from the same raw
  /// SIRA period. Univalle semesters run Feb-Jun (1) and Aug-Dec (2), so the
  /// semester number is inferred from the start month. Returns [rawPeriod]
  /// unchanged if it doesn't match the expected shape.
  static String shortCode(String rawPeriod) {
    final start = rawPeriod.split('-').first.trim().split('/');
    if (start.length != 2) return rawPeriod;

    final monthIndex = _monthAbbreviations.keys.toList().indexOf(
      start[0].trim().toUpperCase(),
    );
    final year = start[1].trim();
    if (monthIndex == -1 || year.length != 4) return rawPeriod;

    final semester = monthIndex < 6 ? 1 : 2;
    return '$year-$semester';
  }

  static String? _formatMonthYear(String monthYear) {
    final parts = monthYear.split('/');
    if (parts.length != 2) return null;

    final abbreviation = _monthAbbreviations[parts[0].trim().toUpperCase()];
    final year = parts[1].trim();
    if (abbreviation == null || year.length < 2) return null;

    return '$abbreviation/${year.substring(year.length - 2)}';
  }
}

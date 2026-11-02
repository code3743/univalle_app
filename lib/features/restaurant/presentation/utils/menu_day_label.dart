/// Splits a portal day label like "Martes 03" into the three-letter
/// weekday and the day-of-month, for the compact day selector.
({String weekday, String number}) splitMenuDayLabel(String dayLabel) {
  final parts = dayLabel.trim().split(RegExp(r'\s+'));
  final weekday = parts.first;
  return (
    weekday: weekday.length > 3 ? weekday.substring(0, 3) : weekday,
    number: parts.length > 1 ? parts.last : '',
  );
}

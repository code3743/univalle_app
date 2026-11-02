import '../../domain/entities/weekly_menu.dart';

/// Picks the day to show first: today if the week lists it, otherwise the
/// next served day (or the first day when the week is already over).
///
/// Days only carry a label like "Martes 03", so they're matched by the
/// trailing day-of-month number.
int initialMenuDayIndex(List<DailyMenu> days, DateTime today) {
  int? dayOfMonth(DailyMenu day) {
    final match = RegExp(r'(\d+)\s*$').firstMatch(day.dayLabel);
    return match == null ? null : int.parse(match.group(1)!);
  }

  final todayIndex = days.indexWhere((day) => dayOfMonth(day) == today.day);
  if (todayIndex != -1) return todayIndex;

  final nextIndex = days.indexWhere(
    (day) => !day.isClosed && (dayOfMonth(day) ?? 0) > today.day,
  );
  return nextIndex == -1 ? 0 : nextIndex;
}

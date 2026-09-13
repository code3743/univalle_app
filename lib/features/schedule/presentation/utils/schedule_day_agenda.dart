import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/schedule_class.dart';
import '../../domain/entities/weekday.dart';

const _accents = [
  AppColors.accentBlue,
  AppColors.accentGreen,
  AppColors.accentPurple,
  AppColors.accentAmber,
  AppColors.accentPink,
];

/// SIRA schedules don't run classes on Sunday, so it's left out of the
/// selectable days entirely.
const scheduleSelectableDays = [
  Weekday.monday,
  Weekday.tuesday,
  Weekday.wednesday,
  Weekday.thursday,
  Weekday.friday,
  Weekday.saturday,
];

/// Groups a week's classes by day, resolves which day to show, and assigns
/// each subject a stable accent color, so the View is left with only layout
/// to do.
class ScheduleDayAgenda {
  final Weekday selectedDay;
  final List<ScheduleClass> dayClasses;
  final Map<String, Color> accentBySubject;

  const ScheduleDayAgenda._({
    required this.selectedDay,
    required this.dayClasses,
    required this.accentBySubject,
  });

  factory ScheduleDayAgenda.from(
    List<ScheduleClass> classes, {
    Weekday? selectedDay,
  }) {
    final byDay = <Weekday, List<ScheduleClass>>{};
    for (final scheduleClass in classes) {
      byDay.putIfAbsent(scheduleClass.day, () => []).add(scheduleClass);
    }

    final resolvedDay = selectedDay ?? _defaultDay(byDay);
    final dayClasses = List<ScheduleClass>.of(byDay[resolvedDay] ?? const [])
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final accentBySubject = <String, Color>{};
    for (final scheduleClass in classes) {
      accentBySubject.putIfAbsent(
        scheduleClass.subjectCode,
        () => _accents[accentBySubject.length % _accents.length],
      );
    }

    return ScheduleDayAgenda._(
      selectedDay: resolvedDay,
      dayClasses: dayClasses,
      accentBySubject: accentBySubject,
    );
  }

  // On Sunday there's no matching tab (classes don't run that day), so
  // default to the last day up to Saturday that actually has a class.
  static Weekday _defaultDay(Map<Weekday, List<ScheduleClass>> byDay) {
    final today = Weekday.values[DateTime.now().weekday - 1];
    if (today != Weekday.sunday) return today;

    for (final day in scheduleSelectableDays.reversed) {
      if (byDay[day]?.isNotEmpty ?? false) return day;
    }
    return Weekday.saturday;
  }
}

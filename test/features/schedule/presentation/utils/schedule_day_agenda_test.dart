import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/theme/app_colors.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';
import 'package:univalle_app/features/schedule/presentation/utils/schedule_day_agenda.dart';

import '../schedule_fixtures.dart';

void main() {
  test('keeps only the selected day, sorted by start time', () {
    final agenda = ScheduleDayAgenda.from([
      scheduleClass(code: 'B', start: '14:00', day: Weekday.tuesday),
      scheduleClass(code: 'A', start: '08:00', day: Weekday.tuesday),
      scheduleClass(code: 'C', day: Weekday.friday),
    ], selectedDay: Weekday.tuesday);

    expect(agenda.selectedDay, Weekday.tuesday);
    expect(agenda.dayClasses.map((c) => c.subjectCode), ['A', 'B']);
  });

  test('has no classes for a day without any', () {
    final agenda = ScheduleDayAgenda.from([
      scheduleClass(day: Weekday.monday),
    ], selectedDay: Weekday.saturday);

    expect(agenda.dayClasses, isEmpty);
  });

  test('gives each subject a stable accent, cycling past the palette', () {
    final classes = [
      for (var i = 0; i < 6; i++) scheduleClass(code: 'S$i'),
      scheduleClass(code: 'S0', day: Weekday.friday),
    ];

    final agenda = ScheduleDayAgenda.from(classes, selectedDay: Weekday.monday);

    expect(agenda.accentBySubject, hasLength(6));
    expect(agenda.accentBySubject['S0'], AppColors.accentBlue);
    expect(agenda.accentBySubject['S5'], AppColors.accentBlue);
    expect(agenda.accentBySubject['S1'], AppColors.accentGreen);
  });

  test('defaults to a selectable day when none is chosen', () {
    final agenda = ScheduleDayAgenda.from([scheduleClass(day: Weekday.friday)]);

    expect(scheduleSelectableDays, contains(agenda.selectedDay));
  });
}

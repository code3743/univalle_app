import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/theme/app_colors.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';
import 'package:univalle_app/features/schedule/presentation/utils/schedule_day_agenda.dart';
import 'package:univalle_app/features/schedule/presentation/widgets/schedule_class_tile.dart';
import 'package:univalle_app/features/schedule/presentation/widgets/schedule_day_selector.dart';
import 'package:univalle_app/features/schedule/presentation/widgets/schedule_empty_day.dart';
import 'package:univalle_app/features/schedule/presentation/widgets/schedule_timeline_tile.dart';
import 'package:univalle_app/features/schedule/schedule_strings.dart';

import '../../../../helpers/pump_app.dart';
import '../schedule_fixtures.dart';

void main() {
  testWidgets('ScheduleClassTile shows time in 12h, place and teacher', (
    tester,
  ) async {
    await tester.pumpApp(
      ScheduleClassTile(
        scheduleClass: scheduleClass(start: '14:00', end: '17:30'),
        accent: AppColors.accentBlue,
      ),
    );

    expect(find.text('2:00 p.m - 5:30 p.m'), findsOneWidget);
    expect(find.text('CÁLCULO I'), findsOneWidget);
    expect(find.text('Edif. B13 · Aula 101 · Meléndez'), findsOneWidget);
    expect(find.text('ANA GÓMEZ'), findsOneWidget);
    expect(find.text('ana@univalle.edu.co'), findsOneWidget);
  });

  testWidgets('ScheduleClassTile converts midnight and noon correctly', (
    tester,
  ) async {
    await tester.pumpApp(
      ScheduleClassTile(
        scheduleClass: scheduleClass(start: '00:15', end: '12:00'),
        accent: AppColors.accentBlue,
      ),
    );

    expect(find.text('12:15 a.m - 12:00 p.m'), findsOneWidget);
  });

  testWidgets('ScheduleClassTile omits missing place and teacher lines', (
    tester,
  ) async {
    await tester.pumpApp(
      ScheduleClassTile(
        scheduleClass: scheduleClass(
          building: '',
          room: '',
          campus: '',
          teacher: '',
          teacherEmail: null,
        ),
        accent: AppColors.accentBlue,
      ),
    );

    expect(find.byIcon(Icons.location_on_outlined), findsNothing);
    expect(find.byIcon(Icons.person_outline), findsNothing);
    expect(find.byIcon(Icons.email_outlined), findsNothing);
  });

  testWidgets('ScheduleDaySelector reports the tapped day', (tester) async {
    Weekday? selected;
    await tester.pumpApp(
      ScheduleDaySelector(
        days: scheduleSelectableDays,
        selectedDay: Weekday.monday,
        onSelected: (day) => selected = day,
      ),
    );

    await tester.tap(
      find.text(ScheduleStrings.weekdayShortLabel(Weekday.thursday)),
    );

    expect(selected, Weekday.thursday);
  });

  testWidgets('ScheduleEmptyDay shows the default and a custom message', (
    tester,
  ) async {
    await tester.pumpApp(const ScheduleEmptyDay());
    expect(find.text(ScheduleStrings.noClassesThisDay), findsOneWidget);

    await tester.pumpApp(
      const ScheduleEmptyDay(message: 'Nada', icon: Icons.event),
    );
    expect(find.text('Nada'), findsOneWidget);
    expect(find.byIcon(Icons.event), findsOneWidget);
  });

  testWidgets('ScheduleTimelineTile draws a connector only when not last', (
    tester,
  ) async {
    await tester.pumpApp(
      const ScheduleTimelineTile(
        accent: AppColors.accentBlue,
        isLast: false,
        child: Text('card'),
      ),
    );
    expect(find.text('card'), findsOneWidget);
    final withConnector = find.byType(Container).evaluate().length;

    await tester.pumpApp(
      const ScheduleTimelineTile(
        accent: AppColors.accentBlue,
        isLast: true,
        child: Text('card'),
      ),
    );

    expect(find.byType(Container).evaluate().length, withConnector - 1);
  });
}

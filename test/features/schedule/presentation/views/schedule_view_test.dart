import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/schedule/domain/entities/schedule_class.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';
import 'package:univalle_app/features/schedule/presentation/providers/schedule_providers.dart';
import 'package:univalle_app/features/schedule/presentation/views/schedule_view.dart';
import 'package:univalle_app/features/schedule/presentation/widgets/schedule_class_tile.dart';
import 'package:univalle_app/features/schedule/presentation/widgets/schedule_skeleton.dart';
import 'package:univalle_app/features/schedule/schedule_strings.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/grades_providers.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/session.dart';
import '../../../student_grades/presentation/grades_fixtures.dart' as grades;
import '../schedule_fixtures.dart';

void main() {
  late MockScheduleRepository scheduleRepository;
  late grades.MockGradesRepository gradesRepository;

  setUpAll(() {
    registerFallbackValue(<Never>[]);
  });

  setUp(() {
    scheduleRepository = MockScheduleRepository();
    gradesRepository = grades.MockGradesRepository();
    when(() => gradesRepository.getGrades(username: 'jdoe'))
        .thenAnswer((_) async => Ok(grades.history()));
  });

  Future<void> pumpView(WidgetTester tester) async {
    await tester.pumpApp(
      const ScheduleView(),
      overrides: [
        signedInAs(),
        gradesRepositoryProvider.overrideWithValue(gradesRepository),
        scheduleRepositoryProvider.overrideWithValue(scheduleRepository),
      ],
    );
  }

  void stubSchedule(List<ScheduleClass> classes) {
    when(() => scheduleRepository.getSchedule(subjects: any(named: 'subjects')))
        .thenAnswer((_) async => Ok(classes));
  }

  testWidgets('shows a skeleton while loading', (tester) async {
    final completer = Completer<Result<List<ScheduleClass>>>();
    when(() => scheduleRepository.getSchedule(subjects: any(named: 'subjects')))
        .thenAnswer((_) => completer.future);

    await pumpView(tester);
    await tester.pump();
    await tester.pump();

    expect(find.byType(ScheduleSkeleton), findsOneWidget);
    completer.complete(const Ok([]));
    await tester.pumpAndSettle();
  });

  testWidgets('shows the empty message when no schedule was found', (
    tester,
  ) async {
    stubSchedule([]);

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(ScheduleStrings.empty), findsOneWidget);
  });

  testWidgets('shows the classes of the day picked in the selector', (
    tester,
  ) async {
    stubSchedule([
      scheduleClass(code: 'A', name: 'CÁLCULO I', day: Weekday.monday),
      scheduleClass(
        code: 'B',
        name: 'FÍSICA I',
        day: Weekday.wednesday,
        start: '10:00',
      ),
    ]);

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(ScheduleStrings.weekdayShortLabel(Weekday.monday)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ScheduleClassTile), findsOneWidget);
    expect(find.text('CÁLCULO I'), findsOneWidget);

    await tester.tap(
      find.text(ScheduleStrings.weekdayShortLabel(Weekday.wednesday)),
    );
    await tester.pumpAndSettle();

    expect(find.text('FÍSICA I'), findsOneWidget);
    expect(find.text('CÁLCULO I'), findsNothing);
  });

  testWidgets('shows a message on a day without classes', (tester) async {
    stubSchedule([scheduleClass(day: Weekday.monday)]);

    await pumpView(tester);
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(ScheduleStrings.weekdayShortLabel(Weekday.saturday)),
    );
    await tester.pumpAndSettle();

    expect(find.text(ScheduleStrings.noClassesThisDay), findsOneWidget);
  });

  testWidgets('shows the failure and retries', (tester) async {
    when(() => scheduleRepository.getSchedule(subjects: any(named: 'subjects')))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    stubSchedule([scheduleClass(day: Weekday.monday)]);
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.networkError), findsNothing);
  });
}

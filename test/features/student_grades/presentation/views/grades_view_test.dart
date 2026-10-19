import 'dart:async';

import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/features/student_grades/domain/entities/academic_history.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/grades_providers.dart';
import 'package:univalle_app/features/student_grades/presentation/views/equivalences_view.dart';
import 'package:univalle_app/features/student_grades/presentation/views/grades_view.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/equivalence_tile.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/grades_skeleton.dart';
import 'package:univalle_app/features/student_grades/presentation/widgets/period_grades_section.dart';
import 'package:univalle_app/features/student_grades/student_grades_strings.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/session.dart';
import '../grades_fixtures.dart';

void main() {
  late MockGradesRepository repository;

  setUp(() {
    repository = MockGradesRepository();
  });

  List<Override> overrides() => [
    signedInAs(),
    gradesRepositoryProvider.overrideWithValue(repository),
  ];

  void stub(AcademicHistory value) {
    when(() => repository.getGrades(username: 'jdoe'))
        .thenAnswer((_) async => Ok(value));
  }

  group('GradesView', () {
    Future<void> pumpView(WidgetTester tester) async {
      await tester.pumpRoutedApp(const GradesView(), overrides: overrides());
      await tester.pump();
    }

    testWidgets('shows a skeleton while loading', (tester) async {
      final completer = Completer<Result<AcademicHistory>>();
      when(() => repository.getGrades(username: 'jdoe'))
          .thenAnswer((_) => completer.future);

      await pumpView(tester);

      expect(find.byType(GradesSkeleton), findsOneWidget);
      completer.complete(Ok(history()));
      await tester.pumpAndSettle();
    });

    testWidgets('shows a section per period', (tester) async {
      stub(
        history(
          periods: [
            period(),
            period(period: 'AGOSTO/2024 - DICIEMBRE/2024'),
          ],
        ),
      );

      await pumpView(tester);
      await tester.pumpAndSettle();

      expect(find.text(StudentGradesStrings.title), findsOneWidget);
      expect(find.byType(PeriodGradesSection), findsNWidgets(2));
    });

    testWidgets('shows the empty message when there are no periods', (
      tester,
    ) async {
      stub(history(periods: []));

      await pumpView(tester);
      await tester.pumpAndSettle();

      expect(find.text(StudentGradesStrings.empty), findsOneWidget);
    });

    testWidgets('links to equivalences when there are some', (tester) async {
      stub(history(equivalences: [equivalence]));

      await pumpView(tester);
      await tester.pumpAndSettle();
      await tester.tap(
        find.text(StudentGradesStrings.equivalencesShortcutLabel(1, 3)),
      );
      await tester.pumpAndSettle();

      expect(find.text('route:${AppRoutes.equivalences}'), findsOneWidget);
    });

    testWidgets('shows the failure and retries', (tester) async {
      when(() => repository.getGrades(username: 'jdoe'))
          .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
      await pumpView(tester);
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.networkError), findsOneWidget);

      stub(history());
      await tester.tap(find.text(AppStrings.retry));
      await tester.pumpAndSettle();

      expect(find.byType(PeriodGradesSection), findsOneWidget);
    });
  });

  group('EquivalencesView', () {
    Future<void> pumpView(WidgetTester tester) async {
      await tester.pumpApp(const EquivalencesView(), overrides: overrides());
    }

    testWidgets('lists the equivalences with their totals', (tester) async {
      stub(history(equivalences: [equivalence]));

      await pumpView(tester);
      await tester.pumpAndSettle();

      expect(find.text(StudentGradesStrings.equivalencesTitle), findsOneWidget);
      expect(find.byType(EquivalenceTile), findsOneWidget);
      expect(
        find.text(StudentGradesStrings.equivalencesSubjectsLabel),
        findsOneWidget,
      );
    });

    testWidgets('shows the empty state without equivalences', (tester) async {
      stub(history());

      await pumpView(tester);
      await tester.pumpAndSettle();

      expect(find.text(StudentGradesStrings.equivalencesEmpty), findsOneWidget);
    });

    testWidgets('shows the failure and retries', (tester) async {
      when(() => repository.getGrades(username: 'jdoe'))
          .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
      await pumpView(tester);
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.networkError), findsOneWidget);

      stub(history(equivalences: [equivalence]));
      await tester.tap(find.text(AppStrings.retry));
      await tester.pumpAndSettle();

      expect(find.byType(EquivalenceTile), findsOneWidget);
    });
  });
}

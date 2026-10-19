import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_to_rate.dart';
import 'package:univalle_app/features/teaching_rating/presentation/providers/teaching_rating_providers.dart';
import 'package:univalle_app/features/teaching_rating/presentation/views/teachers_to_rate_view.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/teacher_to_rate_tile.dart';
import 'package:univalle_app/features/teaching_rating/teaching_rating_strings.dart';

import '../../../../helpers/pump_app.dart';
import '../teaching_rating_fixtures.dart';

void main() {
  late MockTeachingRatingRepository repository;

  setUp(() {
    repository = MockTeachingRatingRepository();
  });

  Future<void> pumpView(WidgetTester tester) async {
    await tester.pumpRoutedApp(
      const TeachersToRateView(),
      overrides: [
        teachingRatingRepositoryProvider.overrideWithValue(repository),
      ],
    );
    await tester.pump();
  }

  void stubTeachers(List<TeacherToRate> teachers) {
    when(() => repository.getTeachersToRate())
        .thenAnswer((_) async => Ok(teachers));
  }

  testWidgets('shows a skeleton while loading', (tester) async {
    final completer = Completer<Result<List<TeacherToRate>>>();
    when(() => repository.getTeachersToRate())
        .thenAnswer((_) => completer.future);

    await pumpView(tester);

    expect(find.byType(TeacherToRateTile), findsNothing);
    completer.complete(const Ok([]));
    await tester.pumpAndSettle();
  });

  testWidgets('lists the teachers under the banner', (tester) async {
    stubTeachers([teacher(), teacher(id: '2', name: 'Luis Pérez')]);

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(TeachingRatingStrings.banner), findsOneWidget);
    expect(find.byType(TeacherToRateTile), findsNWidgets(2));
  });

  testWidgets('shows the empty message when nothing is pending', (
    tester,
  ) async {
    stubTeachers([]);

    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text(TeachingRatingStrings.empty), findsOneWidget);
  });

  testWidgets('tells the user an already-qualified teacher cannot be rated', (
    tester,
  ) async {
    stubTeachers([teacher(isQualified: true)]);
    await pumpView(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TeacherToRateTile));
    await tester.pump();

    expect(find.text(TeachingRatingStrings.alreadyQualified), findsOneWidget);
  });

  testWidgets('shows the novelty text instead of opening the review', (
    tester,
  ) async {
    stubTeachers([teacher(novelty: 'Grupo cancelado')]);
    await pumpView(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TeacherToRateTile));
    await tester.pump();

    expect(find.text('Grupo cancelado'), findsOneWidget);
  });

  testWidgets('opens the review for a teacher that can be rated', (
    tester,
  ) async {
    stubTeachers([teacher()]);
    await pumpView(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TeacherToRateTile));
    await tester.pumpAndSettle();

    expect(find.text('route:${AppRoutes.teacherReview}'), findsOneWidget);
  });

  testWidgets('shows the failure and retries', (tester) async {
    when(() => repository.getTeachersToRate())
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    stubTeachers([teacher()]);
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.byType(TeacherToRateTile), findsOneWidget);
  });
}

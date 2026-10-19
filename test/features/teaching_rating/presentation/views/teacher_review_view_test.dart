import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/constants/app_strings.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/rating_option.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teacher_review.dart';
import 'package:univalle_app/features/teaching_rating/presentation/providers/teaching_rating_providers.dart';
import 'package:univalle_app/features/teaching_rating/presentation/views/teacher_review_view.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/teacher_review_skeleton.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/teacher_review_wizard.dart';
import 'package:univalle_app/features/teaching_rating/teaching_rating_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../helpers/pump_app.dart';
import '../teaching_rating_fixtures.dart';

void main() {
  late MockTeachingRatingRepository repository;

  setUpAll(() {
    registerFallbackValue(teacher());
    registerFallbackValue(review);
    registerFallbackValue(<String, RatingOption>{});
  });

  setUp(() {
    repository = MockTeachingRatingRepository();
  });

  Future<void> pumpView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      TeacherReviewView(teacher: teacher()),
      overrides: [
        teachingRatingRepositoryProvider.overrideWithValue(repository),
      ],
    );
  }

  Future<void> answer(WidgetTester tester, RatingOption option) async {
    await tester.tap(find.text(option.label));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
  }

  testWidgets('shows a skeleton while the form loads', (tester) async {
    final completer = Completer<Result<TeacherReview>>();
    when(() => repository.getTeacherReview(teacher: any(named: 'teacher')))
        .thenAnswer((_) => completer.future);

    await pumpView(tester);
    await tester.pump();

    expect(find.byType(TeacherReviewSkeleton), findsOneWidget);
    completer.complete(const Ok(review));
    await tester.pumpAndSettle();
  });

  testWidgets('shows the failure and retries', (tester) async {
    when(() => repository.getTeacherReview(teacher: any(named: 'teacher')))
        .thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.networkError), findsOneWidget);

    when(() => repository.getTeacherReview(teacher: any(named: 'teacher')))
        .thenAnswer((_) async => const Ok(review));
    await tester.tap(find.text(AppStrings.retry));
    await tester.pumpAndSettle();

    expect(find.byType(TeacherReviewWizard), findsOneWidget);
  });

  testWidgets('walks through the questions, going back and forth', (
    tester,
  ) async {
    when(() => repository.getTeacherReview(teacher: any(named: 'teacher')))
        .thenAnswer((_) async => const Ok(review));
    await pumpView(tester);
    await tester.pumpAndSettle();

    expect(find.text('¿Pregunta uno?'), findsOneWidget);
    expect(
      find.text(TeachingRatingStrings.questionCounter(1, 2)),
      findsOneWidget,
    );

    await answer(tester, RatingOption.agree);
    expect(find.text('¿Pregunta dos?'), findsOneWidget);
    expect(
      find.text(TeachingRatingStrings.questionCounter(2, 2)),
      findsOneWidget,
    );

    await tester.tap(find.text(TeachingRatingStrings.previousLabel));
    await tester.pumpAndSettle();
    expect(find.text('¿Pregunta uno?'), findsOneWidget);

    await answer(tester, RatingOption.disagree);
    await answer(tester, RatingOption.totallyAgree);

    expect(find.text(TeachingRatingStrings.feedbackTitle), findsOneWidget);
    expect(find.textContaining('Pregunta'), findsNothing);
  });

  testWidgets('submits the answers and returns on success', (tester) async {
    when(() => repository.getTeacherReview(teacher: any(named: 'teacher')))
        .thenAnswer((_) async => const Ok(review));
    when(
      () => repository.submitTeacherReview(
        review: any(named: 'review'),
        answers: any(named: 'answers'),
        feedback: any(named: 'feedback'),
      ),
    ).thenAnswer((_) async => const Ok(null));
    when(() => repository.getTeachersToRate())
        .thenAnswer((_) async => const Ok([]));

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('list')),
        ),
        GoRoute(
          path: '/review',
          builder: (_, _) => TeacherReviewView(teacher: teacher()),
        ),
      ],
    );
    addTearDown(router.dispose);
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          teachingRatingRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    unawaited(router.push('/review'));
    await tester.pumpAndSettle();

    await answer(tester, RatingOption.agree);
    await answer(tester, RatingOption.totallyAgree);
    await tester.enterText(find.byType(TextField), '  buena clase  ');
    await tester.tap(find.text(TeachingRatingStrings.submitLabel));
    await tester.pumpAndSettle();

    verify(
      () => repository.submitTeacherReview(
        review: review,
        answers: {'q1': RatingOption.agree, 'q2': RatingOption.totallyAgree},
        feedback: 'buena clase',
      ),
    ).called(1);
    expect(find.text('list'), findsOneWidget);
    expect(find.text(TeachingRatingStrings.submitSuccess), findsOneWidget);
  });

  testWidgets('shows the failure message when submitting fails', (
    tester,
  ) async {
    when(() => repository.getTeacherReview(teacher: any(named: 'teacher')))
        .thenAnswer((_) async => const Ok(review));
    when(
      () => repository.submitTeacherReview(
        review: any(named: 'review'),
        answers: any(named: 'answers'),
        feedback: any(named: 'feedback'),
      ),
    ).thenAnswer((_) async => Err(NetworkFailure(message: 'down')));
    await pumpView(tester);
    await tester.pumpAndSettle();

    await answer(tester, RatingOption.agree);
    await answer(tester, RatingOption.agree);
    await tester.tap(find.text(TeachingRatingStrings.submitLabel));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.networkError), findsOneWidget);
    expect(find.byType(TeacherReviewWizard), findsOneWidget);
  });
}

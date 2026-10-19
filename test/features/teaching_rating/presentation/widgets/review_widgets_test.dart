import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/rating_option.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_question.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/rating_options_list.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/review_feedback_page.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/review_progress_indicator.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/review_question_page.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/teacher_rating_banner.dart';
import 'package:univalle_app/features/teaching_rating/presentation/widgets/teacher_to_rate_tile.dart';
import 'package:univalle_app/features/teaching_rating/teaching_rating_strings.dart';

import '../../../../helpers/pump_app.dart';
import '../teaching_rating_fixtures.dart';

void main() {
  testWidgets('RatingOptionsList lists every option and reports the choice', (
    tester,
  ) async {
    RatingOption? chosen;
    await tester.pumpApp(
      SingleChildScrollView(
        child: RatingOptionsList(selected: null, onChanged: (o) => chosen = o),
      ),
    );

    for (final option in RatingOption.values) {
      expect(find.text(option.label), findsOneWidget);
    }

    await tester.tap(find.text(RatingOption.agree.label));

    expect(chosen, RatingOption.agree);
  });

  testWidgets('ReviewProgressIndicator shows the counter and category', (
    tester,
  ) async {
    await tester.pumpApp(
      const ReviewProgressIndicator(
        current: 2,
        total: 4,
        category: QuestionCategory.teacher,
      ),
    );

    expect(
      find.text(TeachingRatingStrings.questionCounter(2, 4)),
      findsOneWidget,
    );
    expect(find.text('DOCENTE'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.5,
    );
  });

  testWidgets('ReviewQuestionPage hides "previous" on the first question', (
    tester,
  ) async {
    await tester.pumpApp(
      ReviewQuestionPage(
        question: question1,
        selected: null,
        onSelected: (_) {},
        onPrevious: null,
      ),
    );

    expect(find.text('¿Pregunta uno?'), findsOneWidget);
    expect(find.text(TeachingRatingStrings.previousLabel), findsNothing);
  });

  testWidgets('ReviewQuestionPage offers "previous" and reports answers', (
    tester,
  ) async {
    var wentBack = false;
    RatingOption? chosen;
    await tester.pumpApp(
      ReviewQuestionPage(
        question: question2,
        selected: null,
        onSelected: (o) => chosen = o,
        onPrevious: () => wentBack = true,
      ),
    );

    await tester.tap(find.text(TeachingRatingStrings.previousLabel));
    await tester.tap(find.text(RatingOption.totallyAgree.label));

    expect(wentBack, isTrue);
    expect(chosen, RatingOption.totallyAgree);
  });

  testWidgets('ReviewFeedbackPage submits and locks while submitting', (
    tester,
  ) async {
    var submitted = false;
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpApp(
      SingleChildScrollView(
        child: ReviewFeedbackPage(
          controller: controller,
          isSubmitting: false,
          onSubmit: () => submitted = true,
        ),
      ),
    );

    await tester.tap(find.text(TeachingRatingStrings.submitLabel));
    expect(submitted, isTrue);

    await tester.pumpApp(
      SingleChildScrollView(
        child: ReviewFeedbackPage(
          controller: controller,
          isSubmitting: true,
          onSubmit: () {},
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('TeacherRatingBanner shows the banner copy', (tester) async {
    await tester.pumpApp(const TeacherRatingBanner());

    expect(find.text(TeachingRatingStrings.banner), findsOneWidget);
  });

  testWidgets('TeacherToRateTile shows the teacher and a star by state', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpApp(
      TeacherToRateTile(teacher: teacher(), onTap: () => tapped = true),
    );

    expect(find.text('Ana Gómez'), findsOneWidget);
    expect(find.text('Cálculo'), findsOneWidget);
    expect(find.byIcon(Icons.star_border_rounded), findsOneWidget);

    await tester.tap(find.byType(TeacherToRateTile));
    expect(tapped, isTrue);

    await tester.pumpApp(
      TeacherToRateTile(teacher: teacher(isQualified: true)),
    );
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  });
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/rating_option.dart';
import '../../domain/entities/teacher_review.dart';
import '../../teaching_rating_strings.dart';
import '../providers/teaching_rating_providers.dart';

part 'submit_teacher_review_view_model.g.dart';

@riverpod
class SubmitTeacherReviewViewModel extends _$SubmitTeacherReviewViewModel {
  @override
  Future<bool?> build() async => null;

  Future<void> submit({
    required TeacherReview review,
    required Map<String, RatingOption> answers,
    required String feedback,
  }) async {
    final missingIndex = review.questions.indexWhere(
      (question) => !answers.containsKey(question.id),
    );
    if (missingIndex != -1) {
      state = AsyncError(
        BusinessFailure(
          message: TeachingRatingStrings.unansweredQuestion(missingIndex + 1),
        ),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    final result = await ref
        .read(submitTeacherReviewUseCaseProvider)
        .call(review: review, answers: answers, feedback: feedback);
    state = result.fold(
      onError: (failure) => AsyncError(failure, StackTrace.current),
      onSuccess: (_) => const AsyncData(true),
    );
  }
}

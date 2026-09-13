import '../../../../core/error/result.dart';
import '../entities/rating_option.dart';
import '../entities/teacher_review.dart';
import '../repositories/teaching_rating_repository.dart';

class SubmitTeacherReviewUseCase {
  final TeachingRatingRepository _repository;
  const SubmitTeacherReviewUseCase(this._repository);

  Future<Result<void>> call({
    required TeacherReview review,
    required Map<String, RatingOption> answers,
    String? feedback,
  }) {
    return _repository.submitTeacherReview(
      review: review,
      answers: answers,
      feedback: feedback,
    );
  }
}

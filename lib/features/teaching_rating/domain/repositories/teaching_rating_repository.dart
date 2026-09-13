import '../../../../core/error/result.dart';
import '../entities/rating_option.dart';
import '../entities/teacher_review.dart';
import '../entities/teacher_to_rate.dart';

abstract interface class TeachingRatingRepository {
  Future<Result<List<TeacherToRate>>> getTeachersToRate();

  Future<Result<TeacherReview>> getTeacherReview({
    required TeacherToRate teacher,
  });

  Future<Result<void>> submitTeacherReview({
    required TeacherReview review,
    required Map<String, RatingOption> answers,
    String? feedback,
  });
}

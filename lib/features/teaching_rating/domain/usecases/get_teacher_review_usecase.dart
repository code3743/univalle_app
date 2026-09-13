import '../../../../core/error/result.dart';
import '../entities/teacher_review.dart';
import '../entities/teacher_to_rate.dart';
import '../repositories/teaching_rating_repository.dart';

class GetTeacherReviewUseCase {
  final TeachingRatingRepository _repository;
  const GetTeacherReviewUseCase(this._repository);

  Future<Result<TeacherReview>> call({required TeacherToRate teacher}) {
    return _repository.getTeacherReview(teacher: teacher);
  }
}

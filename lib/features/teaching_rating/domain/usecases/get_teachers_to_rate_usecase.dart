import '../../../../core/error/result.dart';
import '../entities/teacher_to_rate.dart';
import '../repositories/teaching_rating_repository.dart';

class GetTeachersToRateUseCase {
  final TeachingRatingRepository _repository;
  const GetTeachersToRateUseCase(this._repository);

  Future<Result<List<TeacherToRate>>> call() {
    return _repository.getTeachersToRate();
  }
}

import '../../../../core/error/result.dart';
import '../entities/academic_history.dart';
import '../repositories/grades_repository.dart';

class GetGradesUseCase {
  final GradesRepository _repository;
  const GetGradesUseCase(this._repository);

  Future<Result<AcademicHistory>> call({required String username}) {
    return _repository.getGrades(username: username);
  }
}

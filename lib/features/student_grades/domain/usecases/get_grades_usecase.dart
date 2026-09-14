import '../../../../core/error/result.dart';
import '../entities/grades.dart';
import '../repositories/grades_repository.dart';

class GetGradesUseCase {
  final GradesRepository _repository;
  const GetGradesUseCase(this._repository);

  Future<Result<List<Grades>>> call({required String username}) {
    return _repository.getGrades(username: username);
  }
}

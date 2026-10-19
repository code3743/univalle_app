import '../../../../core/error/result.dart';
import '../../../../core/domain/entities/student.dart';
import '../repositories/profile_repository.dart';

class GetStudentUseCase {
  final ProfileRepository _repository;
  const GetStudentUseCase(this._repository);

  Future<Result<Student>> call({required String username}) {
    return _repository.getStudent(username: username);
  }
}

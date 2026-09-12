import '../../../../core/error/result.dart';
import '../entities/curriculum.dart';
import '../repositories/resolution_repository.dart';

class GetCurriculumUseCase {
  final ResolutionRepository _repository;
  const GetCurriculumUseCase(this._repository);

  Future<Result<Curriculum>> call({required String username}) {
    return _repository.getCurriculum(username: username);
  }
}

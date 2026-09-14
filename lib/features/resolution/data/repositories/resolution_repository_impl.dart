import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/curriculum.dart';
import '../../domain/repositories/resolution_repository.dart';
import '../datasources/sira_resolution_remote_datasource.dart';

class ResolutionRepositoryImpl implements ResolutionRepository {
  final SiraResolutionRemoteDataSource _remote;
  const ResolutionRepositoryImpl(this._remote);

  @override
  Future<Result<Curriculum>> getCurriculum({required String username}) async {
    try {
      final subjects = await _remote.fetchCurriculum(username: username);
      return Ok(
        Curriculum(
          subjects: subjects.map((subject) => subject.toEntity()).toList(),
        ),
      );
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}

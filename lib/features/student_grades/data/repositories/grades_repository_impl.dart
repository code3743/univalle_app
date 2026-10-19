import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/academic_history.dart';
import '../../domain/repositories/grades_repository.dart';
import '../datasources/sira_grades_remote_datasource.dart';

class GradesRepositoryImpl implements GradesRepository {
  final SiraGradesRemoteDataSource _remote;
  const GradesRepositoryImpl(this._remote);

  @override
  Future<Result<AcademicHistory>> getGrades({required String username}) async {
    try {
      final history = await _remote.fetchGrades(username: username);
      return Ok(history.toEntity());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}

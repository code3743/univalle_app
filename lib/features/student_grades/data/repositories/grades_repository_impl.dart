import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/grades.dart';
import '../../domain/repositories/grades_repository.dart';
import '../datasources/sira_grades_remote_datasource.dart';

class GradesRepositoryImpl implements GradesRepository {
  final SiraGradesRemoteDataSource _remote;
  const GradesRepositoryImpl(this._remote);

  @override
  Future<Result<List<Grades>>> getGrades({required String username}) async {
    try {
      final grades = await _remote.fetchGrades(username: username);
      return Ok(grades.map((grade) => grade.toEntity()).toList());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}

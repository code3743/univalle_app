import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/sira_profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SiraProfileRemoteDataSource _remote;
  const ProfileRepositoryImpl(this._remote);

  @override
  Future<Result<Student>> getStudent({required String username}) async {
    try {
      final student = await _remote.fetchStudent(username: username);
      return Ok(student.toEntity());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}

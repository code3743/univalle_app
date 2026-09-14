import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/schedule_class.dart';
import '../../domain/entities/schedule_subject.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/sira_schedule_remote_datasource.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final SiraScheduleRemoteDataSource _remote;
  const ScheduleRepositoryImpl(this._remote);

  @override
  Future<Result<List<ScheduleClass>>> getSchedule({
    required List<ScheduleSubject> subjects,
  }) async {
    try {
      final classes = await _remote.fetchSchedule(subjects: subjects);
      return Ok(classes.map((classModel) => classModel.toEntity()).toList());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}

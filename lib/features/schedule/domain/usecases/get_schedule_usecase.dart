import '../../../../core/error/result.dart';
import '../entities/schedule_class.dart';
import '../entities/schedule_subject.dart';
import '../repositories/schedule_repository.dart';

class GetScheduleUseCase {
  final ScheduleRepository _repository;
  const GetScheduleUseCase(this._repository);

  Future<Result<List<ScheduleClass>>> call({
    required List<ScheduleSubject> subjects,
  }) {
    return _repository.getSchedule(subjects: subjects);
  }
}

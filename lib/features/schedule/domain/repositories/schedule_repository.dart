import '../../../../core/error/result.dart';
import '../entities/schedule_class.dart';
import '../entities/schedule_subject.dart';

abstract interface class ScheduleRepository {
  Future<Result<List<ScheduleClass>>> getSchedule({
    required List<ScheduleSubject> subjects,
  });
}

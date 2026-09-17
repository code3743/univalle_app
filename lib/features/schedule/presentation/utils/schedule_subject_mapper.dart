import '../../../student_grades/domain/entities/subject.dart';
import '../../domain/entities/schedule_subject.dart';

/// Derives the current period's lookup keys for the schedule from grades
/// data: cancelled subjects have no class to look up, and an empty group
/// means SIRA never assigned the student one.
List<ScheduleSubject> scheduleSubjectsFrom(List<Subject> subjects) {
  return subjects
      .where((subject) => !subject.isCanceled && subject.group.isNotEmpty)
      .map(
        (subject) => ScheduleSubject(
          code: subject.code,
          group: subject.group,
          campusId: subject.campusId,
          name: subject.name,
        ),
      )
      .toList();
}

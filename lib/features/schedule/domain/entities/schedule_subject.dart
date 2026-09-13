/// Identifies one enrolled subject to look up the schedule for. Kept
/// independent from `student_grades`' `Subject` entity so this feature
/// doesn't depend on another feature's domain layer.
class ScheduleSubject {
  final String code;
  final String group;
  final String campusId;
  final String name;

  const ScheduleSubject({
    required this.code,
    required this.group,
    required this.campusId,
    required this.name,
  });
}

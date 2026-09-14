import 'weekday.dart';

/// One weekly recurring session of an enrolled subject, e.g. "Thursday
/// 14:00-17:00 in building B13".
class ScheduleClass {
  final String subjectCode;
  final String subjectName;
  final String group;
  final String teacher;
  final String? teacherEmail;
  final Weekday day;
  final String startTime;
  final String endTime;
  final String building;
  final String room;
  final String campus;

  const ScheduleClass({
    required this.subjectCode,
    required this.subjectName,
    required this.group,
    required this.teacher,
    this.teacherEmail,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.building,
    required this.room,
    required this.campus,
  });
}

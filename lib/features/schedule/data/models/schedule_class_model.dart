import '../../domain/entities/schedule_class.dart';
import '../../domain/entities/weekday.dart';

class ScheduleClassModel {
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

  const ScheduleClassModel({
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

  ScheduleClass toEntity() => ScheduleClass(
    subjectCode: subjectCode,
    subjectName: subjectName,
    group: group,
    teacher: teacher,
    teacherEmail: teacherEmail,
    day: day,
    startTime: startTime,
    endTime: endTime,
    building: building,
    room: room,
    campus: campus,
  );
}

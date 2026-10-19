import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/features/schedule/domain/entities/schedule_class.dart';
import 'package:univalle_app/features/schedule/domain/entities/weekday.dart';
import 'package:univalle_app/features/schedule/domain/repositories/schedule_repository.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

ScheduleClass scheduleClass({
  String code = 'MAT1',
  String name = 'CÁLCULO I',
  Weekday day = Weekday.monday,
  String start = '08:00',
  String end = '10:00',
  String teacher = 'ANA GÓMEZ',
  String? teacherEmail = 'ana@univalle.edu.co',
  String building = 'B13',
  String room = 'AULA 101',
  String campus = 'MELÉNDEZ',
}) => ScheduleClass(
  subjectCode: code,
  subjectName: name,
  group: '01',
  teacher: teacher,
  teacherEmail: teacherEmail,
  day: day,
  startTime: start,
  endTime: end,
  building: building,
  room: room,
  campus: campus,
);

import 'package:univalle_app/features/student_grades/domain/entities/subject.dart';

class Grades {
  final String period;
  final double average;
  final int credits;
  final String porcentageApproved;
  final bool isWorthy;
  final List<Subject> subjects;

  Grades({
    required this.period,
    required this.average,
    required this.credits,
    required this.porcentageApproved,
    required this.isWorthy,
    required this.subjects,
  });
}

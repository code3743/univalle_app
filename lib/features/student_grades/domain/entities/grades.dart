import 'subject.dart';

class Grades {
  final String period;
  final double average;
  final int credits;
  final String approvedPercentage;
  final bool hasAcademicMerit;
  final List<Subject> subjects;

  const Grades({
    required this.period,
    required this.average,
    required this.credits,
    required this.approvedPercentage,
    required this.hasAcademicMerit,
    required this.subjects,
  });
}

import '../../domain/entities/grades.dart';
import 'subject_model.dart';

class GradesModel {
  final String period;
  final double average;
  final int credits;
  final String approvedPercentage;
  final bool hasAcademicMerit;
  final List<SubjectModel> subjects;

  const GradesModel({
    required this.period,
    required this.average,
    required this.credits,
    required this.approvedPercentage,
    required this.hasAcademicMerit,
    required this.subjects,
  });

  Grades toEntity() => Grades(
        period: period,
        average: average,
        credits: credits,
        approvedPercentage: approvedPercentage,
        hasAcademicMerit: hasAcademicMerit,
        subjects: subjects.map((subject) => subject.toEntity()).toList(),
      );
}

import 'package:univalle_app/features/student_grades/data/models/subject_model.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';

class GradesModel {
  final String period;
  final double average;
  final int credits;
  final String porcentageApproved;
  final bool isWorthy;
  final List<SubjectModel> subjects;

  GradesModel({
    required this.period,
    required this.average,
    required this.credits,
    required this.porcentageApproved,
    required this.isWorthy,
    required this.subjects,
  });

  factory GradesModel.fromJson(Map<String, dynamic> json) {
    return GradesModel(
      period: json['period'],
      average: json['average'],
      credits: json['credits'],
      porcentageApproved: json['porcentageApproved'],
      isWorthy: json['isWorthy'],
      subjects: List<SubjectModel>.from(
        json['subjects'].map(
          (subject) => SubjectModel.fromJson(subject),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'average': average,
      'credits': credits,
      'porcentageApproved': porcentageApproved,
      'isWorthy': isWorthy,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }

  factory GradesModel.fromEntity(Grades entity) {
    return GradesModel(
      period: entity.period,
      average: entity.average,
      credits: entity.credits,
      porcentageApproved: entity.porcentageApproved,
      isWorthy: entity.isWorthy,
      subjects: entity.subjects
          .map((subject) => SubjectModel.fromEntity(subject))
          .toList(),
    );
  }

  Grades toEntity() {
    return Grades(
      period: period,
      average: average,
      credits: credits,
      porcentageApproved: porcentageApproved,
      isWorthy: isWorthy,
      subjects: subjects.map((subject) => subject.toEntity()).toList(),
    );
  }
}

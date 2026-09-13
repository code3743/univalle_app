import '../../domain/entities/subject.dart';

class SubjectModel {
  final String code;
  final String group;
  final String name;
  final int credits;
  final String grade;
  final bool isCanceled;
  final String campusId;

  const SubjectModel({
    required this.code,
    required this.group,
    required this.name,
    required this.credits,
    required this.grade,
    required this.isCanceled,
    required this.campusId,
  });

  Subject toEntity() => Subject(
    code: code,
    group: group,
    name: name,
    credits: credits,
    grade: grade,
    isCanceled: isCanceled,
    campusId: campusId,
  );
}

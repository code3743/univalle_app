import '../../domain/entities/curriculum_subject.dart';

class CurriculumSubjectModel {
  final String code;
  final String name;
  final String subjectType;
  final int credits;
  final int semester;
  final List<String> prerequisiteCodes;

  CurriculumSubjectModel({
    required this.code,
    required this.name,
    required this.subjectType,
    required this.credits,
    required this.semester,
    required this.prerequisiteCodes,
  });

  CurriculumSubject toEntity() => CurriculumSubject(
    code: code,
    name: name,
    subjectType: subjectType,
    credits: credits,
    semester: semester,
    prerequisiteCodes: prerequisiteCodes,
  );
}

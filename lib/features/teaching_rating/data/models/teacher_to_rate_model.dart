import '../../domain/entities/teacher_to_rate.dart';

class TeacherToRateModel {
  final String id;
  final String teacherName;
  final String subjectName;
  final String subjectCode;
  final String group;
  final String campusId;
  final String teacherId;
  final String teacherDocument;
  final String programId;
  final String programName;
  final String programCode;
  final bool isQualified;
  final String? novelty;

  TeacherToRateModel({
    required this.id,
    required this.teacherName,
    required this.subjectName,
    required this.subjectCode,
    required this.group,
    required this.campusId,
    required this.teacherId,
    required this.teacherDocument,
    required this.programId,
    required this.programName,
    required this.programCode,
    required this.isQualified,
    this.novelty,
  });

  TeacherToRate toEntity() => TeacherToRate(
    id: id,
    teacherName: teacherName,
    subjectName: subjectName,
    subjectCode: subjectCode,
    group: group,
    campusId: campusId,
    teacherId: teacherId,
    teacherDocument: teacherDocument,
    programId: programId,
    programName: programName,
    programCode: programCode,
    isQualified: isQualified,
    novelty: novelty,
  );
}

import 'package:univalle_app/features/teaching%20qualification/domain/entities/subject_teacher.dart';

class SubjectTeacherModel {
  final String id;
  final String teacherName;
  final String subjectName;
  final String code;
  final String group;
  final String campusId;
  final String teacherId;
  final String teacherDocument;
  final String programName;
  final String programId;

  SubjectTeacherModel({
    required this.id,
    required this.teacherName,
    required this.subjectName,
    required this.code,
    required this.group,
    required this.campusId,
    required this.teacherId,
    required this.teacherDocument,
    required this.programName,
    required this.programId,
  });

  factory SubjectTeacherModel.fromJson(Map<String, dynamic> json) {
    return SubjectTeacherModel(
      id: json['id'],
      teacherName: json['teacherName'],
      subjectName: json['subjectName'],
      code: json['code'],
      group: json['group'],
      campusId: json['campusId'],
      teacherId: json['teacherId'],
      teacherDocument: json['teacherDocument'],
      programName: json['programName'],
      programId: json['programId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacherName': teacherName,
      'subjectName': subjectName,
      'code': code,
      'group': group,
      'campusId': campusId,
      'teacherId': teacherId,
      'teacherDocument': teacherDocument,
      'programName': programName,
      'programId': programId,
    };
  }

  factory SubjectTeacherModel.fromEntity(SubjectTeacher entity) {
    return SubjectTeacherModel(
      id: entity.id,
      teacherName: entity.teacherName,
      subjectName: entity.subjectName,
      code: entity.code,
      group: entity.group,
      campusId: entity.campusId,
      teacherId: entity.teacherId,
      teacherDocument: entity.teacherDocument,
      programName: entity.programName,
      programId: entity.programId,
    );
  }

  SubjectTeacher toEntity() {
    return SubjectTeacher(
      id: id,
      teacherName: teacherName,
      subjectName: subjectName,
      code: code,
      group: group,
      campusId: campusId,
      teacherId: teacherId,
      teacherDocument: teacherDocument,
      programName: programName,
      programId: programId,
    );
  }
}

import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';

class TeachingRatingModel {
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
  final bool isQualified;
  final String? novelty;

  TeachingRatingModel({
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
    required this.isQualified,
    this.novelty,
  });

  factory TeachingRatingModel.fromJson(Map<String, dynamic> json) {
    return TeachingRatingModel(
      id: json['ase_maa_pea_codigo'],
      teacherName: json['teacherName'],
      subjectName: json['apd_asi_nombre'],
      code: json['ase_apd_asi_codigo'],
      group: json['ase_apd_agp_grupo'],
      campusId: json['ase_apd_sed_codigo'],
      teacherId: json['ase_apd_doc_per_codigo'],
      teacherDocument: json['ase_apd_doc_codigo'],
      programName: json['ase_pra_nombre'],
      programId: json['ase_maa_pra_codigo'],
      isQualified: json['isQualified'],
      novelty: json['novelty'],
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
      'isQualified': isQualified,
      'novelty': novelty,
    };
  }

  factory TeachingRatingModel.fromEntity(TeachingRating entity) {
    return TeachingRatingModel(
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
      isQualified: entity.isQualified,
      novelty: entity.novelty,
    );
  }

  TeachingRating toEntity() {
    return TeachingRating(
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
      isQualified: isQualified,
      novelty: novelty,
    );
  }
}

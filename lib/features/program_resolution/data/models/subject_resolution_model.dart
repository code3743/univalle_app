import 'package:univalle_app/features/program_resolution/domain/entities/subject_resolution.dart';

class SubjectResolutionModel {
  final String code;
  final String name;
  final String subjectType;
  final String credits;
  final List<String> prerequisites;

  SubjectResolutionModel({
    required this.code,
    required this.name,
    required this.subjectType,
    required this.credits,
    required this.prerequisites,
  });

  factory SubjectResolutionModel.fromJson(Map<String, dynamic> json) {
    return SubjectResolutionModel(
      code: json['code'],
      name: json['name'],
      subjectType: json['subjectType'],
      credits: json['credits'],
      prerequisites: List<String>.from(json['prerequisites']),
    );
  }

  SubjectResolution toEntity() {
    return SubjectResolution(
      code: code,
      name: name,
      subjectType: subjectType,
      credits: credits,
      prerequisites: prerequisites,
    );
  }
}

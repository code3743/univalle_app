import 'package:univalle_app/features/student_grades/domain/entities/subject.dart';

class SubjectModel {
  final String name;
  final String code;
  final String group;
  final bool isCanceled;
  final double grade;
  final bool isEnabled;
  final int credits;

  SubjectModel({
    required this.name,
    required this.code,
    required this.group,
    required this.isCanceled,
    required this.grade,
    required this.isEnabled,
    required this.credits,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      name: json['name'],
      code: json['code'],
      group: json['group'],
      isCanceled: json['isCanceled'],
      grade: json['grade'],
      isEnabled: json['isEnabled'],
      credits: json['credits'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'group': group,
      'isCanceled': isCanceled,
      'grade': grade,
      'isEnabled': isEnabled,
      'credits': credits,
    };
  }

  Subject toEntity() {
    return Subject(
      name: name,
      code: code,
      group: group,
      isCanceled: isCanceled,
      grade: grade,
      isEnabled: isEnabled,
      credits: credits,
    );
  }

  factory SubjectModel.fromEntity(Subject entity) {
    return SubjectModel(
      name: entity.name,
      code: entity.code,
      group: entity.group,
      isCanceled: entity.isCanceled,
      grade: entity.grade,
      isEnabled: entity.isEnabled,
      credits: entity.credits,
    );
  }
}

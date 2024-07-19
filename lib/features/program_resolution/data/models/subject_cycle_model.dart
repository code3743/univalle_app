import 'package:univalle_app/features/program_resolution/data/models/subject_resolution_model.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';

class ResultCycleModel {
  final List<SubjectCycleModel> cycles;

  ResultCycleModel({
    required this.cycles,
  });

  factory ResultCycleModel.fromJson(Map<String, dynamic> json) {
    return ResultCycleModel(
      cycles: json.keys
          .map((key) => SubjectCycleModel.fromJson(
              {'semester': key, 'subjects': json[key]}))
          .toList(),
    );
  }
}

class SubjectCycleModel {
  final String semester;
  final List<SubjectResolutionModel> subjects;

  SubjectCycleModel({
    required this.semester,
    required this.subjects,
  });

  factory SubjectCycleModel.fromJson(Map<String, dynamic> json) {
    return SubjectCycleModel(
      semester: json['semester'],
      subjects: List<SubjectResolutionModel>.from(
          json['subjects'].map((x) => SubjectResolutionModel.fromJson(x))),
    );
  }

  SubjectCycle toEntity() {
    return SubjectCycle(
      semester: semester,
      subjects: subjects.map((e) => e.toEntity()).toList(),
    );
  }
}

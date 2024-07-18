import 'package:univalle_app/features/program_resolution/domain/entities/subject_resolution.dart';

class SubjectCycle {
  final String semester;
  final List<SubjectResolution> subjects;

  SubjectCycle({
    required this.semester,
    required this.subjects,
  });
}

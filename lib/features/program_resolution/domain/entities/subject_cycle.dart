import 'package:univalle_app/features/program_resolution/domain/entities/subject_resolution.dart';

class SubjectCycle {
  final String semester;
  final int totalCredits;
  final int totalPreRequisites;
  final List<SubjectResolution> subjects;

  SubjectCycle({
    required this.semester,
    required this.subjects,
  })  : totalCredits = subjects.fold<int>(
          0,
          (previousValue, element) =>
              previousValue + int.parse(element.credits),
        ),
        totalPreRequisites = subjects.fold<int>(
          0,
          (previousValue, element) =>
              previousValue + element.prerequisites.length,
        );
}

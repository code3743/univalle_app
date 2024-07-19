import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';

abstract class ResolutionDataSource {
  Future<List<SubjectCycle>> getResolution(
      String token, String studentId, String programId);
}

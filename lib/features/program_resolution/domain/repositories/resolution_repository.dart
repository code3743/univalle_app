import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';

abstract class ResolutionRepository {
  Future<List<SubjectCycle>> getResolution(
      String token, String studentId, String programId);
}

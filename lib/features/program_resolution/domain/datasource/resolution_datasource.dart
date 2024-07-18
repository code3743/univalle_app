import 'package:univalle_app/features/program_resolution/domain/entities/resolution.dart';

abstract class ResolutionDataSource {
  Future<List<SubjectCycle>> getResolution(
      String token, String studentId, String programId);
}

import '../../../../core/error/result.dart';
import '../entities/academic_history.dart';

abstract interface class GradesRepository {
  Future<Result<AcademicHistory>> getGrades({required String username});
}

import '../../../../core/error/result.dart';
import '../entities/grades.dart';

abstract interface class GradesRepository {
  Future<Result<List<Grades>>> getGrades({required String username});
}

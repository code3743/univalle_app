import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';

abstract class GradesRepository {
  Future<List<Grades>> getGrades(String token, String studentId);
}

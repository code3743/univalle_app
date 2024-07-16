import 'package:univalle_app/features/student_grades/domain/datasources/grades_datasource.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/student_grades/domain/repositories/grades_repository.dart';

class SiraGradesRepositoryImpl implements GradesRepository {
  final GradesDataSource _datasource;

  SiraGradesRepositoryImpl(this._datasource);

  @override
  Future<List<Grades>> getGrades(String token, String studentId) {
    return _datasource.getGrades(token, studentId);
  }
}

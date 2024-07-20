import 'package:univalle_app/features/auth/domain/entities/student.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';
import 'package:univalle_app/features/student_grades/domain/repositories/grades_repository.dart';
import 'package:univalle_app/features/student_tabulate/domain/repositories/tabulate_repository.dart';
import 'package:univalle_app/features/program_resolution/domain/repositories/resolution_repository.dart';

class StudentUseCase {
  final AuthRepository _authRepository;

  final GradesRepository _gradesRepository;

  final TabulateRepository _tabulateRepository;

  final ResolutionRepository _resolutionRepository;
  late Student _student;

  StudentUseCase(
    this._authRepository,
    this._gradesRepository,
    this._tabulateRepository,
    this._resolutionRepository,
  );

  Future<void> login(String code, String password) async {
    try {
      await _authRepository.login(code, password);
      _student = await _authRepository.getStudent();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLogged() async {
    return await _authRepository.isLogged();
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  Student getStudent() {
    return _student;
  }

  Future<List<Grades>> getGrades() async {
    return await _gradesRepository.getGrades(
        _student.token, _student.studentId.substring(2));
  }

  Future<Tabulate> getTabulate() async {
    return await _tabulateRepository.getTabulate(
        _student.studentId.substring(2), _student.programId, _student.token);
  }

  Future<List<SubjectCycle>> getResolution() async {
    return await _resolutionRepository.getResolution(
        _student.token, _student.studentId, _student.programId);
  }
}

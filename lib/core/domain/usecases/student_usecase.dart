import 'package:univalle_app/core/domain/entities/student.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';
import 'package:univalle_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';
import 'package:univalle_app/features/student_grades/domain/repositories/grades_repository.dart';
import 'package:univalle_app/features/student_tabulate/domain/repositories/tabulate_repository.dart';
import 'package:univalle_app/features/program_resolution/domain/repositories/resolution_repository.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/review_subject.dart';
import 'package:univalle_app/features/teaching_rating/domain/entities/teaching_rating.dart';
import 'package:univalle_app/features/teaching_rating/domain/repositories/teaching_rating_repository.dart';

class StudentUseCase {
  final AuthRepository _authRepository;

  final GradesRepository _gradesRepository;

  final TabulateRepository _tabulateRepository;

  final ResolutionRepository _resolutionRepository;

  final TeachingRatingRepository _teachingRatingRepository;
  late final Student? _student;

  StudentUseCase(
    this._authRepository,
    this._gradesRepository,
    this._tabulateRepository,
    this._resolutionRepository,
    this._teachingRatingRepository,
  );

  Future<void> login(String code, String password) async {
    try {
      await _authRepository.login(code, password);
      _student = await _authRepository.getStudent();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String code) async {
    await _authRepository.resetPassword(code);
  }

  Future<bool> isLogged() async {
    final status = await _authRepository.isLogged();
    if (status && _student == null) {
      _student = await _authRepository.getStudent();
    }
    return status;
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  Student getStudent() {
    return _student!;
  }

  Future<List<Grades>> getGrades() async {
    return await _gradesRepository.getGrades(
        _student!.token, _student.studentId.substring(2));
  }

  Future<Tabulate> getTabulate() async {
    return await _tabulateRepository.getTabulate(
        _student!.studentId.substring(2), _student.programId, _student.token);
  }

  Future<List<SubjectCycle>> getResolution() async {
    return await _resolutionRepository.getResolution(
        _student!.token, _student.studentId, _student.programId);
  }

  Future<List<TeachingRating>> getTeachingToRatings() async {
    return await _teachingRatingRepository.getTeachingToRatings(
        '${_student!.studentId.substring(2)}-${_student.programId}',
        _student.password);
  }

  Future<void> sendTeachingRating(ReviewSubject review) async {
    await _teachingRatingRepository.sendTeachingRating(review);
  }

  Future<ReviewSubject> getReviewSubject(TeachingRating teacher) async {
    return await _teachingRatingRepository.getReviewSubject(teacher);
  }
}

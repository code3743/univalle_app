import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/auth_local_datasource.dart';
import '../../domain/entities/rating_option.dart';
import '../../domain/entities/teacher_review.dart';
import '../../domain/entities/teacher_to_rate.dart';
import '../../domain/repositories/teaching_rating_repository.dart';
import '../datasources/course_evaluation_remote_datasource.dart';

class TeachingRatingRepositoryImpl implements TeachingRatingRepository {
  final CourseEvaluationRemoteDataSource _remote;
  final AuthLocalDataSource _credentials;
  const TeachingRatingRepositoryImpl(this._remote, this._credentials);

  @override
  Future<Result<List<TeacherToRate>>> getTeachersToRate() async {
    try {
      final credentials = await _requireCredentials();
      final teachers = await _remote.fetchTeachersToRate(
        username: credentials.username,
        password: credentials.password,
      );
      return Ok(teachers.map((teacher) => teacher.toEntity()).toList());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<TeacherReview>> getTeacherReview({
    required TeacherToRate teacher,
  }) async {
    try {
      final review = await _remote.fetchTeacherReview(teacher: teacher);
      return Ok(review.toEntity());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> submitTeacherReview({
    required TeacherReview review,
    required Map<String, RatingOption> answers,
    String? feedback,
  }) async {
    try {
      await _remote.submitTeacherReview(
        review: review,
        answers: answers,
        feedback: feedback,
      );
      return const Ok(null);
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }

  Future<StoredCredentials> _requireCredentials() async {
    final credentials = await _credentials.getCredentials();
    if (credentials == null) {
      throw const AuthException(message: AppStrings.sessionExpired);
    }
    return credentials;
  }
}

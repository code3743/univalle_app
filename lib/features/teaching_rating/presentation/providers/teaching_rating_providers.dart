import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/course_evaluation_dio_provider.dart';
import '../../../../core/storage/local_storage_providers.dart';
import '../../data/datasources/course_evaluation_remote_datasource.dart';
import '../../data/repositories/teaching_rating_repository_impl.dart';
import '../../domain/repositories/teaching_rating_repository.dart';
import '../../domain/usecases/get_teacher_review_usecase.dart';
import '../../domain/usecases/get_teachers_to_rate_usecase.dart';
import '../../domain/usecases/submit_teacher_review_usecase.dart';

part 'teaching_rating_providers.g.dart';

@Riverpod(keepAlive: true)
CourseEvaluationRemoteDataSource courseEvaluationRemoteDataSource(Ref ref) {
  return CourseEvaluationRemoteDataSource(
    ref.watch(courseEvaluationDioProvider),
    ref.watch(courseEvaluationCookieJarProvider),
  );
}

@Riverpod(keepAlive: true)
TeachingRatingRepository teachingRatingRepository(Ref ref) {
  return TeachingRatingRepositoryImpl(
    ref.watch(courseEvaluationRemoteDataSourceProvider),
    ref.watch(authLocalDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
GetTeachersToRateUseCase getTeachersToRateUseCase(Ref ref) {
  return GetTeachersToRateUseCase(ref.watch(teachingRatingRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetTeacherReviewUseCase getTeacherReviewUseCase(Ref ref) {
  return GetTeacherReviewUseCase(ref.watch(teachingRatingRepositoryProvider));
}

@Riverpod(keepAlive: true)
SubmitTeacherReviewUseCase submitTeacherReviewUseCase(Ref ref) {
  return SubmitTeacherReviewUseCase(
    ref.watch(teachingRatingRepositoryProvider),
  );
}

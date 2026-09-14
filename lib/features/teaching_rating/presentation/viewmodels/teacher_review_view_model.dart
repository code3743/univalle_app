import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/teacher_review.dart';
import '../../domain/entities/teacher_to_rate.dart';
import '../providers/teaching_rating_providers.dart';

part 'teacher_review_view_model.g.dart';

@riverpod
class TeacherReviewViewModel extends _$TeacherReviewViewModel {
  @override
  Future<TeacherReview> build(TeacherToRate teacher) async {
    final result = await ref
        .read(getTeacherReviewUseCaseProvider)
        .call(teacher: teacher);
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (review) => review,
    );
  }
}

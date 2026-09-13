import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/teacher_to_rate.dart';
import '../providers/teaching_rating_providers.dart';

part 'teachers_to_rate_view_model.g.dart';

@riverpod
class TeachersToRateViewModel extends _$TeachersToRateViewModel {
  @override
  Future<List<TeacherToRate>> build() async {
    final result = await ref.read(getTeachersToRateUseCaseProvider).call();
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (teachers) => teachers,
    );
  }
}

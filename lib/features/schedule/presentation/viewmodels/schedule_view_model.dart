import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../student_grades/presentation/viewmodels/grades_view_model.dart';
import '../../domain/entities/schedule_class.dart';
import '../providers/schedule_providers.dart';
import '../utils/schedule_subject_mapper.dart';

part 'schedule_view_model.g.dart';

@riverpod
class ScheduleViewModel extends _$ScheduleViewModel {
  @override
  Future<List<ScheduleClass>> build() async {
    final periods = await ref.watch(gradesViewModelProvider.future);
    if (periods.isEmpty) return [];

    final subjects = scheduleSubjectsFrom(periods.last.subjects);
    if (subjects.isEmpty) return [];

    final result = await ref
        .read(getScheduleUseCaseProvider)
        .call(subjects: subjects);
    return result.fold(
      onError: (failure) => throw failure,
      onSuccess: (schedule) => schedule,
    );
  }
}

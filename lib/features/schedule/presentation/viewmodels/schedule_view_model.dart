import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../student_grades/presentation/viewmodels/grades_view_model.dart';
import '../../domain/entities/schedule_class.dart';
import '../../domain/entities/schedule_subject.dart';
import '../providers/schedule_providers.dart';

part 'schedule_view_model.g.dart';

@riverpod
class ScheduleViewModel extends _$ScheduleViewModel {
  @override
  Future<List<ScheduleClass>> build() async {
    final periods = await ref.watch(gradesViewModelProvider.future);
    if (periods.isEmpty) return [];

    final subjects = periods.last.subjects
        .where((subject) => !subject.isCanceled && subject.group.isNotEmpty)
        .map(
          (subject) => ScheduleSubject(
            code: subject.code,
            group: subject.group,
            campusId: subject.campusId,
            name: subject.name,
          ),
        )
        .toList();
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

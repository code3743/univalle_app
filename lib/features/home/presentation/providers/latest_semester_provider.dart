import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/sira_period_formatter.dart';
import '../../../student_grades/presentation/viewmodels/grades_view_model.dart';

part 'latest_semester_provider.g.dart';

/// Latest (highest year-semester) period among the fetched grades, e.g.
/// "2026-1". Null while grades are loading, on error, or when there's no
/// academic history yet.
@riverpod
String? latestSemester(Ref ref) {
  final periods = ref.watch(gradesViewModelProvider).value;
  if (periods == null || periods.isEmpty) return null;

  return periods
      .map((period) => SiraPeriodFormatter.shortCode(period.period))
      .reduce((a, b) => a.compareTo(b) >= 0 ? a : b);
}

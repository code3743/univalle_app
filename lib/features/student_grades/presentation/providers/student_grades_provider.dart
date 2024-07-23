import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/core/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';

final studentGradesProvider =
    StateNotifierProvider<StudentGradesNotifier, List<Grades>?>((ref) {
  return StudentGradesNotifier(ref);
});

final _gradesProvider = FutureProvider<List<Grades>>((ref) async {
  final studentUseCase = ref.watch(studentUseCasesProvider);
  return await studentUseCase.getGrades();
});

class StudentGradesNotifier extends StateNotifier<List<Grades>?> {
  final Ref _ref;
  StudentGradesNotifier(this._ref) : super(null) {
    getGrades();
  }

  final List<String> periods = ['Todos'];
  int selectedPeriod = 0;

  Future<void> getGrades() async {
    try {
      final grades = await _ref.read(_gradesProvider.future);
      for (var element in grades) {
        periods.add(element.period);
      }
      state = grades;
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBar(e.toString());
      _ref.read(appRouterProvider).pop();
      dispose();
    }
  }

  void filterGrades(int index) async {
    if (index == 0) {
      state = await _ref.read(_gradesProvider.future);
    } else {
      final grades = await _ref.read(_gradesProvider.future);
      state = [grades[index - 1]];
    }
    selectedPeriod = index;
  }
}

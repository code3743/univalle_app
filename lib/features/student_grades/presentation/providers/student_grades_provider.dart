import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';

final studentGradesProvider =
    StateNotifierProvider<StudentGradesNotifier, List<Grades>?>((ref) {
  return StudentGradesNotifier(ref);
});

class StudentGradesNotifier extends StateNotifier<List<Grades>?> {
  final Ref _ref;
  StudentGradesNotifier(this._ref) : super(null) {
    getGrades();
  }

  final List<String> periods = ['Todos'];
  late final List<Grades> grades;
  int selectedPeriod = 0;

  Future<void> getGrades() async {
    try {
      grades = await _ref.read(studentUseCasesProvider).getGrades();
      for (var element in grades) {
        periods.add(element.period);
      }
      state = grades;
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
      _ref.read(appRouterProvider).pop();
      dispose();
    }
  }

  void filterGrades(int index) async {
    if (index == 0) {
      state = grades;
    } else {
      state = [grades[index - 1]];
    }
    selectedPeriod = index;
  }
}

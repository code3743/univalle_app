import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/student_grades/domain/entities/grades.dart';

final studentGradesProvider = FutureProvider<List<Grades>>((ref) async {
  final studentUseCase = ref.watch(studentUseCasesProvider);
  try {
    final grades = await studentUseCase.getGrades();
    return grades;
  } catch (e) {
    ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
    rethrow;
  }
});

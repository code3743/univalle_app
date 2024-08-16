import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';

final programResolutionProvider =
    FutureProvider<List<SubjectCycle>>((ref) async {
  try {
    final studentUseCase = ref.watch(studentUseCasesProvider);
    final subjects = await studentUseCase.getResolution();
    return subjects;
  } catch (e) {
    ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
    rethrow;
  }
});

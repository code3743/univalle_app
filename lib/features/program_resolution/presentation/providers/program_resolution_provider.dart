import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/core/common/handlers/handlers.dart';
import 'package:univalle_app/config/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';

final programResolutionProvider =
    StateNotifierProvider<ProgramResolutionNotifier, List<SubjectCycle>?>(
        (ref) {
  return ProgramResolutionNotifier(ref);
});

class ProgramResolutionNotifier extends StateNotifier<List<SubjectCycle>?> {
  final Ref _ref;

  ProgramResolutionNotifier(this._ref) : super(null) {
    _getSubjectCycles();
  }

  void _getSubjectCycles() async {
    try {
      final subjectCycles =
          await _ref.read(studentUseCasesProvider).getResolution();
      state = subjectCycles;
    } catch (e) {
      _ref.read(snackBarHandlerProvider).showSnackBarError(e.toString());
      _ref.read(appRouterProvider).pop();
      dispose();
    }
  }
}

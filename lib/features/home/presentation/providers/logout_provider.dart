import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/routers/app_router.dart';
import 'package:univalle_app/core/providers/shared_preferences_provider.dart';
import 'package:univalle_app/core/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/student_grades/presentation/providers/student_grades_provider.dart';
import 'package:univalle_app/features/student_tabulate/presentation/providers/student_tabulate_provider.dart';

final logoutProvider = Provider.autoDispose<void>((ref) async {
  final studentUseCase = ref.read(studentUseCasesProvider);
  await studentUseCase.logout();
  ref.invalidate(studentGradesProvider);
  ref.invalidate(studentTabulateProvider);
  await ref.read(sharedUtilityProvider).clearStudentData();
  ref.read(appRouterProvider).go('/login');
  return;
});

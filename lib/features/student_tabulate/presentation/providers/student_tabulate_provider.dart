import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/core/providers/student_use_cases_provider.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';

final studentTabulateProvider = FutureProvider<Tabulate>((ref) async {
  final studentUseCase = ref.watch(studentUseCasesProvider);
  return await studentUseCase.getTabulate();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:univalle_app/config/providers/shared_preferences_provider.dart';
import 'package:univalle_app/core/domain/usecases/student_usecase.dart';
import 'package:univalle_app/features/auth/data/datasource/sira_auth_datasource.dart';
import 'package:univalle_app/features/auth/data/repositories/sira_auth_repository_impl.dart';
import 'package:univalle_app/features/program_resolution/data/datasource/sira_resolution_datasource.dart';
import 'package:univalle_app/features/program_resolution/data/repositories/sira_resolution_repository_impl.dart';
import 'package:univalle_app/features/student_grades/data/datasources/sira_grades_datasource.dart';
import 'package:univalle_app/features/student_grades/data/repositories/sira_grades_repository_impl.dart';
import 'package:univalle_app/features/student_tabulate/data/datasource/sira_tabulate_datasource.dart';
import 'package:univalle_app/features/student_tabulate/data/repositories/sira_tabulate_repository_impl.dart';
import 'package:univalle_app/features/teaching_rating/data/datasource/sira_teaching_rating_datasource.dart';
import 'package:univalle_app/features/teaching_rating/data/repositories/sira_teaching_rating_repository_impl.dart';

final studentUseCasesProvider = Provider<StudentUseCase>((ref) {
  final sharedStudentUtility = ref.watch(sharedUtilityProvider);
  final authRepository =
      SiraAuthRepositoryImpl(SiraAuthDatasource(sharedStudentUtility));
  final studentGradesRepository =
      SiraGradesRepositoryImpl(SiraGradesDatasource());
  final studentTabulateRepository =
      SiraTabulateRepositoryImpl(SiraTabulateDatasource());
  final resolutionRepository =
      SiraResolutionRepositoryImpl(SiraResolutionDatasource());

  final teachingRatingRepository =
      SiraTeachingRatingRepositoryImpl(SiraTeachingRatingDatasource());

  return StudentUseCase(
      authRepository,
      studentGradesRepository,
      studentTabulateRepository,
      resolutionRepository,
      teachingRatingRepository);
});

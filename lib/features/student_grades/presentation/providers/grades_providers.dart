import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/sira_academic_record_client.dart';
import '../../data/datasources/sira_grades_remote_datasource.dart';
import '../../data/repositories/grades_repository_impl.dart';
import '../../domain/repositories/grades_repository.dart';
import '../../domain/usecases/get_grades_usecase.dart';

part 'grades_providers.g.dart';

@Riverpod(keepAlive: true)
SiraGradesRemoteDataSource siraGradesRemoteDataSource(Ref ref) {
  return SiraGradesRemoteDataSource(
    ref.watch(siraAcademicRecordClientProvider),
  );
}

@Riverpod(keepAlive: true)
GradesRepository gradesRepository(Ref ref) {
  return GradesRepositoryImpl(ref.watch(siraGradesRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
GetGradesUseCase getGradesUseCase(Ref ref) {
  return GetGradesUseCase(ref.watch(gradesRepositoryProvider));
}

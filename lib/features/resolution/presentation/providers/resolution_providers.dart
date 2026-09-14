import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/sira_dio_provider.dart';
import '../../data/datasources/sira_resolution_remote_datasource.dart';
import '../../data/repositories/resolution_repository_impl.dart';
import '../../domain/repositories/resolution_repository.dart';
import '../../domain/usecases/get_curriculum_usecase.dart';

part 'resolution_providers.g.dart';

@Riverpod(keepAlive: true)
SiraResolutionRemoteDataSource siraResolutionRemoteDataSource(Ref ref) {
  return SiraResolutionRemoteDataSource(ref.watch(siraDioProvider));
}

@Riverpod(keepAlive: true)
ResolutionRepository resolutionRepository(Ref ref) {
  return ResolutionRepositoryImpl(
    ref.watch(siraResolutionRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
GetCurriculumUseCase getCurriculumUseCase(Ref ref) {
  return GetCurriculumUseCase(ref.watch(resolutionRepositoryProvider));
}

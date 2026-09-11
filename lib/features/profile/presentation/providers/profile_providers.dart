import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/sira_dio_provider.dart';
import '../../data/datasources/sira_profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_student_usecase.dart';

part 'profile_providers.g.dart';

@Riverpod(keepAlive: true)
SiraProfileRemoteDataSource siraProfileRemoteDataSource(Ref ref) {
  return SiraProfileRemoteDataSource(ref.watch(siraDioProvider));
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(ref.watch(siraProfileRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
GetStudentUseCase getStudentUseCase(Ref ref) {
  return GetStudentUseCase(ref.watch(profileRepositoryProvider));
}

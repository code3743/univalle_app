import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/schedule_dio_provider.dart';
import '../../data/datasources/sira_schedule_remote_datasource.dart';
import '../../data/repositories/schedule_repository_impl.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/usecases/get_schedule_usecase.dart';

part 'schedule_providers.g.dart';

@Riverpod(keepAlive: true)
SiraScheduleRemoteDataSource siraScheduleRemoteDataSource(Ref ref) {
  return SiraScheduleRemoteDataSource(ref.watch(scheduleDioProvider));
}

@Riverpod(keepAlive: true)
ScheduleRepository scheduleRepository(Ref ref) {
  return ScheduleRepositoryImpl(
    ref.watch(siraScheduleRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
GetScheduleUseCase getScheduleUseCase(Ref ref) {
  return GetScheduleUseCase(ref.watch(scheduleRepositoryProvider));
}

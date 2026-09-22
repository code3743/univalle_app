import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_dio_provider.dart';
import '../../../../core/storage/local_storage_providers.dart';
import '../../data/datasources/remote_config_local_datasource.dart';
import '../../data/datasources/remote_config_remote_datasource.dart';
import '../../data/repositories/remote_config_repository_impl.dart';
import '../../domain/repositories/remote_config_repository.dart';
import '../../domain/usecases/dismiss_update_usecase.dart';
import '../../domain/usecases/get_announcements_usecase.dart';
import '../../domain/usecases/get_app_config_usecase.dart';
import '../../domain/usecases/get_dismissed_update_usecase.dart';
import '../../domain/usecases/get_seen_welcome_usecase.dart';
import '../../domain/usecases/mark_welcome_seen_usecase.dart';

part 'remote_config_providers.g.dart';

@Riverpod(keepAlive: true)
RemoteConfigRemoteDataSource remoteConfigRemoteDataSource(Ref ref) {
  return RemoteConfigRemoteDataSource(ref.watch(apiDioProvider));
}

@Riverpod(keepAlive: true)
RemoteConfigLocalDataSource remoteConfigLocalDataSource(Ref ref) {
  return RemoteConfigLocalDataSource(ref.watch(localStorageServiceProvider));
}

@Riverpod(keepAlive: true)
RemoteConfigRepository remoteConfigRepository(Ref ref) {
  return RemoteConfigRepositoryImpl(
    ref.watch(remoteConfigRemoteDataSourceProvider),
    ref.watch(remoteConfigLocalDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
GetAppConfigUseCase getAppConfigUseCase(Ref ref) {
  return GetAppConfigUseCase(ref.watch(remoteConfigRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetAnnouncementsUseCase getAnnouncementsUseCase(Ref ref) {
  return GetAnnouncementsUseCase(ref.watch(remoteConfigRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetDismissedUpdateUseCase getDismissedUpdateUseCase(Ref ref) {
  return GetDismissedUpdateUseCase(ref.watch(remoteConfigRepositoryProvider));
}

@Riverpod(keepAlive: true)
DismissUpdateUseCase dismissUpdateUseCase(Ref ref) {
  return DismissUpdateUseCase(ref.watch(remoteConfigRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetSeenWelcomeUseCase getSeenWelcomeUseCase(Ref ref) {
  return GetSeenWelcomeUseCase(ref.watch(remoteConfigRepositoryProvider));
}

@Riverpod(keepAlive: true)
MarkWelcomeSeenUseCase markWelcomeSeenUseCase(Ref ref) {
  return MarkWelcomeSeenUseCase(ref.watch(remoteConfigRepositoryProvider));
}

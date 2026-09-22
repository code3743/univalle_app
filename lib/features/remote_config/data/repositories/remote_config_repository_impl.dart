import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/app_config.dart';
import '../../domain/entities/announcements_page.dart';
import '../../domain/repositories/remote_config_repository.dart';
import '../datasources/remote_config_local_datasource.dart';
import '../datasources/remote_config_remote_datasource.dart';

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  final RemoteConfigRemoteDataSource _remote;
  final RemoteConfigLocalDataSource _local;
  const RemoteConfigRepositoryImpl(this._remote, this._local);

  @override
  Future<Result<AppConfig>> getConfig({
    required String platform,
    required String version,
  }) async {
    try {
      final model = await _remote.fetchConfig(
        platform: platform,
        version: version,
      );
      await _local.saveConfigSnapshot(model.toJson());
      return Ok(model.toEntity());
    } on AppException catch (e) {
      final cached = await _local.getConfigSnapshot();
      if (cached != null) return Ok(cached.toEntity());
      return Err(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<AnnouncementsPage>> getAnnouncements({
    required int page,
  }) async {
    try {
      final model = await _remote.fetchAnnouncements(page: page);
      return Ok(model.toEntity());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<String?>> getDismissedUpdate() =>
      _guard(() => _local.getDismissedUpdate());

  @override
  Future<Result<void>> dismissUpdate(String latestVersion) =>
      _guard(() => _local.dismissUpdate(latestVersion));

  @override
  Future<Result<String?>> getSeenWelcome() =>
      _guard(() => _local.getSeenWelcome());

  @override
  Future<Result<void>> markWelcomeSeen(String fingerprint) =>
      _guard(() => _local.markWelcomeSeen(fingerprint));

  Future<Result<T>> _guard<T>(Future<T> Function() operation) async {
    try {
      return Ok(await operation());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}

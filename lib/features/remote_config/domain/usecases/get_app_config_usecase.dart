import '../../../../core/error/result.dart';
import '../entities/app_config.dart';
import '../repositories/remote_config_repository.dart';

class GetAppConfigUseCase {
  final RemoteConfigRepository _repository;
  const GetAppConfigUseCase(this._repository);

  Future<Result<AppConfig>> call({
    required String platform,
    required String version,
  }) => _repository.getConfig(platform: platform, version: version);
}

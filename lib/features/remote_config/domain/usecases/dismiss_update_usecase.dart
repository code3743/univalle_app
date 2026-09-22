import '../../../../core/error/result.dart';
import '../repositories/remote_config_repository.dart';

class DismissUpdateUseCase {
  final RemoteConfigRepository _repository;
  const DismissUpdateUseCase(this._repository);

  Future<Result<void>> call(String latestVersion) =>
      _repository.dismissUpdate(latestVersion);
}

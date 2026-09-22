import '../../../../core/error/result.dart';
import '../repositories/remote_config_repository.dart';

class MarkWelcomeSeenUseCase {
  final RemoteConfigRepository _repository;
  const MarkWelcomeSeenUseCase(this._repository);

  Future<Result<void>> call(String fingerprint) =>
      _repository.markWelcomeSeen(fingerprint);
}

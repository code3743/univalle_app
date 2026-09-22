import '../../../../core/error/result.dart';
import '../repositories/remote_config_repository.dart';

class GetSeenWelcomeUseCase {
  final RemoteConfigRepository _repository;
  const GetSeenWelcomeUseCase(this._repository);

  Future<Result<String?>> call() => _repository.getSeenWelcome();
}

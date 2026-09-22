import '../../../../core/error/result.dart';
import '../repositories/remote_config_repository.dart';

class GetDismissedUpdateUseCase {
  final RemoteConfigRepository _repository;
  const GetDismissedUpdateUseCase(this._repository);

  Future<Result<String?>> call() => _repository.getDismissedUpdate();
}

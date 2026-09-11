import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class RestoreSessionUseCase {
  final AuthRepository _repository;
  const RestoreSessionUseCase(this._repository);

  Future<Result<String?>> call() => _repository.restoreSession();
}

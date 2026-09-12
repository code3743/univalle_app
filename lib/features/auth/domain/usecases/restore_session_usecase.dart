import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class RestoreSessionUseCase {
  final AuthRepository _repository;
  const RestoreSessionUseCase(this._repository);

  Future<Result<AuthSession?>> call() => _repository.restoreSession();
}

import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<Result<void>> call() => _repository.logout();
}

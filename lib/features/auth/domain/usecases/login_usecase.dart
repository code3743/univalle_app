import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<Result<void>> call({required String username, required String password}) {
    return _repository.login(username: username, password: password);
  }
}

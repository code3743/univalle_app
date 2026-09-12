import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<Result<AuthSession>> call({
    required String username,
    required String password,
  }) {
    return _repository.login(username: username, password: password);
  }
}

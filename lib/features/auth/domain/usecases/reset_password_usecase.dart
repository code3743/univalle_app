import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;
  const ResetPasswordUseCase(this._repository);

  Future<Result<String>> call({required String username}) {
    return _repository.resetPassword(username: username);
  }
}

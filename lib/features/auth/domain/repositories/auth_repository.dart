import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  });
  Future<Result<void>> logout();
  Future<Result<AuthSession?>> restoreSession();
  Future<Result<String>> resetPassword({required String username});
}

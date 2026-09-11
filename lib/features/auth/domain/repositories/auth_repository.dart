import '../../../../core/error/result.dart';

abstract interface class AuthRepository {
  Future<Result<void>> login({required String username, required String password});
  Future<Result<void>> logout();
  Future<Result<String?>> restoreSession();
  Future<Result<String>> resetPassword({required String username});
}

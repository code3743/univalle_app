import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/sira_auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SiraAuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  const AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<Result<void>> login({required String username, required String password}) async {
    try {
      await _remote.login(username: username, password: password);
      await _local.saveCredentials(username: username, password: password);
      return const Ok(null);
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remote.logout();
    } on AppException {
      // no-op
    }
    await _local.clearCredentials();
    return const Ok(null);
  }

  @override
  Future<Result<String?>> restoreSession() async {
    final credentials = await _local.getCredentials();
    if (credentials == null) return const Ok(null);

    try {
      await _remote.login(username: credentials.username, password: credentials.password);
      return Ok(credentials.username);
    } on AuthException {
      await _local.clearCredentials();
      return const Ok(null);
    } on AppException {
      return const Ok(null);
    }
  }

  @override
  Future<Result<void>> resetPassword({required String username}) async {
    try {
      await _remote.resetPassword(username: username);
      return const Ok(null);
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}

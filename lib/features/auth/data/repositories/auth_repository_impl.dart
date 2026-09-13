import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/auth_local_datasource.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/sira_auth_remote_datasource.dart';
import '../datasources/uplanner_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SiraAuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final UplannerRemoteDataSource _uplanner;

  const AuthRepositoryImpl(this._remote, this._local, this._uplanner);

  @override
  Future<Result<AuthSession>> login({
    required String username,
    required String password,
  }) async {
    try {
      await _remote.login(username: username, password: password);
      await _local.saveCredentials(username: username, password: password);
      final photoUrl = await _resolvePhotoUrl(
        username: username,
        password: password,
        cachedPhotoUrl: null,
      );
      return Ok(AuthSession(username: username, photoUrl: photoUrl));
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
  Future<Result<AuthSession?>> restoreSession() async {
    final credentials = await _local.getCredentials();
    if (credentials == null) return const Ok(null);

    try {
      await _remote.login(
        username: credentials.username,
        password: credentials.password,
      );
      final photoUrl = await _resolvePhotoUrl(
        username: credentials.username,
        password: credentials.password,
        cachedPhotoUrl: credentials.photoUrl,
      );
      return Ok(
        AuthSession(username: credentials.username, photoUrl: photoUrl),
      );
    } on AuthException {
      await _local.clearCredentials();
      return const Ok(null);
    } on AppException {
      return const Ok(null);
    }
  }

  Future<String?> _resolvePhotoUrl({
    required String username,
    required String password,
    required String? cachedPhotoUrl,
  }) async {
    if (cachedPhotoUrl != null) return cachedPhotoUrl;
    final photoUrl = await _uplanner.fetchPhotoUrl(
      username: username,
      password: password,
    );
    if (photoUrl != null) await _local.savePhotoUrl(photoUrl);
    return photoUrl;
  }

  @override
  Future<Result<String>> resetPassword({required String username}) async {
    try {
      final email = await _remote.resetPassword(username: username);
      return Ok(email);
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}

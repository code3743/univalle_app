import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/auth_local_datasource.dart';
import '../../domain/entities/library_account.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/library_remote_datasource.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteDataSource _remote;
  final AuthLocalDataSource _credentials;
  const LibraryRepositoryImpl(this._remote, this._credentials);

  @override
  Future<Result<LibraryAccount>> getAccount() async {
    try {
      final credentials = await _credentials.getCredentials();
      if (credentials == null) {
        throw const AuthException(message: AppStrings.sessionExpired);
      }
      final account = await _remote.fetchAccount(
        username: credentials.username,
      );
      return Ok(account.toEntity());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}

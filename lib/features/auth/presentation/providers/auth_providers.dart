import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/sira_dio_provider.dart';
import '../../../../core/network/uplanner_dio_provider.dart';
import '../../../../core/storage/local_storage_providers.dart';
import '../../data/datasources/sira_auth_remote_datasource.dart';
import '../../data/datasources/uplanner_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/restore_session_usecase.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
SiraAuthRemoteDataSource siraAuthRemoteDataSource(Ref ref) {
  return SiraAuthRemoteDataSource(ref.watch(siraDioProvider));
}

@Riverpod(keepAlive: true)
UplannerRemoteDataSource uplannerRemoteDataSource(Ref ref) {
  return UplannerRemoteDataSource(ref.watch(uplannerDioProvider));
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    ref.watch(siraAuthRemoteDataSourceProvider),
    ref.watch(authLocalDataSourceProvider),
    ref.watch(uplannerRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
LoginUseCase loginUseCase(Ref ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));

@Riverpod(keepAlive: true)
LogoutUseCase logoutUseCase(Ref ref) =>
    LogoutUseCase(ref.watch(authRepositoryProvider));

@Riverpod(keepAlive: true)
RestoreSessionUseCase restoreSessionUseCase(Ref ref) {
  return RestoreSessionUseCase(ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
ResetPasswordUseCase resetPasswordUseCase(Ref ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
}

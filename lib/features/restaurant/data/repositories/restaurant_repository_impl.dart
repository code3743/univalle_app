import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/auth_local_datasource.dart';
import '../../domain/entities/lunch_payment.dart';
import '../../domain/entities/restaurant_account.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource _remote;
  final AuthLocalDataSource _credentials;
  const RestaurantRepositoryImpl(this._remote, this._credentials);

  @override
  Future<Result<RestaurantAccount>> getAccount() async {
    try {
      final credentials = await _requireCredentials();
      final account = await _remote.fetchAccount(
        username: credentials.username,
        password: credentials.password,
      );
      return Ok(account.toEntity());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<LunchPayment>> buyLunches({
    required int quantity,
    required double total,
  }) async {
    try {
      final payment = await _remote.buyLunches(
        quantity: quantity,
        total: total,
      );
      return Ok(payment.toEntity());
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }

  Future<StoredCredentials> _requireCredentials() async {
    final credentials = await _credentials.getCredentials();
    if (credentials == null) {
      throw const AuthException(message: AppStrings.sessionExpired);
    }
    return credentials;
  }
}

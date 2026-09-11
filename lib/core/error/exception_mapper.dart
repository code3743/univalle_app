import 'exceptions.dart';
import 'failures.dart';

Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    ServerException(:final message, :final statusCode) =>
      ServerFailure(message: message, statusCode: statusCode),
    NetworkException(:final message) => NetworkFailure(message: message),
    CacheException(:final message) => CacheFailure(message: message),
    _ => UnknownFailure(message: error.toString()),
  };
}

sealed class AppException implements Exception {
  final String message;
  const AppException({required this.message});

  @override
  String toString() => runtimeType.toString();
}

final class ServerException extends AppException {
  final int? statusCode;
  const ServerException({required super.message, this.statusCode});
}

final class NetworkException extends AppException {
  const NetworkException({required super.message});
}

final class CacheException extends AppException {
  const CacheException({required super.message});
}

final class AuthException extends AppException {
  const AuthException({required super.message});
}

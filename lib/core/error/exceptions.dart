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

/// A business-rule outcome carrying its own specific, already
/// user-appropriate message (e.g. text scraped from the source system)
/// rather than a technical failure mapped to a generic message by status
/// code — see [BusinessFailure].
///
/// [retryable] should be false for a state that a retry can't change (e.g.
/// "this assignment has no survey configured"), so the UI can skip showing
/// a "Reintentar" button that would just repeat the same outcome.
final class BusinessException extends AppException {
  final bool retryable;
  const BusinessException({required super.message, this.retryable = true});
}

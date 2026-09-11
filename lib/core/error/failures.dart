import '../constants/app_strings.dart';

sealed class Failure {
  final String message;
  final String userMessage;

  const Failure({required this.message, required this.userMessage});

  @override
  String toString() => 'Failure(message: $message)';
}

final class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure({required super.message, this.statusCode})
      : super(userMessage: _userMessageFor(statusCode));

  static String _userMessageFor(int? statusCode) {
    if (statusCode == 401) return AppStrings.sessionExpired;
    if (statusCode == 403) return AppStrings.forbidden;
    if (statusCode == 404) return AppStrings.notFound;
    if (statusCode != null && statusCode >= 500) return AppStrings.serverError;
    return AppStrings.requestError;
  }
}

final class NetworkFailure extends Failure {
  NetworkFailure({required super.message}) : super(userMessage: AppStrings.networkError);
}

final class CacheFailure extends Failure {
  CacheFailure({required super.message}) : super(userMessage: AppStrings.cacheError);
}

final class UnknownFailure extends Failure {
  UnknownFailure({required super.message}) : super(userMessage: AppStrings.genericError);
}

final class AuthFailure extends Failure {
  AuthFailure({required super.message}) : super(userMessage: message);
}

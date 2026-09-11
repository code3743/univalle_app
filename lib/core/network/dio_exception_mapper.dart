import 'package:dio/dio.dart';

import '../error/exceptions.dart';

AppException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkException(message: error.message ?? 'Connection error');
    case DioExceptionType.badResponse:
      return ServerException(
        message: error.response?.data?.toString() ?? error.message ?? 'Bad response',
        statusCode: error.response?.statusCode,
      );
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
    default:
      return ServerException(message: error.message ?? 'Unexpected error');
  }
}

import 'package:dio/dio.dart' show DioException, DioExceptionType;
import 'package:univalle_app/core/errors/sira_exception.dart';

void _handleDioException(DioException dioError) {
  switch (dioError.type) {
    case DioExceptionType.badCertificate:
      throw SiraException('Certificado no válido');
    case DioExceptionType.connectionTimeout:
      throw SiraException('Tiempo de conexión agotado');
    case DioExceptionType.badResponse:
      throw SiraException('Respuesta inesperada');
    case DioExceptionType.cancel:
      throw SiraException('Petición cancelada');
    case DioExceptionType.connectionError:
      throw SiraException('Error de conexión');
    case DioExceptionType.sendTimeout:
      throw SiraException('Tiempo de envío agotado');
    case DioExceptionType.receiveTimeout:
      throw SiraException('Tiempo de recepción agotado');
    default:
      throw SiraException('Error desconocido');
  }
}

void handleSiraError(Object e) {
  if (e is DioException) {
    _handleDioException(e);
  } else if (e is SiraException) {
    throw e;
  } else {
    throw SiraException('Error desconocido $e');
  }
}

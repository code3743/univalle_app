import 'package:dio/dio.dart' show DioException, DioExceptionType;
import 'package:univalle_app/core/errors/sira_exception.dart';

SiraException _handleDioException(DioException dioError) {
  switch (dioError.type) {
    case DioExceptionType.badCertificate:
      return SiraException('Certificado no válido');
    case DioExceptionType.connectionTimeout:
      return SiraException('Tiempo de conexión agotado');
    case DioExceptionType.badResponse:
      return SiraException('Respuesta inesperada');
    case DioExceptionType.cancel:
      return SiraException('Petición cancelada');
    case DioExceptionType.connectionError:
      return SiraException('Error de conexión');
    case DioExceptionType.sendTimeout:
      return SiraException('Tiempo de envío agotado');
    case DioExceptionType.receiveTimeout:
      return SiraException('Tiempo de recepción agotado');
    default:
      return SiraException(
          'Error desconocido - probablemente un en los certificados de Univalle');
  }
}

SiraException handleSiraError(Object e) {
  if (e is DioException) {
    return _handleDioException(e);
  } else if (e is SiraException) {
    return e;
  } else {
    return SiraException('Error desconocido $e');
  }
}

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
    if (statusCode == 401) return 'Tu sesión expiró, inicia sesión de nuevo.';
    if (statusCode == 403) return 'No tienes permisos para esta acción.';
    if (statusCode == 404) return 'No encontramos lo que buscabas.';
    if (statusCode != null && statusCode >= 500) {
      return 'Estamos teniendo problemas en el servidor, intenta más tarde.';
    }
    return 'Ocurrió un error al procesar tu solicitud.';
  }
}

final class NetworkFailure extends Failure {
  NetworkFailure({required super.message})
      : super(userMessage: 'Revisa tu conexión a internet e intenta de nuevo.');
}

final class CacheFailure extends Failure {
  CacheFailure({required super.message})
      : super(userMessage: 'No pudimos cargar la información guardada en tu dispositivo.');
}

final class UnknownFailure extends Failure {
  UnknownFailure({required super.message})
      : super(userMessage: 'Algo salió mal, intenta de nuevo.');
}

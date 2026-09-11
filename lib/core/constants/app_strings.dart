/// Generic copy shared across features. Feature-specific copy (e.g., forms)
/// lives in `features/<feature>/<feature>_strings.dart`.
abstract final class AppStrings {
  static const genericError = 'Algo salió mal, intenta de nuevo.';
  static const retry = 'Reintentar';
  static const networkError =
      'Revisa tu conexión a internet e intenta de nuevo.';
  static const cacheError =
      'No pudimos cargar la información guardada en tu dispositivo.';
  static const sessionExpired = 'Tu sesión expiró, inicia sesión de nuevo.';
  static const forbidden = 'No tienes permisos para esta acción.';
  static const notFound = 'No encontramos lo que buscabas.';
  static const serverError =
      'Estamos teniendo problemas en el servidor, intenta más tarde.';
  static const requestError = 'Ocurrió un error al procesar tu solicitud.';
}

abstract final class RestaurantConstants {
  static const String baseUrl =
      'https://restauranteuniversitario.univalle.edu.co/restaurante.php/';
  static const String menuBaseUrl = 'https://vicebienestar.univalle.edu.co';
  static const String menuPath = '/restaurante-universitario';
  static const String menuUrl = '$menuBaseUrl$menuPath';
  static const String menuTableSelector = 'table.tabla-info';
  static const String loginPath = 'login';
  static const String homePath = 'panel/seleccionarGrupoTrabajo';
  static const String purchasePath = 'tiquete_en_linea/comprar';
  static const String payPath = 'tiquete_en_linea/pagar';

  /// Exact text the portal shows to users without an active ticket account.
  static const String firstTicketNotice =
      'Recuerde que para hacer uso de la consulta o compra de ticket debe ser '
      'estudiante activo o poseer alguna vinculación con la Universidad del '
      'Valle.';
}

abstract final class NewsConstants {
  static const String baseUrl = 'https://www.univalle.edu.co';
  static const String listPath = '/agencia-de-noticias';

  // K2 (the Joomla component behind the news agency) paginates via a
  // "start" query param rather than a page number, and always returns this
  // many items per page.
  static const int itemsPerPage = 21;

  static const String itemSelector = '.catItemView';
  static const String titleLinkSelector = '.agencia-lst-item-titulo a';
  static const String summarySelector = '.agencia-lista-texto';
  static const String imageSelector = '.agencia-lst-img img';
  static const String categorySelector = '.agencia-lista-categoria-item';
}

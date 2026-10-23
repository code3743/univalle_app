abstract final class LibraryConstants {
  static const String baseUrl = 'https://opac.univalle.edu.co/cgi-olib/';
  static const String accountPath = '?action=getLatestBreadcrumb&defaultType=3';

  static const String renewPath = '?action=renItem&ItemBarcode=';

  static const String historyTableSelector = '#user_tab_hist table > tbody';

  static const String currentLoansTableSelector =
      '#user_tab_loan table > tbody';

  static const Map<String, String> monthAbbreviations = {
    'enero': 'Jan',
    'febrero': 'Feb',
    'marzo': 'Mar',
    'abril': 'Apr',
    'mayo': 'May',
    'junio': 'Jun',
    'julio': 'Jul',
    'agosto': 'Aug',
    'septiembre': 'Sep',
    'octubre': 'Oct',
    'noviembre': 'Nov',
    'diciembre': 'Dec',
  };
}

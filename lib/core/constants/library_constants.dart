abstract final class LibraryConstants {
  static const String baseUrl = 'https://opac.univalle.edu.co/cgi-olib/';
  static const String accountPath = '?action=getLatestBreadcrumb&defaultType=3';

  static const String historyTableSelector = '#user_tab_hist table > tbody';

  // Mirrors the history tab's id pattern ("hist" -> "loan"), but unverified:
  // confirming it needs an account with an actual active loan to test against.
  static const String currentLoansTableSelector =
      '#user_tab_loan table > tbody';
}

import 'package:webview_flutter/webview_flutter.dart';

// The report is rendered from an in-memory HTML string, so the only
// legitimate navigation is that initial load (about:blank / data:). Anything
// else, such as a link inside the scraped page, must not leave the WebView.
NavigationDecision tabulateNavigationDecision(NavigationRequest request) {
  final uri = Uri.tryParse(request.url);
  final isLocalLoad =
      uri != null && (uri.scheme == 'about' || uri.scheme == 'data');
  return isLocalLoad ? NavigationDecision.navigate : NavigationDecision.prevent;
}

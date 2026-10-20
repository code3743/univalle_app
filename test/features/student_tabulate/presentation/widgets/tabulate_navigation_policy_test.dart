import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/student_tabulate/presentation/widgets/tabulate_navigation_policy.dart';
import 'package:webview_flutter/webview_flutter.dart';

NavigationDecision _decide(String url) =>
    tabulateNavigationDecision(NavigationRequest(url: url, isMainFrame: true));

void main() {
  test('allows the in-memory HTML load', () {
    expect(_decide('about:blank'), NavigationDecision.navigate);
    expect(_decide('data:text/html;base64,AAAA'), NavigationDecision.navigate);
  });

  test('blocks navigation to any remote or malformed url', () {
    expect(
      _decide('https://sira.univalle.edu.co/x'),
      NavigationDecision.prevent,
    );
    expect(_decide('javascript:window.print();'), NavigationDecision.prevent);
    expect(_decide('http://[bad'), NavigationDecision.prevent);
  });
}

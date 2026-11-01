import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/student_tabulate/domain/entities/tabulate.dart';
import 'package:univalle_app/features/student_tabulate/presentation/viewmodels/tabulate_view_model.dart';
import 'package:univalle_app/features/student_tabulate/presentation/views/tabulate_view.dart';
import 'package:univalle_app/features/student_tabulate/student_tabulate_strings.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import '../../../../helpers/pump_app.dart';

class _FakeWebViewPlatform extends WebViewPlatform {
  final controllers = <_FakeController>[];

  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    final controller = _FakeController(params);
    controllers.add(controller);
    return controller;
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) => _FakeNavigationDelegate(params);

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) => _FakeWidget(params);
}

class _FakeController extends PlatformWebViewController {
  _FakeController(super.params) : super.implementation();

  final loadedHtml = <String>[];

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {
    loadedHtml.add(html);
  }
}

class _FakeNavigationDelegate extends PlatformNavigationDelegate {
  _FakeNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {}
}

class _FakeWidget extends PlatformWebViewWidget {
  _FakeWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) =>
      const SizedBox(key: Key('fake-webview'));
}

class _FakeTabulateViewModel extends TabulateViewModel {
  _FakeTabulateViewModel(this._result);

  final Future<Tabulate> Function() _result;

  @override
  Future<Tabulate> build() => _result();
}

void main() {
  late _FakeWebViewPlatform platform;

  setUp(() {
    platform = _FakeWebViewPlatform();
    WebViewPlatform.instance = platform;
  });

  Tabulate tabulate(String html) =>
      Tabulate(html: html, baseUrl: Uri.parse('https://x'));

  testWidgets('loads the tabulate html and offers the save action', (
    tester,
  ) async {
    await tester.pumpApp(
      const TabulateView(),
      overrides: [
        tabulateViewModelProvider.overrideWith(
          () => _FakeTabulateViewModel(() async => tabulate('<p>hi</p>')),
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('fake-webview')), findsOneWidget);
    expect(platform.controllers.single.loadedHtml, ['<p>hi</p>']);
    expect(find.byTooltip(StudentTabulateStrings.saveTooltip), findsOneWidget);

    // Not an Android controller, so saving is a no-op instead of an error.
    await tester.tap(find.byTooltip(StudentTabulateStrings.saveTooltip));
    await tester.pump();
    expect(find.text(StudentTabulateStrings.saveFailed), findsNothing);
  });

  testWidgets('hides the save action while the tabulate is not loaded', (
    tester,
  ) async {
    await tester.pumpApp(
      const TabulateView(),
      overrides: [
        tabulateViewModelProvider.overrideWith(
          () => _FakeTabulateViewModel(() async => throw StateError('boom')),
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip(StudentTabulateStrings.saveTooltip), findsNothing);
    expect(find.byKey(const Key('fake-webview')), findsNothing);
  });
}

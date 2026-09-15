import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:univalle_app/features/home/home_strings.dart';
import 'package:univalle_app/features/home/presentation/widgets/home_footer.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../../helpers/pump_app.dart';

class _FakeUrlLauncher extends UrlLauncherPlatform {
  _FakeUrlLauncher({this.result = true});

  final bool result;
  String? launchedUrl;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    return result;
  }
}

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Univalle App',
      packageName: 'co.edu.univalle.univalle_app',
      version: '1.2.3',
      buildNumber: '7',
      buildSignature: '',
    );
  });

  testWidgets('shows the repository label and the app version', (tester) async {
    UrlLauncherPlatform.instance = _FakeUrlLauncher();

    await tester.pumpApp(const HomeFooter());
    await tester.pumpAndSettle();

    expect(find.text(HomeStrings.repositoryLabel), findsOneWidget);
    expect(find.text('v1.2.3'), findsOneWidget);
  });

  testWidgets('opens the repository url when tapped', (tester) async {
    final fakeLauncher = _FakeUrlLauncher();
    UrlLauncherPlatform.instance = fakeLauncher;

    await tester.pumpApp(const HomeFooter());
    await tester.pumpAndSettle();

    await tester.tap(find.text(HomeStrings.repositoryLabel));
    await tester.pumpAndSettle();

    expect(fakeLauncher.launchedUrl, HomeStrings.repositoryUrl);
  });

  testWidgets('shows a snackbar when the link cannot be opened', (
    tester,
  ) async {
    UrlLauncherPlatform.instance = _FakeUrlLauncher(result: false);

    await tester.pumpApp(const HomeFooter());
    await tester.pumpAndSettle();

    await tester.tap(find.text(HomeStrings.repositoryLabel));
    await tester.pumpAndSettle();

    expect(find.text(HomeStrings.cannotOpenRepositoryLink), findsOneWidget);
  });
}

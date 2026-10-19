import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/domain/entities/welcome_banner.dart';
import 'package:univalle_app/features/remote_config/presentation/widgets/welcome_banner_dialog.dart';
import 'package:univalle_app/features/remote_config/remote_config_strings.dart';

import '../../../../helpers/fake_url_launcher.dart';
import '../../../../helpers/pump_app.dart';

WelcomeBanner _banner({String? imageUrl, String? linkUrl}) => WelcomeBanner(
  enabled: true,
  title: 'Bienvenido',
  description: 'Mira las novedades',
  imageUrl: imageUrl,
  linkUrl: linkUrl,
);

void main() {
  testWidgets('shows only text and close when there is no image or link', (
    tester,
  ) async {
    await tester.pumpApp(WelcomeBannerDialog(banner: _banner()));

    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Mira las novedades'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.text(RemoteConfigStrings.welcomeDialogOpenLink), findsNothing);
    expect(find.text(RemoteConfigStrings.welcomeDialogClose), findsOneWidget);
  });

  testWidgets('opens the link when one is provided', (tester) async {
    final launcher = FakeUrlLauncher.install();
    await tester.pumpApp(
      WelcomeBannerDialog(banner: _banner(linkUrl: 'https://univalle.edu.co')),
    );

    await tester.tap(find.text(RemoteConfigStrings.welcomeDialogOpenLink));
    await tester.pump();

    expect(launcher.launched, ['https://univalle.edu.co']);
  });

  testWidgets('tells the user when the link cannot be opened', (tester) async {
    FakeUrlLauncher.install(canOpen: false);
    await tester.pumpApp(
      WelcomeBannerDialog(banner: _banner(linkUrl: 'https://univalle.edu.co')),
    );

    await tester.tap(find.text(RemoteConfigStrings.welcomeDialogOpenLink));
    await tester.pump();

    expect(find.text(RemoteConfigStrings.cannotOpenStoreLink), findsOneWidget);
  });

  testWidgets('collapses the image if it fails to load', (tester) async {
    await tester.pumpApp(
      WelcomeBannerDialog(
        banner: _banner(imageUrl: 'https://img.example/a.png'),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    final fallback = image.errorBuilder!(
      tester.element(find.byType(Image)),
      Exception('x'),
      null,
    );

    expect((fallback as SizedBox).height, 0);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/widgets/app_loading_indicator.dart';
import 'package:univalle_app/core/widgets/app_logo.dart';
import 'package:univalle_app/features/splash/presentation/views/splash_view.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the logo and a loading indicator', (tester) async {
    await tester.pumpApp(const SplashView());

    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.byType(AppLoadingIndicator), findsOneWidget);
  });
}

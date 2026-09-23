import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_scaffold.dart';

/// Initial route. Purely visual — `appRouterRedirect`
/// (`core/router/app_router.dart`) is what waits for the restored session
/// and the remote config to settle and then routes to Home or Login.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      scrollable: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(size: 96),
            SizedBox(height: AppSpacing.lg),
            AppLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}

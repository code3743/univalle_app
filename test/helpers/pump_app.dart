import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:univalle_app/core/router/app_routes.dart';
import 'package:univalle_app/core/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {List<Override> overrides = const []}) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: widget),
        ),
      ),
    );
  }

  /// Like [pumpApp], but mounts [widget] at [AppRoutes.home] inside a real
  /// `GoRouter`, with every other [AppRoutes] path stubbed as a `Text` that
  /// reads `route:<path>`. Lets a test tap something and assert on where it
  /// navigated (`find.text('route:/profile')`) without building the target
  /// view and its providers.
  Future<GoRouter> pumpRoutedApp(
    Widget widget, {
    List<Override> overrides = const [],
  }) async {
    final router = GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (_, _) => Scaffold(body: widget),
        ),
        for (final path in stubbedRoutePaths)
          GoRoute(path: path, builder: (_, _) => Text('route:$path')),
      ],
    );
    addTearDown(router.dispose);

    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    await pump();
    return router;
  }
}

const stubbedRoutePaths = [
  AppRoutes.splash,
  AppRoutes.login,
  AppRoutes.profile,
  AppRoutes.forgotPassword,
  AppRoutes.grades,
  AppRoutes.equivalences,
  AppRoutes.digitalCard,
  AppRoutes.tabulate,
  AppRoutes.resolution,
  AppRoutes.teacherRating,
  AppRoutes.teacherReview,
  AppRoutes.schedule,
  AppRoutes.restaurant,
  AppRoutes.library,
  AppRoutes.news,
  AppRoutes.announcements,
  AppRoutes.pendingPayment,
  AppRoutes.allFunctionalities,
];

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/device/app_platform_provider.dart';

import '../../helpers/container.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('maps iOS to "ios"', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    expect(createContainer().read(appPlatformProvider), 'ios');
  });

  test('maps every other platform to "android"', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(createContainer().read(appPlatformProvider), 'android');
  });
}

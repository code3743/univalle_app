import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_platform_provider.g.dart';

/// The platform key the backend expects for `GET /app/config` ('ios' or
/// 'android'). Derived from [defaultTargetPlatform] rather than `dart:io`
/// so it stays overridable in tests.
@riverpod
String appPlatform(Ref ref) {
  return switch (defaultTargetPlatform) {
    TargetPlatform.iOS => 'ios',
    _ => 'android',
  };
}

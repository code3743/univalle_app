import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderContainer createContainer({List<Override> overrides = const []}) {
  final container = ProviderContainer(
    overrides: overrides,
    // Riverpod 3's default retry policy keeps a failed AsyncNotifier stuck
    // in a retrying AsyncLoading for several seconds before ever settling
    // into AsyncError, which makes failure-path tests flaky/slow. Tests
    // want the first failure to surface immediately.
    retry: (_, _) => null,
  );
  addTearDown(container.dispose);
  return container;
}

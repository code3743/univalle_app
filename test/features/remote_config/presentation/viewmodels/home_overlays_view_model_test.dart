import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/domain/entities/app_config.dart';
import 'package:univalle_app/features/remote_config/domain/entities/welcome_banner.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/presentation/providers/remote_config_providers.dart';
import 'package:univalle_app/features/remote_config/presentation/viewmodels/home_overlays_view_model.dart';

import '../../../../helpers/container.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

String _fingerprintOf(WelcomeBanner banner) {
  final raw = '${banner.title}|${banner.description}|${banner.imageUrl ?? ''}';
  return md5.convert(utf8.encode(raw)).toString();
}

void main() {
  late MockRemoteConfigRepository repository;

  setUp(() {
    repository = MockRemoteConfigRepository();
  });

  List<Override> overridesWith(RemoteConfigRepository repo) => [
    remoteConfigRepositoryProvider.overrideWithValue(repo),
  ];

  group('shouldShowUpdateSheet', () {
    const available = UpdateStatus(
      latestVersion: '2.0.0',
      updateAvailable: true,
      updateRequired: false,
      storeUrl: 'https://store',
      message: '',
    );

    test(
      'is false when no update is available, without calling the repository',
      () async {
        final container = createContainer(overrides: overridesWith(repository));
        const noUpdate = UpdateStatus(
          latestVersion: '1.0.0',
          updateAvailable: false,
          updateRequired: false,
          storeUrl: '',
          message: '',
        );

        final shouldShow = await container
            .read(homeOverlaysViewModelProvider.notifier)
            .shouldShowUpdateSheet(noUpdate);

        expect(shouldShow, isFalse);
        verifyNever(() => repository.getDismissedUpdate());
      },
    );

    test('is false when the update is required (handled by a blocking screen instead)', () async {
      final container = createContainer(overrides: overridesWith(repository));
      const required = UpdateStatus(
        latestVersion: '2.0.0',
        updateAvailable: true,
        updateRequired: true,
        storeUrl: 'https://store',
        message: '',
      );

      final shouldShow = await container
          .read(homeOverlaysViewModelProvider.notifier)
          .shouldShowUpdateSheet(required);

      expect(shouldShow, isFalse);
      verifyNever(() => repository.getDismissedUpdate());
    });

    test('is true when the latest version has not been dismissed', () async {
      when(() => repository.getDismissedUpdate())
          .thenAnswer((_) async => const Ok('1.0.0'));
      final container = createContainer(overrides: overridesWith(repository));

      final shouldShow = await container
          .read(homeOverlaysViewModelProvider.notifier)
          .shouldShowUpdateSheet(available);

      expect(shouldShow, isTrue);
    });

    test('is false when the latest version was already dismissed', () async {
      when(() => repository.getDismissedUpdate())
          .thenAnswer((_) async => const Ok('2.0.0'));
      final container = createContainer(overrides: overridesWith(repository));

      final shouldShow = await container
          .read(homeOverlaysViewModelProvider.notifier)
          .shouldShowUpdateSheet(available);

      expect(shouldShow, isFalse);
    });

    test(
      'fails closed (treated as dismissed) when reading the cache fails',
      () async {
        when(() => repository.getDismissedUpdate())
            .thenAnswer((_) async => Err(CacheFailure(message: 'corrupt')));
        final container = createContainer(overrides: overridesWith(repository));

        final shouldShow = await container
            .read(homeOverlaysViewModelProvider.notifier)
            .shouldShowUpdateSheet(available);

        expect(shouldShow, isFalse);
      },
    );
  });

  test('dismissUpdate forwards the latest version to the repository', () async {
    when(() => repository.dismissUpdate('2.0.0'))
        .thenAnswer((_) async => const Ok(null));
    final container = createContainer(overrides: overridesWith(repository));

    await container
        .read(homeOverlaysViewModelProvider.notifier)
        .dismissUpdate('2.0.0');

    verify(() => repository.dismissUpdate('2.0.0')).called(1);
  });

  group('shouldShowWelcomeBanner', () {
    const banner = WelcomeBanner(
      enabled: true,
      title: 'Bienvenida',
      description: 'Nuevo semestre',
    );

    test(
      'is false when the banner is disabled, without calling the repository',
      () async {
        final container = createContainer(overrides: overridesWith(repository));
        const disabled = WelcomeBanner(
          enabled: false,
          title: '',
          description: '',
        );

        final shouldShow = await container
            .read(homeOverlaysViewModelProvider.notifier)
            .shouldShowWelcomeBanner(disabled);

        expect(shouldShow, isFalse);
        verifyNever(() => repository.getSeenWelcome());
      },
    );

    test('is true when the banner content has not been seen', () async {
      when(() => repository.getSeenWelcome())
          .thenAnswer((_) async => const Ok('stale'));
      final container = createContainer(overrides: overridesWith(repository));

      final shouldShow = await container
          .read(homeOverlaysViewModelProvider.notifier)
          .shouldShowWelcomeBanner(banner);

      expect(shouldShow, isTrue);
    });

    test('is false when the exact same content was already seen', () async {
      when(() => repository.getSeenWelcome())
          .thenAnswer((_) async => Ok(_fingerprintOf(banner)));
      final container = createContainer(overrides: overridesWith(repository));

      final shouldShow = await container
          .read(homeOverlaysViewModelProvider.notifier)
          .shouldShowWelcomeBanner(banner);

      expect(shouldShow, isFalse);
    });

    test(
      'fails closed (treated as seen) when reading the cache fails',
      () async {
        when(() => repository.getSeenWelcome())
            .thenAnswer((_) async => Err(CacheFailure(message: 'corrupt')));
        final container = createContainer(overrides: overridesWith(repository));

        final shouldShow = await container
            .read(homeOverlaysViewModelProvider.notifier)
            .shouldShowWelcomeBanner(banner);

        expect(shouldShow, isFalse);
      },
    );
  });

  test('markWelcomeSeen persists the banner content fingerprint', () async {
    const banner = WelcomeBanner(
      enabled: true,
      title: 'Hola',
      description: 'Bienvenida',
    );
    when(() => repository.markWelcomeSeen(any()))
        .thenAnswer((_) async => const Ok(null));
    final container = createContainer(overrides: overridesWith(repository));

    await container
        .read(homeOverlaysViewModelProvider.notifier)
        .markWelcomeSeen(banner);

    verify(() => repository.markWelcomeSeen(_fingerprintOf(banner))).called(1);
  });
}

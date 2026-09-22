import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:univalle_app/core/device/app_platform_provider.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/domain/entities/app_config.dart';
import 'package:univalle_app/features/remote_config/domain/entities/welcome_banner.dart'
    as domain;
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';
import 'package:univalle_app/features/remote_config/presentation/providers/remote_config_providers.dart';
import 'package:univalle_app/features/remote_config/presentation/viewmodels/remote_config_view_model.dart';

import '../../../../helpers/container.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

AppConfig _config() => const AppConfig(
  platformEnabled: true,
  maintenance: MaintenanceStatus(enabled: false, title: '', message: ''),
  update: UpdateStatus(
    latestVersion: '1.0.0',
    updateAvailable: false,
    updateRequired: false,
    storeUrl: '',
    message: '',
  ),
  modules: [],
  quickAccess: [],
  welcome: domain.WelcomeBanner(enabled: false, title: '', description: ''),
);

void main() {
  late MockRemoteConfigRepository repository;

  setUp(() {
    repository = MockRemoteConfigRepository();
    PackageInfo.setMockInitialValues(
      appName: 'Univalle App',
      packageName: 'co.edu.univalle.univalle_app',
      version: '0.1.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  List<Override> overridesWith(RemoteConfigRepository repo) => [
    remoteConfigRepositoryProvider.overrideWithValue(repo),
    appPlatformProvider.overrideWithValue('android'),
  ];

  test('returns the config on success', () async {
    when(() => repository.getConfig(platform: 'android', version: '0.1.0'))
        .thenAnswer((_) async => Ok(_config()));
    final container = createContainer(overrides: overridesWith(repository));

    final config = await container.read(remoteConfigViewModelProvider.future);

    expect(config, isNotNull);
    expect(config!.platformEnabled, isTrue);
  });

  test('fails open: resolves to null instead of throwing when the repository errors', () async {
    when(() => repository.getConfig(platform: 'android', version: '0.1.0'))
        .thenAnswer(
          (_) async => Err(
            NetworkFailure(
              message: const NetworkException(message: 'down').message,
            ),
          ),
        );
    final container = createContainer(overrides: overridesWith(repository));

    final config = await container.read(remoteConfigViewModelProvider.future);

    expect(config, isNull);
  });
}

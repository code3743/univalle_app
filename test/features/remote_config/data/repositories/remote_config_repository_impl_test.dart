import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/error/failures.dart';
import 'package:univalle_app/core/error/result.dart';
import 'package:univalle_app/features/remote_config/data/datasources/remote_config_local_datasource.dart';
import 'package:univalle_app/features/remote_config/data/datasources/remote_config_remote_datasource.dart';
import 'package:univalle_app/features/remote_config/data/models/app_config_model.dart';
import 'package:univalle_app/features/remote_config/data/repositories/remote_config_repository_impl.dart';
import 'package:univalle_app/features/remote_config/domain/entities/app_config.dart';

class MockRemoteConfigRemoteDataSource extends Mock
    implements RemoteConfigRemoteDataSource {}

class MockRemoteConfigLocalDataSource extends Mock
    implements RemoteConfigLocalDataSource {}

void main() {
  late MockRemoteConfigRemoteDataSource remote;
  late MockRemoteConfigLocalDataSource local;
  late RemoteConfigRepositoryImpl repository;
  late AppConfigModel configModel;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    configModel = AppConfigModel.fromJson(
      jsonDecode(
        File('test/fixtures/remote_config/app_config.json').readAsStringSync(),
      ) as Map<String, dynamic>,
    );
  });

  setUp(() {
    remote = MockRemoteConfigRemoteDataSource();
    local = MockRemoteConfigLocalDataSource();
    repository = RemoteConfigRepositoryImpl(remote, local);
  });

  group('getConfig', () {
    test(
      'caches and returns the config when the remote call succeeds',
      () async {
        when(() => remote.fetchConfig(platform: 'android', version: '0.1.0'))
            .thenAnswer((_) async => configModel);
        when(() => local.saveConfigSnapshot(any())).thenAnswer((_) async {});

        final result = await repository.getConfig(
          platform: 'android',
          version: '0.1.0',
        );

        expect(result, isA<Ok<AppConfig>>());
        verify(() => local.saveConfigSnapshot(configModel.toJson())).called(1);
      },
    );

    test(
      'falls back to the cached config when the remote call fails',
      () async {
        when(() => remote.fetchConfig(platform: 'android', version: '0.1.0'))
            .thenThrow(const NetworkException(message: 'no connection'));
        when(() => local.getConfigSnapshot())
            .thenAnswer((_) async => configModel);

        final result = await repository.getConfig(
          platform: 'android',
          version: '0.1.0',
        );

        expect(result, isA<Ok<AppConfig>>());
      },
    );

    test(
      'returns Err when the remote call fails and there is no cache',
      () async {
        when(() => remote.fetchConfig(platform: 'android', version: '0.1.0'))
            .thenThrow(const NetworkException(message: 'no connection'));
        when(() => local.getConfigSnapshot()).thenAnswer((_) async => null);

        final result = await repository.getConfig(
          platform: 'android',
          version: '0.1.0',
        );

        expect((result as Err<AppConfig>).failure, isA<NetworkFailure>());
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/core/storage/local_storage_service.dart';
import 'package:univalle_app/features/remote_config/data/datasources/remote_config_local_datasource.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late MockLocalStorageService storage;
  late RemoteConfigLocalDataSource dataSource;

  setUp(() {
    storage = MockLocalStorageService();
    dataSource = RemoteConfigLocalDataSource(storage);
  });

  group('config snapshot', () {
    test('returns null when nothing is cached', () async {
      when(() => storage.getString('remote_config_snapshot'))
          .thenAnswer((_) async => null);

      expect(await dataSource.getConfigSnapshot(), isNull);
    });

    test(
      'returns null instead of throwing when the cache is corrupted',
      () async {
        when(() => storage.getString('remote_config_snapshot'))
            .thenAnswer((_) async => 'not json');

        expect(await dataSource.getConfigSnapshot(), isNull);
      },
    );

    test('round-trips a saved snapshot', () async {
      when(
        () => storage.setString(
          'remote_config_snapshot',
          any(that: contains('grades')),
        ),
      ).thenAnswer((_) async {});
      when(() => storage.getString('remote_config_snapshot')).thenAnswer(
        (_) async =>
            '{"platformEnabled":true,'
            '"maintenance":{"enabled":false,"title":"","message":""},'
            '"update":{"latestVersion":"1.0.0","updateAvailable":false,'
            '"updateRequired":false,"storeUrl":"","message":""},'
            '"modules":[{"key":"grades","label":"Notas","icon":"notebook-text",'
            '"route":"/grades","color":"#FF0000"}],'
            '"quickAccess":["grades"],'
            '"welcome":{"enabled":false,"title":"","description":"",'
            '"imageUrl":null,"linkUrl":null},'
            '"announcements":[]}',
      );

      await dataSource.saveConfigSnapshot({
        'modules': ['grades'],
      });
      final cached = await dataSource.getConfigSnapshot();

      expect(cached, isNotNull);
      expect(cached!.modules.single.key, 'grades');
    });
  });

  test('dismissed update round-trips', () async {
    when(() => storage.setString('remote_config_dismissed_update', '1.2.0'))
        .thenAnswer((_) async {});
    when(() => storage.getString('remote_config_dismissed_update'))
        .thenAnswer((_) async => '1.2.0');

    await dataSource.dismissUpdate('1.2.0');

    expect(await dataSource.getDismissedUpdate(), '1.2.0');
  });

  test('seen welcome fingerprint round-trips', () async {
    when(() => storage.setString('remote_config_seen_welcome', 'abc123'))
        .thenAnswer((_) async {});
    when(() => storage.getString('remote_config_seen_welcome'))
        .thenAnswer((_) async => 'abc123');

    await dataSource.markWelcomeSeen('abc123');

    expect(await dataSource.getSeenWelcome(), 'abc123');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univalle_app/core/error/exceptions.dart';
import 'package:univalle_app/core/storage/shared_preferences_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences preferences;
  late SharedPreferencesService service;

  setUp(() {
    preferences = MockSharedPreferences();
    service = SharedPreferencesService(preferences);
  });

  test('getString reads through to SharedPreferences', () async {
    when(() => preferences.getString('k')).thenReturn('v');
    expect(await service.getString('k'), 'v');
  });

  test('setString writes through to SharedPreferences', () async {
    when(() => preferences.setString('k', 'v')).thenAnswer((_) async => true);
    await service.setString('k', 'v');
    verify(() => preferences.setString('k', 'v')).called(1);
  });

  test('getBool reads through to SharedPreferences', () async {
    when(() => preferences.getBool('k')).thenReturn(true);
    expect(await service.getBool('k'), isTrue);
  });

  test('setBool writes through to SharedPreferences', () async {
    when(() => preferences.setBool('k', true)).thenAnswer((_) async => true);
    await service.setBool('k', true);
    verify(() => preferences.setBool('k', true)).called(1);
  });

  test('getInt reads through to SharedPreferences', () async {
    when(() => preferences.getInt('k')).thenReturn(42);
    expect(await service.getInt('k'), 42);
  });

  test('setInt writes through to SharedPreferences', () async {
    when(() => preferences.setInt('k', 42)).thenAnswer((_) async => true);
    await service.setInt('k', 42);
    verify(() => preferences.setInt('k', 42)).called(1);
  });

  test('getDouble reads through to SharedPreferences', () async {
    when(() => preferences.getDouble('k')).thenReturn(4.2);
    expect(await service.getDouble('k'), 4.2);
  });

  test('setDouble writes through to SharedPreferences', () async {
    when(() => preferences.setDouble('k', 4.2)).thenAnswer((_) async => true);
    await service.setDouble('k', 4.2);
    verify(() => preferences.setDouble('k', 4.2)).called(1);
  });

  test('getStringList reads through to SharedPreferences', () async {
    when(() => preferences.getStringList('k')).thenReturn(['a', 'b']);
    expect(await service.getStringList('k'), ['a', 'b']);
  });

  test('setStringList writes through to SharedPreferences', () async {
    when(() => preferences.setStringList('k', ['a', 'b']))
        .thenAnswer((_) async => true);
    await service.setStringList('k', ['a', 'b']);
    verify(() => preferences.setStringList('k', ['a', 'b'])).called(1);
  });

  test('remove delegates to SharedPreferences', () async {
    when(() => preferences.remove('k')).thenAnswer((_) async => true);
    await service.remove('k');
    verify(() => preferences.remove('k')).called(1);
  });

  test('clear delegates to SharedPreferences', () async {
    when(() => preferences.clear()).thenAnswer((_) async => true);
    await service.clear();
    verify(() => preferences.clear()).called(1);
  });

  test('wraps any thrown error as a CacheException', () async {
    when(() => preferences.getString('k')).thenThrow(Exception('disk full'));

    await expectLater(
      () => service.getString('k'),
      throwsA(
        isA<CacheException>().having(
          (e) => e.message,
          'message',
          contains('disk full'),
        ),
      ),
    );
  });
}

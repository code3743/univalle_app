import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/core/storage/auth_local_datasource.dart';
import 'package:univalle_app/core/storage/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AuthLocalDataSource dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    dataSource = AuthLocalDataSource(SharedPreferencesService(preferences));
  });

  test('returns null when nothing has been saved', () async {
    expect(await dataSource.getCredentials(), isNull);
  });

  test('returns null when only the username was saved', () async {
    SharedPreferences.setMockInitialValues({'auth_username': 'jperez'});
    final preferences = await SharedPreferences.getInstance();
    dataSource = AuthLocalDataSource(SharedPreferencesService(preferences));

    expect(await dataSource.getCredentials(), isNull);
  });

  test('round-trips the saved credentials without a photo', () async {
    await dataSource.saveCredentials(username: 'jperez', password: 'secret');

    final credentials = await dataSource.getCredentials();

    expect(credentials?.username, 'jperez');
    expect(credentials?.password, 'secret');
    expect(credentials?.photoUrl, isNull);
  });

  test('includes the photo url once it has been saved', () async {
    await dataSource.saveCredentials(username: 'jperez', password: 'secret');
    await dataSource.savePhotoUrl('https://photos/jperez.jpg');

    final credentials = await dataSource.getCredentials();

    expect(credentials?.photoUrl, 'https://photos/jperez.jpg');
  });

  test('clearCredentials removes username, password and photo', () async {
    await dataSource.saveCredentials(username: 'jperez', password: 'secret');
    await dataSource.savePhotoUrl('https://photos/jperez.jpg');

    await dataSource.clearCredentials();

    expect(await dataSource.getCredentials(), isNull);
  });
}

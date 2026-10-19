import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univalle_app/core/storage/local_storage_providers.dart';

import '../../helpers/container.dart';

void main() {
  test('sharedPreferencesProvider throws until it is overridden', () {
    final container = createContainer();

    expect(() => container.read(sharedPreferencesProvider), throwsA(anything));
  });

  test(
    'wires the storage service and auth datasource from preferences',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final container = createContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      );

      await container
          .read(authLocalDataSourceProvider)
          .saveCredentials(username: 'jperez', password: 'secret');

      expect(preferences.getString('auth_username'), 'jperez');
      expect(container.read(localStorageServiceProvider), isNotNull);
    },
  );
}
